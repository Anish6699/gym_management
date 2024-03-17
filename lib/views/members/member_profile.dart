
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/global_functions.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/controllers/trainers_controller.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/members/members.dart';
import 'package:gmstest/views/profilewidgets/reusablecomponents.dart';
import 'package:gmstest/views/profilewidgets/reusabletext.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});
  static const String routeName = '/members-profile';

  static Route route(dynamic arguments) {
    return MaterialPageRoute(
        builder: (_) => const MemberProfile(),
        settings: RouteSettings(name: routeName, arguments: arguments));
  }

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNavOpen = true;
  MemberController memmberController = MemberController();
  Map membersData = {};
  List planList = [];
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController totalAmtPaid = TextEditingController();
  TextEditingController paidAmmot = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  //edit//
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();
  TextEditingController primaryMobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  var selectedTrainer;
  var selectedGender;
  TextEditingController secondaryMobileNoController = TextEditingController();

  List<Map<String, dynamic>> trainerList = [];

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM y').format(dateTime);
    } catch (e) {
      // Handle parsing error or return the original string if the format is not valid
      return dateString;
    }
  }

  initializeData() async {
    // if (Get.arguments == null) {
    //   Get.toNamed(MembersView.membersRouteName);
    // } else {}
    var a = await memmberController.getSingleMember(Get.arguments);
    if (a.toString() == 'null' || a.toString() == 'Null') {
      Get.offAllNamed(MembersView.membersRouteName);
    } else {
      membersData = a['data'];
      planList = a['plan_details'];

      firstNameController.text = membersData['first_name'] ?? '';
      lastNameController.text = membersData['last_name'] ?? '';
      primaryMobileNo.text = membersData['primary_mobile_no'] ?? '';
      secondaryMobileNoController.text =
          membersData['secondary_mobile_no'] ?? '';

      address.text = membersData['addr'] ?? '';
      email.text = membersData['email'] ?? '';
      referenceController.text = membersData['reference'] ?? '';
      ageController.text = membersData['age']?.toString() ?? '';
      heightController.text = membersData['height'] ?? '';
      weightController.text = membersData['weight'] ?? '';
      bloodGroupController.text = membersData['blood_group'] ?? '';
      selectedGender = membersData['gender'] == 0
          ? 'Male'
          : membersData['gender'] == 1
              ? 'Female'
              : 'Others';
      var b = await TrainerController()
          .getAllTrainer(branchId: membersData['branch_id'], searchKeyword: '');

      trainerList = b.map((dynamic item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else {
          return {'data': item};
        }
      }).toList();

      membersData['trainer_id'] != null
          ? trainerList.firstWhere((element) {
              if (membersData['trainer_id'] == element['id']) {
                selectedTrainer = element;
                return true;
              }
              return false;
            })
          : null;

      setState(() {});
    }
  }

  editProfile() {
    var mediaQuery = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return GenericDialogBox(
            enableSecondaryButton: true,
            isLoader: false,
            title: "Edit Member",
            primaryButtonText: 'update',
            secondaryButtonText: 'Cancel',
            content: SizedBox(
              height: mediaQuery.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'First Name',
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
                                        RegExp(r'[a-zA-Z ]{0,20}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: firstNameController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Last Name',
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
                                        RegExp(r'[a-zA-Z ]{0,20}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: lastNameController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Primary Mobile No',
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
                                        RegExp(r'[0-9]{0,10}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: primaryMobileNo,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Refrenced By',
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
                                        RegExp(r'[a-zA-Z ]{0,20}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: referenceController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Trainer',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 177, 174, 174)),
                                ),
                                child: DropdownButtonFormField(
                                  value: selectedTrainer,
                                  isExpanded: true,
                                  elevation: 1,
                                  items: trainerList.map(
                                    (item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          '${item['first_name'] ?? ''} ${item['last_name'] ?? ''}',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.008,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    selectedTrainer = value;
                                    setState(() {});
                                    // selectedStatus = value;
                                    // setDataOnBranchChange();
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Select Trainer",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.008,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Secondary Mobile No',
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
                                        RegExp(r'[0-9]{0,10}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: secondaryMobileNoController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Email',
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
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Address',
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
                                        RegExp(r'[0-9,a-z,A-Z, ]{0,50}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: address,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Age',
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
                                        RegExp(r'[0-9]{0,2}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: ageController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Height',
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
                                        RegExp(r'[a-zA-Z 0-9.]{0,20}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: heightController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Weight',
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
                                        RegExp(r'[0-9]{0,3}$')),
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: weightController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Blood Group',
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
                                            color: primaryDarkGreenColor),
                                      )),
                                  controller: bloodGroupController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Select Gender ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  elevation: 1,
                                  value: selectedGender,
                                  items: ['Male', 'Female', 'Others'].map(
                                    (item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
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
                                  borderRadius: BorderRadius.circular(4),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.008,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Select Gender",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.008,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return FutureBuilder(
                      future: memmberController.editMember({
                        'first_name': firstNameController.text == ''
                            ? null
                            : firstNameController.text,
                        'last_name': lastNameController.text == ''
                            ? null
                            : lastNameController.text,
                        'primary_mobile_no': primaryMobileNo.text == ''
                            ? null
                            : primaryMobileNo.text,
                        'email': email.text == '' ? null : email.text,
                        'addr': address.text == '' ? null : address.text,
                        'reference': referenceController.text == ''
                            ? null
                            : referenceController.text,
                        'trainer_id': selectedTrainer != null
                            ? selectedTrainer['id']
                            : null,
                        'age': ageController.text == ''
                            ? null
                            : ageController.text,
                        'height': heightController.text,
                        'secondary_mobile_no': secondaryMobileNoController.text,
                        'weight': weightController.text,
                        'blood_group': bloodGroupController.text,
                        'gender': selectedGender == 'Male'
                            ? 0
                            : selectedGender == 'Female'
                                ? 1
                                : 2
                      }, membersData['id']),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? GenericDialogBox(
                                enableSecondaryButton: false,
                                isLoader: true,
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data!['message'])
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                primaryButtonText: 'Ok',
                                onPrimaryButtonPressed: () async {
                                  Get.offAllNamed(MemberProfile.routeName,
                                      arguments: membersData['id']);
                                },
                              );
                      },
                    );
                  });
            },
          );
        });
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

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        isNavOpen
            ? Expanded(
                flex: 2,
                child: InventoryNavigationPaneExpanded(selected: "members"),
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
              //   title: "Member's Profile",
              //   toolbarHeight: MediaQuery.of(context).size.height * 0.075,
              // ),
              body: SafeArea(
                  child: Stack(children: [
            membersData.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                              child: Stack(children: [
                                Container(
                                  width: _width,
                                  margin: const EdgeInsets.only(top: 70),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.1),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ]),
                                  child: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                        /// card header
                                        SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Age',
                                                      membersData['age']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Height',
                                                      membersData['height']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Weight',
                                                      membersData['weight']
                                                              ?.toString() ??
                                                          '-'),
                                                  SocialValue(
                                                      'Blood Group',
                                                      membersData['blood_group']
                                                              ?.toString() ??
                                                          '-'),
                                                  const Spacer(flex: 10),
                                                  NormalButton(
                                                      'ACTIVE',
                                                      Colors.white,
                                                      '',
                                                      Colors.white,
                                                      Colors.green),
                                                  const Spacer(flex: 1),
                                                  PrimaryButton(
                                                      onPressed: () {
                                                        editProfile();
                                                      },
                                                      title: 'Edit Profile')
                                                ])),
                                        const SizedBox(height: 50),
                                        LargeBoldTextBlack(
                                            '${membersData['first_name']?.toString() ?? '-'} ${membersData['last_name']?.toString()}'),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.location_pin,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  membersData['addr']!
                                                      .toString())
                                            ]),
                                        const SizedBox(height: 30),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sports_gymnastics,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  'Personal Trainer - ${membersData['trainer_fname']?.toString() ?? ''} ${membersData['trainer_lname']?.toString() ?? ''}')
                                            ]),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.mail,
                                                  size: 20,
                                                  color: Colors.grey[400]),
                                              const SizedBox(width: 5),
                                              NormalGreyText(
                                                  'Email Address : ${membersData['email']?.toString() ?? ''}')
                                            ]),

                                        /// description
                                        const Divider(
                                            height: 30,
                                            thickness: 1,
                                            color: primaryThemeColor),
                                        SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Primary Mobile Number',
                                                      '${membersData['primary_mobile_no']?.toString() ?? ''}'),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Secondary Mobile Number',
                                                      membersData['secondary_mobile_no']
                                                              ?.toString() ??
                                                          ''),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Start Date',
                                                      planList.first[
                                                                  'start_date'] ==
                                                              null
                                                          ? '-'
                                                          : formatDate(planList
                                                                  .first[
                                                              'start_date'])),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'End Date',
                                                      planList.first[
                                                                  'end_date'] ==
                                                              null
                                                          ? '-'
                                                          : formatDate(
                                                              planList.first[
                                                                  'end_date'])),
                                                  const Spacer(flex: 1),
                                                  SocialValue(
                                                      'Pending Ammount',
                                                      planList.first[
                                                              'unpaid_amount'] ??
                                                          '-'),
                                                  const Spacer(flex: 10),
                                                  PrimaryButton(
                                                      onPressed: () {
                                                        paidAmmot.clear();
                                                        totalAmtPaid.clear();
                                                        fromDate.clear();
                                                        toDate.clear();
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return GenericDialogBox(
                                                                enableSecondaryButton:
                                                                    true,
                                                                isLoader: false,
                                                                title:
                                                                    "Add Plan",
                                                                primaryButtonText:
                                                                    'Add',
                                                                secondaryButtonText:
                                                                    'Cancel',
                                                                onSecondaryButtonPressed:
                                                                    () {
                                                                  Get.back();
                                                                },
                                                                content:
                                                                    SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.7,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    const SelectableText(
                                                                                      "From Date ",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(height: 8),
                                                                                    SizedBox(
                                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                                      child: TextField(
                                                                                        style: TextStyle(
                                                                                          fontSize: MediaQuery.of(context).size.width * 0.008,
                                                                                        ),
                                                                                        controller: fromDate,
                                                                                        readOnly: true,
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: const EdgeInsets.only(left: 10),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                            borderSide: const BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          hintText: 'Select Date ',
                                                                                          suffixIcon: IconButton(
                                                                                            icon: const Icon(Icons.calendar_today),
                                                                                            onPressed: () async {
                                                                                              fromDate.text = await selectedDatee(context);

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
                                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    const SelectableText(
                                                                                      "To Date ",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(height: 8),
                                                                                    SizedBox(
                                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                                      child: TextField(
                                                                                        style: TextStyle(
                                                                                          fontSize: MediaQuery.of(context).size.width * 0.008,
                                                                                        ),
                                                                                        controller: toDate,
                                                                                        readOnly: true,
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: const EdgeInsets.only(left: 10),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(4.0),
                                                                                            borderSide: const BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          hintText: 'Select Date ',
                                                                                          suffixIcon: IconButton(
                                                                                            icon: const Icon(Icons.calendar_today),
                                                                                            onPressed: () async {
                                                                                              toDate.text = await selectedDatee(context);

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
                                                                              width: MediaQuery.of(context).size.width * 0.3,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  const Flexible(
                                                                                    child: SelectableText(
                                                                                      'Total Ammount',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: MediaQuery.of(context).size.height * 0.07,
                                                                                    child: TextFormField(
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                                      ],
                                                                                      decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColor),
                                                                                          )),
                                                                                      controller: totalAmtPaid,
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: true,
                                                                                      autofocus: true,
                                                                                      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.3,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
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
                                                                                    height: MediaQuery.of(context).size.height * 0.07,
                                                                                    child: TextFormField(
                                                                                      inputFormatters: [
                                                                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                                      ],
                                                                                      decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                                          ),
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColor),
                                                                                          )),
                                                                                      controller: paidAmmot,
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: true,
                                                                                      autofocus: true,
                                                                                      style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                                      textAlignVertical: TextAlignVertical.center,
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
                                                                onPrimaryButtonPressed:
                                                                    () {
                                                                  if (isStartDateAfterEndDate(
                                                                          fromDate
                                                                              .text,
                                                                          toDate
                                                                              .text) ==
                                                                      true) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GenericDialogBox(
                                                                            enableSecondaryButton:
                                                                                false,
                                                                            primaryButtonText:
                                                                                'Ok',
                                                                            isLoader:
                                                                                false,
                                                                            content:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.04,
                                                                                height: MediaQuery.of(context).size.width * 0.06,
                                                                                child: const Center(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text('Please Check From Date and To Date')
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            onPrimaryButtonPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                          );
                                                                        });
                                                                  } else {
                                                                    if ((double.parse(totalAmtPaid.text) +
                                                                            double.parse(planList.first[
                                                                                'unpaid_amount'])) <
                                                                        double.parse(
                                                                            paidAmmot.text)) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GenericDialogBox(
                                                                              enableSecondaryButton: false,
                                                                              primaryButtonText: 'Ok',
                                                                              isLoader: false,
                                                                              content: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.04,
                                                                                  height: MediaQuery.of(context).size.width * 0.06,
                                                                                  child: const Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text('Please Check Total Amount and Paid Amount')
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
                                                                          barrierDismissible:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return FutureBuilder(
                                                                              future: memmberController.addMemberPlan({
                                                                                'start_date': fromDate.text,
                                                                                'end_date': toDate.text,
                                                                                'price': totalAmtPaid.text,
                                                                                'paid_amount': paidAmmot.text
                                                                              }, membersData['id']),
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
                                                                                                children: [
                                                                                                  Text(snapshot.data!['message'])
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        primaryButtonText: 'Ok',
                                                                                        onPrimaryButtonPressed: () async {
                                                                                          Get.offAllNamed(MemberProfile.routeName, arguments: membersData['id']);
                                                                                        },
                                                                                      );
                                                                              },
                                                                            );
                                                                          });
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            });
                                                      },
                                                      title: 'Add Plan'),
                                                  const Spacer(flex: 1),
                                                  PrimaryButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return GenericDialogBox(
                                                                enableSecondaryButton:
                                                                    true,
                                                                isLoader: false,
                                                                title:
                                                                    "Pay Pending Ammount",
                                                                primaryButtonText:
                                                                    'Paid',
                                                                secondaryButtonText:
                                                                    'Cancel',
                                                                content:
                                                                    SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.3,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      const Flexible(
                                                                        child:
                                                                            SelectableText(
                                                                          'Paid Ammount',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.07,
                                                                        child:
                                                                            TextFormField(
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                          ],
                                                                          decoration: const InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: secondaryBorderGreyColor),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: primaryThemeColor),
                                                                              )),
                                                                          controller:
                                                                              paidAmmot,
                                                                          keyboardType:
                                                                              TextInputType.emailAddress,
                                                                          enableSuggestions:
                                                                              true,
                                                                          autofocus:
                                                                              true,
                                                                          style:
                                                                              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onSecondaryButtonPressed:
                                                                    () {
                                                                  Get.back();
                                                                },
                                                                onPrimaryButtonPressed:
                                                                    () {
                                                                  if (double.parse(
                                                                          paidAmmot
                                                                              .text) >
                                                                      double.parse(
                                                                          planList
                                                                              .first['unpaid_amount'])) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return GenericDialogBox(
                                                                            enableSecondaryButton:
                                                                                false,
                                                                            primaryButtonText:
                                                                                'Ok',
                                                                            isLoader:
                                                                                false,
                                                                            content:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.04,
                                                                                height: MediaQuery.of(context).size.width * 0.06,
                                                                                child: const Center(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Please Check Amount you are Paynig !!',
                                                                                        style: TextStyle(color: Colors.red),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            onPrimaryButtonPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                          );
                                                                        });
                                                                  } else {
                                                                    showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return FutureBuilder(
                                                                            future:
                                                                                memmberController.payPending({
                                                                              'price': paidAmmot.text
                                                                            }, membersData['id']),
                                                                            builder:
                                                                                (context, snapshot) {
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
                                                                                              children: [
                                                                                                Text(snapshot.data!['message'])
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      primaryButtonText: 'Ok',
                                                                                      onPrimaryButtonPressed: () async {
                                                                                        Get.offAllNamed(MemberProfile.routeName, arguments: membersData['id']);
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
                                                      title: 'Pay Pending')
                                                ])),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15 *
                                                planList.length,
                                            child: ListView.builder(
                                              itemCount: planList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.115,
                                                    color: const Color.fromARGB(
                                                        255, 220, 215, 215),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SocialValue(
                                                              'Start Date',
                                                              planList[index][
                                                                          'start_date'] ==
                                                                      null
                                                                  ? '-'
                                                                  : formatDate(planList[
                                                                          index]
                                                                      [
                                                                      'start_date'])),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'End Date',
                                                              planList[index][
                                                                          'end_date'] ==
                                                                      null
                                                                  ? '-'
                                                                  : formatDate(planList[
                                                                          index]
                                                                      [
                                                                      'end_date'])),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Total Ammount',
                                                              planList[index][
                                                                          'price']
                                                                      ?.toString() ??
                                                                  '-'),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Paid Ammount',
                                                              planList[index][
                                                                          'paid_amount']
                                                                      ?.toString() ??
                                                                  '-'),
                                                          const Spacer(flex: 1),
                                                          SocialValue(
                                                              'Pending Ammount',
                                                              planList[index][
                                                                          'unpaid_amount']
                                                                      ?.toString() ??
                                                                  '-'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ))
                                      ])),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Lottie.asset(
                                          'assets/animations/member_profile_animation.json'),
                                    ))
                              ])),
                        ]),
                  )
          ]))),
        ),
      ],
    );
  }
}

Widget SocialValue(String label, String value) => Container(
    padding: const EdgeInsets.all(5),
    height: 50,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$value',
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ]));

Widget FloatingIconsButtons(String path) => Container(
    margin: const EdgeInsets.all(5),
    height: 40,
    child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: ColorLogoButton(path),
        onPressed: () {}));
