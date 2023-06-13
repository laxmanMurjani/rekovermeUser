import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/promocode_list_model.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final UserController _userController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd MMM yyyy");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _userController.getPromoCodeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Offers"),
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Column(
          children: [
            SizedBox(height: 20),
            ListView.builder(
              itemCount: cont.promoCodeList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                PromoList promoCode = cont.promoCodeList[index];
                return Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      AppBoxShadow.defaultShadow(),
                    ],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${promoCode.promoCode ?? ""}",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${promoCode.promoDescription ?? ""}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 15),
                              ),
                              Text(
                                "${"valid_till".tr} ${_dateFormat.format(promoCode.expiration ?? DateTime.now())}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(25.r)),
                            child: Center(
                              child: Text(
                                "use_code".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            )
          ],
        );
      }),
    );
  }
}
