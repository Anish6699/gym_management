import 'package:flutter/material.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/widgets/generic_appbar.dart';

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

  @override
  void initState() {
    // getTasks();
    super.initState();
  }

  Widget _body() {
    return Center(
      child: Text('Admin Dashboard'),
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
