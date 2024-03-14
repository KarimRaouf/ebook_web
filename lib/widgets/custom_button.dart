import 'package:ebook_web/core/utils/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.size,
    required this.buttomWidth,
    this.hasChild = true,
  });

  final String text;
  void Function()? onTap;
  double? size;
  final double buttomWidth;
  final bool hasChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppUI.navyBlue,
        child: Container(
          width: buttomWidth,
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: hasChild
                ? Text(
              text,
              style: TextStyle(
                  fontFamily: 'futur',
                  color: Colors.white,
                  fontSize: size),
            )
                : const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white , strokeWidth: 3),
            ),
          ),
        ),
      ),
    );
  }
}