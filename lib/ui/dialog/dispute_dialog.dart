import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/model/dispute_model.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../model/check_request_response_model.dart';
import '../widget/custom_fade_in_image.dart';

class DisputeDialog extends StatefulWidget {
  int? tripId;

  DisputeDialog({this.tripId = 0});
  @override
  State<DisputeDialog> createState() => _DisputeDialogState();
}

class _DisputeDialogState extends State<DisputeDialog> {
  final HomeController _homeController = Get.find();
  final BaseController _baseController = BaseController();
  DisputeModel? _selectedDispute = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getDisputeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      child: GetX<HomeController>(builder: (cont) {
        TripDataModel _tripData = cont.tripDetails.value;
        if (cont.tripDetails.value.dispute != null) {
          Dispute lostItem = cont.tripDetails.value.dispute!;
          bool isOpen = lostItem.status?.toLowerCase() == "open";
          return Container(
            padding: EdgeInsets.only(top: 5.h),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
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
                          'dispute'.tr,
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
                              "${lostItem.disputeName ?? ""}",
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
                                "admin".tr,
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.h),
            Text(
              "dispute",
              style: TextStyle(
                fontSize: 14.sp,
                // fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 7.h),
            Divider(),
            if (cont.disputeList.isNotEmpty)
              ListView.builder(
                itemBuilder: (context, index) {
                  DisputeModel disputeModel = cont.disputeList[index];
                  return InkWell(
                    onTap: () {
                      _selectedDispute = disputeModel;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 22.w,
                                color: _selectedDispute?.disputeName ==
                                        disputeModel.disputeName
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                  child: Text(
                                "${disputeModel.disputeName ?? ""}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ))
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 1.h,
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: cont.disputeList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              )
            else
              Container(
                height: 285.h,
                alignment: Alignment.center,
                child: Text("something_went_wrong...".tr),
              ),
            Row(
              children: [
                if (cont.disputeList.isNotEmpty) ...[
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      child: CustomButton(
                        text: "submit".tr,
                        onTap: () async {
                          if (_selectedDispute == null) {
                            Get.snackbar("Alert", "please_dispute..".tr,
                                backgroundColor: Colors.redAccent.withOpacity(0.8),
                                colorText: Colors.white);
                            Get.snackbar("Alert", "please_dispute..".tr,
                                backgroundColor: Colors.redAccent.withOpacity(0.8),
                                colorText: Colors.white);
                            // _baseController.showError(
                            //     msg: "please_dispute..".tr);
                            return;
                          }
                          String? msg = await cont.sendDispute(
                            disputeModel: _selectedDispute!,
                          );
                          if (msg != null) {
                            Get.back();
                            _baseController.showSnack(msg: msg);
                            _homeController.getTripDetails(id: widget.tripId);
                          }
                        },
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ] else
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      alignment: Alignment.center,
                      child: Text(
                        "dismiss".tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )),
              ],
            ),
            SizedBox(height: 15.h),
          ],
        );
      }),
    );
  }
}
