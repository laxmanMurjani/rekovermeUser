import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  bool isAddWalletMoney;
  dynamic currentUserId;

  PaymentScreen({this.isAddWalletMoney = false, this.currentUserId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  dynamic argumentData = Get.arguments;
  dynamic invoiceArgument = Get.arguments;
  double? walletAmount;
  int? invoiceAmount;
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    if (widget.isAddWalletMoney) {
      setState(() {
        walletAmount = double.parse(argumentData[0]);
      });
    } else {
      setState(() {
        invoiceAmount = int.parse(invoiceArgument[0].toString());
      });
    }

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _userController.getCardList();
    // });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // });
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   Get.snackbar("Payment", "SUCCESS: " + response.paymentId!,
  //       backgroundColor: Colors.green);
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Get.snackbar("Payment Fail",
  //       "ERROR: " + response.code.toString() + " - " + response.message!,
  //       backgroundColor: Colors.redAccent);
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Get.snackbar("External Wallet", "EXTERNAL_WALLET: " + response.walletName!,
  //       backgroundColor: Colors.green);
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _razorpay.clear();
  //   super.dispose();
  // }

  // void openCheckout(amount) async {
  //   var options = {
  //     'key': 'rzp_live_ILgsfZCZoFIKMb',
  //     'amount': amount,
  //     'name': 'Acme Corp.',
  //     'description': 'Fine T-Shirt',
  //     'retry': {'enabled': true, 'max_count': 1},
  //     'send_sms_hash': true,
  //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          text: "payment".tr,
        ),
        body: GetX<HomeController>(builder: (homeCont) {
          if (homeCont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          TripDataModel tripDataModel = homeCont.tripDetails.value;
          return GetX<UserController>(builder: (cont) {
            if (cont.error.value.errorType == ErrorType.internet) {
              return NoInternetWidget();
            }
            return Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        AppBoxShadow.defaultShadow(),
                      ],                      borderRadius: BorderRadius.circular(10.r)),
                  child: Column(
                    children: [
                      Text(
                        "payment_options".tr,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      if (!widget.isAddWalletMoney) ...[
                        InkWell(
                          onTap: () {
                            print("tripDataModel===> ${tripDataModel.id}");
                            Map<String, String> result = {};
                            result["payment_mode"] = "CASH";
                            _homeController.paymentModeChangeRequest("cash");
                            Get.back(result: result);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                AppImage.wallet_icon,
                                height: 30.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "by_cash".tr,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 12.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                      InkWell(
                        onTap: () {
                          print("tripDataModel===> ${tripDataModel.id}");
                          Map<String, String> result = {};
                          result["payment_mode"] = "ONLINE";
                          _homeController.paymentModeChangeRequest("online");
                          Get.back(result: result);
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 15.w),
                            Icon(
                              Icons.payment,
                              size: 30.w,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "online".tr,
                              style: TextStyle(
                                  color: AppColors.primaryColor, fontSize: 12.sp),
                            ),

                          ],
                        ),
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                      //     Datum datum = cont.cardList[index];
                      //     return InkWell(
                      //       onTap: () {
                      //         Map<String, String> result = {};
                      //         result["payment_mode"] = "CARD";
                      //         result["card_id"] = "${datum.id ?? ""}";
                      //         Get.back(result: result);
                      //       },
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(vertical: 5.h),
                      //         child: Row(
                      //           children: [
                      //             detectCardType(
                      //               cardNumber: datum.card?.last4 ?? "",
                      //             ),
                      //             SizedBox(width: 10.w),
                      //             Expanded(
                      //               child: Text(
                      //                 "xxxx-xxxx-xxxx-${datum.card?.last4 ?? ""}",
                      //                 style: TextStyle(
                      //                   fontSize: 12.sp,
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   itemCount: cont.cardList.length,
                      // ),
                      // Divider(
                      //   thickness: 2,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Map<String, String> result = {};
                      //     result["payment_mode"] = "PAYPAL";
                      //     Get.back(result: result);
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         AppImage.wallet_icon,
                      //         height: 30.w,
                      //       ),
                      //       SizedBox(width: 3.w),
                      //       Text(
                      //         "payStack".tr,
                      //         style: TextStyle(
                      //           color: AppColors.primaryColor,
                      //           fontSize: 12.sp,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            );
          });
        }),
      ),
    );
  }
}
