import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';
import 'package:gmstest/website/models/Project.dart';
import 'package:gmstest/website/responsive.dart' as rr;
import 'package:gmstest/website/screens/home/tshirt_component/custom_popup.dart';

import '../../../constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: project.image == null
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) => CustomPopup(
                  title: project.title!,
                  description: project.description!,
                  imagePath: project.image!,
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.all(defaultPadding),
        padding: const EdgeInsets.all(defaultPadding * 1.5),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            SizedBox(height: defaultPadding * 0.5),
            Text(
              project.description!,
              maxLines: rr.Responsive.isMobileLarge(context) ? 3 : 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1.5,
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
