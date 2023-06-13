import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/app_constant.dart';

class MultipleLocationAddModel {
  FocusNode? focusNode;
  TextEditingController? textEditingController;
  LatLng? latLng;
  String? hint;
  Function? remove;
  Function(String)? onChange;
  TextField? textField;

  MultipleLocationAddModel(
      {this.focusNode,
      this.textEditingController,
      this.latLng,
      this.hint,
      this.remove,
      this.textField,
      this.onChange}) {
    if (focusNode == null) {
      focusNode = FocusNode();
    }

    if (textEditingController == null) {
      textEditingController = TextEditingController();
    }

    if (focusNode == null) {
      focusNode = FocusNode();
    }

    if (focusNode == null) {
      focusNode = FocusNode();
    }
    if (textField == null) {
      textField = TextField(
        focusNode: focusNode,
        controller: textEditingController,
        style: TextStyle(
          fontSize: 12.sp,
        ),
        decoration: InputDecoration(
          hintText: hint ?? "Where To",
          hintStyle: TextStyle(color: Color(0xff9F9F9F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 12.h,
          ),
          isDense: true,
        ),
        onChanged: (s) {
          if (onChange != null) {
            onChange!(s);
          }
        },
      );
    }
  }

  Widget getWidget() {
    return Row(
      children: [
        if (textField != null) ...{
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
                // boxShadow: [
                //   AppBoxShadow.defaultShadow(),
                // ]
              ),
              child: textField!,
            ),
          ),
        },
        SizedBox(width: 10.w),
        if (remove != null)
          InkWell(
            onTap: () {
              if (remove != null) {
                remove!();
              }
            },
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          )
      ],
    );
  }
}
