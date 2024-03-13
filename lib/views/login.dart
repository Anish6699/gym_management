import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/configs/server_configs.dart';
import 'package:gmstest/controllers/login_controllers.dart';
import 'package:gmstest/super_admin/admins.dart';
import 'package:gmstest/views/dashboards/admin_dashboard.dart';
import 'package:gmstest/views/dashboards/branch/branch_dashboard.dart';
import 'package:gmstest/views/dashboards/dashboard.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController forgotPasswordController = TextEditingController();
  bool isLogin = true;

  var nameController = TextEditingController();
  var managerController = TextEditingController();
  var searchController = TextEditingController();

  Map<String, dynamic> userSearchResults = {};
  var controllers = <String, TextEditingController>{};

  bool isLoading = false;
  bool isLoggedIn = false;
  bool viewPassword = true;

  LoginController loginController = LoginController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Lottie.asset('assets/animations/login_animation_2.json'))

            // ),
            ),
        Expanded(
          flex: 2,
          child: Scaffold(
            // backgroundColor: tertiaryGreyColor,
            body: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            // width: MediaQuery.of(context).size.height * 0.2,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child:
                                Image.asset("assets/images/fittraa_logo.png")),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.095,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: SelectableText(
                                  'Login ID',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      )),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: true,
                                  onChanged: (e) {},
                                  autofocus: true,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                child: SelectableText(
                                  'Password',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                child: TextFormField(
                                  obscureText: viewPassword,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            viewPassword = !viewPassword;
                                          });
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: viewPassword == true
                                                ? const Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.white,
                                                  )),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      )),
                                  controller: passwordController,
                                  onFieldSubmitted: (e) {
                                    setState(() {
                                      isLoggedIn = true;
                                    });
                                  },
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.095,
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .2,
                          child: PrimaryButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return FutureBuilder(
                                      future: loginController.login({
                                        'email': emailController.text,
                                        'password': passwordController.text
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
                                            : snapshot.data!['access_token'] !=
                                                    null
                                                ? GenericDialogBox(
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
                                                        child: const Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  'Login Successfully')
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    primaryButtonText: 'Ok',
                                                    onPrimaryButtonPressed:
                                                        () async {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      await prefs.setInt(
                                                          'categoryId',
                                                          snapshot.data![
                                                              'category_id']);

                                                      categoryId = snapshot
                                                          .data!['category_id'];
                                                      userType = snapshot
                                                          .data!['user_type'];
                                                      if (userType == 1) {}
                                                      if (userType == 2) {
                                                        adminId = snapshot
                                                            .data!['user_id'];
                                                        await prefs.setInt(
                                                            'adminId',
                                                            snapshot.data![
                                                                'user_id']);
                                                      }
                                                      if (userType == 3) {
                                                        branchId = snapshot
                                                            .data!['user_id'];
                                                        await prefs.setInt(
                                                            'branchId',
                                                            snapshot.data![
                                                                'user_id']);
                                                      }

                                                      await prefs.setString(
                                                          'token',
                                                          snapshot.data![
                                                              'access_token']);
                                                      await prefs.setInt(
                                                          'user_type',
                                                          snapshot.data![
                                                              'user_type']);

                                                      if (userType == 1) {
                                                        Get.toNamed(
                                                          AllAdmins
                                                              .allAdminRouteName,
                                                        );
                                                      } else if (userType ==
                                                          2) {
                                                        Get.toNamed(
                                                          AdminDashboard
                                                              .routeName,
                                                        );
                                                      } else if (userType ==
                                                          3) {
                                                        Get.toNamed(
                                                          BranchDashboard
                                                              .routeName,
                                                        );
                                                      }
                                                    },
                                                  )
                                                : GenericDialogBox(
                                                    enableSecondaryButton:
                                                        false,
                                                    primaryButtonText: 'Ok',
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
                                                        child: const Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  'Login Failed')
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onPrimaryButtonPressed: () {
                                                      Get.back();
                                                    },
                                                  );
                                      },
                                    );
                                  });
                              // Get.toNamed(
                              //   Dashboard.routeName,
                              // );
                            },
                            title: 'Login',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return GenericDialogBox(
                                    enableSecondaryButton: true,
                                    isLoader: false,
                                    title: "Forgot Password",
                                    primaryButtonText: 'Submit',
                                    secondaryButtonText: 'Cancel',
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Flexible(
                                            child: SelectableText(
                                              'Registered Email Address',
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
                                                            secondaryBorderGreyColor),
                                                  )),
                                              controller:
                                                  forgotPasswordController,
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
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            'Reset Password link will be shared on email',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    onSecondaryButtonPressed: () {
                                      Get.back();
                                    },
                                    onPrimaryButtonPressed: () {
                                      if (forgotPasswordController.text
                                          .contains('@')) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return FutureBuilder(
                                                future: loginController
                                                    .forgetPassword({
                                                  'email':
                                                      forgotPasswordController
                                                          .text
                                                }),
                                                builder: (context, snapshot) {
                                                  return snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting
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
                                                              child:
                                                                  const Center(
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
                                                          closeButtonEnabled:
                                                              false,
                                                          enablePrimaryButton:
                                                              true,
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
                                                          primaryButtonText:
                                                              'Ok',
                                                          onPrimaryButtonPressed:
                                                              () async {
                                                            Get.back();
                                                            Get.back();
                                                          },
                                                        );
                                                },
                                              );
                                            });
                                      } else {
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
                                                          Text(
                                                            'Please Enter Valid Email Address !!',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          )
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
                                    },
                                  );
                                });
                          },
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.01),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
