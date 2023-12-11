import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_SHORT,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: length,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}