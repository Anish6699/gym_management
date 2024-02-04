import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/views/dashboards/branch/testdata.dart';
import 'package:gmstest/views/dashboards/widgets/stack_bargraph.dart';
import 'package:gmstest/views/dashboards/widgets/tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard1View extends StatefulWidget {
  const Dashboard1View({super.key});

  @override
  State<Dashboard1View> createState() => _Dashboard1ViewState();
}

class _Dashboard1ViewState extends State<Dashboard1View> {
  List adminBranchList = [];
  AdminController adminController = AdminController();
  var selectedBranch;
  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    print('set initial data');
    final prefs = await SharedPreferences.getInstance();

    userType = prefs.getInt('user_type');
    adminId = prefs.getInt('adminId');
    branchId = prefs.getInt('branchId');

    if (userType == 2) {
      print('Admin login');
      adminBranchList =
          await adminController.getAdminAllBranches(adminId: adminId);
      selectedBranch = adminBranchList.first;
      // setDataOnBranchChange();
      setState(() {});
    }
    if (userType == 3) {
      print('branch login');
      // setDataOnBranchLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                userType == 2
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          elevation: 1,
                          value: selectedBranch,
                          items: adminBranchList.map(
                            (item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item['branch_name'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      color: Colors.white),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            selectedBranch = value;
                            setState(() {});
                            // setDataOnBranchChange();
                          },
                          borderRadius: BorderRadius.circular(4),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.08,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.015,
                          ),
                          decoration: InputDecoration(
                            hintText: "Select Branch",
                            hintStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.01,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                      )
                    : SizedBox(),
                SizedBox(
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
                    fieldName: "Active Member's",
                    value: '1000',
                    svgSrc: 'assets/icon/people.png',
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: FileInfoCard(
                    fieldName: "In-Active Member's",
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
                "  - Active Member's    ",
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
                "  - In-Active Member's    ",
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
                      child: StackBarGraphWidget(stackBarList)
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
                          label: Text("Active Member's"),
                        ),
                        DataColumn(
                          label: Text("In-Active Member's"),
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
  }

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
}
