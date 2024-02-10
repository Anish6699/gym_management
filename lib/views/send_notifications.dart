import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/profilewidgets/reusablecomponents.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
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
                                            items: [
                                              'Members',
                                              'Visitors',
                                              'Branches',
                                              'Trainers',
                                              'Admin'
                                            ].map(
                                              (item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
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
                                        selectedAudience == 'Members'
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
                                                  items: [
                                                    'All',
                                                    'Active',
                                                    'In Active',
                                                    'Payment Pending'
                                                  ].map(
                                                    (item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(
                                                          item,
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
                                                  onChanged: (value) {},
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
                                                    hintText: "Select Filter",
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
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
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
                                        maxLines: 12,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          PrimaryButton(
                                              onPressed: () {},
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
