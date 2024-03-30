import 'package:flutter/material.dart';
import 'package:gmstest/website/screens/main/main_screen.dart';

import 'components/heighlights.dart';
import 'components/home_banner.dart';
import 'components/my_projects.dart';
import 'components/recommendations.dart';

class WebsiteHomeScreen extends StatefulWidget {
  const WebsiteHomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/website-home-screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const WebsiteHomeScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<WebsiteHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<WebsiteHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MainScreen(
      children: [
        HomeBanner(),
        GithubStats(),
        MyProjects(),
        //Recommendations(),
      ],
    );
  }
}
