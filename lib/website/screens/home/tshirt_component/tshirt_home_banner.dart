import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/website/responsive.dart';

import '../../../constants.dart';

class TshirtHomeBanner extends StatelessWidget {
  const TshirtHomeBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: Responsive.isMobile(context) ? 2.5 : 3,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            "assets/images/virus_logo.png",
            fit: BoxFit.fitWidth,
          ),
          Container(color: darkColor.withOpacity(0.8)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "We here deal in Commercial T-Shirt Printing ",
                  style: Responsive.isDesktop(context)
                      ? Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      : TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                ),
                if (Responsive.isMobileLarge(context))
                  const SizedBox(height: defaultPadding),
                MyBuildAnimatedText(),
                SizedBox(height: defaultPadding),
                if (!Responsive.isMobileLarge(context))
                  ElevatedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      "1 Year T-Shirt/Print Warranty",
                      style: TextStyle(color: darkColor),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyBuildAnimatedText extends StatelessWidget {
  const MyBuildAnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      // it applies same style to all the widgets under it
      style: Theme.of(context).textTheme.subtitle1!,
      maxLines: 1,
      child: Row(
        children: [
          if (!Responsive.isMobileLarge(context))
            SizedBox(width: defaultPadding / 2),
          Text("Get Your "),
          Responsive.isMobile(context)
              ? Expanded(child: AnimatedText())
              : AnimatedText(),
          if (!Responsive.isMobileLarge(context))
            SizedBox(width: defaultPadding / 2),
        ],
      ),
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          "Custom T-shirts",
          speed: Duration(milliseconds: 60),
        ),
      ],
    );
  }
}

class FlutterCodedText extends StatelessWidget {
  const FlutterCodedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "<",
        children: [
          TextSpan(
            text: "Virus",
            style: TextStyle(color: primaryColor),
          ),
          TextSpan(text: ">"),
        ],
      ),
    );
  }
}
