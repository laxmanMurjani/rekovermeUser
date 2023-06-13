import 'dart:io';

import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriendScreen extends StatefulWidget {
  @override
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      // appBar: CustomAppBar(
      //   text: "invite_friend".tr,
      // ),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                  height: 230,
                  decoration: BoxDecoration(
                      color: AppColors.skyBlue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(55),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 65,
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.primary,
                                size: 25,
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "together_we are".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "#SPREADTHELOVE",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
                                )),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "refer_now_and_earn".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "referral_code".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    String s =
                                        "Hey Checkout this app, Arby Ride \nUser - https://play.google.com/store/apps/details?id=com.recuvame.user\nProvider - https://play.google.com/store/apps/details?id=com.arby.driver.\nInstall this app with referral code ${cont.userData.value.referralUniqueId ?? ""}";
                                    FlutterShare.share(
                                        title: "choose_one", text: s);
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.skyBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                    child: Text(
                                      cont.userData.value.referralUniqueId! ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "or".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "share_your_link_via".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                facebookLaunch();
                              },
                              child: Image.asset(
                                AppImage.facebook,
                                height: 40,
                                width: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            InkWell(
                              onTap: () {
                                instaLaunch();
                              },
                              child: Image.asset(
                                AppImage.insta,
                                height: 35,
                                width: 35,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            InkWell(
                              onTap: () {
                                print("smdh");
                                String s =
                                    "Hey Checkout this app, Arby Ride User - https://play.google.com/store/apps/details?id=com.recuvame.user Provider - https://play.google.com/store/apps/details?id=com.arby.driver.\nInstall this app with referral code ${cont.userData.value.referralUniqueId ?? ""}";

                                openWhatsapp(
                                    context: context,
                                    message:
                                    s,
                                    number: "");
                              },
                              child: Image.asset(
                                AppImage.whatsapp,
                                height: 40,
                                width: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: 290,
                          // color: Colors.black45,
                          child: Text(
                            "spread the word, And we will reward you".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 290,
                          // color: Colors.black45,
                          child: Text(
                            "get INR 100 in your Arby wallet for every friend you refer".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                                color: AppColors.skyBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
                                )),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Referral Count".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${cont.userData.value.referralTotalCount ?? ""}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Referral Amount".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${cont.userData.value.currency ?? ""}${cont.userData.value.referralTotalAmount ?? "0"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
        // return Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        //   child: Column(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 10.w),
        //         height: 100.h,
        //         width: MediaQuery.of(context).size.width,
        //         decoration: BoxDecoration(
        //           color: Color(0xff2e2929),
        //           borderRadius: BorderRadius.circular(15.r),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Expanded(
        //                 child: Html(
        //                     data: "${cont.userData.value.referralText ?? ""}")),
        //             Image.asset(
        //               AppImage.giftCard,
        //               height: 35.h,
        //             )
        //           ],
        //         ),
        //       ),
        //       SizedBox(height: 15.h),
        //       Stack(
        //         clipBehavior: Clip.none,
        //         children: [
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10.w),
        //             height: 100.h,
        //             width: MediaQuery.of(context).size.width,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 AppBoxShadow.defaultShadow(),
        //               ],
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(15.r),
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 SizedBox(height: 15.h),
        //                 Text(
        //                   "your_referral_code".tr,
        //                   style: TextStyle(
        //                       fontSize: 15, color: AppColors.primaryColor),
        //                 ),
        //                 SizedBox(height: 7.h),
        //                 Container(
        //                   padding: EdgeInsets.symmetric(horizontal: 15),
        //                   height: 35.h,
        //                   width: MediaQuery.of(context).size.width,
        //                   decoration: BoxDecoration(
        //                     color: Colors.grey[200],
        //                     borderRadius: BorderRadius.circular(8.r),
        //                   ),
        //                   child: Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text(
        //                         "${cont.userData.value.referralUniqueId ?? ""}",
        //                         style: TextStyle(
        //                             color: Colors.grey,
        //                             fontSize: 15,
        //                             fontWeight: FontWeight.w500),
        //                       )),
        //                 )
        //               ],
        //             ),
        //           ),
        //           Positioned(
        //             left: MediaQuery.of(context).size.width / 2.5,
        //             bottom: -15.h,
        //             child: InkWell(
        //               onTap: () {
        //                 String s =
        //                     "Hey Checkout this app, Mozlit User \nUser - https://play.google.com/store/apps/details?id=com.mozilitdemo.user\nProvider - https://play.google.com/store/apps/details?id=com.mozilitdemo.partner.\nInstall this app with referral code ${cont.userData.value.referralUniqueId ?? ""}";
        //                 FlutterShare.share(title: "choose_one".tr, text: s);
        //               },
        //               child: CircleAvatar(
        //                 radius: 20.r,
        //                 backgroundColor: Colors.green,
        //                 child: Center(
        //                   child: Image.asset(
        //                     AppImage.next,
        //                     height: 15.h,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 25.h),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        //         width: MediaQuery.of(context).size.width,
        //         decoration: BoxDecoration(
        //           boxShadow: [
        //             AppBoxShadow.defaultShadow(),
        //           ],
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(15.r),
        //         ),
        //         child: Column(
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   "referral_count :".tr,
        //                   style: TextStyle(
        //                       fontSize: 16, color: AppColors.primaryColor),
        //                 ),
        //                 Text(
        //                   "${cont.userData.value.referalCount ?? ""}",
        //                   style: TextStyle(
        //                       fontSize: 15,
        //                       color: Colors.grey,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(height: 2.h),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   "referral_amount:".tr,
        //                   style: TextStyle(
        //                       fontSize: 16, color: AppColors.primaryColor),
        //                 ),
        //                 Text(
        //                   "${cont.userData.value.referralTotalAmount ?? "0"} ${cont.userData.value.currency ?? ""}",
        //                   style: TextStyle(
        //                       fontSize: 15,
        //                       color: Colors.grey,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      }),
    );
  }

  void facebookLaunch() async {
    var url = 'fb://facewebmodal/f?href=https://www.facebook.com/krunalnathani';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void instaLaunch() async {
    var url = 'https://www.instagram.com/krunalnathani';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  static openWhatsapp(
      {context, required String message, required String number}) async {
    var whatsappURl_android = "https://wa.me/$number? &text=${message}";
    var whatappURL_ios = "whatsapp://send?phone=${Uri.parse("${message}")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
}
