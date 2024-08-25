import 'package:flutter/material.dart';
import 'package:gmstest/website/constants.dart';
import 'my_info.dart';
import 'skills.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: Column(
          children: [
            MyInfo(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Skills(),
                    SizedBox(height: defaultPadding),
                    Divider(),
                    SizedBox(height: defaultPadding / 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
