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
