import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../core/utils/app_ui.dart';
import '../core/utils/styles.dart';

class CustomTextField extends StatelessWidget {
  final String? hint, lable;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function()? onTap, onEditingComplete;
  final Function(String? v)? onChange, onFieldSubmitted;
  final bool obscureText, readOnly, autofocus, validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines, maxLength;
  final double radius;
  final TextAlign? textAlign;
  final Color? borderColor, fillColor;
  final Color? labelColor;
  final bool border;
  final double fontSize;
  final double? hintSize;
  final String? initialValue;
  final FocusNode? focusNode;
  final double? height;
  final double? cursorHeight;

  const CustomTextField(
      {super.key,
        required this.controller,
        this.onFieldSubmitted,
        this.hint,
        this.lable,
        required this.textInputType,
        this.obscureText = false,
        this.prefixIcon,
        this.suffixIcon,
        this.onTap,
        this.onChange,
        this.onEditingComplete,
        this.focusNode,
        this.maxLines,
        this.textAlign,
        this.readOnly = false,
        this.autofocus = false,
        this.radius = 6.0,
        this.maxLength,
        this.validation = false,
        this.borderColor,
        this.fillColor,
        this.border = true,
        this.fontSize = 14,
        this.hintSize,
        this.labelColor = Colors.black,
        this.initialValue,
        this.height,
        this.cursorHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      child: TextFormField(
        cursorHeight: cursorHeight ?? 22,
        onEditingComplete: onEditingComplete,
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        onTap: onTap,
        readOnly: readOnly,
        onFieldSubmitted: onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // maxLength: maxLength,
        textAlign: TextAlign.left,
        onChanged: onChange,
        validator: validation
            ? (v) {
          if (v!.isEmpty) {
            return "Field is required".tr();
          } else {
            return null;
          }
        }
            : null,
        autofocus: autofocus,
        maxLines: maxLines ?? 1,
        cursorColor: AppUI.blackColor,
        cursorWidth: 1.0,
        cursorRadius: const Radius.circular(30),
        decoration: InputDecoration(
          hintText: hint?.tr(),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: Styles.textStyle14.copyWith(color: AppUI.hintTextColor),
          errorMaxLines: 2,
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: suffixIcon,
          ),
          labelText: lable,
          labelStyle: TextStyle(
              color: AppUI.whiteColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
          filled: true,
          fillColor: fillColor ?? AppUI.whiteColor,
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
            child: prefixIcon,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          border: border
              ? OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor ?? AppUI.navyBlue,
            ),
          )
              : null,
          disabledBorder: border
              ? OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor ?? AppUI.navyBlue,
            ),
          )
              : null,
          enabledBorder: border
              ? OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: BorderSide(color: borderColor ?? AppUI.disableTextFieldBorderColor))
              : null,
          focusedBorder: border
              ? OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                  bottomRight: Radius.circular(radius)),
              borderSide: BorderSide(
                  color: borderColor ?? AppUI.navyBlue))
              : null,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: const BorderSide(color: AppUI.navyBlue)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: const BorderSide(color: AppUI.navyBlue)),
          suffixIconColor: AppUI.blackColor,
          suffixIconConstraints:
          const BoxConstraints(maxHeight: 36, maxWidth: 36),
          prefixIconConstraints:
          const BoxConstraints(maxHeight: 36, maxWidth: 36),
        ),
      ),
    );
  }
}