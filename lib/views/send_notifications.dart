import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/configs/mail_template.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/login_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/profilewidgets/reusablecomponents.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendNotificationView extends StatefulWidget {
  const SendNotificationView({super.key});
  static const String routeName = '/send-notification';

  static Route route(dynamic arguments) {
    return MaterialPageRoute(
        builder: (_) => const SendNotificationView(),
        settings: RouteSettings(name: routeName, arguments: arguments));
  }

  @override
  State<SendNotificationView> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotificationView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;

  DateTime selectedDateTime = DateTime.now();
  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  AdminController adminController = AdminController();
  List adminBranchList = [];
  var selectedBranch;

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    print('set initial data');
    final prefs = await SharedPreferences.getInstance();

    userType = prefs.getInt('user_type');
    adminId = prefs.getInt('adminId');
    branchId = prefs.getInt('branchId');

    if (userType == 2) {
      print('Admin login');
      adminBranchList =
          await adminController.getAdminAllBranches(adminId: adminId);
      if (globalSelectedBranch != null) {
        for (int i = 0; i < adminBranchList.length; i++) {
          if (globalSelectedBranch['id'] == adminBranchList[i]['id']) {
            selectedBranch = adminBranchList[i];
          }
        }
      } else {
        selectedBranch = adminBranchList.first;
      }
      // setDataOnBranchChange();
      setState(() {});
    }
    if (userType == 3) {
      print('branch login');
      // setDataOnBranchLogin();
    }
  }

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM y').format(dateTime);
    } catch (e) {
      // Handle parsing error or return the original string if the format is not valid
      return dateString;
    }
  }

  Future<String> selectedDatee(BuildContext context) async {
    String dateTime = '';
    DateTime initialDateTime = selectedDateTime;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      dateTime = DateFormat('dd-MM-yyyy').format(selectedDateTime);
    }
    return dateTime;
  }

  var selectedAudience;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child:
                    InventoryNavigationPaneExpanded(selected: "invite-members"),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isNavOpen = !isNavOpen;
                    });
                  },
                  child: InventoryNavigationPaneMinimized(
                    selected: "members",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
              // appBar: GenericAppBar(
              //   onNavbarIconPressed: () {
              //     setState(() {
              //       isNavOpen = !isNavOpen;
              //     });
              //   },
              //   title: "Member's Profile",
              //   toolbarHeight: MediaQuery.of(context).size.height * 0.075,
              // ),
              body: SafeArea(
                  child: Stack(children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Stack(children: [
                            Container(
                                width: _width,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                margin: const EdgeInsets.only(top: 70),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: primaryThemeColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            border: Border.all(
                                                color: Colors.transparent),
                                          ),
                                          child: DropdownButtonFormField(
                                            value: selectedAudience,
                                            isExpanded: true,
                                            elevation: 1,
                                            items: mailFilterList.map(
                                              (item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item['name'],
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                        color: Colors.white),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              selectedAudience = value;
                                              subjectController.text =
                                                  selectedAudience['subjet'];
                                              messageController.text =
                                                  selectedAudience[
                                                      'mail_content'];

                                              setState(() {});
                                            },
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.white,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Select Target Audience",
                                              hintStyle: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.01,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                        userType == 2
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                decoration: BoxDecoration(
                                                  color: primaryThemeColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                child: DropdownButtonFormField(
                                                  isExpanded: true,
                                                  elevation: 1,
                                                  value: selectedBranch,
                                                  items: adminBranchList.map(
                                                    (item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(
                                                          item['branch_name'],
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.01,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  onChanged: (value) {
                                                    globalSelectedBranch =
                                                        value;
                                                    selectedBranch = value;
                                                    setState(() {});
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.015,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: "Select Branch",
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                    fillColor: Colors.white,
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TextField(
                                        controller: subjectController,
                                        decoration: InputDecoration(
                                          hintText: "Subject",
                                          hintStyle: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              color: const Color.fromARGB(
                                                  255, 172, 171, 171),
                                              fontWeight: FontWeight.w400),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TextField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Start writing Mail..........",
                                          hintStyle: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              color: const Color.fromARGB(
                                                  255, 172, 171, 171),
                                              fontWeight: FontWeight.w400),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        maxLines: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          PrimaryButton(
                                              onPressed: () {
                                                if (selectedAudience != null &&
                                                    subjectController
                                                        .text.isNotEmpty &&
                                                    messageController
                                                        .text.isNotEmpty) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GenericDialogBox(
                                                          closeButtonEnabled:
                                                              false,
                                                          enableSecondaryButton:
                                                              true,
                                                          isLoader: false,
                                                          message:
                                                              "Are you Sure want to Send Mail",
                                                          primaryButtonText:
                                                              "Confirm",
                                                          secondaryButtonText:
                                                              "Cancel",
                                                          onSecondaryButtonPressed:
                                                              () {
                                                            Get.back();
                                                          },
                                                          onPrimaryButtonPressed:
                                                              () {
                                                            showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return FutureBuilder(
                                                                    future: LoginController()
                                                                        .sendNotifications({
                                                                      'branch_id':
                                                                          branchId ??
                                                                              selectedBranch['id'],
                                                                      'subject':
                                                                          subjectController
                                                                              .text,
                                                                      'message':
                                                                          messageController
                                                                              .text,
                                                                      'mail_to':
                                                                          selectedAudience[
                                                                              'name']
                                                                    }),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      print(
                                                                          'snapshotttt datatatatat');
                                                                      print(snapshot
                                                                          .data);
                                                                      return snapshot.connectionState ==
                                                                              ConnectionState.waiting
                                                                          ? GenericDialogBox(
                                                                              enableSecondaryButton: false,
                                                                              isLoader: true,
                                                                              content: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.04,
                                                                                  height: MediaQuery.of(context).size.width * 0.06,
                                                                                  child: const Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        CircularProgressIndicator(
                                                                                          color: primaryDarkBlueColor,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : snapshot.data!['body'].toString() == '1'
                                                                              ? GenericDialogBox(
                                                                                  closeButtonEnabled: false,
                                                                                  enablePrimaryButton: true,
                                                                                  enableSecondaryButton: false,
                                                                                  isLoader: false,
                                                                                  content: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: SizedBox(
                                                                                      width: MediaQuery.of(context).size.width * 0.04,
                                                                                      height: MediaQuery.of(context).size.width * 0.06,
                                                                                      child: const Center(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text('Mail Sent Successfully')
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  primaryButtonText: 'Ok',
                                                                                  onPrimaryButtonPressed: () async {
                                                                                    Get.back();
                                                                                    Get.back();
                                                                                  },
                                                                                )
                                                                              : GenericDialogBox(
                                                                                  enableSecondaryButton: false,
                                                                                  primaryButtonText: 'Ok',
                                                                                  isLoader: false,
                                                                                  content: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: SizedBox(
                                                                                      width: MediaQuery.of(context).size.width * 0.04,
                                                                                      height: MediaQuery.of(context).size.width * 0.06,
                                                                                      child: const Center(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text('Something went Wrong')
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onPrimaryButtonPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                );
                                                                    },
                                                                  );
                                                                });
                                                          },
                                                        );
                                                      });
                                                }
                                              },
                                              title: 'Send Mail')
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 70,
                                      child: Image.asset(
                                          'assets/icon/notification.png'),
                                      // backgroundImage: AssetImage(
                                      //     'assets/images/person.png')
                                    )))
                          ])),
                    ]),
              ),
            )
          ]))),
        ),
      ],
    );
  }
}

Widget SocialValue(String label, String value) => Container(
    padding: const EdgeInsets.all(5),
    height: 50,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$value',
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ]));

Widget FloatingIconsButtons(String path) => Container(
    margin: const EdgeInsets.all(5),
    height: 40,
    child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: ColorLogoButton(path),
        onPressed: () {}));
