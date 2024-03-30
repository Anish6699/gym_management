import 'package:flutter/material.dart';
import 'package:gmstest/website/components/animated_progress_indicator.dart';

import '../../../constants.dart';

class Skills extends StatelessWidget {
  const Skills({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Text(
            "Sectors",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        const Row(
          children: [
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'member_animation.json',
                label: "Gym",
              ),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'football_animation.json',
                label: "Football",
              ),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'cricket_bat_ball.json',
                label: "Cricket",
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'dance_animation.json',
                label: "Dance",
              ),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'karate_animation.json',
                label: "Karate",
              ),
            ),
            SizedBox(width: defaultPadding),
            Expanded(
              child: AnimatedCircularProgressIndicator(
                animation: 'coach_animation.json',
                label: "Classes",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
