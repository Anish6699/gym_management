// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
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
import 'package:gmstest/views/members/member_profile.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:davi/davi.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

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

  // ScrollController horizontalTableScrollController = ScrollController();

  bool isNavOpen = true;
  final FocusNode _tableFocusNode = FocusNode();
  bool isLoading = true;
  bool uploadingFile = false;

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
  DateTime selectedDateTime = DateTime.now();
  TextEditingController filterFromDateController = TextEditingController();
  TextEditingController filterToDateController = TextEditingController();
  var selectedBranch;
  var selectedGender;
  var selectedMonth;
  List adminBranchList = [];
  var bulkMemberBase64String;

  List<Map<String, dynamic>> filterList = [
    {'id': -1, 'name': 'All'},
    {'id': 0, 'name': 'Active'},
    {'id': 1, 'name': 'In-Active'},
    {'id': 2, 'name': 'Payment Pending'}
  ];
  List monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var selectedStatus;

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  uploadBulkMembers() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: memmberController.addBulkMembers(
                {'member_file': bulkMemberBase64String},
                branchId ?? selectedBranch['id']),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? GenericDialogBox(
                      enableSecondaryButton: false,
                      isLoader: true,
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                          height: MediaQuery.of(context).size.width * 0.06,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: primaryDarkBlueColor,
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
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                          height: MediaQuery.of(context).size.width * 0.06,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(snapshot.data!['message'])],
                            ),
                          ),
                        ),
                      ),
                      primaryButtonText: 'Ok',
                      onPrimaryButtonPressed: () async {
                        downloadCsvFromBase64String(
                            snapshot.data!['file'], fileName);
                        Get.offAllNamed(
                          MembersView.membersRouteName,
                        );
                      },
                    );
            },
          );
        });
  }

  selectfileConvertTobase64() async {
    //  setState(() {
    //   uploadingImage = true;
    // });
    // Prompt user to pick a single image
    print('upload 2');
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    print('upload 3');
    // Check if user picked a file
    if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
      // Get the picked file
      final file = filePickerResult.files.first;

      // Read file as bytes
      Uint8List? fileBytes = await file.bytes;

      String base64String = base64Encode(fileBytes!);
      bulkMemberBase64String = base64String;
      uploadBulkMembers();
      // setState(() {
      //   uploadingImage = false;
      // });
    }
  }

  String addMonthsToDate(String dateString, int numberOfMonths) {
    // Parse the input date string into a DateTime object
    DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);

    // Add the specified number of months to the given date
    int year = date.year + ((date.month + numberOfMonths - 1) ~/ 12);
    int month = (date.month + numberOfMonths) % 12;
    if (month == 0) {
      month = 12;
    }
    int day = date.day;

    // Handle the case where the resulting date might be invalid
    try {
      DateTime newDate = DateTime(year, month, day);
      // Format the new date to match the input format
      return DateFormat('dd-MM-yyyy').format(newDate);
    } catch (e) {
      // If the date is invalid, adjust the day until it becomes valid
      while (true) {
        day -= 1;
        try {
          DateTime newDate = DateTime(year, month, day);
          // Format the new date to match the input format
          return DateFormat('dd-MM-yyyy').format(newDate);
        } catch (e) {
          // Continue looping until a valid date is found
        }
      }
    }
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
    var a = await memmberController.getAllMembers(
        branchId: branchId ?? selectedBranch['id'],
        searchKeyword: searchController.text,
        statusId: selectedStatus,
        startDate: filterFromDateController.text,
        endDate: filterToDateController.text);

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

    var a = await memmberController.getAllMembers(
        branchId: branchId ?? selectedBranch['id'],
        searchKeyword: searchController.text,
        statusId: selectedStatus,
        startDate: filterFromDateController.text,
        endDate: filterToDateController.text);

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

  List<DaviColumn<Map<String, dynamic>>> _getColumns(BuildContext context) {
    return [
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.15,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Name',

        // pinStatus: PinStatus.left,

        sortable: true,

        cellBuilder: (context, row) {
          return Tooltip(
            message: "View Profile",
            child: InkWell(
              onTap: () {
                Get.toNamed(MemberProfile.routeName, arguments: row.data['id']);
              },
              child: Text(
                '${row.data['first_name']} ${row.data['last_name']}',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: MediaQuery.of(context).size.width * 0.009,
                ),
              ),
            ),
          );
        },

        // stringValue: (row) => '${row['first_name']} ${row['last_name']}',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.12,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Mobile No',

        // pinStatus: PinStatus.left,

        sortable: true,
        cellTextStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009,
        ),

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

        headerTextStyle: const TextStyle(color: primaryLightColor),
        cellTextStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009,
        ),

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

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Status',
        cellTextStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009,
        ),

        // pinStatus: PinStatus.left,

        sortable: true,
        cellBuilder: (context, row) {
          return Container(
            decoration: BoxDecoration(
                color: row.data['status'] == 0
                    ? const Color.fromARGB(255, 76, 209, 76)
                    : const Color.fromARGB(255, 177, 54, 46),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4, left: 16, right: 16),
              child: Text(
                row.data['status'] == 0 ? 'Active' : 'In-Active',
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white),
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
        width: MediaQuery.of(context).size.width * 0.12,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Pending Amount',
        cellTextStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009,
        ),

        // pinStatus: PinStatus.left,

        sortable: true,
        cellBuilder: (context, row) {
          return Text(
            row.data['unpaid_amount'] ?? '-',
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          );
        },

        // stringValue: (row) => row['payment_status'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.12,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Trainer',

        // pinStatus: PinStatus.left,

        sortable: true,
        cellTextStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.009,
        ),
        stringValue: (row) =>
            '${row['tfirst_name']?.toString() ?? ''} ${row['tlast_name']?.toString() ?? ''}',

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        width: MediaQuery.of(context).size.width * 0.12,

        headerPadding: EdgeInsets.zero,

        cellPadding: EdgeInsets.zero,

        headerTextStyle: const TextStyle(color: primaryLightColor),

        name: 'Action',

        // pinStatus: PinStatus.left,

        sortable: true,

        cellBuilder: (context, row) {
          return IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return GenericDialogBox(
                        closeButtonEnabled: false,
                        enableSecondaryButton: true,
                        isLoader: false,
                        message: "Are you Sure want to Delete Member",
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
                                  future: memmberController
                                      .deleteMember(row.data['id']),
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
                                                      Text(
                                                        snapshot
                                                            .data!['message'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
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
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ));
        },
        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
    ];
  }

  void downloadTemplate() {
    Uri url = Uri.parse('${serverUrl}member-download-template');
    launchUrl(url);
  }

  String fileName = 'responseFile';
  String samplBase64String =
      'Zmlyc3RfbmFtZSxsYXN0X25hbWUscHJpbWFyeV9tb2JpbGVfbm8sc2Vjb25kYXJ5X21vYmlsZV9ubyxhZGRyLGVtYWlsLGdlbmRlcixzdGFydF9kYXRlLGVuZF9kYXRlLHByaWNlLHBhaWRfYW1vdW50CnNzc2FzLGRodW1hbCw0NDQ5OTk5OTk5LDk1OTk5OTk5OTksamVlaixzYWdkZGR0ZWVzMzNzdDg4ODUzYXJAZ21haWwuY29tLG00YWxlLDI0LTAyLTIwMjQsMjctMDMtMjAyNCwxMDAwLDUwMApvbSxndW5ramFsLDk1ODk5OTk5OTIsOTk3ODk5OTk5OSxqZWVqLGRzc2oyM2tzamRrampAZ21haWwuY29tLG1hbDRlLDI0LTAyLTIwMjQsMjgtMDMtMjAyNCw0MDAsMzAw';
  void downloadCsvFromBase64String(String base64String, String fileName) {
    // Decode base64 string to binary data
    List<int> csvBytes = base64Decode(base64String);

    // Create a Blob from the binary data
    final blob = html.Blob([csvBytes], 'text/csv');

    // Create an object URL from the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a link element
    final link = html.AnchorElement(href: url)
      ..setAttribute('download', fileName);

    // Trigger download
    html.document.body!.children.add(link);
    link.click();

    // Cleanup
    html.Url.revokeObjectUrl(url);
    link.remove();
  }

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
                "Members   ",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Tooltip(
                message: "click to bulk upload",
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return GenericDialogBox(
                            enableSecondaryButton: false,
                            enablePrimaryButton: false,
                            isLoader: false,
                            content: StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter uploadState) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PrimaryButton(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            onPressed: () {
                                              downloadTemplate();
                                              // downloadCsvFromBase64String(
                                              //     samplBase64String, fileName);
                                            },
                                            title: "Download Template"),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        PrimaryButton(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            buttonColor: Colors.green,
                                            onPressed: () {
                                              // uploadState(() {
                                              //   uploadingFile = true;
                                              // });

                                              print('upload 1');
                                              selectfileConvertTobase64();
                                            },
                                            title: "Upload Excel"),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        uploadingFile == true
                                            ? const Text(
                                                'Uploading File....',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            onPrimaryButtonPressed: () {
                              Get.back();
                            },
                          );
                        });
                  },
                  child: const Text(
                    "Bulk Upload Members   ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),

              userType == 2
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
                  : const SizedBox(),
              SizedBox(
                width: mediaQuery.width * 0.01,
              ),
              // Expanded(child: SearchField()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextField(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.008,
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
                            setDataOnBranchChange();
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
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.11,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: DropdownButtonFormField(
                    value: selectedStatus,
                    isExpanded: true,
                    elevation: 1,
                    items: filterList.map(
                      (item) {
                        return DropdownMenuItem(
                          value: item['id'],
                          child: Text(
                            item['name'],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.008,
                                color: Colors.white),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      selectedStatus = value;
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
                      hintText: "Select Filter",
                      hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.008,
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
                ),
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
                      selectedStatus = null;
                      filterFromDateController.clear();
                      filterToDateController.clear();
                      setDataOnBranchChange();
                    },
                    title: 'Clear Filter',
                  ),
                ),
              ],
            ),
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
            // backgroundColor: secondaryColor,
            // appBar: GenericAppBar(
            //   applicationValue: 'Coal Inventory',
            //   onNavbarIconPressed: () {
            //     setState(() {
            //       isNavOpen = !isNavOpen;
            //     });
            //   },
            //   title: 'Members',
            //   toolbarHeight: MediaQuery.of(context).size.height * 0.075,
            // ),
            body: _body(mediaQuery),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              onPressed: () {
                firstNameController.clear();

                lastNameController.clear();
                primaryMobileNo.clear();

                email.clear();
                address.clear();
                totalAmmountController.clear();

                paidAmmountController.clear();
                toDateController.clear();

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'First Name *',
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: firstNameController,
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Last Name *',
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: lastNameController,
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Select Gender *',
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
                                            child: DropdownButtonFormField(
                                              isExpanded: true,
                                              elevation: 1,
                                              value: selectedGender,
                                              items: [
                                                'Male',
                                                'Female',
                                                'Others'
                                              ].map(
                                                (item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (value) {
                                                selectedGender = value;
                                                setState(() {});
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.008,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Select Gender",
                                                hintStyle: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.008,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                fillColor: Colors.white,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: primaryMobileNo,
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
                                              'Refrenced By',
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: referenceController,
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
                                const SizedBox(
                                  height: 20,
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
                                              'Email *',
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
                                                            primaryDarkGreenColor),
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: address,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SelectableText(
                                              "From Date *",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: TextField(
                                                style: TextStyle(
                                                  fontSize:
                                                      mediaQuery.width * 0.008,
                                                ),
                                                controller: fromDateController,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  hintText: 'Select Date ',
                                                  suffixIcon: IconButton(
                                                    icon: const Icon(
                                                        Icons.calendar_today),
                                                    onPressed: () async {
                                                      fromDateController.text =
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
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Select Months ',
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
                                            child: DropdownButtonFormField(
                                              isExpanded: true,
                                              elevation: 1,
                                              value: selectedMonth,
                                              items: monthList.map(
                                                (item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      '${item?.toString() ?? '-'} Month',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (value) {
                                                selectedMonth = value;

                                                toDateController.text =
                                                    addMonthsToDate(
                                                        fromDateController.text,
                                                        selectedMonth);

                                                setState(() {});
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.008,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Select Months",
                                                hintStyle: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.008,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                fillColor: Colors.white,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SelectableText(
                                              "End Date *",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: TextField(
                                                style: TextStyle(
                                                  fontSize:
                                                      mediaQuery.width * 0.008,
                                                ),
                                                controller: toDateController,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            secondaryBorderGreyColor),
                                                  ),
                                                  hintText: 'Select Date ',
                                                  suffixIcon: IconButton(
                                                    icon: const Icon(
                                                        Icons.calendar_today),
                                                    onPressed: () async {
                                                      // toDateController.text =
                                                      //     await selectedDatee(
                                                      //         context);

                                                      // setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
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
                                              'Total Ammount *',
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
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller:
                                                  totalAmmountController,
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
                                              'Paid Ammount *',
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
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
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
                                                            primaryDarkGreenColor),
                                                  )),
                                              controller: paidAmmountController,
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
                                const SizedBox(
                                  height: 20,
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
                              primaryMobileNo.text.isEmpty ||
                              fromDateController.text.isEmpty ||
                              toDateController.text.isEmpty ||
                              totalAmmountController.text.isEmpty ||
                              paidAmmountController.text.isEmpty ||
                              email.text.isEmpty ||
                              selectedGender == null) {
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
                            if (double.parse(totalAmmountController.text) <
                                double.parse(paidAmmountController.text)) {
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
                                                    'Please Check Total Amount and Paid Amount')
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
                              if (isStartDateAfterEndDate(
                                      fromDateController.text,
                                      toDateController.text) ==
                                  true) {
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
                                                      'Please Check From Date and To Date')
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
                                if (email.text.contains('@')) {
                                  if (primaryMobileNo.text.length != 10) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return GenericDialogBox(
                                            enableSecondaryButton: false,
                                            primaryButtonText: 'Ok',
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
                                                child: const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          'Please Enter Valid Mobile Number')
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
                                            future:
                                                memmberController.addMember({
                                              'branch_id': branchId ??
                                                  selectedBranch['id'],
                                              'first_name':
                                                  firstNameController.text == ''
                                                      ? null
                                                      : firstNameController
                                                          .text,
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
                                                      : referenceController
                                                          .text,
                                              'start_date':
                                                  fromDateController.text == ''
                                                      ? null
                                                      : fromDateController.text,
                                              'end_date':
                                                  toDateController.text == ''
                                                      ? null
                                                      : toDateController.text,
                                              'price':
                                                  totalAmmountController.text,
                                              'paid_amount':
                                                  paidAmmountController.text,
                                              'status': 0,
                                              'gender': selectedGender == 'Male'
                                                  ? 0
                                                  : selectedGender == 'Female'
                                                      ? 1
                                                      : 2
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                          MembersView
                                                              .membersRouteName,
                                                        );
                                                      },
                                                    );
                                            },
                                          );
                                        });
                                  }
                                } else {
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
                                                        'Please Enter Valid Email Address')
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
                                }
                              }
                            }
                          }
                        },
                      );
                    });
              },
              child: Tooltip(
                  message: "Add Member",
                  child: Lottie.asset(
                      'assets/animations/add_member_animation.json')),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ],
    );
  }
}
