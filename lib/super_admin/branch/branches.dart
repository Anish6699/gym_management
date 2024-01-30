// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/super_admin/branch/branch_view.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:davi/davi.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:intl/intl.dart';
// import 'package:easy_table/easy_table.dart';

class AdminAllBranch extends StatefulWidget {
  const AdminAllBranch({Key? key}) : super(key: key);

  static const String adminAllBranchesRouteName = '/admin-all-branch-view';

  static Route allAdminsRoute(dynamic arguments) {
    return MaterialPageRoute(
        builder: (_) => const AdminAllBranch(),
        settings: RouteSettings(
            name: adminAllBranchesRouteName, arguments: arguments));
  }

  @override
  State<AdminAllBranch> createState() => _MembersState();
}

class _MembersState extends State<AdminAllBranch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> uploadRakeDispatched = [];

  ScrollController horizontalTableScrollController = ScrollController();

  bool isNavOpen = true;
  final FocusNode _tableFocusNode = FocusNode();
  bool isLoading = true;

  var _headerModel;
  var selectedEntity = 'All';

  AdminController adminController = AdminController();
  TextEditingController searchController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController primaryMobileNo = TextEditingController();
  TextEditingController secondaryMobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController totalAmtPaid = TextEditingController();
  TextEditingController paidAmmot = TextEditingController();
  Map arrData = {};
  DateTime selectedDateTime = DateTime.now();

  List adminBranchList = [];
  @override
  void initState() {
    getAdminData();
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

  getAdminData() async {
    print('innnn elseee');

    arrData = Get.arguments;
    adminBranchList = await adminController.getAdminAllBranches(
        adminId: Get.arguments['adminId']);

    initializeData();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  initializeData() {
    _headerModel = DaviModel(
      rows: adminBranchList,
      columns: _getColumns(context),
    );

    isLoading = false;
    setState(() {});
  }

  setSearchData() {
    if (searchController.text.isNotEmpty) {
      changeTableDataBySearch();
    } else {
      changeTableData();
    }
  }

  changeTableData() async {
    isLoading = true;
    setState(() {});
    adminBranchList =
        await adminController.getAdminAllBranches(adminId: arrData['adminId']);
    _headerModel = DaviModel(
      rows: adminBranchList,
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
      rows: adminBranchList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  List<DaviColumn> _getColumns(BuildContext context) {
    return [
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.13,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Branch Name',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['branch_name'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.12,

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
        width: MediaQuery.of(context).size.width * 0.12,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Alternate Number',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['secondary_mobile_no'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.17,

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
        width: MediaQuery.of(context).size.width * 0.16,

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
        name: 'Action',
        cellBuilder: (context, data) {
          return Center(
              child: InkWell(
                  onTap: () {
                    Get.toNamed(BranchProfile.routeName,
                        arguments: data.data['id']);
                  },
                  child: const Tooltip(
                    message: 'View Profile',
                    child: Icon(
                      Icons.home,
                      color: primaryDarkGreenColor,
                    ),
                  )));
          ;
        },

        width: MediaQuery.of(context).size.width * 0.066,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => '',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        name: 'Action',
        cellBuilder: (context, data) {
          return Center(
              child: InkWell(
                  onTap: () {
                    firstNameController.clear();

                    lastNameController.clear();
                    primaryMobileNo.clear();
                    secondaryMobileNo.clear();
                    email.clear();
                    address.clear();
                    password.clear();

                    firstNameController.text = data.data['branch_name'] ?? '';

                    primaryMobileNo.text = data.data['primary_mobile_no'] ?? '';
                    secondaryMobileNo.text =
                        data.data['secondary_mobile_no'] ?? '';
                    email.text = data.data['email'] ?? '';
                    address.text = data.data['addr'] ?? '';

                    showDialog(
                        context: context,
                        builder: (context) {
                          return GenericDialogBox(
                            enableSecondaryButton: true,
                            isLoader: false,
                            title: "Edit Branch",
                            primaryButtonText: 'Edit',
                            secondaryButtonText: 'Cancel',
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Branch Name',
                                              style: TextStyle(
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
                                              controller: firstNameController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Primary Mobile No',
                                              style: TextStyle(
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
                                              controller: primaryMobileNo,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Secondary Mobile No',
                                              style: TextStyle(
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
                                              controller: secondaryMobileNo,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
                                              onChanged: (e) {},
                                              autofocus: true,
                                              style: TextStyle(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Email',
                                              style: TextStyle(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Address',
                                              style: TextStyle(
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
                              ),
                            ),
                            onPrimaryButtonPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return FutureBuilder(
                                      future: adminController.editBranch({
                                        'owner_name': arrData['adminId'],
                                        'branch_name': firstNameController.text,
                                        'primary_mobile_no':
                                            primaryMobileNo.text,
                                        'email': email.text,
                                        'address': address.text,
                                        'secondary_mobile_no':
                                            secondaryMobileNo.text,
                                      }, data.data['id']),
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
                                                          Text(snapshot
                                                              .data!['message'])
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                primaryButtonText: 'Ok',
                                                onPrimaryButtonPressed:
                                                    () async {
                                                  await changeTableData();
                                                  Get.back();
                                                  Get.back();
                                                  // Get.offAllNamed(
                                                  //   AdminAllBranch
                                                  //       .adminAllBranchesRouteName,
                                                  // );
                                                },
                                              );
                                      },
                                    );
                                  });
                            },
                          );
                        });
                  },
                  child: const Icon(Icons.edit)));
        },

        width: MediaQuery.of(context).size.width * 0.066,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => '',

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: mediaQuery.width * 0.03,
                    width: MediaQuery.of(context).size.width * 0.09,
                    color: Colors.white,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      elevation: 1,
                      value: selectedEntity,
                      items:
                          ['All', 'Active', 'In Active', 'Payment Pending'].map(
                        (String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.008,
                                  color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        selectedEntity = value!;
                        searchController.text = '';
                        setState(() {});
                        changeTableData();
                        // getRatnagiriRevisionList();
                      },
                      borderRadius: BorderRadius.circular(4),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: primaryGreyColor,
                        size: MediaQuery.of(context).size.width * 0.011,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Select Filter",
                        // hintStyle: TextStyle(
                        //     fontSize:
                        //         MediaQuery.of(context).size.width *
                        //             0.08,
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                      ),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.width * 0.01,
                  ),
                  Container(
                    height: mediaQuery.width * 0.03,
                    width: mediaQuery.width * 0.2,
                    color: Colors.white,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      controller: searchController,
                      onChanged: (value) {
                        if (searchController.text.isEmpty) {
                          changeTableData();
                        }
                        setState(() {});
                      },
                      style: TextStyle(
                        fontSize: mediaQuery.width * 0.008,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.008,
                        ),
                        suffixIcon: InkWell(
                          onTap: searchController.text.isNotEmpty
                              ? () {
                                  setSearchData();
                                }
                              : null,
                          child: Icon(
                            Icons.search,
                            color: searchController.text.isNotEmpty
                                ? Colors.black
                                : primaryGreyColor,
                            size: MediaQuery.of(context).size.width * 0.015,
                          ),
                        ),
                        errorStyle:
                            TextStyle(fontSize: mediaQuery.width * 0.006),
                        contentPadding: const EdgeInsets.only(left: 10),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide:
                              const BorderSide(color: secondaryBorderGreyColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide:
                              const BorderSide(color: secondaryBorderGreyColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    // margin:
                    //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(darkGreenColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ))),
                      onPressed: () {
                        firstNameController.clear();

                        lastNameController.clear();
                        primaryMobileNo.clear();
                        secondaryMobileNo.clear();
                        email.clear();
                        address.clear();
                        password.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return GenericDialogBox(
                                enableSecondaryButton: true,
                                isLoader: false,
                                title: "Add Branch",
                                primaryButtonText: 'Add',
                                secondaryButtonText: 'Cancel',
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Branch Name',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller:
                                                          firstNameController,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Primary Mobile No',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller:
                                                          primaryMobileNo,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
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
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Secondary Mobile No',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller:
                                                          secondaryMobileNo,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Email',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller: email,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
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
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Address',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller: address,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Password',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller: password,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      onChanged: (e) {},
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
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
                                                    0.3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SelectableText(
                                                      "From Date ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      child: TextField(
                                                        style: TextStyle(
                                                          fontSize:
                                                              mediaQuery.width *
                                                                  0.008,
                                                        ),
                                                        controller: fromDate,
                                                        readOnly: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        secondaryBorderGreyColor),
                                                          ),
                                                          hintText:
                                                              'Select Date ',
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            onPressed:
                                                                () async {
                                                              fromDate.text =
                                                                  await selectedDatee(
                                                                      context);

                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SelectableText(
                                                      "To Date ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      child: TextField(
                                                        style: TextStyle(
                                                          fontSize:
                                                              mediaQuery.width *
                                                                  0.008,
                                                        ),
                                                        controller: toDate,
                                                        readOnly: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        secondaryBorderGreyColor),
                                                          ),
                                                          hintText:
                                                              'Select Date ',
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            onPressed:
                                                                () async {
                                                              toDate.text =
                                                                  await selectedDatee(
                                                                      context);

                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Total Ammount',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller: totalAmtPaid,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Flexible(
                                                    child: SelectableText(
                                                      'Paid Ammount',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryBorderGreyColor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            primaryThemeColor),
                                                              )),
                                                      controller: paidAmmot,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      enableSuggestions: true,
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
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
                                onPrimaryButtonPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return FutureBuilder(
                                          future: adminController.addBranch({
                                            'owner_name': arrData['adminId'],
                                            'branch_name':
                                                firstNameController.text,
                                            'primary_mobile_no':
                                                primaryMobileNo.text,
                                            'email': email.text,
                                            'address': address.text,
                                            'password': password.text,
                                            'secondary_mobile_no':
                                                secondaryMobileNo.text,
                                            'start_date': fromDate.text,
                                            'end_date': toDate.text,
                                            'price': totalAmtPaid.text,
                                            'paid_amount': paidAmmot.text
                                          }),
                                          builder: (context, snapshot) {
                                            return snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? GenericDialogBox(
                                                    enableSecondaryButton:
                                                        false,
                                                    isLoader: true,
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                        height: MediaQuery.of(
                                                                    context)
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
                                                    enableSecondaryButton:
                                                        false,
                                                    isLoader: false,
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                        height: MediaQuery.of(
                                                                    context)
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
                                                                      .data![
                                                                  'message'])
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    primaryButtonText: 'Ok',
                                                    onPrimaryButtonPressed:
                                                        () async {
                                                      await changeTableData();
                                                      Get.back();
                                                      Get.back();
                                                      // Get.offAllNamed(
                                                      //   AdminAllBranch
                                                      //       .adminAllBranchesRouteName,
                                                      // );
                                                    },
                                                  );
                                          },
                                        );
                                      });
                                },
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.017,
                          ),
                          Text(
                            'Add Branch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.009,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text('ADMIN NAME : ${arrData['adminName'] ?? '-'}'),
              ),
            ],
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RawKeyboardListener(
                    focusNode: _tableFocusNode,
                    autofocus: true,
                    child: DaviTheme(
                      data: DaviThemeData(
                        columnDividerThickness: 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryThemeColor),
                        ),
                        columnDividerColor: primaryThemeColor,
                        scrollbar: const TableScrollbarThemeData(
                          pinnedHorizontalColor: Colors.transparent,
                          unpinnedHorizontalColor: Colors.transparent,
                          verticalColor: Colors.transparent,
                          borderThickness: 0.0,
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
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        header: const HeaderThemeData(
                          columnDividerColor: Colors.transparent,
                          bottomBorderColor: Colors.transparent,
                          color: Colors.black,
                        ),
                        row: RowThemeData(
                          color: (rowIndex) {
                            return Colors.white;
                          },
                          dividerColor: Colors.transparent,
                        ),
                        cell: CellThemeData(
                          contentHeight:
                              MediaQuery.of(context).size.height * 0.07,
                        ),
                      ),
                      child: Davi(
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
                  selected: "allAdmin",
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
                    selected: "allAdmin",
                    // subSelected: "approvedCoalDatabase",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            backgroundColor: lightBlueColor,
            appBar: GenericAppBar(
              onNavbarIconPressed: () {
                setState(() {
                  isNavOpen = !isNavOpen;
                });
              },
              title: 'Admin All Branches',
              toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            ),
            body: _body(mediaQuery),
          ),
        ),
      ],
    );
  }
}
