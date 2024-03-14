import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class AppUtil {
  static double responsiveHeight(context) => MediaQuery.of(context).size.height;

  static double responsiveWidth(context) => MediaQuery.of(context).size.width;

  // static bool rtlDirection(context) {
  //   return EasyLocalization.of(context)!.currentLocale == const Locale('en')
  //       ? false
  //       : true;
  // }

  static mainNavigator(context, screen) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => screen));

  static removeUntilNavigator(context, screen) =>
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);

  static replacementNavigator(context, screen) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));

  static void showToast({
    required message,
    backgroundColor,
  }) =>
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  static Color chooseToastColor(ToastStates state) {
    late Color color;
    switch (state) {
      case ToastStates.ERROR:
        color = Colors.red;
        break;
      case ToastStates.SUCCESS:
        color = Colors.green;
        break;
      case ToastStates.WARNING:
        color = Colors.amber;
        break;
    }
    return color;
  }
}

enum ToastStates { SUCCESS, ERROR, WARNING }
