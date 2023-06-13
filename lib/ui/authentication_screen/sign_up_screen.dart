import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../util/app_constant.dart';
import '../widget/custom_text_filed.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserController _userController = Get.find();
  bool value = false;
  bool rememberMe = false;

  _onRememberMeChanged(bool? newValue) => setState(() {
        rememberMe = newValue!;
        if (rememberMe) {
        } else {}
      });

  @override
  void initState() {
    super.initState();
    _userController.clearFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
          child: Column(
            // shrinkWrap: true,
            // physics: BouncingScrollPhysics,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 20,
              // ),
              SizedBox(height: MediaQuery.of(context).size.height*0.325,child:
              Stack(children: [
                Positioned(top: -550,left: -300,right: -300,
                    child: CircleAvatar(backgroundColor: AppColors.skyBlue,radius: 400,)),
                Align(alignment: Alignment.topCenter,child:
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(children: [
                    Image.asset(AppImage.rekovermeLogo,width: 180,height: 180,),
                    Text(
                      'register'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],),
                ),),
              ],),),
              // Container(
              //     height: 150, child: Image.asset(AppImage.rekovermeLogo)),

              CustomTextFiled(
                controller: cont.firstNameController,
                label: "First Name",
                hint: "First Name",
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                      RegExp("[a-zA-Z]"))
                ],
                filled: true,
                fillColor: AppColors.white,
              ),
              SizedBox(height: 20.h),
              CustomTextFiled( filled: true,
                  fillColor: AppColors.white,
                  controller: cont.lastNameController,
                  label: "last_name".tr,
                  hint: "last_name".tr,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z]")),
                  ]),
              SizedBox(height: 20.h),
              CustomTextFiled( filled: true,
                fillColor: AppColors.white,
                controller: cont.emailController,
                hint: "email".tr,
                label: "email".tr,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Card(shadowColor: Colors.grey,
                      color: Colors.white,
                      child: Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (s) {
                              cont.countryCode.value = s.toString();
                            },

                            textStyle: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            hideMainText: true,
                            initialSelection: "+1",
                            // favorite: ['+91', 'IN'],
                            countryFilter: ['US', "IN"],
                            showFlagDialog: true,
                            // showDropDownButton: true,
                            showCountryOnly: true,
                            padding: EdgeInsets.zero,
                            comparator: (a, b) =>
                                b.name!.compareTo(a.name.toString()),
                            //Get the country information relevant to the initial selection
                            onInit: (code) {
                              print(
                                  "on init ${code!.name} ${code.dialCode} ${code.name}");
                              cont.countryCode.value = code.dialCode.toString();
                            },
                            backgroundColor: AppColors.white,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: AppColors.primaryColor,
                            size: 25,
                          ),
                          SizedBox(width: 5,)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomTextFiled(
                      controller: cont.phoneNumberController,
                      label: "phone".tr,
                      hint: "phone".tr,
                      inputType: TextInputType.phone,
                      fillColor: AppColors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomTextFiled( filled: true,
                fillColor: AppColors.white,
                controller: cont.passwordController,
                isPassword: true,
                hint: "password".tr,
                label: "password".tr,
              ),
              SizedBox(height: 20.h),
              CustomTextFiled( filled: true,
                fillColor: AppColors.white,
                controller: cont.referralCodeController,
                hint: "Referral Code (optional)".tr,
                label: "Referral Code".tr,
              ),
              // CustomTextFiled(
              //   controller: cont.passwordController,
              //   hint: "your_referral_code".tr,
              //   label: "your_referral_code".tr,
              // ),
              SizedBox(height: 25.h),
              GestureDetector(onTap: (){
                 cont.registerUser();
                 //cont.registerUser();
                 // Get.to(() => HomeScreen());
              },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(height: 50,width: MediaQuery.of(context).size.width*0.8,decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.primaryColor),child:
                  Align(alignment: Alignment.center,child: Text('Create an Account',style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.w500,color: Colors.white),),),),
                  // child: CustomButton(
                  //   text: "Create an Account",
                  //   onTap: () {
                  //     cont.registerUser();
                  //     //cont.registerUser();
                  //     // Get.to(() => HomeScreen());
                  //   },
                  // ),
                ),
              ),
              SizedBox(height: 15.h),
              // Text("Or",
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w500)),
              // SizedBox(height: 15.h),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: CustomButton(
              //     text: "log_in".tr,
              //     bgColor: AppColors.white,
              //     textColor: AppColors.primaryColor,
              //     onTap: () {
              //       Get.to(LoginScreen());
              //     },
              //   ),
              // ),
              // Flexible(
              //   child: SizedBox(),
              //   fit: FlexFit.tight,
              // ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.15),

              // SizedBox(
              //   height: 20,
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: RichText(
                    text: TextSpan(
                      text: 'By Continuing, You Agree to our ',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 10),
                      children: <TextSpan>[
                        TextSpan(
                            text: '\nTerms of use ',
                            style:
                            TextStyle(color: Color(0xff297FFF), fontSize: 10)),
                        TextSpan(
                          text: 'and',
                        ),
                        TextSpan(
                            text: '  Privacy Policy',
                            style:
                            TextStyle(color: Color(0xff297FFF), fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
