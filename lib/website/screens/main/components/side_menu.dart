import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/website/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'area_info_text.dart';
import 'coding.dart';
import 'knowledges.dart';
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
                    // TextButton(
                    //   onPressed: () {},
                    //   child: FittedBox(
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           "DOWNLOAD Details",
                    //           style: TextStyle(
                    //             color: Theme.of(context)
                    //                 .textTheme
                    //                 .bodyText1!
                    //                 .color,
                    //           ),
                    //         ),
                    //         SizedBox(width: defaultPadding / 2),
                    //         Icon(Icons.download),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: defaultPadding),
                    //   color: primaryColor,
                    //   child: Row(
                    //     children: [
                    //       Spacer(),
                    //       IconButton(
                    //         onPressed: () {
                    //           // _launchLIURL();
                    //         },
                    //         icon: Icon(Icons.share),
                    //       ),
                    //       IconButton(
                    //         onPressed: () {
                    //           // _launchgitURL();
                    //         },
                    //         icon: Icon(Icons.share),
                    //       ),
                    //       IconButton(
                    //         onPressed: () {
                    //           // _launchTwitURL();
                    //         },
                    //         icon: Icon(Icons.share),
                    //       ),
                    //       Spacer(),
                    //     ],
                    //   ),
                    // ),
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

_launchLIURL() async {
  const url = 'https://www.linkedin.com/in/wasiullah-soomro-60415417a/';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_launchgitURL() async {
  const url = 'https://github.com/Wasiullah1';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_launchTwitURL() async {
  const url = 'https://twitter.com/wasi_sumro';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
