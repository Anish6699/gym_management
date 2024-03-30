import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/views/login.dart';
import 'package:gmstest/website/components/animated_counter.dart';
import 'package:gmstest/website/utils/function.dart';
import 'package:gmstest/widgets/buttons.dart';

import '../../../constants.dart';
import 'heigh_light.dart';

class GithubStats extends StatelessWidget {
  const GithubStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: (MediaQuery.of(context).size.width > 500)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  PrimaryButton(
                      onPressed: () {
                        Get.toNamed(LoginPage.routeName);
                      },
                      title: 'Login'),
                  Spacer(),
                  PrimaryButton(onPressed: () {}, title: 'Contact Us'),
                  Spacer(),
                  // StatsText(
                  //     number: snapshot.data['public_gists'], text: 'Gists'),
                  // Spacer(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                      onPressed: () {
                        Get.toNamed(LoginPage.routeName);
                      },
                      title: 'Login'),
                  SizedBox(
                    height: 10,
                  ),
                  PrimaryButton(onPressed: () {}, title: 'Contact Us'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ));
  }
}

class StatsText extends StatelessWidget {
  const StatsText({
    Key? key,
    required this.number,
    required this.text,
  }) : super(key: key);

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedCounter(
          value: number,
          text: '+',
        ),
        SizedBox(
          width: defaultPadding / 2,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
