import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/model/wallet_transaction_model.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class PassbookScreen extends StatefulWidget {
  @override
  _PassbookScreenState createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getWalletTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "passbook".tr,
      ),
      body: GetX<UserController>(
        builder: (cont) {
          if (cont.walletTransationModel.value.walletTransation.isEmpty) {
            return Center(
              child: Text(
                "no_wallet_history".tr,
                style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              WalletTransation walletTransation =
                  cont.walletTransationModel.value.walletTransation[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ],
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${walletTransation.transactionAlias ?? ""}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          // color: AppColors.primaryColor
                        ),
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
                                  "${walletTransation.amount ?? ""} ${cont.userData.value.currency ?? ""}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
                                  color: AppColors.primaryColor,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: cont.walletTransationModel.value.walletTransation.length,
          );
        },
      ),
    );
  }
}
