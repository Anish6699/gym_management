import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/expense_tracker_controller.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/dashboards/widgets/expense_tracker_graph.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseTrackerView extends StatefulWidget {
  const ExpenseTrackerView({super.key});
  static const String routeName = '/expense-tracker';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const ExpenseTrackerView(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ExpenseTrackerView> createState() => _DashboardState();
}

class _DashboardState extends State<ExpenseTrackerView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isNavOpen = true;
  final FocusNode _tableFocusNode = FocusNode();
  bool isLoading = true;

  var _headerModel;
  var selectedEntity = 'All';

  TextEditingController searchController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expenseDateController = TextEditingController();
  TextEditingController expensePaidAmountController = TextEditingController();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  List<Map<String, dynamic>> expenseList = [];
  AdminController adminController = AdminController();
  ExpenseController expenseController = ExpenseController();
  List adminBranchList = [];
  DateTime selectedDateTime = DateTime.now();

  var selectedBranch;
  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  Future<String> selectedDatee(BuildContext context) async {
    String dateTime = '';
    DateTime initialDateTime = selectedDateTime;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      dateTime = DateFormat('dd-MM-yyyy').format(selectedDateTime);
    }
    return dateTime;
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
      setDataOnBranchChange();
    }
    if (userType == 3) {
      print('branch login');
      setDataOnBranchLogin();
    }
  }

  setDataOnBranchLogin() async {
    isLoading = true;
    setState(() {});

    var a = await expenseController.getAllExpenses(
        branchId: branchId,
        searchKeyword: searchController.text,
        startDate: fromDateController.text,
        endDate: toDateController.text);

    List<Map<String, dynamic>> expenseList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();
    print(' trainerrrr ${expenseList}');
    _headerModel = DaviModel(
      rows: expenseList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
  }

  initializeData() {
    _headerModel = DaviModel(
      rows: expenseList,
      columns: _getColumns(context),
    );

    isLoading = false;
    setState(() {});
  }

  setSearchData() {
    if (searchController.text.isNotEmpty) {
      changeTableDataBySearch();
    } else {
      setDataOnBranchChange();
    }
  }

  setDataOnBranchChange() async {
    isLoading = true;
    setState(() {});
    var a = await expenseController.getAllExpenses(
        branchId: branchId ?? selectedBranch['id'],
        searchKeyword: searchController.text,
        startDate: fromDateController.text,
        endDate: toDateController.text);

    List<Map<String, dynamic>> expenseList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();

    print(' trainerrrr ${expenseList}');

    _headerModel = DaviModel(
      rows: expenseList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  changeTableDataBySearch() async {
    isLoading = true;
    setState(() {});
    // var a = await rakeDispatchedController.getSearchedRakes(
    //     entity: selectedEntity == 'All' ? 'all' : selectedEntity,
    //     searchText: searchController.text);

    _headerModel = DaviModel(
      rows: expenseList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  List<DaviColumn<Map<String, dynamic>>> _getColumns(BuildContext context) {
    return [
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.2,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Expense',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => '${row['name']}',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.18,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Date',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['date']?.toString() ?? '-',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.18,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Ammount',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['amount']?.toString() ?? '-',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.1,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Action',

        // pinStatus: PinStatus.left,

        sortable: true,

        cellBuilder: (context, row) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      expenseNameController.text = row.data['name'];
                      expenseDateController.text = row.data['date'];
                      expensePaidAmountController.text = row.data['amount'];
                      showDialog(
                          context: context,
                          builder: (context) {
                            return GenericDialogBox(
                              enableSecondaryButton: true,
                              isLoader: false,
                              title: "Add Expense",
                              primaryButtonText: 'Add',
                              secondaryButtonText: 'Cancel',
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SelectableText(
                                      "Expense Date ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.008,
                                        ),
                                        controller: expenseDateController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            borderSide: const BorderSide(
                                                color:
                                                    secondaryBorderGreyColor),
                                          ),
                                          hintText: 'Select Date ',
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            onPressed: () async {
                                              expenseDateController.text =
                                                  await selectedDatee(context);

                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    const Flexible(
                                      child: SelectableText(
                                        'Expense',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      secondaryBorderGreyColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryThemeColor),
                                            )),
                                        controller: expenseNameController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        enableSuggestions: true,
                                        autofocus: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Flexible(
                                      child: SelectableText(
                                        'Paid Ammount',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      secondaryBorderGreyColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryThemeColor),
                                            )),
                                        controller: expensePaidAmountController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        enableSuggestions: true,
                                        autofocus: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onSecondaryButtonPressed: () {
                                Get.back();
                              },
                              onPrimaryButtonPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: expenseController.editExpence({
                                          'name': expenseNameController.text,
                                          'amount':
                                              expensePaidAmountController.text,
                                          'date': expenseDateController.text
                                        }, row.data['id']),
                                        builder: (context, snapshot) {
                                          return snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? GenericDialogBox(
                                                  enableSecondaryButton: false,
                                                  isLoader: true,
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      child: const Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircularProgressIndicator(
                                                              color:
                                                                  primaryDarkBlueColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : GenericDialogBox(
                                                  closeButtonEnabled: false,
                                                  enablePrimaryButton: true,
                                                  enableSecondaryButton: false,
                                                  isLoader: false,
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              snapshot.data![
                                                                  'message'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  primaryButtonText: 'Ok',
                                                  onPrimaryButtonPressed:
                                                      () async {
                                                    setDataOnBranchChange();
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                );
                                        },
                                      );
                                    });
                              },
                            );
                          });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: primaryColor,
                    )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return GenericDialogBox(
                              closeButtonEnabled: false,
                              enableSecondaryButton: true,
                              isLoader: false,
                              message: "Are you Sure want to Delete Expense",
                              primaryButtonText: "Confirm",
                              secondaryButtonText: "Cancel",
                              onSecondaryButtonPressed: () {
                                Get.back();
                              },
                              onPrimaryButtonPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: expenseController
                                            .deleteExpence(row.data['id']),
                                        builder: (context, snapshot) {
                                          print('snapshotttt datatatatat');
                                          print(snapshot.data);
                                          return snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? GenericDialogBox(
                                                  enableSecondaryButton: false,
                                                  isLoader: true,
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      child: const Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircularProgressIndicator(
                                                              color:
                                                                  primaryDarkBlueColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : GenericDialogBox(
                                                  closeButtonEnabled: false,
                                                  enablePrimaryButton: true,
                                                  enableSecondaryButton: false,
                                                  isLoader: false,
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              snapshot.data![
                                                                  'message'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  primaryButtonText: 'Ok',
                                                  onPrimaryButtonPressed:
                                                      () async {
                                                    setDataOnBranchChange();
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                );
                                        },
                                      );
                                    });
                              },
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
          );
        },

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
    ];
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
                  "Expense Tracker",
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: ExpenseTrackerGraph()
                      //  InventoryForecastGraphWidget(
                      //     inventoryForecastList, ''),
                      ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: body2(MediaQuery.of(context).size),
            )
          ],
        ),
      ),
    );
  }

  Widget body2(mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.08,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: secondaryColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setDataOnBranchChange();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, top: 3, bottom: 3),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset("assets/Search.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            userType == 2
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                                      MediaQuery.of(context).size.width * 0.01,
                                  color: Colors.white),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        selectedBranch = value;
                        setState(() {});
                        setDataOnBranchChange();
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
                        hintText: "Select Branch",
                        hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
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
                : const SizedBox(),
            SizedBox(
              width: mediaQuery.width * 0.01,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.height * 0.08,
                child: TextField(
                  style: TextStyle(
                    fontSize: mediaQuery.width * 0.008,
                  ),
                  controller: fromDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          const BorderSide(color: secondaryBorderGreyColor),
                    ),
                    hintText: 'From Date ',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        fromDateController.text = await selectedDatee(context);

                        setDataOnBranchChange();
                      },
                    ),
                  ),
                )),
            SizedBox(
              width: mediaQuery.width * 0.01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.08,
              child: TextField(
                style: TextStyle(
                  fontSize: mediaQuery.width * 0.008,
                ),
                controller: toDateController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        const BorderSide(color: secondaryBorderGreyColor),
                  ),
                  hintText: 'End Date ',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      toDateController.text = await selectedDatee(context);

                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: mediaQuery.width * 0.01,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: PrimaryButton(
                onPressed: () {
                  searchController.clear();

                  fromDateController.clear();
                  toDateController.clear();

                  setDataOnBranchChange();
                },
                title: 'Clear Filter',
              ),
            ),
          ],
        ),
        SizedBox(
          height: mediaQuery.height * 0.01,
        ),
        Container(
          padding: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.74,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RawKeyboardListener(
                  focusNode: _tableFocusNode,
                  autofocus: true,
                  child: DaviTheme(
                    data: DaviThemeData(
                      columnDividerThickness: 0.0,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0),
                      ),
                      columnDividerColor: primaryThemeColor,
                      scrollbar: const TableScrollbarThemeData(
                        pinnedHorizontalColor: Colors.transparent,
                        unpinnedHorizontalColor: Colors.transparent,
                        verticalColor: Colors.transparent,
                        borderThickness: 0.5,
                        verticalBorderColor: secondaryBorderGreyColor,
                        columnDividerColor: Colors.transparent,
                        thickness: 10.0,
                        horizontalOnlyWhenNeeded: true,
                        verticalOnlyWhenNeeded: true,
                        thumbColor: secondaryDarkGreyColor,
                      ),
                      headerCell: HeaderCellThemeData(
                        alignment: Alignment.center,
                        // sortIconSize:
                        //     MediaQuery.of(context).size.height * 0.05,
                        // ascendingIcon: Icons.arrow_drop_up,
                        // descendingIcon: Icons.arrow_drop_down,
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      header: const HeaderThemeData(
                        columnDividerColor: Colors.transparent,
                        bottomBorderColor: Colors.transparent,
                        color: primaryThemeColor,
                      ),
                      row: RowThemeData(
                        color: (rowIndex) {
                          return secondaryColor;
                        },
                        dividerColor: secondaryBorderGreyColor.withOpacity(0.2),
                      ),
                      cell: CellThemeData(
                        contentHeight:
                            MediaQuery.of(context).size.height * 0.08,
                      ),
                    ),
                    child: Davi<Map<String, dynamic>>(
                      _headerModel,

                      // visibleRowsCount:
                      //     MediaQuery.of(context).size.height ~/ 82.85,

                      // unpinnedHorizontalScrollController:
                      //     horizontalTableScrollController,

                      // verticalScrollController: _verticalScrollController,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(
                    selected: "expense-tracker"),
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
                    selected: "expense-tracker",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            body: _body(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                expenseNameController.clear();
                expenseDateController.clear();
                expensePaidAmountController.clear();
                showDialog(
                    context: context,
                    builder: (context) {
                      return GenericDialogBox(
                        enableSecondaryButton: true,
                        isLoader: false,
                        title: "Add Expense",
                        primaryButtonText: 'Add',
                        secondaryButtonText: 'Cancel',
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SelectableText(
                                "Expense Date ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: TextField(
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.008,
                                  ),
                                  controller: expenseDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: const BorderSide(
                                          color: secondaryBorderGreyColor),
                                    ),
                                    hintText: 'Select Date ',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () async {
                                        expenseDateController.text =
                                            await selectedDatee(context);

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              const Flexible(
                                child: SelectableText(
                                  'Expense',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryThemeColor),
                                      )),
                                  controller: expenseNameController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  autofocus: true,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Flexible(
                                child: SelectableText(
                                  'Paid Ammount',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryThemeColor),
                                      )),
                                  controller: expensePaidAmountController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  autofocus: true,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onSecondaryButtonPressed: () {
                          Get.back();
                        },
                        onPrimaryButtonPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return FutureBuilder(
                                  future: expenseController.addExpense(
                                    {
                                      'branch_id':
                                          branchId ?? selectedBranch['id'],
                                      'name': expenseNameController.text,
                                      'amount':
                                          expensePaidAmountController.text,
                                      'date': expenseDateController.text
                                    },
                                  ),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? GenericDialogBox(
                                            enableSecondaryButton: false,
                                            isLoader: true,
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                child: const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color:
                                                            primaryDarkBlueColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : GenericDialogBox(
                                            closeButtonEnabled: false,
                                            enablePrimaryButton: true,
                                            enableSecondaryButton: false,
                                            isLoader: false,
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(snapshot
                                                          .data!['message'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            primaryButtonText: 'Ok',
                                            onPrimaryButtonPressed: () async {
                                              setDataOnBranchChange();
                                              Get.back();
                                              Get.back();
                                            },
                                          );
                                  },
                                );
                              });
                        },
                      );
                    });
              },
              child:
                  Tooltip(message: "Add Expense", child: const Icon(Icons.add)),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ],
    );
  }
}
