// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/super_admin/branch/branches.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:davi/davi.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:gmstest/widgets/searchfield.dart';
// import 'package:easy_table/easy_table.dart';

class AllAdmins extends StatefulWidget {
  const AllAdmins({Key? key}) : super(key: key);

  static const String allAdminRouteName = '/all-admin-view';

  static Route allAdminsRoute() {
    return MaterialPageRoute(
        builder: (_) => const AllAdmins(),
        settings: const RouteSettings(name: allAdminRouteName));
  }

  @override
  State<AllAdmins> createState() => _MembersState();
}

class _MembersState extends State<AllAdmins> {
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

  List adminList = [];
  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  getAdminData() async {
    adminList =
        await adminController.getAllAdmin(searchKeyword: searchController.text);
    print('aaaaaaaaaaaaaaaa');
    print(adminList);
    initializeData();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  initializeData() {
    _headerModel = DaviModel(
      rows: adminList,
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
    // var a = await rakeDispatchedController.getAllRakes(
    //     entity: selectedEntity == 'All' ? 'all' : selectedEntity);

    _headerModel = DaviModel(
      rows: adminList,
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
      rows: adminList,
      columns: _getColumns(context),
    );
    isLoading = false;
    setState(() {});
  }

  List<DaviColumn> _getColumns(BuildContext context) {
    return [
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.088,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'First Name',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['first_name'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.088,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Last Name',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['last_name'],

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
        width: MediaQuery.of(context).size.width * 0.12,

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
        name: 'Active',
        cellBuilder: (context, data) {
          return Center(
              child: Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
                activeColor: primaryDarkGreenColor,
                value: data.data['status'] == 0 ? true : false,
                onChanged: (v) {}),
          ));
        },

        width: MediaQuery.of(context).size.width * 0.07,

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
        name: 'View Branches',
        cellBuilder: (context, data) {
          return Center(
              child: InkWell(
                  onTap: () {
                    Get.toNamed(AdminAllBranch.adminAllBranchesRouteName,
                        arguments: {
                          'adminName': data.data['first_name'],
                          'adminId': data.data['id']
                        });
                  },
                  child: const Icon(
                    Icons.visibility,
                    color: primaryColor,
                  )));
        },

        width: MediaQuery.of(context).size.width * 0.078,

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
                    firstNameController.text =
                        data.data['first_name'].toString();
                    lastNameController.text = data.data['last_name'].toString();
                    primaryMobileNo.text =
                        data.data['primary_mobile_no'].toString();
                    secondaryMobileNo.text =
                        data.data['secondary_mobile_no'].toString();
                    email.text = data.data['email'].toString();
                    address.text = data.data['addr'].toString();
                    password.text = data.data['password']?.toString() ?? '';

                    showDialog(
                        context: context,
                        builder: (context) {
                          return GenericDialogBox(
                            enableSecondaryButton: true,
                            isLoader: false,
                            title: "Edit Admin",
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
                                              'First Name',
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
                                              'Last Name',
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
                                              controller: lastNameController,
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
                                              'Password',
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
                                              controller: password,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              enableSuggestions: true,
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
                            onSecondaryButtonPressed: () {
                              Get.back();
                            },
                            onPrimaryButtonPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return FutureBuilder(
                                      future: adminController.editAdmin({
                                        'first_name': firstNameController.text,
                                        'last_name': lastNameController.text,
                                        'primary_mobile_no':
                                            primaryMobileNo.text,
                                        'email': email.text,
                                        'address': address.text,
                                        'password': password.text,
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
                                                          Text(
                                                            snapshot.data![
                                                                'message'],
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                primaryButtonText: 'Ok',
                                                onPrimaryButtonPressed:
                                                    () async {
                                                  Get.offAllNamed(
                                                    AllAdmins.allAdminRouteName,
                                                  );
                                                },
                                              );
                                      },
                                    );
                                  });
                            },
                          );
                        });
                  },
                  child: const Icon(
                    Icons.edit,
                    color: primaryColor,
                  )));
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
            children: [
              Text(
                "All Admins",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(
                flex: 2,
              ),
              // Expanded(child: SearchField()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              getAdminData();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, top: 3, bottom: 3),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
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
                      items:
                          ['All', 'Active', 'In Active', 'Payment Pending'].map(
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
                        hintText: "Select Filter",
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    // margin:
                    //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ))),
                      onPressed: () async {
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
                                title: "Add Admin",
                                primaryButtonText: 'Add',
                                secondaryButtonText: 'Cancel',
                                content: SizedBox(
                                  height: mediaQuery.height * 0.7,
                                  child: SingleChildScrollView(
                                    child: Column(
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
                                                  'First Name',
                                                  style: TextStyle(
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
                                                  controller:
                                                      firstNameController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
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
                                                  'Last Name',
                                                  style: TextStyle(
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
                                                  controller:
                                                      lastNameController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
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
                                                  controller: primaryMobileNo,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
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
                                                  controller: secondaryMobileNo,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
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
                                                  controller: password,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  enableSuggestions: true,
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
                                onSecondaryButtonPressed: () {
                                  Get.back();
                                },
                                onPrimaryButtonPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return FutureBuilder(
                                          future: adminController.addAdmin({
                                            'first_name':
                                                firstNameController.text,
                                            'last_name':
                                                lastNameController.text,
                                            'primary_mobile_no':
                                                primaryMobileNo.text,
                                            'email': email.text,
                                            'address': address.text,
                                            'password': password.text,
                                            'secondary_mobile_no':
                                                secondaryMobileNo.text,
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
                                                      Get.offAllNamed(
                                                        AllAdmins
                                                            .allAdminRouteName,
                                                      );
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
                            'Add Admin',
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
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.78,
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
            // appBar: GenericAppBar(
            //   onNavbarIconPressed: () {
            //     setState(() {
            //       isNavOpen = !isNavOpen;
            //     });
            //   },
            //   title: 'All Admins',
            //   toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            // ),
            body: _body(mediaQuery),
          ),
        ),
      ],
    );
  }
}
