import 'package:flutter/material.dart';

import '../core/utils/app_ui.dart';
import '../core/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color = AppUI.navyBlue,
    this.textColor = AppUI.whiteColor,
    required this.text,
    required this.height,
    required this.onTap,
  });

  final Color color;
  final Color textColor;
  final String text;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Styles.textStyle16.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}