import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/members/members.dart';
import 'package:gmstest/views/profilewidgets/headerpannel.dart';
import 'package:gmstest/views/profilewidgets/reusablecomponents.dart';
import 'package:gmstest/views/profilewidgets/reusabletext.dart';
import 'package:gmstest/views/profilewidgets/topbackground.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:intl/intl.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});
  static const String routeName = '/members-profile';

  static Route route(dynamic arguments) {
    return MaterialPageRoute(
        builder: (_) => const MemberProfile(),
        settings: RouteSettings(name: routeName, arguments: arguments));
  }

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;
  MemberController memmberController = MemberController();
  Map membersData = {};
  List planList = [];
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController totalAmtPaid = TextEditingController();
  TextEditingController paidAmmot = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    print('argumentsssssssssssssssssssss ${Get.arguments}');
    initializeData();
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

  initializeData() async {
    var a = await memmberController.getSingleMember(Get.arguments);
    membersData = a['data'];
    planList = a['plan_details'];
    print('dataaaaaaaaaaaaaaaaaaaaaa');
    print(membersData);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(selected: "members"),
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
            membersData.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                              child: Stack(children: [
                                Container(
                                  width: _width,
                                  margin: const EdgeInsets.only(top: 70),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.1),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ]),
                                  child: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                        /// card header
                                        Container(
                                            width: double.infinity,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Age',
                                                      membersData['age']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Height',
                                                      membersData['height']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Weight',
                                                      membersData['weight']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Blood Group',
                                                      membersData['blood_group']
                                                              ?.toString() ??
                                                          '-'),
                                                  const Spacer(flex: 10),
                                                  NormalButton(
                                                      'ACTIVE',
                                                      Colors.white,
                                                      '',
                                                      Colors.white,
                                                      Colors.green),
                                                  const Spacer(flex: 1)
                                                ])),
                                        const SizedBox(height: 50),
                                        LargeBoldTextBlack(
                                            '${membersData['first_name']?.toString() ?? '-'} ${membersData['last_name']?.toString()}'),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.location_pin,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  membersData['addr']!
                                                      .toString())
                                            ]),
                                        const SizedBox(height: 30),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sports_gymnastics,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  'Personal Trainer - ${membersData['personal_trainer']?.toString() ?? ''}')
                                            ]),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.mail,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  'Email Address : ${membersData['email']?.toString() ?? ''}')
                                            ]),

                                        /// description
                                        Divider(
                                            height: 30,
                                            thickness: 1,
                                            color: primaryThemeColor),
                                        Container(
                                            width: double.infinity,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Primary Mobile Number',
                                                      '${membersData['primary_mobile_no']?.toString() ?? ''}'),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Secondary Mobile Number',
                                                      membersData['secondary_mobile_no']
                                                              ?.toString() ??
                                                          ''),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Start Date',
                                                      planList.first[
                                                                  'start_date'] ==
                                                              null
                                                          ? '-'
                                                          : formatDate(planList
                                                                  .first[
                                                              'start_date'])),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'End Date',
                                                      planList.first[
                                                                  'end_date'] ==
                                                              null
                                                          ? '-'
                                                          : formatDate(
                                                              planList.first[
                                                                  'end_date'])),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Pending Ammount',
                                                      planList.first[
                                                              'unpaid_amount'] ??
                                                          '-'),
                                                  const Spacer(flex: 10),
                                                  PrimaryButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return GenericDialogBox(
                                                                enableSecondaryButton:
                                                                    true,
                                                                isLoader: false,
                                                                title:
                                                                    "Add Branch Plan",
                                                                primaryButtonText:
                                                                    'Add',
                                                                secondaryButtonText:
                                                                    'Cancel',
                                                                onSecondaryButtonPressed:
                                                                    () {
                                                                  Get.back();
                                                                },
                                                                content:
                                                                    SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.7,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SelectableText(
                                                                                      "From Date ",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 8),
                                                                                    Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                                      child: TextField(
                                                                                        style: TextStyle(
                                                                                          fontSize: MediaQuery.of(context).size.width * 0.008,
                                                                                        ),
                                                                                        controller: fromDate,
                                                                                        readOnly: true,
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: const EdgeInsets.only(left: 10),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                            borderSide: const BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          hintText: 'Select Date ',
                                                                                          suffixIcon: IconButton(
                                                                                            icon: Icon(Icons.calendar_today),
                                                                                            onPressed: () async {
                                                                                              fromDate.text = await selectedDatee(context);

                                                                                              setState(() {});
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                            SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SelectableText(
                                                                                      "To Date ",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 8),
                                                                                    Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                                      child: TextField(
                                                                                        style: TextStyle(
                                                                                          fontSize: MediaQuery.of(context).size.width * 0.008,
                                                                                        ),
                                                                                        controller: toDate,
                                                                                        readOnly: true,
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: const EdgeInsets.only(left: 10),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                            borderSide: const BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          hintText: 'Select Date ',
                                                                                          suffixIcon: IconButton(
                                                                                            icon: Icon(Icons.calendar_today),
                                                                                            onPressed: () async {
                                                                                              toDate.text = await selectedDatee(context);

                                                                                              setState(() {});
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.3,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  const Flexible(
                                                                                    child: SelectableText(
                                                                                      'Total Ammount',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.07,
                                                                                    child: TextFormField(
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                                      ],
                                                                                      decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColor),
                                                                                          )),
                                                                                      controller: totalAmtPaid,
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: true,
                                                                                      autofocus: true,
                                                                                      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.3,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  const Flexible(
                                                                                    child: SelectableText(
                                                                                      'Paid Ammount',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.07,
                                                                                    child: TextFormField(
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                                      ],
                                                                                      decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColor),
                                                                                          )),
                                                                                      controller: paidAmmot,
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: true,
                                                                                      autofocus: true,
                                                                                      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
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
                                                                          future:
                                                                              memmberController.addMemberPlan({
                                                                            'start_date':
                                                                                fromDate.text,
                                                                            'end_date':
                                                                                toDate.text,
                                                                            'price':
                                                                                totalAmtPaid.text,
                                                                            'paid_amount':
                                                                                paidAmmot.text
                                                                          }, membersData['id']),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            return snapshot.connectionState == ConnectionState.waiting
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
                                                                                : GenericDialogBox(
                                                                                    closeButtonEnabled: false,
                                                                                    enablePrimaryButton: true,
                                                                                    enableSecondaryButton: false,
                                                                                    isLoader: false,
                                                                                    content: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.04,
                                                                                        height: MediaQuery.of(context).size.width * 0.06,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(snapshot.data!['message'])
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    primaryButtonText: 'Ok',
                                                                                    onPrimaryButtonPressed: () async {
                                                                                      Get.offAllNamed(MemberProfile.routeName, arguments: membersData['id']);
                                                                                    },
                                                                                  );
                                                                          },
                                                                        );
                                                                      });
                                                                },
                                                              );
                                                            });
                                                      },
                                                      title: 'Add Plan'),
                                                  const Spacer(flex: 1),
                                                  PrimaryButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return GenericDialogBox(
                                                                enableSecondaryButton:
                                                                    true,
                                                                isLoader: false,
                                                                title:
                                                                    "Pay Pending Ammount",
                                                                primaryButtonText:
                                                                    'Paid',
                                                                secondaryButtonText:
                                                                    'Cancel',
                                                                content:
                                                                    SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.3,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Flexible(
                                                                        child:
                                                                            SelectableText(
                                                                          'Paid Ammount',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.07,
                                                                        child:
                                                                            TextFormField(
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                          ],
                                                                          decoration: const InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: primaryThemeColor),
                                                                              )),
                                                                          controller:
                                                                              paidAmmot,
                                                                          keyboardType:
                                                                              TextInputType.emailAddress,
                                                                          enableSuggestions:
                                                                              true,
                                                                          autofocus:
                                                                              true,
                                                                          style:
                                                                              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
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
                                                                          future:
                                                                              memmberController.payPending({
                                                                            'price':
                                                                                paidAmmot.text
                                                                          }, membersData['id']),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            return snapshot.connectionState == ConnectionState.waiting
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
                                                                                : GenericDialogBox(
                                                                                    closeButtonEnabled: false,
                                                                                    enablePrimaryButton: true,
                                                                                    enableSecondaryButton: false,
                                                                                    isLoader: false,
                                                                                    content: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.04,
                                                                                        height: MediaQuery.of(context).size.width * 0.06,
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(snapshot.data!['message'])
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    primaryButtonText: 'Ok',
                                                                                    onPrimaryButtonPressed: () async {
                                                                                      Get.offAllNamed(MemberProfile.routeName, arguments: membersData['id']);
                                                                                    },
                                                                                  );
                                                                          },
                                                                        );
                                                                      });
                                                                },
                                                              );
                                                            });
                                                      },
                                                      title: 'Pay Pending')
                                                ])),
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15 *
                                                planList.length,
                                            child: ListView.builder(
                                              itemCount: planList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.115,
                                                    color: Color.fromARGB(
                                                        255, 220, 215, 215),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SocialValue(
                                                              'Start Date',
                                                              planList[index][
                                                                          'start_date'] ==
                                                                      null
                                                                  ? '-'
                                                                  : formatDate(planList[
                                                                          index]
                                                                      [
                                                                      'start_date'])),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'End Date',
                                                              planList[index][
                                                                          'end_date'] ==
                                                                      null
                                                                  ? '-'
                                                                  : formatDate(planList[
                                                                          index]
                                                                      [
                                                                      'end_date'])),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Total Ammount',
                                                              planList[index][
                                                                          'price']
                                                                      ?.toString() ??
                                                                  '-'),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Paid Ammount',
                                                              planList[index][
                                                                          'paid_amount']
                                                                      ?.toString() ??
                                                                  '-'),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Pending Ammount',
                                                              planList[index][
                                                                          'unpaid_amount']
                                                                      ?.toString() ??
                                                                  '-'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))
                                      ])),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: const CircleAvatar(
                                            radius: 70,
                                            backgroundImage: AssetImage(
                                                'assets/images/person.png'))))
                              ])),
                          // Container(
                          //     margin: EdgeInsets.symmetric(
                          //         horizontal: _width / 10, vertical: 20),
                          //     padding: const EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(5),
                          //         boxShadow: [
                          //           BoxShadow(
                          //               color: Colors.black.withOpacity(.1),
                          //               blurRadius: 5,
                          //               spreadRadius: 2)
                          //         ]),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         Container(
                          //             margin:
                          //                 const EdgeInsets.symmetric(vertical: 20),
                          //             child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 children: [
                          //                   BoldBlackText('Let\'s keep in touch!'),
                          //                   NormalGreyText(
                          //                       'Find us on any of these platforms, we respond 1-2 business days.'),
                          //                   const SizedBox(height: 10),
                          //                   Row(children: [
                          //                     const Spacer(flex: 1),
                          //                     FloatingIconsButtons(
                          //                         'assets/icon/facebook.svg'),
                          //                     FloatingIconsButtons(
                          //                         'assets/icon/linkedin.svg'),
                          //                     FloatingIconsButtons(
                          //                         'assets/icon/skype.svg'),
                          //                     FloatingIconsButtons(
                          //                         'assets/icon/twitter.svg'),
                          //                     FloatingIconsButtons(
                          //                         'assets/icon/youtube.svg'),
                          //                     const Spacer(flex: 1)
                          //                   ])
                          //                 ])),
                          //         Container(
                          //             margin: const EdgeInsets.all(20),
                          //             child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: [
                          //                   Column(
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.center,
                          //                       children: [
                          //                         NormalGreyText('USEFUL LINKS'),
                          //                         TextButtons('About Us',
                          //                             Colors.grey[900]!),
                          //                         TextButtons(
                          //                             'Blog', Colors.grey[900]!),
                          //                         TextButtons(
                          //                             'Github', Colors.grey[900]!),
                          //                         TextButtons('Free Products',
                          //                             Colors.grey[900]!)
                          //                       ]),
                          //                   const SizedBox(width: 50),
                          //                   Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.center,
                          //                     children: [
                          //                       NormalGreyText('OTHER RESOURCES'),
                          //                       TextButtons('MIT License',
                          //                           Colors.grey[900]!),
                          //                       TextButtons('Terms & Conditions',
                          //                           Colors.grey[900]!),
                          //                       TextButtons('Privacy Policy',
                          //                           Colors.grey[900]!),
                          //                       TextButtons(
                          //                           'Contact Us', Colors.grey[900]!)
                          //                     ],
                          //                   )
                          //                 ]))
                          //       ],
                          //     ))
                        ]),
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
