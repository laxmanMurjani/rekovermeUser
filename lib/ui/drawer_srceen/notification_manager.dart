import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/model/notification_manager_model.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class NotificationManagerScreen extends StatefulWidget {
  const NotificationManagerScreen({Key? key}) : super(key: key);

  @override
  _NotificationManagerScreenState createState() =>
      _NotificationManagerScreenState();
}

class _NotificationManagerScreenState extends State<NotificationManagerScreen> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getNotificationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        appBar: CustomAppBar(
          text: "notification_manager".tr,
        ),
        body: GetX<UserController>(builder: (cont) {
          if (cont.notificationManagerList.isEmpty) {
            return Center(
              child: Text(
                "you_any_notification".tr,
                style: TextStyle(color: AppColors.primaryColor, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              NotificationManagerModel _notificationModel =
                  cont.notificationManagerList[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "${_notificationModel.notifyType ?? ""}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: Color(0xffD1D1D1),
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                border: Border.all(
                                    color: Colors.grey, width: 1.2.w)),
                            child: Container(
                              width: 50.w,
                              height: 50.w,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CustomFadeInImage(
                                url: _notificationModel.image ?? "",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              "${_notificationModel.description ?? ""}",
                              style: TextStyle(
                                color: AppColors.primaryColor.withOpacity(0.7),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: cont.notificationManagerList.length,
          );
        }));
  }
}
