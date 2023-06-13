import 'dart:developer';
import 'dart:io';

import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:arbyuser/ui/authentication_screen/sign_up_screen.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../widget/custom_text_filed.dart';

class SignInUpScreen extends StatefulWidget {
  const SignInUpScreen({Key? key}) : super(key: key);

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find();
  CarouselController? controller;
  List images = [
    AppImage.walkthroughFirst,
    AppImage.walkthrough3,
    AppImage.walkthrough2,
  ];
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly'
    ],
    signInOption: SignInOption.standard,
    // clientId: AppString.googleSignInServerClientId,
    // hostedDomain: "predictive-host-314811.firebaseapp.com"
  );

  @override
  void initState() {
    super.initState();
    _userController.clearFormData();
    _userController.isShowLogin.value = false;
    _userController.currentCarouselSliderPosition.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (_userController.isShowLogin.value) {
          _userController.isShowLogin.value = false;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: GetX<UserController>(builder: (cont) {
          return Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.logo1,
                width: _size.width * 0.4,
                height: _size.height * 0.2,
                // fit: BoxFit.contai n,
              ),
              SizedBox(height: 50,),
              cont.isShowLogin.value
                  ? LoginScreen()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CarouselSlider(
                          carouselController: controller,
                          items: List.generate(
                            3,
                            (index) => Container(
                              width: MediaQuery.of(context).size.width,
                              child:
                              index == 0 ?
                              Container(
                               margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                // color: Colors.red,
                                child: Column(
                                  children: [
                                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                    Image.asset(AppImage.gps,height: 35,width: 35),
                                    Image.asset(AppImage.speedCar,width: 150,height: 70),
                                  ]),
                                    // Expanded(
                                    //   child: Image.asset(
                                    //     images[index],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 5.h),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Share your trip with your\nfriends and family".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5),
                                          width: 101,
                                          decoration: BoxDecoration(color: Colors.black,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text("Share Statud",style: TextStyle(
                                              color: AppColors.white
                                          )),
                                        )
                                      ],
                                    ),


                                  ],
                                ),
                              )
                                  :index == 1 ?
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(AppImage.siren,width: 45,height: 45,),
                                      Text("Safety on\nevery trip",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Montserrat",
                                      ),textAlign: TextAlign.start) ,
                                      SizedBox(height: 3,),
                                      Text("S.O.S",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                      )) ,
                                      ],
                                    ),
                                    Image.asset(AppImage.halfCar,width: 230,height: 250,)
                                  ],
                                ),
                              ) :
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(AppImage.protect,width: 35,height: 35,),
                                        Text("All our drivers\nare verified",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,fontFamily: "Montserrat",
                                        ),textAlign: TextAlign.start) ,
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Image.asset(AppImage.boy,width: 150,height: 180,),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          options: CarouselOptions(
                            onPageChanged: (int, CarouselPageChangedReason) {
                              _userController
                                  .currentCarouselSliderPosition.value = int;
                            },
                            height: 150.h,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.9,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              3,
                              (index) => _userController
                                          .currentCarouselSliderPosition
                                          .value ==
                                      index
                                  ? _selectedDot()
                                  : _unSelectedDot()),
                        ),
                        SizedBox(height: 70.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: CustomButton(
                              text: "log_in".tr,
                              bgColor: AppColors.primaryColor,
                              textColor: AppColors.white,
                              onTap: () {
                                Get.to(() => LoginScreen());
                                // _showLoginScreen();
                                // cont.isShowLogin.value = true;
                              }),
                        ),
                        SizedBox(height: 40.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: CustomButton(
                            onTap: () {
                              Get.to(() => SignUpScreen());
                            },
                            text: "register".tr,
                            bgColor: AppColors.primaryColor2,
                            textColor: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 20.h)
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }

  Widget _selectedDot() {
    return Container(
      width: 15.w,
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 5.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(5.w),
      ),
    );
  }

  Widget _unSelectedDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 5.w,
      height: 5.w,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(5.w),
      ),
    );
  }

  void _showLoginScreen() {
    showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LoginScreen();
        });
  }

  Future<void> _faceBookLogin() async {
    try {
      AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      // await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      log("messageFacebook    ==>   ${result.message}     ${result.status}");

      switch (result.status) {
        case LoginStatus.success:
          // final AuthCredential? facebookCredential =
          // FacebookAuthProvider.credential(result.accessToken.token);
          // final userCredential =
          //     await _auth.signInWithCredential(facebookCredential);
          // Map<String, String> params = {};
          // params["name"] = "${userCredential.user.displayName}";
          // params["email"] = "${userCredential.user.email}";
          // params["so_id"] = "${userCredential.user.uid}";
          // params["so_platform"] = "FACEBOOK";
          // log("messageFacebook    ==>   ${userCredential.user.email}   ${userCredential.user.displayName}   ${userCredential.user.phoneNumber}  ${userCredential.user.photoURL}  ${userCredential.user.uid}");
          // _socialLogin(params: params);
          _userController.loginWithFacebook(
              accessToken: "${result.accessToken?.token ?? ""}");
          break;

        case LoginStatus.failed:
          Get.snackbar("Alert", result.message!,
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              colorText: Colors.white);
          // _userController.showError(msg: result.message ?? "");
          break;
        case LoginStatus.cancelled:
          Get.snackbar("Alert", result.message!,
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              colorText: Colors.white);
          // _userController.showError(msg: result.message ?? "");
          break;
        default:
          return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: 'example-nonce',
        state: 'example-state',
      );

      log("Apple Login ==>  ${credential.userIdentifier}    ${credential.email}   ${credential.authorizationCode}");
      _userController.loginWithApple(
          socialUniqueId: credential.userIdentifier ?? "");
    } on SignInWithAppleAuthorizationException catch (e) {
      // _userController.showError(msg: "${e.message}");
      Get.snackbar("Alert", e.message,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    } catch (e) {
      // _userController.showError(msg: "$e");
      Get.snackbar("Alert", "$e",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    }
  }

  Future<void> _googleLogin() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    GoogleSignInAccount? _googleSignAccount = await _googleSignIn.signIn();

    if (_googleSignAccount != null) {
      GoogleSignInAuthentication? googleSignInAuthentication =
          await _googleSignAccount.authentication;
      log("GoogleSignInAuthentication   ==>    ${googleSignInAuthentication.accessToken}");
      _userController.loginWithGoogle(
          accessToken: googleSignInAuthentication.accessToken ?? "");
    }
  }
}
