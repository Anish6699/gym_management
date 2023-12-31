import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/configs/colors.dart';

class AddNewDialog extends StatelessWidget {
  AddNewDialog({
    Key? key,
    required this.widget,
    required this.submitOnPressed,
    required this.editParameter,
  }) : super(key: key);

  final Widget? widget;
  final Function submitOnPressed;
  final String editParameter;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SelectableText(
        'Add New $editParameter',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryThemeColor,
          fontSize: 15,
        ),
      ),
      content: widget,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: Get.back,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: primaryThemeColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SelectableText('Cancel'),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryThemeColor,
              ),
              onPressed: () {
                submitOnPressed();
              },
              child: const SelectableText('Add'),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
