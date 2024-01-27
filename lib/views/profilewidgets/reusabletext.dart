import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmstest/configs/colors.dart';

Widget LargeBoldTextBlack(String label) => Text(label,
    style: TextStyle(
        fontSize: 25,
        color: primaryThemeColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 1));

Widget NormalGreyText(String label) => Text(label,
    overflow: TextOverflow.visible,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: 14,
        wordSpacing: 1,
        letterSpacing: .5,
        color: primaryThemeColor));

Widget BoldBlackText(String label) => Text(label,
    style: TextStyle(
        fontSize: 20,
        color: Colors.grey[800],
        fontWeight: FontWeight.w500,
        letterSpacing: 1));

Widget SmallBlackText(String label) => Text(label,
    style: TextStyle(
        fontSize: 10,
        color: Colors.grey[800],
        fontWeight: FontWeight.w500,
        letterSpacing: 1));
