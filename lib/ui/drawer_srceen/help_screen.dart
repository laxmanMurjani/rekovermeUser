import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/dialog/give_feedback_dialog.dart';
import 'package:arbyuser/ui/privacy_policy_screen.dart';
import 'package:arbyuser/ui/terms_and_condition_screen.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getHelp();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        text: "help".tr,
      ),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.skyBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            "support".tr,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 7.h),
                          child: Column(
                            children: [
                              SizedBox(height: 7.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 80.w,
                                    width: 80.w,
                                    child: Image.asset(AppImage.helpBoy),
                                  ),
                                  Container(
                                      height: 100,
                                      width: 1,
                                      color: Colors.grey),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          cont.makePhoneCall(
                                              phoneNumber: cont
                                                      .helpResponseModel
                                                      .value
                                                      .contactNumber ??
                                                  "");
                                        },
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 7.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.skyBlue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r)),
                                            boxShadow: [
                                              AppBoxShadow.defaultShadow(),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "call".tr,
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          cont.sendMail(
                                              mail: cont.helpResponseModel
                                                      .value.contactEmail ??
                                                  "");
                                        },
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 7.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.skyBlue,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            boxShadow: [
                                              AppBoxShadow.defaultShadow(),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Email".tr,
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "our_you_soon!".tr,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(GiveFeedbackDialog());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 7.h),
                      margin: EdgeInsets.symmetric(
                        horizontal: 30.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.skyBlue,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          AppBoxShadow.defaultShadow(),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Give Feedback".tr,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(TermsAndConditionScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 7.h),
                        margin: EdgeInsets.symmetric(
                          horizontal: 30.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            AppBoxShadow.defaultShadow(),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Terms And Conditions".tr,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: AppColors.primary,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(PrivacyPolicyScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 7.h),
                        margin: EdgeInsets.symmetric(
                          horizontal: 30.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            AppBoxShadow.defaultShadow(),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Privacy Policy".tr,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: AppColors.primary,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
