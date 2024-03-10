import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class LiveDataFileInfoCard extends StatelessWidget {
  const LiveDataFileInfoCard({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.svgSrc,
  }) : super(key: key);

  final String fieldName;
  final String value;
  final String svgSrc;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: fieldName,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    // color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.asset(
                    svgSrc,
                    // colorFilter:
                    //     ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${value} ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white70),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        fieldName,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
