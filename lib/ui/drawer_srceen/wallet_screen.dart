import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/payment_webview_screen.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/wallet_transaction_model.dart';
import '../../util/app_constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';


import '../../util/app_constant.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final UserController _userController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy KK:mm a");
  final TextEditingController _addMoneyTextController = TextEditingController();

  List amount = [
    "10",
    "30",
    "50",
  ];
  final BaseController _baseController = BaseController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _homeController.getServices();
      await _userController.getWalletCreditPointsData();
      await _userController.getWalletTransaction();
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _userController.getWalletTransaction();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          text: "wallet".tr,
        ),
        body: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
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
                            "your_wallet_amount".tr,
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
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(AppImage.walletCard,
                                  width: 110, height: 110),
                              Container(
                                margin: EdgeInsets.only(right: 45),
                                child: Text(
                                  '${_userController.userData.value.currency} ${cont.userData.value.walletBalance ?? "0"}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SizedBox(
                            height: 60,
                            child: TextField(
                              controller: _addMoneyTextController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(55))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(55))),
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          _userController
                                              .userData.value.currency!,
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                  hintText: "0",
                                  hintStyle: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500)),
                              onChanged: (s) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            double amount = 0;
                            if (_addMoneyTextController.text.isEmpty) {
                              Get.snackbar("Alert", "please_enter_amount".tr,
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  colorText: Colors.white);

                              return;
                            }
                            try {
                              amount = double.parse(
                                  _addMoneyTextController.text);
                            } catch (e) {
                              amount = 0;
                            }
                            if (amount < 1) {
                              Get.snackbar("Alert", "Please_enter_more_when_amount".tr,
                                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                                  colorText: Colors.white);
                              // _baseController.showError(
                              //     msg: "Please_enter_more_when_amount".tr);
                              return;
                            }
                            _baseController.removeUnFocusManager();
                            // Get.to(() => PaymentScreen(isAddWalletMoney: true,));
                            // cont.walletAddMoney(money: _addMoneyTextController.text);
                            print(
                                "uuuurrrr===> ${ApiUrl.BASE_URL}/razorpay_payment_add_money?name=${_userController.userData.value.firstName}&amount=${_addMoneyTextController.text}&user_type=user&user_id=${_userController.userData.value.id}");
                            Get.to(
                              () => PaymentWebViewScreen(
                                  isWallet: true,
                                  url:
                                      "${ApiUrl.BASE_URL}/razorpay_payment_add_money?name=${_userController.userData.value.firstName}&amount=${_addMoneyTextController.text}&user_type=user&user_id=${_userController.userData.value.id}"),
                            );
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
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                AppBoxShadow.defaultShadow(),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "add_amount".tr,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Container(
                  //   margin:
                  //       EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height * 0.26.h,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       AppBoxShadow.defaultShadow(),
                  //     ],
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20.r),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         width: double.infinity,
                  //         height: 45,
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           color: AppColors.skyBlue,
                  //           borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(15),
                  //             topRight: Radius.circular(15),
                  //           ),
                  //         ),
                  //         child: Text(
                  //           "eto_credit_balance".tr,
                  //           style: TextStyle(
                  //             color: AppColors.primary,
                  //             fontSize: 16.sp,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: 15.w, vertical: 7.h),
                  //         child: Row(
                  //           mainAxisAlignment:
                  //               MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Image.asset(AppImage.carTexi,
                  //                 width: 110, height: 110),
                  //             Container(
                  //               margin: EdgeInsets.only(right: 45),
                  //               child: Text(
                  //                 '${_userController.userData.value.currency} ${cont.userData.value.creditPoints ?? "0"}',
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontFamily: 'Ubuntu',
                  //                     fontSize: 28.sp,
                  //                     fontWeight: FontWeight.w500),
                  //               ),
                  //               alignment: Alignment.center,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Text(
                  //         "500 Arby points = 100 Rupees in your wallet.",
                  //         style: TextStyle(
                  //           color: AppColors.primaryColor,
                  //           fontSize: 13.sp,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       Text(
                  //         "Ride more with Arby to earn more points.",
                  //         style: TextStyle(
                  //           color: AppColors.primaryColor,
                  //           fontSize: 13.sp,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       // InkWell(
                  //       //   onTap: () {},
                  //       //   child: Container(
                  //       //     width: double.infinity,
                  //       //     height: 55,
                  //       //     padding: EdgeInsets.symmetric(
                  //       //         horizontal: 15.w, vertical: 7.h),
                  //       //     margin: EdgeInsets.symmetric(
                  //       //         horizontal: 30.w, vertical: 15),
                  //       //     decoration: BoxDecoration(
                  //       //       color: AppColors.primaryColor,
                  //       //       borderRadius: BorderRadius.circular(15.r),
                  //       //       boxShadow: [
                  //       //         AppBoxShadow.defaultShadow(),
                  //       //       ],
                  //       //     ),
                  //       //     alignment: Alignment.center,
                  //       //     child: Text(
                  //       //       "Redeem",
                  //       //       style: TextStyle(
                  //       //         color: AppColors.white,
                  //       //         fontSize: 17.sp,
                  //       //         fontWeight: FontWeight.w500,
                  //       //       ),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  cont.walletTransationModel.value.walletTransation.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "no_wallet_history".tr,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          itemBuilder: (context, index) {
                            WalletTransation walletTransation = cont
                                .walletTransationModel
                                .value
                                .walletTransation[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 15.w),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  AppBoxShadow.defaultShadow(),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  // color: ((walletTransation.amount??0) <0 ? Colors.red:Colors.green).withOpacity(0.15),
                                  color: Colors.white,
                                  // border: Border(
                                  //   right: BorderSide(
                                  //     color: (walletTransation.amount??0) <0 ? Colors.red:Colors.green,
                                  //     width: 5.w,
                                  //   ),
                                  // ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "${walletTransation.transactionAlias ?? ""}",
                                    //   style: TextStyle(
                                    //     fontSize: 16.sp,
                                    //     fontWeight: FontWeight.w500,
                                    //     // color: AppColors.primaryColor
                                    //   ),
                                    // ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${walletTransation.transactionAlias ?? ""}",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                // color: AppColors.primaryColor
                                              ),
                                            ),
                                            Text(
                                              "${_dateFormat.format(walletTransation.createdAt!)}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                // color: AppColors.primaryColor
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(

                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "amount".tr,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${walletTransation.amount!.toStringAsFixed(2) ?? ""} ${cont.userData.value.currency ?? ""}",
                                                    style: TextStyle(
                                                      color:
                                                      AppColors.primaryColor,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: Row(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Column(
                                    //         children: [
                                    //           Text(
                                    //             "amount".tr,
                                    //             style: TextStyle(
                                    //               color: Colors.grey,
                                    //               fontWeight:
                                    //                   FontWeight.w500,
                                    //               fontSize: 16.sp,
                                    //             ),
                                    //           ),
                                    //           Text(
                                    //             "${walletTransation.amount ?? ""} ${cont.userData.value.currency ?? ""}",
                                    //             style: TextStyle(
                                    //               color: AppColors
                                    //                   .primaryColor,
                                    //               fontWeight:
                                    //                   FontWeight.w800,
                                    //               fontSize: 18.sp,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    RichText(
                                      text: TextSpan(
                                        text: "balance".tr,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${walletTransation.closeBalance ?? ""} ${cont.userData.value.currency ?? ""}",
                                              style: TextStyle(
                                                color:
                                                    AppColors.primaryColor,
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: cont.walletTransationModel.value
                              .walletTransation.length,
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
