import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/dashboards/branch/testdata.dart';
import 'package:gmstest/views/dashboards/widgets/stack_bargraph.dart';
import 'package:gmstest/views/dashboards/widgets/tile_widget.dart';
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
  DataRow recentFileDataRow(data) {
    return DataRow(
      cells: [
        DataCell(Text(data['month'])),
        DataCell(Text(data['ac'])),
        DataCell(Text(data['inc'])),
        DataCell(Text(data['pr'])),
        DataCell(Text(data['pp'])),
      ],
    );
  }

  @override
  void initState() {
    // getTasks();
    super.initState();
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(
                  flex: 2,
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
                    isExpanded: true,
                    elevation: 1,
                    items: ['2023', '2024', '2025', '2026'].map(
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
                    onChanged: (value) {},
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: FileInfoCard(
                    fieldName: "Active Admin's",
                    value: '1000',
                    svgSrc: 'assets/icon/people.png',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: FileInfoCard(
                    fieldName: "In-Active Admin's",
                    value: '1000',
                    svgSrc: 'assets/icon/people.png',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: FileInfoCard(
                    fieldName: "Payment Received",
                    value: '1000',
                    svgSrc: 'assets/icon/people.png',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: FileInfoCard(
                    fieldName: "Payment Pending",
                    value: '1000',
                    svgSrc: 'assets/icon/people.png',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                width: 20,
                height: 20,
                color: Colors.green,
              ),
              Text(
                "  - Active Admin's    ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.008,
                    fontWeight: FontWeight.w800),
              ),
              Container(
                width: 20,
                height: 20,
                color: primaryDarkYellowColor,
              ),
              Text(
                "  - In-Active Admin's    ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.008,
                    fontWeight: FontWeight.w800),
              )
            ]),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: StackBarGraphWidget([])
                      //  InventoryForecastGraphWidget(
                      //     inventoryForecastList, ''),
                      ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Files",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columnSpacing: 16,
                      // minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text("Month"),
                        ),
                        DataColumn(
                          label: Text("Active Admin's"),
                        ),
                        DataColumn(
                          label: Text("In-Active Admin's"),
                        ),
                        DataColumn(
                          label: Text("Payment Received"),
                        ),
                        DataColumn(
                          label: Text("Pending Payment"),
                        ),
                      ],
                      rows: List.generate(
                        testTableData.length,
                        (index) => recentFileDataRow(testTableData[index]),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
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
            body: _body(),
          ),
        ),
      ],
    );
  }
}
