// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:davi/davi.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:gmstest/widgets/searchfield.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// import 'package:easy_table/easy_table.dart';

class VisitorsView extends StatefulWidget {
  const VisitorsView({Key? key}) : super(key: key);

  static const String visitorsRouteName = '/visitors-view';

  static Route visitorRoute() {
    return MaterialPageRoute(
        builder: (_) => const VisitorsView(),
        settings: const RouteSettings(name: visitorsRouteName));
  }

  @override
  State<VisitorsView> createState() => _VisitorsState();
}

class _VisitorsState extends State<VisitorsView> {
  bool isNavOpen = true;
  final FocusNode _tableFocusNode = FocusNode();
  bool isLoading = true;

  var _headerModel;
  var selectedEntity = 'All';

  TextEditingController searchController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController primaryMobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Map<String, dynamic>> visitorsList = [];
  AdminController adminController = AdminController();
  MemberController visitorController = MemberController();
  List adminBranchList = [];
  DateTime selectedDateTime = DateTime.now();

  TextEditingController filterFromDateController = TextEditingController();
  TextEditingController filterToDateController = TextEditingController();

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
    final prefs = await SharedPreferences.getInstance();

    userType = prefs.getInt('user_type');
    adminId = prefs.getInt('adminId');
    branchId = prefs.getInt('branchId');

    if (userType == 2) {
      adminBranchList =
          await adminController.getAdminAllBranches(adminId: adminId);
      if (globalSelectedBranch != null) {
        for (int i = 0; i < adminBranchList.length; i++) {
          if (globalSelectedBranch['id'] == adminBranchList[i]['id']) {
            selectedBranch = adminBranchList[i];
          }
        }
      } else {
        selectedBranch = adminBranchList.first;
      }
      setDataOnBranchChange();
    }
    if (userType == 3) {
      setDataOnBranchLogin();
    }
  }

  setDataOnBranchLogin() async {
    isLoading = true;
    setState(() {});

    var a = await visitorController.getAllVisitors(
        branchId: branchId,
        searchKeyword: searchController.text,
        startDate: filterFromDateController.text,
        endDate: filterToDateController.text);

    List<Map<String, dynamic>> visitorsList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();

    _headerModel = DaviModel(
      rows: visitorsList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
  }

  initializeData() {
    _headerModel = DaviModel(
      rows: visitorsList,
      columns: _getColumns(context),
    );

    isLoading = false;
    setState(() {});
  }

  setDataOnBranchChange() async {
    isLoading = true;
    setState(() {});

    var a = await visitorController.getAllVisitors(
        branchId: branchId ?? selectedBranch['id'],
        searchKeyword: searchController.text,
        startDate: filterFromDateController.text,
        endDate: filterToDateController.text);

    List<Map<String, dynamic>> visitorsList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();

    _headerModel = DaviModel(
      rows: visitorsList,
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
      rows: visitorsList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  String formatVesselList(List vessels) {
    String formattedString = '';

    for (var vessel in vessels) {
      String vesselName = vessel;
      formattedString += '\n $vesselName \n';
    }

    return formattedString.trim();
  }

  String formatGcvList(List gcvs) {
    String formattedString = '';

    for (var gcv in gcvs) {
      String gcvName = gcv.toString();
      formattedString += '\n ${gcvName.toString()} \n';
    }

    return formattedString.trim();
  }

  String formatVesselList2(List vessels) {
    String formattedString = '';

    for (var vessel in vessels) {
      String vesselName = vessel['vessel_gcv'];
      formattedString += '\n $vesselName \n';
    }

    return formattedString.trim();
  }

  List<DaviColumn<Map<String, dynamic>>> _getColumns(BuildContext context) {
    return [
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Name',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => '${row['first_name']} ${row['last_name']}',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Visited Date',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) =>
            DateFormat('d MMM yyyy').format(DateTime.parse(row['created_at'])),

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.09,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Mobile No',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['primary_mobile_no'].toString(),

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Email',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['email'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Address',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['addr'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Email',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['email'],

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

        name: 'Age',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['age'].toString(),

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
          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    print('row datatatatatatattatatatat');
                    print(row.data);
                    firstNameController.text = row.data['first_name'];
                    lastNameController.text = row.data['last_name'];
                    primaryMobileNo.text = row.data['primary_mobile_no'];
                    ageController.text = row.data['age']?.toString() ?? '';
                    email.text = row.data['email'];
                    address.text = row.data['addr'];

                    showDialog(
                        context: context,
                        builder: (context) {
                          return GenericDialogBox(
                            enableSecondaryButton: true,
                            isLoader: false,
                            title: "Edit Visitor",
                            primaryButtonText: 'Update',
                            secondaryButtonText: 'Cancel',
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'First Name',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[a-zA-Z ]{0,20}$')),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller:
                                                      firstNameController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'Last Name',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[a-zA-Z ]{0,20}$')),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller:
                                                      lastNameController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'Primary Mobile No',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[0-9]{0,10}$')),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller: primaryMobileNo,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'Age',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[0-9]{0,2}$')),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller: ageController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'Email',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller: email,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Flexible(
                                                child: SelectableText(
                                                  'Address',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                child: TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    secondaryBorderGreyColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryThemeColor),
                                                          )),
                                                  controller: address,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
                                                  onChanged: (e) {},
                                                  autofocus: true,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onSecondaryButtonPressed: () {
                              Get.back();
                            },
                            onPrimaryButtonPressed: () {
                              if (firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  primaryMobileNo.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return GenericDialogBox(
                                        enableSecondaryButton: false,
                                        primaryButtonText: 'Ok',
                                        isLoader: false,
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Please Enter All Mandatory Field')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPrimaryButtonPressed: () {
                                          Get.back();
                                        },
                                      );
                                    });
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: visitorController.editVisitor({
                                          'first_name':
                                              firstNameController.text == ''
                                                  ? null
                                                  : firstNameController.text,
                                          'last_name':
                                              lastNameController.text == ''
                                                  ? null
                                                  : lastNameController.text,
                                          'primary_mobile_no':
                                              primaryMobileNo.text == ''
                                                  ? null
                                                  : primaryMobileNo.text,
                                          'email': email.text == ''
                                              ? null
                                              : email.text,
                                          'addr': address.text == ''
                                              ? null
                                              : address.text,
                                          'age': ageController.text == ''
                                              ? null
                                              : ageController.text,
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
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
                              }
                            },
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: primaryColor,
                  )),
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
                            message: "Are you Sure want to Delete Visitor",
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
                                      future: visitorController
                                          .deleteVisitor(row.data['id']),
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
                                                      const EdgeInsets.all(8.0),
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
                                                      const EdgeInsets.all(8.0),
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
          );
        },

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
    ];
  }

  // void downloadTemplate() {
  //   Uri url = Uri.parse('$serverUrl/downloadrakedispatchedtemplate');
  //   launchUrl(url, webOnlyWindowName: '_blank');
  // }

  Widget _body(mediaQuery) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Visitors",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(
                flex: 2,
              ),
              userType == 2
                  ? adminBranchList.isNotEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.15,
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
                                                0.008,
                                        color: Colors.white),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              globalSelectedBranch = value;
                              selectedBranch = value;
                              setState(() {});
                              setDataOnBranchChange();
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
                                  fontSize: mediaQuery.width * 0.008,
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
                      : const SizedBox()
                  : SizedBox(),
              // Expanded(child: SearchField()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: TextField(
                    style: TextStyle(
                      fontSize: mediaQuery.width * 0.008,
                    ),
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
                          setDataOnBranchLogin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, top: 3, bottom: 3),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                    controller: filterFromDateController,
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
                          filterFromDateController.text =
                              await selectedDatee(context);

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
                  controller: filterToDateController,
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
                        filterToDateController.text =
                            await selectedDatee(context);

                        setDataOnBranchChange();
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
                    filterFromDateController.clear();
                    filterToDateController.clear();
                    setDataOnBranchChange();
                  },
                  title: 'Clear Filter',
                ),
              )
            ],
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [],
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
                          dividerColor:
                              secondaryBorderGreyColor.withOpacity(0.2),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(
                  selected: "visitors",
                  // subSelected: "approvedCoalDatabase",
                ),
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
                    selected: "visitors",
                    // subSelected: "approvedCoalDatabase",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                firstNameController.clear();

                lastNameController.clear();
                primaryMobileNo.clear();

                email.clear();
                address.clear();

                showDialog(
                    context: context,
                    builder: (context) {
                      return GenericDialogBox(
                        enableSecondaryButton: true,
                        isLoader: false,
                        title: "Add Visitor",
                        primaryButtonText: 'Add',
                        secondaryButtonText: 'Cancel',
                        content: SizedBox(
                          height: mediaQuery.height * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'First Name *',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[a-zA-Z ]{0,20}$')),
                                              ],
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: firstNameController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Last Name *',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[a-zA-Z ]{0,20}$')),
                                              ],
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: lastNameController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Primary Mobile No *',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[0-9]{0,10}$')),
                                              ],
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: primaryMobileNo,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Age',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'[0-9]{0,2}$')),
                                              ],
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: ageController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Email',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: email,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Address',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            primaryThemeColor),
                                                  )),
                                              controller: address,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onSecondaryButtonPressed: () {
                          Get.back();
                        },
                        onPrimaryButtonPressed: () {
                          if (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              primaryMobileNo.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return GenericDialogBox(
                                    enableSecondaryButton: false,
                                    primaryButtonText: 'Ok',
                                    isLoader: false,
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'Please Enter All Mandatory Field')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPrimaryButtonPressed: () {
                                      Get.back();
                                    },
                                  );
                                });
                          } else {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return FutureBuilder(
                                    future: visitorController.addVisitor({
                                      'branch_id':
                                          branchId ?? selectedBranch['id'],
                                      'first_name':
                                          firstNameController.text == ''
                                              ? null
                                              : firstNameController.text,
                                      'last_name': lastNameController.text == ''
                                          ? null
                                          : lastNameController.text,
                                      'primary_mobile_no':
                                          primaryMobileNo.text == ''
                                              ? null
                                              : primaryMobileNo.text,
                                      'email':
                                          email.text == '' ? null : email.text,
                                      'addr': address.text == ''
                                          ? null
                                          : address.text,
                                      'age': ageController.text == ''
                                          ? null
                                          : ageController.text,
                                    }),
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
                          }
                        },
                      );
                    });
              },
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              child: Tooltip(
                  message: "Add Visitor",
                  child: Lottie.asset(
                      'assets/animations/add_member_animation.json')),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: _body(mediaQuery),
          ),
        ),
      ],
    );
  }
}
