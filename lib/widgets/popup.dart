
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmstest/widgets/buttons.dart';

class GenericDialogBox extends StatelessWidget {
  GenericDialogBox({
    super.key,
    this.title,
    this.message,
    this.content,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.deactivateButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.buttonColor,
    this.deactivateButtonPressed,
    this.onCloseButtonPressed,
    this.deactivateButtonColor,
    this.deactivateEnable = false,
    required this.enableSecondaryButton,
    required this.isLoader,
    this.enablePrimaryButton = true,
    this.height,
    this.width,
    this.secondaryButtonWidth,
    this.closeButtonEnabled = true,
  });

  String? title;

  ///Message is displayed only when `content` property is null
  String? message;

  /// `true` if the dialog is for Loader, else `false`
  final bool isLoader;

  /// `true` if you want a secondary button, else `false`
  final bool enableSecondaryButton;
  bool enablePrimaryButton;
  final bool deactivateEnable;
  String? primaryButtonText;
  String? secondaryButtonText;
  String? deactivateButtonText;
  void Function()? onPrimaryButtonPressed;
  void Function()? onSecondaryButtonPressed;
  void Function()? deactivateButtonPressed;
  void Function()? onCloseButtonPressed;
  Widget? content;
  double? height;
  double? width;
  double? secondaryButtonWidth;
  final Color? buttonColor;
  final Color? deactivateButtonColor;

  bool? closeButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: !isLoader && closeButtonEnabled!
          ? Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onCloseButtonPressed ??
                    () {
                      Get.back();
                    },
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: MediaQuery.of(context).size.width * 0.015,
                ),
              ),
            )
          : null,
      iconPadding: const EdgeInsets.only(top: 15, right: 15),
      title: !isLoader
          ? SelectableText(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.011,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      content: content ??
          Container(
            color: Colors.white,
            height: height ?? MediaQuery.of(context).size.height * 0.06,
            width: width ??
                (enableSecondaryButton
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.15),
            child: Center(
              child: SelectableText(
                message ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.009,
                ),
              ),
            ),
          ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: !isLoader
          ? EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.05,
            )
          : null,
      actions: !isLoader
          ? [
              enableSecondaryButton
                  ? SecondaryButton(onPressed: onSecondaryButtonPressed, title: secondaryButtonText!, width: secondaryButtonWidth,)
                  : const SizedBox(),
              enablePrimaryButton
                  ? PrimaryButton(
                      onPressed: onPrimaryButtonPressed,
                      title: primaryButtonText ?? '',
                      buttonColor: buttonColor,
                    )
                  : const SizedBox.shrink(),
              deactivateEnable
                  ? DeactivateButton(
                      onPressed: deactivateButtonPressed,
                      title: deactivateButtonText!,
                      deactivateButtonColor: deactivateButtonColor,
                    )
                  : const SizedBox()
            ]
          : null,
    );
  }
}
