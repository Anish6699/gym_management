import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/admin_controllers.dart';
import 'package:gmstest/controllers/login_controllers.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenericAppBar extends StatefulWidget implements PreferredSizeWidget {
  GenericAppBar(
      {super.key,
      required this.title,
      required this.toolbarHeight,
      required this.onNavbarIconPressed,
      this.notificationOnPressed,
      this.applicationValue});

  final void Function()? onNavbarIconPressed;
  final String title;
  final double toolbarHeight;
  final void Function()? notificationOnPressed;
  String? applicationValue;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  State<GenericAppBar> createState() => _GenericAppBarState();
}

class _GenericAppBarState extends State<GenericAppBar> {
  Map<String, dynamic> userData = {};
  AdminController adminController = AdminController();
  List adminBranchList = [];

  @override
  initState() {
    super.initState();
  }

  List<Map<String, dynamic>> getTasksList = [];
  LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      leading: Container(
        margin: const EdgeInsets.only(left: 5, right: 20),
        child: IconButton(
            onPressed: widget.onNavbarIconPressed,
            iconSize: MediaQuery.of(context).size.width * 0.02,
            icon: const Icon(Icons.sort)),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.035,
      title: SelectableText(
        widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 0.0115,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      actions: [
        Row(
          children: [
            // userType == 2
            //     ? Container(
            //         height: MediaQuery.of(context).size.width * 0.02,
            //         width: MediaQuery.of(context).size.width * 0.2,
            //         color: Colors.white,
            //         child: DropdownButtonFormField(
            //           isExpanded: true,
            //           elevation: 1,
            //           // value: selectedEntity,
            //           items:
            //               ['Branch 1', 'Branch 2', 'Branch 3', 'Branch 4'].map(
            //             (String item) {
            //               return DropdownMenuItem(
            //                 value: item,
            //                 child: Text(
            //                   item,
            //                   style: TextStyle(
            //                       fontSize:
            //                           MediaQuery.of(context).size.width * 0.008,
            //                       color: Colors.black),
            //                 ),
            //               );
            //             },
            //           ).toList(),
            //           onChanged: (value) {},
            //           borderRadius: BorderRadius.circular(4),
            //           style: TextStyle(
            //               fontSize: MediaQuery.of(context).size.width * 0.08,
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold),
            //           icon: Icon(
            //             Icons.keyboard_arrow_down_rounded,
            //             color: primaryGreyColor,
            //             size: MediaQuery.of(context).size.width * 0.011,
            //           ),
            //           decoration: InputDecoration(
            //             hintText: "Select Branch",
            //             hintStyle: TextStyle(
            //                 fontSize: MediaQuery.of(context).size.width * 0.008,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold),
            //             contentPadding: EdgeInsets.symmetric(horizontal: 10),
            //             fillColor: Colors.white,
            //             focusedBorder: const OutlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.black,
            //               ),
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(4.0),
            //               ),
            //             ),
            //             border: const OutlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.black,
            //               ),
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(4.0),
            //               ),
            //             ),
            //           ),
            //           dropdownColor: Colors.white,
            //         ),
            //       )
            //     : SizedBox(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Tooltip(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: secondaryLightGreyColor,
              ),
              message: "Help Manual",
              verticalOffset: 25,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.009,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.026,
                height: MediaQuery.of(context).size.width * 0.026,
                child: InkWell(
                  onTap: () async {},
                  child: Icon(
                    Icons.help_outline,
                    size: MediaQuery.of(context).size.width * 0.026,
                    color: secondaryGreyColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: getTasksList.isNotEmpty
                  ? InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.025,
                        height: MediaQuery.of(context).size.width * 0.025,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          size: MediaQuery.of(context).size.width * 0.016,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.026,
              height: MediaQuery.of(context).size.width * 0.026,
              child: PopupMenuButton(
                splashRadius: 0,
                offset: Offset(
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.height * 0.06,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.005),
                      enabled: false,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.005),
                              child: Row(
                                children: [
                                  SelectableText(
                                    'Employee ID: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SelectableText(
                                    userData['empId'] != null
                                        ? userData['empId'].toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.005),
                              child: Row(
                                children: [
                                  SelectableText(
                                    'Name: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SelectableText(
                                    userData['userName'] ?? '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.005),
                              child: Row(
                                children: [
                                  SelectableText(
                                    'Email: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SelectableText(
                                    userData['userEmail'] ?? '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.005),
                              child: Row(
                                children: [
                                  SelectableText(
                                    'Role: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SelectableText(
                                    userData['roles'] ?? '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.005),
                              child: Row(
                                children: [
                                  SelectableText(
                                    'Manager: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SelectableText(
                                    userData['manager'] ?? '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0085,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                elevation: 4.0,
                color: Colors.white,
                // shape: const CircleBorder(),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.026,
                    height: MediaQuery.of(context).size.width * 0.026,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300, shape: BoxShape.circle),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.015,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Tooltip(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: secondaryLightGreyColor,
              ),
              message: "Logout",
              verticalOffset: 25,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.009,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.026,
                height: MediaQuery.of(context).size.width * 0.026,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    await loginController.logout();
                  },
                  child: Icon(
                    Icons.logout,
                    size: MediaQuery.of(context).size.width * 0.015,
                    color: secondaryGreyColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
          ],
        )
      ],
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
