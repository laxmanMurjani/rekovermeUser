import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/custom_text_filed.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    // _userController.clearFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "change_password".tr),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  AppBoxShadow.defaultShadow(),
                ],
              ),
              child: Column(
                children: [
                  CustomTextFiled(
                    controller: cont.oldPasswordController,
                    isPassword: true,
                    label: "current_password".tr,
                    hint: "current_password".tr,
                  ),
                  CustomTextFiled(
                    controller: cont.passwordController,
                    isPassword: true,
                    label: "new_password".tr,
                    hint: "New Password".tr,
                  ),
                  CustomTextFiled(
                    controller: cont.conPasswordController,
                    isPassword: true,
                    label: "confirm_new_password".tr,
                    hint: "confirm_new_password".tr,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
              child: CustomButton(
                text: "change_password".tr,
                onTap: () {
                  cont.changePassword();
                },
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }
}
