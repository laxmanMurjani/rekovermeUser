import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowQrDialog extends StatefulWidget {
  const ShowQrDialog({Key? key}) : super(key: key);

  @override
  State<ShowQrDialog> createState() => _ShowQrDialogState();
}

class _ShowQrDialogState extends State<ShowQrDialog> {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: GetX<UserController>(
                builder: (cont) {
                  if (cont.error.value.errorType == ErrorType.internet) {
                    return NoInternetWidget();
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, right: 10.w, top: 15.h),
                            child: Icon(
                              Icons.close,
                              color: AppColors.primaryColor,
                              size: 35.w,
                            ),
                          ),
                        ),
                      ),
                      CustomFadeInImage(
                        url:
                            "${ApiUrl.BASE_URL}/${_userController.userData.value.qrcodeUrl ?? ""}",
                        width: 200.w,
                        height: 200.w,
                      fit: BoxFit.cover,
                      ),
                      Text(
                        "scan_the_number".tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 15.h,)
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
