import 'package:flutter/material.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/widgets/generic_appbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const String routeName = '/dashboard';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const Dashboard(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;

  @override
  void initState() {
    // getTasks();
    super.initState();
  }

  Widget _body() {
    return Center(
      child: Text('Dashboard'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(selected: "dashboard"),
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
                    selected: "dashboard",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            appBar: GenericAppBar(
              onNavbarIconPressed: () {
                setState(() {
                  isNavOpen = !isNavOpen;
                });
              },
              title: 'Dashboard',
              toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            ),
            body: _body(),
          ),
        ),
      ],
    );
  }
}
