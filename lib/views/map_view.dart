// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
// import 'package:easy_table/easy_table.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  static const String routeName = '/map-view';

  static Route mapviewRoute() {
    return MaterialPageRoute(
        builder: (_) => const MapView(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<MapView> createState() => _VisitorsState();
}

class _VisitorsState extends State<MapView> {
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

  List<Map<String, dynamic>> memberLocationList = [];
  AdminController adminController = AdminController();
  MemberController visitorController = MemberController();
  List adminBranchList = [];
  DateTime selectedDateTime = DateTime.now();

  TextEditingController filterFromDateController = TextEditingController();
  TextEditingController filterToDateController = TextEditingController();
  List<Marker> markers = [];

  var selectedBranch;
  var selectedGender;
  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  MemberController memmberController = MemberController();

  setInitialData() async {
    markers.clear();
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
    markers.clear();
    isLoading = true;
    setState(() {});

    var a = await memmberController.getMemberLocation(
      branchId: branchId,
    );
    memberLocationList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();
    print('memberLoaction listttttttttttttttttttt');
    print(memberLocationList);
    createMarkerList();
  }

  createMarkerList() {
    markers.clear();
    for (var j = 0; j < memberLocationList.length; j++) {
      markers.add(Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(double.parse(memberLocationList[j]['latitude']),
            double.parse(memberLocationList[j]['longitude'])),
        child: GestureDetector(
          // onTap: () {
          //   setState(() {
          //     tooltipVisibility[i] = !tooltipVisibility[i];
          //   });
          // },
          child: Tooltip(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            textStyle: const TextStyle(
              color: Colors.black, // Change the text color here
            ),
            message: memberLocationList[j]['name'].toString(),
            child: const Icon(
              Icons.location_on,
              color: Colors.blueAccent,
              size: 35.0,
            ),
          ),
        ),
      ));
    }
    isLoading = false;
    setState(() {});
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
  }

  initializeData() {
    isLoading = false;
    setState(() {});
  }

  setDataOnBranchChange() async {
    markers.clear();
    isLoading = true;
    setState(() {});

    var a = await visitorController.getMemberLocation(
      branchId: branchId ?? selectedBranch['id'],
    );

    memberLocationList = a.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        return {'data': item};
      }
    }).toList();
    print('memberLoaction listttttttttttttttttttt');
    print(memberLocationList);
    createMarkerList();
  }

  changeTableDataBySearch() async {
    isLoading = true;
    setState(() {});
    // var a = await rakeDispatchedController.getSearchedRakes(
    //     entity: selectedEntity == 'All' ? 'all' : selectedEntity,
    //     searchText: searchController.text);

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
                "Map View",
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
                  : const SizedBox(),
              // Expanded(child: SearchField()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading == true
              ? const CircularProgressIndicator()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: const MapOptions(
                          minZoom: 5,
                          maxZoom: 18,
                          zoom: 9,
                          center: LatLng(18.5204, 73.8567),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            // subdomains: ['a', 'b', 'c'],
                          ),
                          // PolylineLayer(
                          //   polylines: [s
                          //     Polyline(
                          //       points: routePoints,
                          //       color: Colors.blue, // Color of the route line
                          //       strokeWidth: 3.0, // Width of the route line
                          //     ),
                          //   ],
                          // ),

                          // PolylineLayer(
                          //   polylines: polylinesList
                          //       .map((points) => Polyline(
                          //             points: points,
                          //             color: Colors.primaries[Random()
                          //                 .nextInt(
                          //                     Colors.primaries.length)],
                          //             strokeWidth: 4.0,
                          //           ))
                          //       .toList(),
                          // ),
                          MarkerLayer(
                            markers: [
                              for (int i = 0; i < markers.length; i++)
                                markers[i]
                            ],
                          ),
                        ],
                      ),
                    ],
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
                  selected: "map-view",
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
                    selected: "map-view",
                    // subSelected: "approvedCoalDatabase",
                  ),
                ),
              ),
        Expanded(
          flex: 9,
          child: Scaffold(
            body: _body(mediaQuery),
          ),
        ),
      ],
    );
  }
}
