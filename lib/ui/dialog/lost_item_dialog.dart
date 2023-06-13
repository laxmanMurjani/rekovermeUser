import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/trip_data_model.dart';

class LostItemDialog extends StatefulWidget {
  const LostItemDialog({Key? key}) : super(key: key);

  @override
  State<LostItemDialog> createState() => _LostItemDialogState();
}

class _LostItemDialogState extends State<LostItemDialog> {
  final TextEditingController _lostItemController = TextEditingController();
  final BaseController _baseController = BaseController();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetX<HomeController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          TripDataModel _tripData = cont.tripDetails.value;
          if (cont.tripDetails.value.lostitem != null) {
            LostItem lostItem = cont.tripDetails.value.lostitem!;
            bool isOpen = lostItem.status?.toLowerCase() == "open";
            return Container(
              padding: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            cont.makePhoneCall(
                                phoneNumber: _tripData.contactNumber ?? "");
                          },
                          child: Icon(
                            Icons.phone,
                            color: AppColors.primaryColor,
                            size: 30.w,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'lost_item'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 30.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Divider(thickness: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CustomFadeInImage(
                            url: "",
                            placeHolder: AppImage.icUserPlaceholder,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "you".tr,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${lostItem.lostItemName ?? ""}",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80.w,
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? AppColors.openBgColor
                                : AppColors.openBgColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text(
                              "${lostItem.status ?? ""}",
                              style: TextStyle(
                                color: isOpen
                                    ? AppColors.openWordColor
                                    : AppColors.openWordColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (lostItem.isAdmin == 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Admin",
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "driver_unprofessional".tr,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CustomFadeInImage(
                              url: "",
                              placeHolder: AppImage.icUserPlaceholder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: _lostItemController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      hintText: "Mention_the_lost_item".tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r))),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () async {
                    if (_lostItemController.text.isEmpty) {
                      Get.snackbar("Alert", "please_details".tr,
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          colorText: Colors.white);
                      // _baseController.showError(msg: "please_details".tr);
                      return;
                    }
                    String? msg = await _homeController.sendDropItem(
                        lostItem: _lostItemController.text);
                    if (msg != null) {
                      Get.back();
                      _baseController.showSnack(msg: msg);
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(35.r),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5),
                        ]),
                    child: Center(
                      child: Text(
                        "submit".tr,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
