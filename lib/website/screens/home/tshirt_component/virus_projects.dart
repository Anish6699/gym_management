import 'package:flutter/material.dart';
import 'package:gmstest/website/models/Project.dart';
import 'package:gmstest/website/responsive.dart';
import 'package:gmstest/website/screens/home/components/project_card.dart';

import '../../../constants.dart';

class VirusMyProjects extends StatelessWidget {
  const VirusMyProjects({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Services",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: ProjectsGridView(
            crossAxisCount: 1,
            childAspectRatio: 1.7,
          ),
          mobileLarge: ProjectsGridView(crossAxisCount: 2),
          tablet: ProjectsGridView(childAspectRatio: 1.1),
          desktop: ProjectsGridView(),
        )
      ],
    );
  }
}

class ProjectsGridView extends StatelessWidget {
  const ProjectsGridView({
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.3,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: demo_projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
      ),
      itemBuilder: (context, index) => ProjectCard(
        project: tshirtFeatures[index],
      ),
    );
  }
}
