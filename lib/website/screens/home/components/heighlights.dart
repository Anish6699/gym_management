import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/views/login.dart';

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
                  // Spacer(),
                  // PrimaryButton(
                  // onPressed: () {
                  //   Get.toNamed(LoginPage.routeName);
                  // },
                  //     title: 'Login'),
                  // Spacer(),
                  // PrimaryButton(onPressed: () {}, title: 'Contact Us'),
                  // Spacer(),
                  InkWell(
                      onTap: () {
                        Get.toNamed(LoginPage.routeName);
                      },
                      child: StatsText(text: 'Login')),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        // Get.toNamed(LoginPage.routeName);
                      },
                      child: StatsText(text: 'Contact Us')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Get.toNamed(LoginPage.routeName);
                      },
                      child: StatsText(text: 'Login')),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        // Get.toNamed(LoginPage.routeName);
                      },
                      child: StatsText(text: 'Contact Us')),
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
    // required this.number,
    required this.text,
  }) : super(key: key);

  // final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // AnimatedCounter(
        //   value: number,
        //   text: '+',
        // ),
        // SizedBox(
        //   width: defaultPadding / 2,
        // ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: primaryColor),
        ),
      ],
    );
  }
}
