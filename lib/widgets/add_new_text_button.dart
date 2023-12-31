
import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class AddNewTextButton extends StatelessWidget {
  const AddNewTextButton({
    Key? key,
    required this.buttonOnPressed,
  }) : super(key: key);

  final Function buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          backgroundColor: primaryDarkBlueColor,
          elevation: 0,
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: primaryDarkBlueColor,
          ),
        ),
        onPressed: () {
          buttonOnPressed();
        },
        child: Row(
          children: const [
            Icon(
              Icons.add,
            ),
            Text(
              'Add New',
            )
          ],
        ),
      ),
    );
  }
}
