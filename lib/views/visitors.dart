// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';
import 'package:davi/davi.dart';
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
  State<VisitorsView> createState() => _MembersState();
}

class _MembersState extends State<VisitorsView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> uploadRakeDispatched = [];

  // ScrollController horizontalTableScrollController = ScrollController();

  bool isNavOpen = true;
  final FocusNode _tableFocusNode = FocusNode();
  bool isLoading = true;

  var _headerModel;
  var selectedEntity = 'All';

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> membersList = [
    {
      'first_name': 'Anish',
      'last_name': 'Gunjal',
      'primary_mobile_no': '1111111111',
      'secondary_mobile_no': '1111111111',
      'email': 'abcccc@gmail.com',
      'Address': 'Active',
      'Age': '21',
      'Inquiry Description': 'Pending',
    },
    {
      'first_name': 'Anish',
      'last_name': 'Gunjal',
      'primary_mobile_no': '1111111111',
      'secondary_mobile_no': '1111111111',
      'email': 'abcccc@gmail.com',
      'Address': 'Ganesh nagar yerawda pune - 411006',
      'Age': '21',
      'Inquiry Description': 'Pending',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
  }

  initializeData() {
    print('in it state started');
    _headerModel = DaviModel(
      rows: membersList,
      columns: _getColumns(context),
    );
    print('in it state completed');
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
        width: MediaQuery.of(context).size.width * 0.12,

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

        stringValue: (row) => row['Address'],

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

        name: 'Age',

        // pinStatus: PinStatus.left,

        sortable: true,

        stringValue: (row) => row['Age'],

        cellAlignment: Alignment.center,

        headerAlignment: Alignment.center,

        resizable: false,

        cellOverflow: TextOverflow.visible,
      ),
      DaviColumn(
        name: 'Action',
        cellBuilder: (context, data) {
          return Center(
              child: InkWell(onTap: () {}, child: const Icon(Icons.edit)));
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
                    child: SecondaryButton(
                      title: 'Download Excel',
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
            ],
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.8,
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
