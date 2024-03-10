import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/dashboard_controllers/admin_dashboard_controller.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/dashboards/widgets/admin_graph1.dart';
import 'package:gmstest/views/dashboards/widgets/gender_pi_chart.dart';
import 'package:gmstest/views/dashboards/widgets/livedata_tile_widget.dart';
import 'package:gmstest/views/dashboards/widgets/tile_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  static const String routeName = '/admin-dashboard';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const AdminDashboard(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<AdminDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;
  var selectedYear;
  AdminDashboardController adminDashboardController =
      AdminDashboardController();

  Map<String, dynamic> adminDashboardData = {};
  bool isLoading = true;

  @override
  void initState() {
    selectedYear = (DateTime.now().year).toString();
    getDashboardData();
    super.initState();
  }

  getDashboardData() async {
    adminDashboardData = await adminDashboardController
        .getAdminDashboardData({'year': selectedYear});

    isLoading = false;
    setState(() {});
  }

  setDataOnBranchChange() {}
  List yearList = ['2021', '2022', '2023', '2024', '2025', '2026'];

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          // Row(
          //   children: [
          //     Text(
          //       "Live Data",
          //       style: TextStyle(
          //           color: Colors.greenAccent,
          //           fontSize: MediaQuery.of(context).size.width * 0.035),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        LiveDataFileInfoCard(
                          fieldName: "Total Member's",
                          value: adminDashboardData['total_member'].toString(),
                          svgSrc: 'assets/icon/people.png',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        LiveDataFileInfoCard(
                          fieldName: "Total Visitor's",
                          value: adminDashboardData['total_visitor'].toString(),
                          svgSrc: 'assets/icon/visitors.png',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        LiveDataFileInfoCard(
                          fieldName: "Total Trainer's",
                          value: adminDashboardData['total_trainer'].toString(),
                          svgSrc: 'assets/icon/coach.png',
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "Year wise Data - (Overview of All Branches)",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(
                flex: 2,
              ),

              const SizedBox(
                width: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.transparent),
                ),
                child: DropdownButtonFormField(
                  value: selectedYear,
                  isExpanded: true,
                  elevation: 1,
                  items: yearList.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.01,
                              color: Colors.white),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    selectedYear = value!;
                    setState(() {
                      adminDashboardData.clear();
                      isLoading == true;
                    });
                    getDashboardData();
                  },
                  borderRadius: BorderRadius.circular(4),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.015,
                  ),
                  decoration: InputDecoration(
                    hintText: "Select Year",
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),

              // Expanded(child: SearchField()),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          isLoading == true
              ? CircularProgressIndicator()
              : adminDashboardData.isEmpty
                  ? SizedBox()
                  : AdminGraph1(
                      graphData: adminDashboardData['data'],
                    )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child:
                    // SideMenu()

                    InventoryNavigationPaneExpanded(
                        selected: "admin-dashboard"),
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
                    selected: "admin-dashboard",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            body: _body(),
          ),
        ),
      ],
    );
  }
}



 // CustomPieChart(
                //   maleCount: 20, // Replace with your male count
                //   femaleCount: 30, // Replace with your female count
                // ),