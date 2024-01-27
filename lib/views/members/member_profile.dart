import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/controllers/member_controllers.dart';
import 'package:gmstest/navigation_pane/navigation_pane_closed.dart';
import 'package:gmstest/navigation_pane/navigation_pane_expanded.dart';
import 'package:gmstest/views/members/members.dart';
import 'package:gmstest/views/profilewidgets/headerpannel.dart';
import 'package:gmstest/views/profilewidgets/reusablecomponents.dart';
import 'package:gmstest/views/profilewidgets/reusabletext.dart';
import 'package:gmstest/views/profilewidgets/topbackground.dart';
import 'package:gmstest/widgets/buttons.dart';
import 'package:gmstest/widgets/generic_appbar.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});
  static const String routeName = '/members';

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

  @override
  void initState() {
    print('argumentsssssssssssssssssssss ${Get.arguments}');
    initializeData();
    super.initState();
  }

  initializeData() async {
    if (Get.arguments != null) {
      var a = await memmberController.getSingleMember(Get.arguments);
      print('dataaaaaaaaaaaaaaaaaaaaaa');
      print(a);
    } else {
      Get.toNamed(
        MembersView.membersRouteName,
      );
    }
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
              appBar: GenericAppBar(
                onNavbarIconPressed: () {
                  setState(() {
                    isNavOpen = !isNavOpen;
                  });
                },
                title: "Member's Profile",
                toolbarHeight: MediaQuery.of(context).size.height * 0.075,
              ),
              backgroundColor: const Color(0xffdde9e9),
              body: SafeArea(
                  child: Stack(children: [
                TopBackground(),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
                                    Container(
                                        width: double.infinity,
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Spacer(flex: 1),
                                              SocialValue('Age', '22'),
                                              SocialValue('Height', '7.10'),
                                              SocialValue('Weight', '86'),
                                              const Spacer(flex: 10),
                                              NormalButton(
                                                  'ACTIVE',
                                                  Colors.white,
                                                  '',
                                                  Colors.white,
                                                  Colors.green),
                                              const Spacer(flex: 1)
                                            ])),
                                    const SizedBox(height: 50),
                                    LargeBoldTextBlack('Anish Gunjal'),
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
                                              'Ganesh Nagar Yerawda , Pune -411006')
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
                                              'Personal Trainer - Sagar Dhumal')
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
                                              'Email Address : anishgunjal6699@gmail.com')
                                        ]),

                                    /// description
                                    Divider(
                                        height: 30,
                                        thickness: 1,
                                        color: primaryThemeColor),
                                    Container(
                                        width: double.infinity,
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Spacer(flex: 1),
                                              SocialValue(
                                                  'Primary Mobile Number',
                                                  '8668976697'),
                                              const Spacer(flex: 1),
                                              SocialValue(
                                                  'Secondary Mobile Number',
                                                  '7709389865'),
                                              const Spacer(flex: 1),
                                              SocialValue(
                                                  'Start Date', '10/25/2023'),
                                              const Spacer(flex: 1),
                                              SocialValue(
                                                  'End Date', '10/25/2023'),
                                              const Spacer(flex: 1),
                                              SocialValue(
                                                  'Pending Ammount', '4000'),
                                              const Spacer(flex: 10),
                                              PrimaryButton(
                                                  onPressed: () {},
                                                  title: 'Edit'),
                                              const Spacer(flex: 1)
                                            ])),
                                  ])),
                            ),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: const CircleAvatar(
                                        radius: 70,
                                        backgroundImage: AssetImage(
                                            'assets/images/person.png'))))
                          ])),
                      // Container(
                      //     margin: EdgeInsets.symmetric(
                      //         horizontal: _width / 10, vertical: 20),
                      //     padding: const EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(5),
                      //         boxShadow: [
                      //           BoxShadow(
                      //               color: Colors.black.withOpacity(.1),
                      //               blurRadius: 5,
                      //               spreadRadius: 2)
                      //         ]),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       children: [
                      //         Container(
                      //             margin:
                      //                 const EdgeInsets.symmetric(vertical: 20),
                      //             child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.center,
                      //                 children: [
                      //                   BoldBlackText('Let\'s keep in touch!'),
                      //                   NormalGreyText(
                      //                       'Find us on any of these platforms, we respond 1-2 business days.'),
                      //                   const SizedBox(height: 10),
                      //                   Row(children: [
                      //                     const Spacer(flex: 1),
                      //                     FloatingIconsButtons(
                      //                         'assets/icon/facebook.svg'),
                      //                     FloatingIconsButtons(
                      //                         'assets/icon/linkedin.svg'),
                      //                     FloatingIconsButtons(
                      //                         'assets/icon/skype.svg'),
                      //                     FloatingIconsButtons(
                      //                         'assets/icon/twitter.svg'),
                      //                     FloatingIconsButtons(
                      //                         'assets/icon/youtube.svg'),
                      //                     const Spacer(flex: 1)
                      //                   ])
                      //                 ])),
                      //         Container(
                      //             margin: const EdgeInsets.all(20),
                      //             child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.center,
                      //                       children: [
                      //                         NormalGreyText('USEFUL LINKS'),
                      //                         TextButtons('About Us',
                      //                             Colors.grey[900]!),
                      //                         TextButtons(
                      //                             'Blog', Colors.grey[900]!),
                      //                         TextButtons(
                      //                             'Github', Colors.grey[900]!),
                      //                         TextButtons('Free Products',
                      //                             Colors.grey[900]!)
                      //                       ]),
                      //                   const SizedBox(width: 50),
                      //                   Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     children: [
                      //                       NormalGreyText('OTHER RESOURCES'),
                      //                       TextButtons('MIT License',
                      //                           Colors.grey[900]!),
                      //                       TextButtons('Terms & Conditions',
                      //                           Colors.grey[900]!),
                      //                       TextButtons('Privacy Policy',
                      //                           Colors.grey[900]!),
                      //                       TextButtons(
                      //                           'Contact Us', Colors.grey[900]!)
                      //                     ],
                      //                   )
                      //                 ]))
                      //       ],
                      //     ))
                    ])
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
