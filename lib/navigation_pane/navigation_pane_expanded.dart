import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/login_controllers.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/views/dashboards/admin_dashboard.dart';
import 'package:gmstest/views/dashboards/branch/branch_dashboard.dart';
import 'package:gmstest/views/dashboards/dashboard.dart';
import 'package:gmstest/views/expense_tracker.dart';
import 'package:gmstest/views/map_view.dart';
import 'package:gmstest/views/members/members.dart';
import 'package:gmstest/views/send_notifications.dart';
import 'package:gmstest/views/trainer.dart';
import 'package:gmstest/views/visitors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class InventoryNavigationPaneExpanded extends StatefulWidget {
  InventoryNavigationPaneExpanded({
    Key? key,
    required this.selected,
  }) : super(key: key);
  String selected;

  @override
  State<InventoryNavigationPaneExpanded> createState() =>
      _InventoryNavigationPaneExpandedState();
}

bool rakeVisible = true;

class _InventoryNavigationPaneExpandedState
    extends State<InventoryNavigationPaneExpanded> {
  @override
  initState() {
    // widget.selected == "coal" ? coalVisible = true : null;
    // widget.selected == "coal" ? databaseVisible = true : coalVisible = false;
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    final prefs = await SharedPreferences.getInstance();

    userType = prefs.getInt('user_type');
    adminId = prefs.getInt('adminId');
    branchId = prefs.getInt('branchId');
    categoryId = prefs.getInt('categoryId');

    setState(() {});
  }

  String getAnimationString() {
    switch (categoryId) {
      case 1:
        return 'assets/animations/member_animation.json';
      case 2:
        return 'assets/animations/football_animation.json';
      case 3:
        return 'assets/animations/cricket_animation.json';
      case 4:
        return 'assets/animations/dance_animation.json';
      case 5:
        return 'assets/animations/karate_animation.json';
      case 6:
        return 'assets/animations/singing_animation.json';
      case 7:
        return 'assets/animations/coach_animation.json';
      case 8:
        return 'assets/animations/coach_animation.json';
      default:
        return 'assets/animations/coach_animation.json';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  ScrollController scrollcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              color: primaryThemeColor,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: true),
                child: ListView(
                  controller: scrollcontroller,
                  children: [
                    DrawerHeader(
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Lottie.asset(getAnimationString()))

                        //  Image.asset("assets/manGym.png"),
                        ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // userType == 1
                        //     ? InkWell(
                        //         onTap: () {
                        //           Get.toNamed(
                        //             Dashboard.routeName,
                        //           );
                        //         },
                        //         child: Padding(
                        //           padding: EdgeInsets.only(
                        //               right: MediaQuery.of(context).size.width *
                        //                   0.006,
                        //               top: MediaQuery.of(context).size.width *
                        //                   0.006),
                        //           child: Container(
                        //             height: MediaQuery.of(context).size.width *
                        //                 0.03,
                        //             decoration: BoxDecoration(
                        //               color: widget.selected == "dashboard"
                        //                   ? Colors.white
                        //                   : Colors.transparent,
                        //               borderRadius: const BorderRadius.only(
                        //                   topRight: Radius.circular(5),
                        //                   bottomRight: Radius.circular(5)),
                        //             ),
                        //             child: Padding(
                        //               padding: EdgeInsets.all(
                        //                   MediaQuery.of(context).size.width *
                        //                       0.006),
                        //               child: Row(
                        //                 children: [
                        //                   Image.asset(
                        //                       'assets/icon/business-report.png'),
                        //                   SizedBox(
                        //                     width: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.012,
                        //                   ),
                        //                   Text(
                        //                     "SUPERADMIN DASHBOARD",
                        //                     style: TextStyle(
                        //                         fontSize: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width *
                        //                             0.009,
                        //                         fontWeight: FontWeight.w700,
                        //                         color: widget.selected ==
                        //                                 "dashboard"
                        //                             ? primaryThemeColor
                        //                             : Colors.white),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        userType == 2
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AdminDashboard.routeName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color:
                                          widget.selected == "admin-dashboard"
                                              ? Colors.white
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          // Icon(
                                          //   Icons.dashboard_outlined,
                                          //   size: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.012,
                                          //   color: widget.selected ==
                                          //           "admin-dashboard"
                                          //       ? primaryThemeColor
                                          //       : Colors.white,
                                          // ),
                                          Image.asset(
                                              'assets/icon/business-report.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "ADMIN DASHBOARD",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "admin-dashboard"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    BranchDashboard.routeName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color:
                                          widget.selected == "branch-dashboard"
                                              ? Colors.white
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          // Icon(
                                          //   Icons.dashboard_outlined,
                                          //   size: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.012,
                                          //   color: widget.selected ==
                                          //           "branch-dashboard"
                                          //       ? primaryThemeColor
                                          //       : Colors.white,
                                          // ),
                                          Image.asset(
                                              'assets/icon/business-report.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "BRANCH DASHBOARD",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "branch-dashboard"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        userType == 1
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AllAdmins.allAdminRouteName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "allAdmin"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                            color: widget.selected == "allAdmin"
                                                ? primaryThemeColor
                                                : Colors.white,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "ADMINS",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "allAdmin"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    MembersView.membersRouteName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "members"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          // Icon(
                                          //   Icons.person,
                                          //   size: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.012,
                                          //   color: widget.selected == "members"
                                          //       ? primaryThemeColor
                                          //       : Colors.white,
                                          // ),
                                          Image.asset('assets/icon/people.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "MEMBERS",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    widget.selected == "members"
                                                        ? primaryThemeColor
                                                        : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        // Planned Demand
                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(SendNotificationView.routeName);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "invite-members"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              'assets/icon/notification.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "SEND NOTIFICATIONS",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "invite-members"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        // Vessel Arrival
                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    VisitorsView.visitorsRouteName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "visitors"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              'assets/icon/visitors.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "VISITORS",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "visitors"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        // (userType == 2 || userType == 3)
                        //     ? InkWell(
                        //         onTap: () {
                        //           // Get.toNamed(ConsumptionHomepage.ratnagiriRouteName, );
                        //         },
                        //         child: Padding(
                        //           padding: EdgeInsets.only(
                        //               right: MediaQuery.of(context).size.width *
                        //                   0.006,
                        //               top: MediaQuery.of(context).size.width *
                        //                   0.006),
                        //           child: Container(
                        //             height: MediaQuery.of(context).size.width *
                        //                 0.03,
                        //             decoration: BoxDecoration(
                        //               color:
                        //                   widget.selected == "workout-diet-plan"
                        //                       ? Colors.white
                        //                       : Colors.transparent,
                        //               borderRadius: const BorderRadius.only(
                        //                   topRight: Radius.circular(5),
                        //                   bottomRight: Radius.circular(5)),
                        //             ),
                        //             child: Padding(
                        //               padding: EdgeInsets.all(
                        //                   MediaQuery.of(context).size.width *
                        //                       0.006),
                        //               child: Row(
                        //                 children: [
                        //                   Icon(
                        //                     Icons.sports_gymnastics,
                        //                     size: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.012,
                        //                     color: widget.selected ==
                        //                             "workout-diet-plan"
                        //                         ? primaryThemeColor
                        //                         : Colors.white,
                        //                   ),
                        //                   SizedBox(
                        //                     width: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.012,
                        //                   ),
                        //                   Text(
                        //                     "WORKOUT/DIET PLAN",
                        //                     style: TextStyle(
                        //                         fontSize: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width *
                        //                             0.009,
                        //                         fontWeight: FontWeight.w700,
                        //                         color: widget.selected ==
                        //                                 "workout-diet-plan"
                        //                             ? primaryThemeColor
                        //                             : Colors.white),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),

                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    TrainerView.trainerRouteName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "trainer"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/icon/coach.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "TRAINER",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    widget.selected == "trainer"
                                                        ? primaryThemeColor
                                                        : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),

                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    ExpenseTrackerView.routeName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color:
                                          widget.selected == "expense-tracker"
                                              ? Colors.white
                                              : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/icon/budget.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "Expence Tracker",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "expense-tracker"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        (userType == 2 || userType == 3)
                            ? InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    MapView.routeName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.006,
                                      top: MediaQuery.of(context).size.width *
                                          0.006),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                    decoration: BoxDecoration(
                                      color: widget.selected == "map-view"
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.006),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/icon/map.png'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.012,
                                          ),
                                          Text(
                                            "Map View",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.009,
                                                fontWeight: FontWeight.w700,
                                                color: widget.selected ==
                                                        "map-view"
                                                    ? primaryThemeColor
                                                    : Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        InkWell(
                          onTap: () {
                            LoginController().logout();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.006,
                                top: MediaQuery.of(context).size.width * 0.006),
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.03,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.006),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: MediaQuery.of(context).size.width *
                                          0.012,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.012,
                                    ),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.009,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
