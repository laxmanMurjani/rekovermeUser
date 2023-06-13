import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/check_request_response_model.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/ui/dialog/rating_dialog.dart';
import 'package:arbyuser/ui/drawer_srceen/payment_screen.dart';
import 'package:arbyuser/ui/payment_webview_screen.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class InvoiceDialog extends StatefulWidget {
  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  final BaseController _baseController = BaseController();
  final HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // homeController.paymentModeRequestForInvoice();
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.r),
                ),
              ),
              child: GetX<UserController>(builder: (userCont) {
                if (userCont.error.value.errorType == ErrorType.internet) {
                  return NoInternetWidget();
                }
                return GetX<HomeController>(builder: (cont) {
                  if (cont.error.value.errorType == ErrorType.internet) {
                    return NoInternetWidget();
                  }
                  if (cont.checkRequestResponseModel.value.data.isEmpty) {
                    return Container(
                      height: 300.h,
                      alignment: Alignment.center,
                      child: Text("no_data_found..".tr),
                    );
                  }

                  Datum datum = cont.checkRequestResponseModel.value.data[0];
                  Payment payment = datum.payment ?? Payment();

                  double paid = 0;
                  try {
                    paid = double.parse(datum.paid.toString());
                  } catch (e) {
                    paid = 0;
                  }

                  double payable = 0;
                  try {
                    payable = double.parse(payment.payable.toString());
                  } catch (e) {
                    payable = 0;
                  }

                  double travelTime = 0;
                  try {
                    travelTime = double.parse(datum.travelTime.toString());
                  } catch (e) {
                    travelTime = 0;
                  }

                  double fixed = 0;
                  try {
                    fixed = double.parse(payment.fixed.toString());
                  } catch (e) {
                    fixed = 0;
                  }

                  double timeFare = 0;
                  try {
                    timeFare = double.parse(payment.minute.toString());
                  } catch (e) {
                    timeFare = 0;
                  }

                  double distanceFare = 0;
                  try {
                    distanceFare = double.parse(payment.distance.toString());
                  } catch (e) {
                    distanceFare = 0;
                  }

                  double tax = 0;
                  try {
                    tax = double.parse(payment.tax.toString());
                  } catch (e) {
                    tax = 0;
                  }

                  double waitingAmount = 0;
                  try {
                    waitingAmount =
                        double.parse(payment.waitingAmount.toString());
                  } catch (e) {
                    waitingAmount = 0;
                  }

                  double tollCharges = 0;
                  try {
                    tollCharges = double.parse(payment.tollCharge.toString());
                  } catch (e) {
                    tollCharges = 0;
                  }

                  double walletDetection = 0;
                  try {
                    walletDetection = double.parse(payment.wallet.toString());
                  } catch (e) {
                    walletDetection = 0;
                  }

                  double roundOff = 0;
                  try {
                    roundOff = double.parse(payment.roundOf.toString());
                  } catch (e) {
                    roundOff = 0;
                  }

                  double discount = 0;
                  try {
                    discount = double.parse(payment.discount.toString());
                  } catch (e) {
                    discount = 0;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          "invoice".tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Image.asset(
                        //   AppImage.icInvoice,
                        //   height: 80.h,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(
                            decoration: BoxDecoration(
                            color: AppColors.gray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(35)
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                _invoiceRow(
                                    label: "booking_id".tr,
                                    value: "${datum.bookingId ?? ""}"),
                                // _invoiceRow(
                                //     label: "Distance Travelled",
                                //     value: "${datum.bookingId ?? ""}"),
                                if (travelTime > 0)
                                  _invoiceRow(
                                      label: "time-Taken".tr,
                                      value: "${travelTime} Min(s)"),
                                if (fixed > 0)
                                  _invoiceRow(
                                      label: "base_fare".tr,
                                      value:
                                          "${fixed} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (timeFare > 0)
                                  _invoiceRow(
                                      label: "time_fare".tr,
                                      value:
                                          "${timeFare} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (payment.distance != 0)
                                  _invoiceRow(
                                    label: "distance_fare".tr,
                                    value:
                                        "${payment.distance ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
                                  ),

                                // _invoiceRow(
                                //     label: "Tax",
                                //     value: "${datum.bookingId ?? ""}"),
                                if (waitingAmount > 0)
                                  _invoiceRow(
                                      label: "waiting_amount".tr,
                                      value:
                                          "${waitingAmount} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (tollCharges > 0)
                                  _invoiceRow(
                                      label: "toll_charges".tr,
                                      value:
                                          "${payment.tollCharge ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                Visibility(
                                  visible: false,
                                  child: Row(
                                    children: [
                                      Text(
                                        "tips".tr,
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Text(
                                        "${payment.total ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 3.h),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: Text(
                                          "add_tip".tr,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _invoiceRow(
                                    label: "total".tr,
                                    labelStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      // fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                    value:
                                  "${payment.total ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
                                    valueStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    )),
                              ],
                            ),
                          ),
                        ),

                        if (payable > 0 ||
                            walletDetection > 0 ||
                            roundOff > 0 ||
                            discount > 0) ...[
                          // Divider(
                          //   color: Colors.grey,
                          //   indent: 30,
                          //   endIndent: 30,
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Column(
                              children: [
                                if (walletDetection > 0)
                                  _invoiceRow(
                                      label: "wallet_detection".tr,
                                      value:
                                          "${walletDetection} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (roundOff > 0)
                                  _invoiceRow(
                                      label: "round_off".tr,
                                      value:
                                          "${roundOff} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (discount > 0)
                                  _invoiceRow(
                                      label: "discount".tr,
                                      value:
                                          "${discount} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
                                if (payable > 0)
                                  _invoiceRow(
                                      label: "payable".tr,
                                      labelStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                      value:
                                          "${payment.payable ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
                                      valueStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      )),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 10,),
                        // Padding(
                        //   padding:  EdgeInsets.symmetric(horizontal: 15.0),
                        //   child: Text(
                        //     "You_are_now_riding_for_a_good_causes".tr,
                        //     style: TextStyle(
                        //       color: AppColors.primaryColor,
                        //       fontSize: 14.sp,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        // ),

                        // if (paid == 0) ...[
                        //   SizedBox(height: 10,),
                        //   // Divider(
                        //   //   color: Colors.grey,
                        //   //   indent: 30,
                        //   //   endIndent: 30,
                        //   // ),
                        //   InkWell(
                        //     onTap: () {
                        //       Get.to(
                        //               () => PaymentScreen(
                        //                     isAddWalletMoney: false,
                        //                     currentUserId: cont
                        //                         .checkRequestResponseModel
                        //                         .value
                        //                         .data
                        //                         .first
                        //                         .id,
                        //                   ),
                        //               arguments: [
                        //                 int.parse(payment.payable.toString())
                        //               ],
                        //               preventDuplicates: false)
                        //           ?.then((value) {
                        //
                        //         if (value != null) {
                        //           if (value is Map) {
                        //             print("value ==>  $value");
                        //             // cont.paymentModeMap.clear();
                        //             // cont.paymentModeMap.value = value;
                        //             Map<String, dynamic> params = {};
                        //             value.forEach((key, value) {
                        //               params["$key"] = "$value";
                        //             });
                        //             cont.updateRequest();
                        //           }
                        //         }
                        //       });
                        //     },
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 10.w, vertical: 5.h),
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             "payment_:_".tr,
                        //             style: TextStyle(
                        //               // fontWeight: FontWeight.w500,
                        //               fontSize: 13.sp,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${cont.checkRequestResponseModel.value.data.first.selected_payment ?? ""}",
                        //             style: TextStyle(
                        //               color: AppColors.primaryColor,
                        //               // fontWeight: FontWeight.w500,
                        //               fontSize: 13.sp,
                        //             ),
                        //           ),
                        //           Expanded(child: Container()),
                        //           Text(
                        //             "change".tr,
                        //             style: TextStyle(
                        //               color: Color(0xff5B96AF),
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 13.sp,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ],

                        SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap:
                          cont.checkRequestResponseModel.value.data.first.selected_payment ==
                                  "online"
                              ? () {
                            setState(() {
                              isRideLocationUpdateRead = false;
                            });
                            print(
                                "payment.payable===>${payment.payable}");
                            print(
                                "toll_price${ApiUrl.baseImageUrl + "razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"}");
                            Get.to(
                                    () => PaymentWebViewScreen(
                                    isWallet: false,
                                    url:
                                    "${ApiUrl.baseImageUrl}razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"),
                                preventDuplicates: false);
                            if (paid == 1) {
                              print("paidddd");

                              cont.statusType.value =
                                  StatusType.RATING;
                              print("paidddd000");
                              Get.back();
                              Get.bottomSheet(RatingDialog(),
                                  enableDrag: false,
                                  isDismissible: false,
                                  isScrollControlled: true)
                                  .then((value) {
                                print("paidddd0000");
                                if (Get.isBottomSheetOpen ==
                                    true) {
                                  print("paidddd00000");
                                  Get.back();
                                }
                              });
                              //     ?.then((value) {
                              //       print("check payment confirm===>$value");
                              //       // cont.checkRequest();
                              //       print("checkPayed===>${cont.checkRequestResponseModel.value.data.first.paid}");
                              //       Get.back();
                              //       Get.bottomSheet(RatingDialog(),
                              //           enableDrag: false,
                              //           isDismissible: false,
                              //           isScrollControlled:
                              //           true)
                              //           .then((value) {
                              //         if (Get.isBottomSheetOpen ==
                              //             true) {
                              //           Get.back();
                              //         }
                              //       });
                              // }
                              // );
                              return;
                            }

                                  // setState(() {
                                  //   isRideLocationUpdateRead = false;
                                  // });
                                  // print(
                                  //     "payment.payable===>${payment.payable}");
                                  // print(
                                  //     "toll_price${ApiUrl.baseImageUrl + "razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"}");
                                  // Get.to(
                                  //         () => PaymentWebViewScreen(
                                  //             isWallet: false,
                                  //             url:
                                  //                 "${ApiUrl.baseImageUrl}razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"),
                                  //         preventDuplicates: false)
                                  //     ?.then((value) {
                                  //       print("check payment confirm===>$value");
                                  //       cont.checkRequest();
                                  //       print("checkPayed===>${cont.checkRequestResponseModel.value.data.first.paid}");
                                  //       Get.back();
                                  //       Get.bottomSheet(RatingDialog(),
                                  //           enableDrag: false,
                                  //           isDismissible: false,
                                  //           isScrollControlled:
                                  //           true)
                                  //           .then((value) {
                                  //         if (Get.isBottomSheetOpen ==
                                  //             true) {
                                  //           Get.back();
                                  //         }
                                  //       });
                                  // }
                                  // );
                                }
                              : () {
                                  if (paid <= 0) {
                                    Get.snackbar("Alert", "payment_driver".tr,
                                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                                        colorText: Colors.white);
                                    // _baseController.showError(
                                    //     msg: "payment_driver".tr);
                                    return;
                                  }
                                  cont.statusType.value =
                                      StatusType.RATING;
                                  homeController.isPaymentSuccess.value = false;
                                  Get.back();
                                  Get.bottomSheet(RatingDialog(),
                                          enableDrag: false,
                                          isDismissible: false,
                                          isScrollControlled: true)
                                      .then((value) {
                                    if (Get.isBottomSheetOpen ==
                                        true) {
                                      Get.back();
                                    }
                                  });
                                },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius:
                                    BorderRadius.circular(35)),
                            padding:
                                EdgeInsets.symmetric(vertical: 10.h,),
                             width: MediaQuery.of(context).size.width*0.9,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  // cont.paymentModeModel.value
                                  //             .selectedPayment ==
                                  //         "online"
                                  //     ?
                                  // "Pay Now"
                                  //     :
                                  "continue".tr,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  );
                });
              }),
            )
          ],
        ),
      ),
    );

    // return Container(
    //   child: WillPopScope(
    //     onWillPop: () => Future.value(false),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Container(
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.vertical(
    //               top: Radius.circular(30.r),
    //             ),
    //           ),
    //           child: GetX<UserController>(builder: (userCont) {
    //             if (userCont.error.value.errorType == ErrorType.internet) {
    //               return NoInternetWidget();
    //             }
    //             return GetX<HomeController>(builder: (cont) {
    //               if (cont.error.value.errorType == ErrorType.internet) {
    //                 return NoInternetWidget();
    //               }
    //               if (cont.checkRequestResponseModel.value.data.isEmpty) {
    //                 return Container(
    //                   height: 300.h,
    //                   alignment: Alignment.center,
    //                   child: Text("no_data_found..".tr),
    //                 );
    //               }
    //
    //               Datum datum = cont.checkRequestResponseModel.value.data[0];
    //               Payment payment = datum.payment ?? Payment();
    //
    //               double paid = 0;
    //               try {
    //                 paid = double.parse(datum.paid.toString());
    //               } catch (e) {
    //                 paid = 0;
    //               }
    //
    //               double payable = 0;
    //               try {
    //                 payable = double.parse(payment.payable.toString());
    //               } catch (e) {
    //                 payable = 0;
    //               }
    //
    //               double travelTime = 0;
    //               try {
    //                 travelTime = double.parse(datum.travelTime.toString());
    //               } catch (e) {
    //                 travelTime = 0;
    //               }
    //
    //               double fixed = 0;
    //               try {
    //                 fixed = double.parse(payment.fixed.toString());
    //               } catch (e) {
    //                 fixed = 0;
    //               }
    //
    //               double timeFare = 0;
    //               try {
    //                 timeFare = double.parse(payment.minute.toString());
    //               } catch (e) {
    //                 timeFare = 0;
    //               }
    //
    //               double distanceFare = 0;
    //               try {
    //                 distanceFare = double.parse(payment.distance.toString());
    //               } catch (e) {
    //                 distanceFare = 0;
    //               }
    //
    //               double tax = 0;
    //               try {
    //                 tax = double.parse(payment.tax.toString());
    //               } catch (e) {
    //                 tax = 0;
    //               }
    //
    //               double waitingAmount = 0;
    //               try {
    //                 waitingAmount =
    //                     double.parse(payment.waitingAmount.toString());
    //               } catch (e) {
    //                 waitingAmount = 0;
    //               }
    //
    //               double tollCharges = 0;
    //               try {
    //                 tollCharges = double.parse(payment.tollCharge.toString());
    //               } catch (e) {
    //                 tollCharges = 0;
    //               }
    //
    //               double walletDetection = 0;
    //               try {
    //                 walletDetection = double.parse(payment.wallet.toString());
    //               } catch (e) {
    //                 walletDetection = 0;
    //               }
    //
    //               double roundOff = 0;
    //               try {
    //                 roundOff = double.parse(payment.roundOf.toString());
    //               } catch (e) {
    //                 roundOff = 0;
    //               }
    //
    //               double discount = 0;
    //               try {
    //                 discount = double.parse(payment.discount.toString());
    //               } catch (e) {
    //                 discount = 0;
    //               }
    //
    //               return SingleChildScrollView(
    //                 child: Column(
    //                   children: [
    //                     // TextButton(onPressed: () {
    //                     //   print("payment.payable===>====>${payment.payable}");
    //                     // }, child: Text("datadd")),
    //                     SizedBox(height: 10.h),
    //                     Text(
    //                       "invoice".tr,
    //                       style: TextStyle(
    //                         color: AppColors.primaryColor,
    //                         fontSize: 16.sp,
    //                         fontWeight: FontWeight.w500,
    //                       ),
    //                     ),
    //                     SizedBox(height: 10.h),
    //                     // Image.asset(
    //                     //   AppImage.icInvoice,
    //                     //   height: 80.h,
    //                     // ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(horizontal: 10.w),
    //                       child: Column(
    //                         children: [
    //                           _invoiceRow(
    //                               label: "booking_id".tr,
    //                               value: "${datum.bookingId ?? ""}"),
    //                           // _invoiceRow(
    //                           //     label: "Distance Travelled",
    //                           //     value: "${datum.bookingId ?? ""}"),
    //                           if (travelTime > 0)
    //                             _invoiceRow(
    //                                 label: "time-Taken".tr,
    //                                 value: "${travelTime} Min(s)"),
    //                           if (fixed > 0)
    //                             _invoiceRow(
    //                                 label: "base_fare".tr,
    //                                 value:
    //                                     "${fixed} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                           if (timeFare > 0)
    //                             _invoiceRow(
    //                                 label: "time_fare".tr,
    //                                 value:
    //                                     "${timeFare} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                           if (payment.distance != 0)
    //                             _invoiceRow(
    //                               label: "distance_fare".tr,
    //                               value:
    //                                   "${payment.distance ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
    //                             ),
    //
    //                           // _invoiceRow(
    //                           //     label: "Tax",
    //                           //     value: "${datum.bookingId ?? ""}"),
    //                           if (waitingAmount > 0)
    //                             _invoiceRow(
    //                                 label: "waiting_amount".tr,
    //                                 value:
    //                                     "${waitingAmount} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                           if (tollCharges > 0)
    //                             _invoiceRow(
    //                                 label: "toll_charges".tr,
    //                                 value:
    //                                     "${payment.tollCharge ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                           Visibility(
    //                             visible: false,
    //                             child: Row(
    //                               children: [
    //                                 Text(
    //                                   "tips".tr,
    //                                   style: TextStyle(
    //                                     color: AppColors.primaryColor,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 13.sp,
    //                                   ),
    //                                 ),
    //                                 Expanded(child: Container()),
    //                                 Text(
    //                                   "${payment.total ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
    //                                   style: TextStyle(
    //                                     color: AppColors.primaryColor,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 13.sp,
    //                                   ),
    //                                 ),
    //                                 SizedBox(width: 5.w),
    //                                 Container(
    //                                   padding: EdgeInsets.symmetric(
    //                                       horizontal: 10.w, vertical: 3.h),
    //                                   decoration: BoxDecoration(
    //                                       color: AppColors.primaryColor,
    //                                       borderRadius:
    //                                           BorderRadius.circular(5.r)),
    //                                   child: Text(
    //                                     "add_tip".tr,
    //                                     style: TextStyle(color: Colors.white),
    //                                   ),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           _invoiceRow(
    //                               label: "total".tr,
    //                               labelStyle: TextStyle(
    //                                 color: AppColors.primaryColor,
    //                                 // fontWeight: FontWeight.w500,
    //                                 fontSize: 14.sp,
    //                               ),
    //                               value:
    //                                   "${payment.total ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
    //                               valueStyle: TextStyle(
    //                                 color: AppColors.primaryColor,
    //                                 fontWeight: FontWeight.w500,
    //                                 fontSize: 14.sp,
    //                               )),
    //                         ],
    //                       ),
    //                     ),
    //                     if (payable > 0 ||
    //                         walletDetection > 0 ||
    //                         roundOff > 0 ||
    //                         discount > 0) ...[
    //                       Divider(
    //                         color: Colors.grey,
    //                         indent: 30,
    //                         endIndent: 30,
    //                       ),
    //                       Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 10.w),
    //                         child: Column(
    //                           children: [
    //                             if (walletDetection > 0)
    //                               _invoiceRow(
    //                                   label: "wallet_detection".tr,
    //                                   value:
    //                                       "${walletDetection} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                             if (roundOff > 0)
    //                               _invoiceRow(
    //                                   label: "Round Off",
    //                                   value:
    //                                       "${roundOff} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                             if (discount > 0)
    //                               _invoiceRow(
    //                                   label: "discount".tr,
    //                                   value:
    //                                       "${discount} ${cont.checkRequestResponseModel.value.currency ?? ""}"),
    //                             if (payable > 0)
    //                               _invoiceRow(
    //                                   label: "payable".tr,
    //                                   labelStyle: TextStyle(
    //                                     color: AppColors.primaryColor,
    //                                     // fontWeight: FontWeight.w500,
    //                                     fontSize: 14.sp,
    //                                   ),
    //                                   value:
    //                                       "${payment.payable ?? ""} ${cont.checkRequestResponseModel.value.currency ?? ""}",
    //                                   valueStyle: TextStyle(
    //                                     color: AppColors.primaryColor,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14.sp,
    //                                   )),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                     if (paid == 0) ...[
    //                       Divider(
    //                         color: Colors.grey,
    //                         indent: 30,
    //                         endIndent: 30,
    //                       ),
    //                       InkWell(
    //                         onTap: () {
    //
    //                             Get.to(
    //                                     () => PaymentScreen(
    //                                         isAddWalletMoney: false,
    //                                         currentUserId: cont
    //                                             .checkRequestResponseModel
    //                                             .value
    //                                             .data
    //                                             .first
    //                                             .id),
    //                                     arguments: [
    //                                       int.parse(payment.payable.toString())
    //                                     ],
    //                                     preventDuplicates: false)
    //                                 ?.then((value) {
    //                               if (value != null) {
    //                                 if (value is Map) {
    //                                   print("value ==>  $value");
    //                                   // cont.paymentModeMap.clear();
    //                                   // cont.paymentModeMap.value = value;
    //                                   Map<String, dynamic> params = {};
    //                                   value.forEach((key, value) {
    //                                     params["$key"] = "$value";
    //                                   });
    //                                   cont.updateRequest(params: params);
    //                                 }
    //                               }
    //                             });
    //
    //                         },
    //                         child: Padding(
    //                           padding: EdgeInsets.symmetric(
    //                               horizontal: 10.w, vertical: 5.h),
    //                           child: Row(
    //                             children: [
    //                               Text(
    //                                 "payment_:_".tr,
    //                                 style: TextStyle(
    //                                   // fontWeight: FontWeight.w500,
    //                                   fontSize: 13.sp,
    //                                 ),
    //                               ),
    //                               Text(
    //                                 cont.paymentModeModel.value.selectedPayment!.toUpperCase(),
    //                                 style: TextStyle(
    //                                   color: AppColors.primaryColor,
    //                                   // fontWeight: FontWeight.w500,
    //                                   fontSize: 13.sp,
    //                                 ),
    //                               ),
    //                               Expanded(child: Container()),
    //                                Text(
    //                                       "change".tr,
    //                                       style: TextStyle(
    //                                         color: Color(0xff5B96AF),
    //                                         fontWeight: FontWeight.w500,
    //                                         fontSize: 13.sp,
    //                                       ),
    //                                     )
    //
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                     // Divider(),
    //                     // Padding(
    //                     //   padding: EdgeInsets.symmetric(
    //                     //       horizontal: 10.w, vertical: 3.h),
    //                     //   child: Row(
    //                     //     children: [
    //                     //       Expanded(
    //                     //           child: Text(
    //                     //         "**Waiting charge not applicable for this service type",
    //                     //         style: TextStyle(
    //                     //           color: AppColors.primaryColor,
    //                     //           fontWeight: FontWeight.w500,
    //                     //           fontSize: 12.sp,
    //                     //         ),
    //                     //       ))
    //                     //     ],
    //                     //   ),
    //                     // ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //
    //                   cont.paymentModeModel.value.selectedPayment!.contains("cash")  ? SizedBox() :
    //                   Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: 40.w, vertical: 5.h),
    //                       child: Row(
    //                         children: [
    //                           if ((paid == 0 && datum.paymentMode == "CASH") ||
    //                               (paid == 1 && datum.paymentMode == "CASH") ||
    //                               (paid == 1 && datum.paymentMode != "CASH"))
    //                             Expanded(
    //                               child: InkWell(
    //                                 onTap: () {
    //                                   setState(() {
    //                                     isRideLocationUpdateRead = false;
    //                                   });
    //                                   print("payment.payable===>${payment.payable}");
    //                                   print("toll_price${ApiUrl.baseImageUrl + "razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"}");
    //                                   Get.to(
    //                                           () => PaymentWebViewScreen(
    //                                           isWallet: false,
    //                                           url: "${ApiUrl.baseImageUrl}razorpay_online_payment?payment_mood=online&amount=${payment.payable}&user_id=${userCont.userData.value.id}&user_request_id=${cont.checkRequestResponseModel.value.data.first.id}"),
    //                                       preventDuplicates: false)
    //                                       ?.then((value) {
    //                                         if(cont.checkRequestResponseModel.value.data.first.paid == 1)
    //                                           {
    //                                             print("enter in");
    //                                             if (value != null) {
    //                                               if (value is Map) {
    //                                                 print("value ==>  $value");
    //                                                 // cont.paymentModeMap.clear();
    //                                                 // cont.paymentModeMap.value = value;
    //                                                 Map<String, dynamic> params = {};
    //                                                 value.forEach((key, value) {
    //                                                   params["$key"] = "$value";
    //                                                 });
    //                                                 cont.updateRequest(
    //                                                     params: params);
    //                                               }
    //                                             }
    //
    //                                             cont.statusType.value = StatusType.RATING;
    //                                             Get.back();
    //                                             Get.bottomSheet(RatingDialog(),
    //                                                 enableDrag: false,
    //                                                 isDismissible: false,
    //                                                 isScrollControlled: true)
    //                                                 .then((value) {
    //                                               if (Get.isBottomSheetOpen == true) {
    //                                                 Get.back();
    //                                               }
    //                                             });
    //                                           }
    //
    //                                   });
    //                                   // if (radioItem == "Cash") {
    //                                   //   if (paid <= 0) {
    //                                   //     _baseController.showError(
    //                                   //         msg: "payment_driver".tr);
    //                                   //     return;
    //                                   //   }
    //                                   //   cont.statusType.value =
    //                                   //       StatusType.RATING;
    //                                   //   Get.back();
    //                                   //   Get.bottomSheet(RatingDialog(),
    //                                   //           enableDrag: false,
    //                                   //           isDismissible: false,
    //                                   //           isScrollControlled: true)
    //                                   //       .then((value) {
    //                                   //     if (Get.isBottomSheetOpen == true) {
    //                                   //       Get.back();
    //                                   //     }
    //                                   //   });
    //                                   // } else {
    //                                   //
    //                                   // }
    //                                 },
    //                                 child: Container(
    //                                   alignment: Alignment.center,
    //                                   decoration: BoxDecoration(
    //                                       color: AppColors.primaryColor,
    //                                       borderRadius:
    //                                           BorderRadius.circular(20)),
    //                                   padding:
    //                                       EdgeInsets.symmetric(vertical: 13.h),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     children: [
    //                                       Text(
    //                                         "Pay Now",
    //                                         style: TextStyle(
    //                                             fontSize: 18.sp,
    //                                             fontWeight: FontWeight.w500,
    //                                             color: Colors.white),
    //                                       ),
    //                                       SizedBox(
    //                                         width: 15,
    //                                       ),
    //                                       Icon(
    //                                         Icons.arrow_forward_ios_rounded,
    //                                         size: 20,
    //                                         color: Colors.white,
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             )
    //                           // else ...[
    //                           //   Expanded(
    //                           //     child: InkWell(
    //                           //       onTap: () {
    //                           //         if (datum.paymentMode == "PAYPAL") {
    //                           //           Get.to(
    //                           //             () => PaymentWebViewScreen(
    //                           //               url: ApiUrl.payStackUrl(
    //                           //                   email: userCont
    //                           //                           .userData.value.email ??
    //                           //                       "",
    //                           //                   userId: userCont
    //                           //                           .userData.value.id ??
    //                           //                       "",
    //                           //                   amount:
    //                           //                       "${datum.payment?.payable ?? "0"}",
    //                           //                   requestId:
    //                           //                       "${datum.id ?? "0"}"),
    //                           //             ),
    //                           //             preventDuplicates: false,
    //                           //           );
    //                           //         } else if (datum.paymentMode == "CARD") {
    //                           //           Map<String, dynamic> params = {};
    //                           //           params["request_id"] =
    //                           //               "${datum.id ?? "0"}";
    //                           //           params["tips"] = "0";
    //                           //           params["payment_type"] = "CARD";
    //                           //           cont.payment(paymentData: params);
    //                           //         }
    //                           //       },
    //                           //       child: Container(
    //                           //         padding:
    //                           //             EdgeInsets.symmetric(vertical: 10.h),
    //                           //         alignment: Alignment.center,
    //                           //         decoration: BoxDecoration(
    //                           //           color: AppColors.primaryColor,
    //                           //           borderRadius:
    //                           //               BorderRadius.circular(30.r),
    //                           //         ),
    //                           //         child: Text(
    //                           //           "pay_now".tr,
    //                           //           style: TextStyle(
    //                           //             fontSize: 14.sp,
    //                           //             color: Colors.white,
    //                           //             fontWeight: FontWeight.w500,
    //                           //           ),
    //                           //         ),
    //                           //       ),
    //                           //     ),
    //                           //   ),
    //                           // ],
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(height: 10.h),
    //                   ],
    //                 ),
    //               );
    //             });
    //           }),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _invoiceRow({
    String label = "",
    TextStyle? labelStyle,
    String value = "",
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle ??
                TextStyle(
                  color: AppColors.primaryColor,
                  // fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
          ),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
          ),
        ],
      ),
    );
  }

  void _doneBtn() {}
}
