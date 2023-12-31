import 'package:flutter/material.dart';

import 'package:gmstest/configs/colors.dart';

class InventoryNavigationPaneMinimized extends StatefulWidget {
  InventoryNavigationPaneMinimized({
    Key? key,
    required this.selected,
  }) : super(key: key);
  String selected;

  @override
  State<InventoryNavigationPaneMinimized> createState() =>
      _InventoryNavigationPaneMinimizedState();
}

bool coalVisible = true;
bool databaseVisible = false;
bool operatingConditionVisible = true;

class _InventoryNavigationPaneMinimizedState
    extends State<InventoryNavigationPaneMinimized> {
  @override
  initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: primaryThemeColor,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.085,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Image.asset(
                          'assets/iconpng.png',
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
                    Container(
                      // onTap: () {
                      //   // Get.toNamed(
                      //   //   Dashboard.routeName,
                      //   //   // () => const ApprovedCoalDatabase(),
                      //   //   //transition: Transition.noTransition,
                      //   // );
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "dashboard"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dashboard_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: widget.selected == "dashboard"
                                      ? primaryThemeColor
                                      : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "dashboard",
                                //   style: TextStyle(
                                //       fontSize:
                                //           MediaQuery.of(context).size.width *
                                //               0.009,
                                //       fontWeight: FontWeight.w700,
                                //       color: widget.selected == "dashboard"
                                //           ? primaryThemeColor
                                //           : Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // onTap: () {
                      //   // Get.toNamed(
                      //   //   Dashboard.routeName,
                      //   //   // () => const ApprovedCoalDatabase(),
                      //   //   //transition: Transition.noTransition,
                      //   // );
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "members"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color:
                                      widget.selected == "members"
                                          ? primaryThemeColor
                                          : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "dashboard",
                                //   style: TextStyle(
                                //       fontSize:
                                //           MediaQuery.of(context).size.width *
                                //               0.009,
                                //       fontWeight: FontWeight.w700,
                                //       color: widget.selected == "dashboard"
                                //           ? primaryThemeColor
                                //           : Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // onTap: () {
                      //   // Get.toNamed(
                      //   //   Dashboard.routeName,
                      //   //   // () => const ApprovedCoalDatabase(),
                      //   //   //transition: Transition.noTransition,
                      //   // );
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "inv-plannedDemand"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: widget.selected == "inv-plannedDemand"
                                      ? primaryThemeColor
                                      : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "dashboard",
                                //   style: TextStyle(
                                //       fontSize:
                                //           MediaQuery.of(context).size.width *
                                //               0.009,
                                //       fontWeight: FontWeight.w700,
                                //       color: widget.selected == "dashboard"
                                //           ? primaryThemeColor
                                //           : Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // onTap: () {
                      //   // Get.toNamed(
                      //   //   Dashboard.routeName,
                      //   //   // () => const ApprovedCoalDatabase(),
                      //   //   //transition: Transition.noTransition,
                      //   // );
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "inv-vesselArrival"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dashboard_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: widget.selected == "inv-vesselArrival"
                                      ? primaryThemeColor
                                      : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "dashboard",
                                //   style: TextStyle(
                                //       fontSize:
                                //           MediaQuery.of(context).size.width *
                                //               0.009,
                                //       fontWeight: FontWeight.w700,
                                //       color: widget.selected == "dashboard"
                                //           ? primaryThemeColor
                                //           : Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10),
                      child: Container(
                        // onTap: () {
                        //   //   Get.toNamed(OptimizerPage.scenarioInputRouteName);
                        // },
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "rake"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dashboard_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: widget.selected == "rake"
                                      ? primaryThemeColor
                                      : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "OPTIMIZER",
                                //   style: TextStyle(
                                //     fontSize:
                                //         MediaQuery.of(context).size.width *
                                //             0.009,
                                //     fontWeight: FontWeight.w700,
                                //     color: widget.selected == "optimizer"
                                //         ? primaryThemeColor
                                //         : Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // onTap: () {
                      //   // Get.toNamed(
                      //   //   Dashboard.routeName,
                      //   //   // () => const ApprovedCoalDatabase(),
                      //   //   //transition: Transition.noTransition,
                      //   // );
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.selected == "inv-consumption"
                                ? Colors.white
                                : primaryThemeColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dashboard_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: widget.selected == "inv-consumption"
                                      ? primaryThemeColor
                                      : Colors.white,
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.012,
                                // ),
                                // Text(
                                //   "dashboard",
                                //   style: TextStyle(
                                //       fontSize:
                                //           MediaQuery.of(context).size.width *
                                //               0.009,
                                //       fontWeight: FontWeight.w700,
                                //       color: widget.selected == "dashboard"
                                //           ? primaryThemeColor
                                //           : Colors.white),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.selected == "inv-coalLossStatistics"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color:
                                    widget.selected == "inv-coalLossStatistics"
                                        ? primaryThemeColor
                                        : Colors.white,
                              ),
                              // SizedBox(
                              //   width:
                              //       MediaQuery.of(context).size.width * 0.012,
                              // ),
                              // Text(
                              //   "dashboard",
                              //   style: TextStyle(
                              //       fontSize:
                              //           MediaQuery.of(context).size.width *
                              //               0.009,
                              //       fontWeight: FontWeight.w700,
                              //       color: widget.selected == "dashboard"
                              //           ? primaryThemeColor
                              //           : Colors.white),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.selected == "inv-shipmentStatistics"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color:
                                    widget.selected == "inv-shipmentStatistics"
                                        ? primaryThemeColor
                                        : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.selected == "inv-sales-dashboard"
                              ? Colors.white
                              : primaryThemeColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dashboard_outlined,
                                size: MediaQuery.of(context).size.width * 0.012,
                                color: widget.selected == "inv-sales-dashboard"
                                    ? primaryThemeColor
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
