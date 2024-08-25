import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class VirusGithubStats extends StatelessWidget {
  const VirusGithubStats({
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
                  InkWell(
                      onTap: () {},
                      child: const StatsText(text: 'Contact No : 8668976697')),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        // Get.toNamed(LoginPage.routeName);
                      },
                      child: const StatsText(
                          text: 'Contact Us : virusCustoms_admin@gmial.com')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {},
                      child: const StatsText(text: 'Contact No : 8668976697')),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        // Get.toNamed(LoginPage.routeName);
                      },
                      child: const StatsText(
                          text: 'Email : virusCustoms_admin@gmial.com')),
                  const SizedBox(
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
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: primaryColor),
        ),
      ],
    );
  }
}
