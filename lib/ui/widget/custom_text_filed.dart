import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/util/app_constant.dart';

class CustomTextFiled extends StatelessWidget {
  TextEditingController? controller;
  String? label;
  String? hint;
  InputBorder? border;
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  Color? fillColor;
  bool? filled;
  Widget? labelWidget;
  TextStyle? hintStyle;
  TextInputType inputType;
  bool isPassword;
  bool readOnly;
  Widget? suffixIcon;
  List<TextInputFormatter>? inputFormatter;
  CustomTextFiled(
      {this.controller,
      this.label,
      this.labelWidget,
      this.hintStyle,
      this.filled = false,
      this.hint,
      this.fillColor,
      this.border,
      this.enabledBorder,
      this.focusedBorder,
      this.inputType = TextInputType.text,
      this.isPassword = false,
      this.readOnly = false,
      this.suffixIcon,
      this.inputFormatter});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        offset: const Offset(
          0.0,
          1.0,
        ),
        blurRadius: 1,
      ),]),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            label: labelWidget,
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w500),
            // labelText: label ?? "",
            labelStyle:
                hintStyle ?? TextStyle(fontSize: 15.sp, color: Color(0xffB4B4B5)),
            border: border,
            filled: filled,
            fillColor: fillColor,
            // isDense: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: suffixIcon,
          ),
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
          keyboardType: inputType,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
