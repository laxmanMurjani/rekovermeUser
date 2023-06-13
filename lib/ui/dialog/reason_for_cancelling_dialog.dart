import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/check_request_response_model.dart';

class ReasonForCancelling extends StatefulWidget {
  String? cancelId;

  ReasonForCancelling({this.cancelId});

  @override
  State<ReasonForCancelling> createState() => _ReasonForCancellingState();
}

class _ReasonForCancellingState extends State<ReasonForCancelling> {
  final HomeController _homeController = Get.find();
  final BaseController _baseController = BaseController();
  Reason? _selectedReason = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_homeController.checkRequestResponseModel.value.data.isEmpty) {
        await _homeController.getReasonList();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      child: GetX<HomeController>(builder: (cont) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.h),
            Text(
              "reason_for_canceling".tr,
              style: TextStyle(
                fontSize: 14.sp,
                // fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 7.h),
            Divider(),
            if (cont.reasonList.isNotEmpty)
              ListView.builder(
                itemBuilder: (context, index) {
                  Reason reason = cont.reasonList[index];
                  return InkWell(
                    onTap: () {
                      _selectedReason = reason;
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
                                color: _selectedReason?.id == reason.id
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                  child: Text(
                                "${reason.reason ?? ""}",
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
                itemCount: cont.reasonList.length,
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
                          fontWeight: FontWeight.w500, fontSize: 12.sp),
                    ),
                  ),
                )),
                if (cont.reasonList.isNotEmpty) ...[
                  Container(
                    height: 25.h,
                    width: 1.w,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String? msg = await cont.cancelRequest(
                            reason: _selectedReason, cancelId: widget.cancelId);
                        if (msg != null) {
                          Get.back();
                          if (widget.cancelId == null)
                            _baseController.showSnack(msg: msg);
                        }
                        setState(() {
                          isDriverShow = true;
                        });
                        await _homeController.getDriverMarkerData(
                            updateData: () => setState(() {}));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        alignment: Alignment.center,
                        child: Text(
                          "submit".tr,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 15.h),
          ],
        );
      }),
    );
  }
}
