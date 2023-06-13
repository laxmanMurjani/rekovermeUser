import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/help_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/invite_friend.dart';
import 'package:arbyuser/ui/drawer_srceen/notification_manager.dart';
import 'package:arbyuser/ui/drawer_srceen/offer_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/passbook_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/payment_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/profile_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/setting_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/wallet_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/your_trips_Screen.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int Selected = 0;
  final UserController _userController = Get.find();

  List<String> title = [
    'payments'.tr,
    'your_trips'.tr,
    'offer'.tr,
    'wallet'.tr,
    'passbook'.tr,
    'settings'.tr,
    'notification_manger'.tr,
    'help'.tr,
    'share'.tr,
    'Invite Friend'.tr,
    'logout'.tr,
  ];

  Future<void> share() async {
    await FlutterShare.share(
      title: 'choose_onew'.tr,
      text: 'hey_User'.tr,
      linkUrl:
          'https://play.google.com/store/apps/details?id=com.mozilitdemo.user',
    );
  }

  // Future<void> shareFile() async {
  //   List<dynamic> docs = await DocumentsPicker.pickDocuments;
  //   if (docs == null || docs.isEmpty) return null;
  //
  //   await FlutterShare.shareFile(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     filePath: docs[0] as String,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.h,
      decoration: BoxDecoration(
          // color: AppColors.drawer,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(50.r),
          ),
          image: DecorationImage(
              image: AssetImage(
                AppImage.drawer,
              ),
              fit: BoxFit.cover)),
      child: SafeArea(
        top: true,
        bottom: false,
        child: GetX<UserController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return Column(
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      AppImage.icWhiteArrow,
                      width: 30.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              InkWell(
                onTap: () {
                  Get.to(() => ProfileScreen())?.then((value) {
                    Get.back();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 60.w,
                        width: 60.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.h)),
                        child: CustomFadeInImage(
                          url:
                              "${ApiUrl.baseImageUrl}${cont.userData.value.picture ?? ""}",
                          fit: BoxFit.cover,
                          // placeHolderWidget: Center(
                          //   child: Icon(
                          //     Icons.person,
                          //     color: Colors.grey,
                          //     size: 35.w,
                          //   ),
                          // ),
                          placeHolder: AppImage.icUserPlaceholder,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${cont.userData.value.firstName ?? ""} ${cont.userData.value.lastName ?? ""}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "${cont.userData.value.email ?? ""}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.r),
                        bottomRight: Radius.circular(50.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          offset: Offset(0, -5),
                          blurRadius: 16,
                        )
                      ]),
                  child: Column(
                    children: List.generate(
                        title.length,
                        (index) => InkWell(
                              onTap: () {
                                Get.back();
                                index == 10
                                    ? _showLogoutDialog()
                                    : index == 2
                                        ? Get.to(() => OfferScreen())
                                        : index == 9
                                            ? Get.to(() => InviteFriendScreen())
                                            : index == 8
                                                ? share()
                                                : index == 7
                                                    ? Get.to(() => HelpScreen())
                                                    : index == 6
                                                        ? Get.to(() =>
                                                            NotificationManagerScreen())
                                                        : index == 4
                                                            ? Get.to(() =>
                                                                PassbookScreen())
                                                            : index == 3
                                                                ? Get.to(() =>
                                                                    WalletScreen())
                                                                : index == 1
                                                                    ? Get.to(() =>
                                                                        YourTripsScreen(
                                                                            isUpComingScreenShow:
                                                                                false))
                                                                    : index == 5
                                                                        ? Get.to(() =>
                                                                            SettingScreen())
                                                                        : index ==
                                                                                0
                                                                            ? Get.to(() =>
                                                                                PaymentScreen())
                                                                            : Container();
                              },
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.h),
                                      Text(
                                        title[index],
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Get.back();
                _userController.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
