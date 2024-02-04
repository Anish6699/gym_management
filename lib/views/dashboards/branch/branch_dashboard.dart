import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/dashboards/branch/branch_dashboard1.dart';
import 'package:gmstest/widgets/generic_appbar.dart';

class BranchDashboard extends StatefulWidget {
  const BranchDashboard({super.key});
  static const String routeName = '/branch-dashboard';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const BranchDashboard(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<BranchDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<BranchDashboard>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;

  @override
  void initState() {
    // getTasks();
    super.initState();
  }

  AppBar _getTabs() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TabBar(
                    onTap: (value) {
                      // removeFocus();
                    },
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: primaryDarkBlueColor,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Colors.transparent;
                      },
                    ),
                    tabs: [
                      Text(
                        'Dashboard 1',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.011),
                      ),
                      Text(
                        'Dashboard 2',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.011),
                      ),
                      Text(
                        'Dashboard 3',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.011),
                      ),
                      Text(
                        'Dashboard 4',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.011),
                      ),
                      Text(
                        'Dashboard 5',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.011),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    var mediaQuery = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: DefaultTabController(
            // initialIndex: widget.selectedTab,
            length: 5,
            child: Scaffold(
              key: scaffoldKey,
              // backgroundColor: tertiaryGreyColor,
              appBar: _getTabs(),
              body: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Dashboard1View(),
                  Dashboard1View(),
                  Dashboard1View(),
                  Dashboard1View(),
                  Dashboard1View()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _body1() {
    return Dashboard1View();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(
                    selected: "branch-dashboard"),
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
                    selected: "branch-dashboard",
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
            //   title: 'Branch Dashboard',
            //   toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            // ),
            body: _body1(),
          ),
        ),
      ],
    );
  }
}