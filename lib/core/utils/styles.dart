import 'package:erp_application/utils/app_ui.dart';
import 'package:flutter/material.dart';

import 'app_ui.dart';

abstract class Styles {
  // Font Size 24
  static const textStyle24 = TextStyle(
    color: AppUI.blackColor,
    fontSize: 24,
    fontWeight: FontWeight.w100,
    fontFamily: 'PoppinsBold',
  );

  // Font Size 16

  static const textStyle16 = TextStyle(
    color: AppUI.navyBlue,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Font Size 14

  static const textStyle14 = TextStyle(
    color: AppUI.blackColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Font Size 12

  static const textStyle12 = TextStyle(
    color: AppUI.blackColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}