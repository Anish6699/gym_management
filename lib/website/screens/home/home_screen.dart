import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmstest/website/screens/home/tshirt_component/tshirt_home_banner.dart';
import 'package:gmstest/website/screens/home/tshirt_component/virus_heighlights.dart';
import 'package:gmstest/website/screens/home/tshirt_component/virus_projects.dart';
import 'package:gmstest/website/screens/main/main_screen.dart';

import 'components/heighlights.dart';
import 'components/home_banner.dart';
import 'components/my_projects.dart';

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
  List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreen(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleButtons(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Customs'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Software'),
                    ),
                  ],
                  isSelected: _isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _isSelected.length; i++) {
                        _isSelected[i] = i == index;
                      }
                    });
                    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
                    print(_isSelected);
                  },
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  borderColor: Colors.blue,
                  selectedBorderColor: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          _isSelected[0] == true ? TshirtHomeBanner() : HomeBanner(),
          _isSelected[0] == true ? VirusGithubStats() : GithubStats(),
          _isSelected[0] == true ? VirusMyProjects() : MyProjects(),
          //Recommendations(),
        ],
      ),
    );
  }
}
