import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/login_controllers.dart';
import 'package:gmstest/views/dashboard.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLogin = true;

  var nameController = TextEditingController();
  var managerController = TextEditingController();
  var searchController = TextEditingController();

  Map<String, dynamic> userSearchResults = {};
  var controllers = <String, TextEditingController>{};

  bool isLoading = false;
  bool isLoggedIn = false;

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
          child: Image.asset(
            'assets/gym_icon.png',
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
        ),
        Expanded(
          flex: 2,
          child: Scaffold(
            backgroundColor: tertiaryGreyColor,
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
                        SizedBox(
                          // width: MediaQuery.of(context).size.height * 0.2,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Image.asset(
                            'assets/logopng2.png',
                          ),
                        ),
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
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryThemeColor),
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
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryBorderGreyColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryThemeColor),
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
                                                      await prefs.setString(
                                                          'token',
                                                          snapshot.data![
                                                              'access_token']);
                                                      Get.toNamed(
                                                        Dashboard.routeName,
                                                      );
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
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: const Text(
                            'New User?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryThemeColor),
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
