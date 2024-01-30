import 'package:flutter/material.dart';
import 'package:gmstest/configs/colors.dart';

class PrimaryButton extends StatefulWidget {
  final void Function()? onPressed;
  final String title;
  double? width;
  double? height;
  final Color? buttonColor;

  PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.width,
      this.height,
      this.buttonColor})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: widget.width ?? mediaQuery.width * 0.09,
      height: widget.height ?? mediaQuery.width * 0.025,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: widget.buttonColor ?? primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          disabledBackgroundColor: secondaryDarkGreyColor,
          disabledForegroundColor: secondaryGreyColor,
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: mediaQuery.width * 0.01,
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  final void Function()? onPressed;
  final String title;
  double? width;
  double? height;

  SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: widget.width ?? mediaQuery.width * 0.09,
      height: widget.height ?? mediaQuery.width * 0.025,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: widget.onPressed == null
              ? secondaryDarkGreyColor
              : darkGreenColor,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: darkGreenColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          // disabledBackgroundColor: secondaryDarkGreyColor,
          disabledForegroundColor: secondaryDarkGreyColor,
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: mediaQuery.width * 0.01,
          ),
        ),
      ),
    );
  }
}

class DeactivateButton extends StatefulWidget {
  final void Function()? onPressed;
  final String title;
  double? width;
  double? height;
  final Color? deactivateButtonColor;

  DeactivateButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.width,
      this.height,
      this.deactivateButtonColor})
      : super(key: key);

  @override
  State<DeactivateButton> createState() => _DeactivateButtonState();
}

class _DeactivateButtonState extends State<DeactivateButton> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: widget.width ?? mediaQuery.width * 0.09,
      height: widget.height ?? mediaQuery.width * 0.025,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: widget.deactivateButtonColor ?? primaryThemeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: mediaQuery.width * 0.01,
          ),
        ),
      ),
    );
  }
}
