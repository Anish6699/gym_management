import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/views/dashboard.dart';
import 'package:gmstest/views/members.dart';
import 'package:gmstest/views/trainer.dart';
import 'package:gmstest/views/visitors.dart';

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

    super.initState();
  }

  ScrollController scrollcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: primaryThemeColor,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
          child: ListView(
            controller: scrollcontroller,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.075,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      // width: MediaQuery.of(context).size.height * 0.2,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Image.asset(
                        'assets/logopng2.png',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        Dashboard.routeName,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "dashboard"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "dashboard"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "DASHBOARD",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "dashboard"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        AllAdmins.allAdminRouteName,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "allAdmin"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "allAdmin"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "Admins",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "allAdmin"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        MembersView.membersRouteName,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "members"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "members"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "MEMBER",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "members"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Planned Demand
                  InkWell(
                    onTap: () {
                      // Get.toNamed(PlannedDemandPage.routeName);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "invite-members"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "invite-members"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "INVITE MEMBERS",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "invite-members"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Vessel Arrival
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        VisitorsView.visitorsRouteName,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "visitors"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "visitors"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "VISITORS",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "visitors"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      // Get.toNamed(ConsumptionHomepage.ratnagiriRouteName, );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "workout-diet-plan"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sports_gymnastics,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "workout-diet-plan"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "WORKOUT/DIET PLAN",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        widget.selected == "workout-diet-plan"
                                            ? primaryThemeColor
                                            : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

// Coal Loss Statistics
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        TrainerView.trainerRouteName,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "trainer"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_sharp,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "trainer"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "TRAINER",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "trainer"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      //  Get.toNamed(
                      //           SalesDashboard.vijayanagarRouteName,
                      //           );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.006,
                          top: MediaQuery.of(context).size.width * 0.006),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.03,
                        decoration: BoxDecoration(
                          color: widget.selected == "sales-dashboard"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.006),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "sales-dashboard"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.012,
                              ),
                              Text(
                                "SALES DASHBOARD",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.009,
                                    fontWeight: FontWeight.w700,
                                    color: widget.selected == "sales-dashboard"
                                        ? primaryThemeColor
                                        : Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
