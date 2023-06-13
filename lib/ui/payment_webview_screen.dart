import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/check_request_response_model.dart';
import 'package:arbyuser/ui/dialog/rating_dialog.dart';
import 'package:arbyuser/ui/drawer_srceen/wallet_screen.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:get/get.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  String url;
  bool isWallet;

  PaymentWebViewScreen({required this.url, required this.isWallet});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  final BaseController _baseController = BaseController();
  final UserController userController = Get.find();
  final HomeController homeController = Get.find();
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    print("widget.url===> ${widget.url}");
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _baseController.showLoader();
    });
  }

  Future<void> _showPaymentBackDialog() async {
    return Get.defaultDialog(
        title: "Alert".tr,
        titleStyle: TextStyle(
            fontSize: 17,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("payment_back".tr,textAlign: TextAlign.center,style: TextStyle(
            fontWeight: FontWeight.w500
          )),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              width: 130,
              // margin: EdgeInsets.symmetric(horizontal: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
              child: Text("No".tr,
                  style: TextStyle(
                      fontSize: 14.h,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          InkWell(
            onTap: () async {
              Get.back();
              Get.back();
            },
            child: Container(
              height: 50,
              width: 130,
              // margin: EdgeInsets.symmetric(horizontal: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Text("Yes".tr,
                  style: TextStyle(
                      fontSize: 14.h,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        backgroundColor: AppColors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:
        PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: Container(
            padding: EdgeInsets.only(left: 30.w, right: 20.w),
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 6.r,
                    offset: Offset(0, 3.h)),
              ],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(38.r),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        _showPaymentBackDialog();
                      },
                      child: Image.asset(
                        AppImage.backArrow,
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                      )),
                  Text(
                    "payment".tr,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox()
                ],
              ),
            ),
          )),

        body: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return WebView(
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (s) {
              _baseController.dismissLoader();
            },
            navigationDelegate: (NavigationRequest request) async {
              print("request.url====> ${request.url}");

              if (widget.isWallet) {
                if (request.url.contains("login")) {
                  if (widget.isWallet) {
                    cont.getUserProfileData();
                  }
                  Get.showSnackbar(GetSnackBar(
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    message: "Payment Successfully!",
                    title: "Message",
                  ));
                  widget.isWallet ? Get.back() : Get.back();
                  // do not navigate
                  return NavigationDecision.prevent;
                }
              } else {
                print("andar aavyu");
                print("request.url==>${request.url}");
                if (request.url.contains("success")) {
                  print("andar aavyu 000");

                  // Get.back();
                  Get.back();
                  Get.showSnackbar(GetSnackBar(
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    message: "Payment Successfully!",
                    snackPosition: SnackPosition.TOP,
                    title: "Message",
                  ));
                  homeController.isPaymentSuccess.value = true;
                  // if (homeController.checkRequestResponseModel
                  //     .value.data.first.paid ==
                  //     1) {
                  //   print("enter in");
                  // await  homeController.updateRequest();
                  //   homeController.statusType.value = StatusType.RATING;
                  //   Get.back();
                  //   Get.bottomSheet(RatingDialog(),
                  //       enableDrag: false,
                  //       isDismissible: false,
                  //       isScrollControlled:
                  //       true)
                  //       .then((value) {
                  //     if (Get.isBottomSheetOpen ==
                  //         true) {
                  //       Get.back();
                  //     }
                  //   });
                  // }
                  // do not navigate
                  return NavigationDecision.prevent;
                } else if (request.url.contains("fail")) {
                  widget.isWallet ? Get.back() : Get.back();
                  Get.showSnackbar(GetSnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    message: "Payment Fail!",
                    snackPosition: SnackPosition.TOP,
                    title: "Message",
                  ));
                  // do not navigate
                  return NavigationDecision.prevent;
                }
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (s) {
              print('webUrl ==>  $s');
            },

          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _webViewController?.
  }
}
