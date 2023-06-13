import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../home_screen.dart';

class ProfileNumberOtpScreen extends StatefulWidget {
  Map<String, dynamic> params;

  ProfileNumberOtpScreen({required this.params});

  @override
  State<ProfileNumberOtpScreen> createState() => ProfileNumberOtpScreenState();
}

class ProfileNumberOtpScreenState extends State<ProfileNumberOtpScreen> {
  String _otp = "";
  final phoneNumber = Get.arguments[0];
  final countryCode = Get.arguments[1];
  bool isResendOtp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "verification_code".tr,
      ),
      body: GetX<UserController>(builder: (cont) {
        if ((cont.error.value.errorType == ErrorType.internet)) {
          return NoInternetWidget();
        }
        return Stack(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Please_type_the_verification_code_sent_to_your".tr,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'mobile_number'.tr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    animationType: AnimationType.fade,enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    boxShadows: [BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),],
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        borderWidth: 1,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        activeColor: AppColors.white,
                        disabledColor: AppColors.white,
                        errorBorderColor: Colors.red,
                        inactiveColor: AppColors.white,
                        selectedColor: AppColors.white,
                        selectedFillColor: AppColors.white,
                        inactiveFillColor: AppColors.white
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,

                    onCompleted: (v) {
                      print("Completed===>${v}");
                      _otp = v;
                      print("value00===>${_otp}");
                    },
                    onChanged: (value) {
                      print("value===>${value}");
                      _otp = value;
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                  // OtpTextField(
                  //   numberOfFields: 4,
                  //   // borderColor: AppColors.primaryColor,
                  //   decoration: InputDecoration(
                  //     fillColor: Colors.red,
                  //     filled: true,
                  //     focusedBorder: OutlineInputBorder(
                  //       // borderRadius: BorderRadius.circular(5.0),
                  //       borderSide: const BorderSide(
                  //         color: Colors.white,
                  //         width: 3.0,
                  //       ),
                  //     ),
                  //     contentPadding: const EdgeInsets.fromLTRB(
                  //       20.0,
                  //       10.0,
                  //       20.0,
                  //       10.0,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       // borderRadius: BorderRadius.circular(5.0),
                  //       borderSide: const BorderSide(
                  //         color: Colors.white,
                  //         width: 3.0,
                  //       ),
                  //     ),
                  //     // enabledBorder: OutlineInputBorder(
                  //     //   borderSide: BorderSide(color: Colors.white),
                  //     // ),
                  //   ),
                  //   showFieldAsBox: true,
                  //   fillColor: Colors.white, filled: true,
                  //   borderColor: AppColors.white,
                  //   enabledBorderColor: AppColors.white,
                  //   focusedBorderColor: AppColors.white,
                  //   disabledBorderColor: AppColors.white,
                  //   autoFocus: true,
                  //   //runs when a code is typed in
                  //   onCodeChanged: (String code) {
                  //     //handle validation or checks here
                  //     _otp = code;
                  //   },
                  //   //runs when every textfield is filled
                  //   onSubmit: (String verificationCode) {
                  //     _otp = verificationCode;
                  //     print("object  ==>  $_otp");
                  //   }, // end onSubmit
                  // ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () async {
                      if (_otp.length != 4) {
                        print("enter 1");
                        Get.snackbar("Alert", "please_enter_otp".tr,
                            backgroundColor: Colors.redAccent.withOpacity(0.8),
                            colorText: Colors.white);
                        // cont.showError(msg: "please_enter_otp".tr);
                        return;
                      }
                      // if (!isResendOtp) {
                      //   if (_otp != widget.params["otp"].toString()) {
                      //     print("enter 2");
                      //     cont.showError(msg: "Please enter valid otp");
                      //     return;
                      //   }
                      // }

                      // if (widget.params["login_by"] == "facebook") {
                      //   print("enter 3");
                      //   cont.loginWithFacebook(
                      //       accessToken: "", data: widget.params);
                      // } else if (widget.params["login_by"] == "google") {
                      //   print("enter 4");
                      //   cont.loginWithGoogle(
                      //       accessToken: "", data: widget.params);
                      // } else if (widget.params["login_by"] == "apple") {
                      //   print("enter 5");
                      //   cont.loginWithApple(
                      //       socialUniqueId: "", data: widget.params);
                      // }
                      // if (isResendOtp) {
                      //   await cont.verifyResendOTp(_otp, phoneNumber);
                      //   setState(() {
                      //     isResendOtp = false;
                      //   });
                      // } else {
                        cont.verifyProfileNumberOTP(_otp);
                      // }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: Text("continue".tr,
                          style:
                              TextStyle(fontSize: 14.h, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("didn_t_get_the_OTP".tr,
                          style: TextStyle(
                            color: AppColors.drawer.withOpacity(0.8),
                          )),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isResendOtp = true;
                          });
                          Map<String, dynamic> params = {};
                          params["mobile"] = phoneNumber;
                          params["country_code"] = countryCode;
                          cont.sendOtp(params: params);
                          print("otp===> ${_otp}");
                        },
                        child: Text(
                          "resend_OTP".tr,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  // RichText(
                  //   text: TextSpan(
                  //     text: "Didn't get the OTP" + " ",
                  //     style: TextStyle(
                  //       color: AppColors.drawer.withOpacity(0.8),
                  //     ),
                  //     children: [
                  //       WidgetSpan(
                  //         child:
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
