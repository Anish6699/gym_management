// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:davi/davi.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// import 'package:easy_table/easy_table.dart';

class MembersView extends StatefulWidget {
  const MembersView({Key? key}) : super(key: key);

  static const String membersRouteName = '/members-view';

  static Route memberRoute() {
    return MaterialPageRoute(
        builder: (_) => const MembersView(),
        settings: const RouteSettings(name: membersRouteName));
  }

  @override
  State<MembersView> createState() => _MembersState();
}

class _MembersState extends State<MembersView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> uploadRakeDispatched = [];

  // ScrollController horizontalTableScrollController = ScrollController();

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
  TextEditingController referenceController = TextEditingController();
  TextEditingController totalAmmountController = TextEditingController();
  TextEditingController paidAmmountController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  List<Map<String, dynamic>> membersList = [];
  AdminController adminController = AdminController();
  MemberController memmberController = MemberController();
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
    print('selected branch ${selectedBranch}');
    var a = await memmberController.getAllMembers(branchId: branchId);

    List<Map<String, dynamic>> membersList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();

    _headerModel = DaviModel(
      rows: membersList,
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
      rows: membersList,
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
    print('selected branch ${selectedBranch}');
    var a = await memmberController.getAllMembers(
        branchId: branchId ?? selectedBranch['id']);

    List<Map<String, dynamic>> membersList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();

    _headerModel = DaviModel(
      rows: membersList,
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
      rows: membersList,
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
        width: MediaQuery.of(context).size.width * 0.08,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: primaryLightColor),

        name: 'Member Status',

        // pinStatus: PinStatus.left,

        sortable: true,
        cellBuilder: (context, row) {
          return Container(
            decoration: BoxDecoration(
                color: row.data['status'] == 0
                    ? Color.fromARGB(255, 76, 209, 76)
                    : Color.fromARGB(255, 177, 54, 46),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 4.0, bottom: 4, left: 16, right: 16),
              child: Text(
                row.data['status'] == 0 ? 'Active' : 'In-Active',
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          );
        },

        // stringValue: (row) => row['status'].toString(),

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

        name: 'Payment Status',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['payment_status'],

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

        name: 'Trainer',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['Trainer'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        name: 'Profile',
        cellBuilder: (context, data) {
          return Center(
              child: InkWell(
                  onTap: () {},
                  child: const Tooltip(
                    message: 'View Profile',
                    child: Icon(
                      Icons.person,
                      color: primaryDarkGreenColor,
                    ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userType == 2
                  ? Container(
                      height: MediaQuery.of(context).size.width * 0.02,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.white,
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
                                    color: Colors.black),
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: primaryGreyColor,
                          size: MediaQuery.of(context).size.width * 0.011,
                        ),
                        decoration: InputDecoration(
                          hintText: "Select Branch",
                          hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.008,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          border: const OutlineInputBorder(
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
                    )
                  : SizedBox(),
              SizedBox(
                width: mediaQuery.width * 0.01,
              ),
              Container(
                height: mediaQuery.width * 0.02,
                width: MediaQuery.of(context).size.width * 0.09,
                color: Colors.white,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  elevation: 1,
                  value: selectedEntity,
                  items: ['All', 'Active', 'In Active', 'Payment Pending'].map(
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
                    setDataOnBranchChange();
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
                height: mediaQuery.width * 0.02,
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
                      setDataOnBranchChange();
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
                    errorStyle: TextStyle(fontSize: mediaQuery.width * 0.006),
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
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    // margin:
                    //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: SecondaryButton(
                      title: 'Download Template',
                      onPressed: () async {},
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.width * 0.01,
                  ),
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
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.017,
                          ),
                          Text(
                            'Import Excel',
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
                  SizedBox(
                    width: mediaQuery.width * 0.01,
                  ),
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
                      onPressed: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.017,
                          ),
                          Text(
                            'Export Excel',
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
              Row(
                children: [
                  PrimaryButton(
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
                              title: "Add Member",
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
                                                    keyboardType: TextInputType
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
                                                        lastNameController,
                                                    keyboardType: TextInputType
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
                                                    controller: primaryMobileNo,
                                                    keyboardType: TextInputType
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
                                                    'Refrenced By',
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
                                                        referenceController,
                                                    keyboardType: TextInputType
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
                                                    keyboardType: TextInputType
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
                                                    keyboardType: TextInputType
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
                                                  0.25,
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
                                                      controller:
                                                          fromDateController,
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(left: 10),
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
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () async {
                                                            fromDateController
                                                                    .text =
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
                                                  0.25,
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
                                                      controller:
                                                          toDateController,
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(left: 10),
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
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () async {
                                                            toDateController
                                                                    .text =
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
                                                0.25,
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
                                                  height: MediaQuery.of(context)
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
                                                        totalAmmountController,
                                                    keyboardType: TextInputType
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
                                                0.25,
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
                                                  height: MediaQuery.of(context)
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
                                                        paidAmmountController,
                                                    keyboardType: TextInputType
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
                              onSecondaryButtonPressed: () {
                                Get.back();
                              },
                              onPrimaryButtonPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: memmberController.addMember({
                                          'branch_id':
                                              branchId ?? selectedBranch['id'],
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
                                          'reference':
                                              referenceController.text == ''
                                                  ? null
                                                  : referenceController.text,
                                          'start_date':
                                              fromDateController.text == ''
                                                  ? null
                                                  : fromDateController.text,
                                          'end_date':
                                              toDateController.text == ''
                                                  ? null
                                                  : toDateController.text,
                                          'price': totalAmmountController.text,
                                          'paid_amount':
                                              paidAmmountController.text,
                                          'status': 0
                                        }),
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
                                                            Text(snapshot.data![
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
                                                      MembersView
                                                          .membersRouteName,
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
                    title: 'Add Member',
                    buttonColor: primaryDarkGreenColor,
                  )
                ],
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
                          verticalBorderColor: Colors.transparent,
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
                  selected: "members",
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
                    selected: "members",
                    // subSelected: "approvedCoalDatabase",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            backgroundColor: lightBlueColor,
            appBar: GenericAppBar(
              applicationValue: 'Coal Inventory',
              onNavbarIconPressed: () {
                setState(() {
                  isNavOpen = !isNavOpen;
                });
              },
              title: 'Members',
              toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            ),
            body: _body(mediaQuery),
          ),
        ),
      ],
    );
  }
}
