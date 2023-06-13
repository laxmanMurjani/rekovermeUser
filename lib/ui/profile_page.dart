import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/ui/drawer_srceen/passbook_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/profile_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/saved_addresses_screen.dart';
import 'package:arbyuser/ui/saved_contacts.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/custom_text_filed.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';

import '../api/api.dart';
import '../controller/base_controller.dart';
import 'dialog/chooseLang.dart';
import 'drawer_srceen/help_screen.dart';
import 'drawer_srceen/invite_friend.dart';
import 'drawer_srceen/setting_screen.dart';
import 'drawer_srceen/wallet_screen.dart';
import 'drawer_srceen/your_trips_Screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    // _userController.clearFormData();
  }

  List _language = ["English", "Hindi"];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      // appBar: CustomAppBar(text: "Profile Page"),
      backgroundColor: Colors.white,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  '${_userController.userData.value.firstName ?? ""} ${_userController.userData.value.lastName ?? ""}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.grey[300],
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('4.8',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primaryColor,
                                      )),
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ProfileScreen());
                            },
                            child: Card(
                                child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                height: 40.w,
                                width: 40.w,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: CustomFadeInImage(
                                  url:
                                      "${ApiUrl.baseImageUrl}${_userController.userData.value.picture ?? ""}",
                                  fit: BoxFit.cover,
                                  placeHolder: AppImage.icUserPlaceholder,
                                ),
                              ),
                            )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => YourTripsScreen(
                                  isUpComingScreenShow: false));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 7, bottom: 7, left: 0, right: 0),
                                  height: 70,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImage.pastRide,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'past_rides'.tr,
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => HelpScreen());
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  height: 70,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImage.help,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'help'.tr,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => WalletScreen());
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  height: 70,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImage.wallet,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'wallet'.tr,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: AppColors.primaryColor,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(SavedAddressesScreen());
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'saved_addresses'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Image.asset(
                      //         AppImage.home,
                      //         width: 35,
                      //         height: 35,
                      //         fit: BoxFit.contain,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(SavedContacts());
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'saved_contacts'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(right: 7.0),
                      //         child: Image.asset(
                      //           AppImage.saveContact,
                      //           width: 20,
                      //           height: 20,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      InkWell(
                        onTap: () {
                          share();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'share'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.share,
                              width: 35,
                              height: 35,
                              fit: BoxFit.contain,
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(() => InviteFriendScreen());
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'invite_friend'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Image.asset(
                      //         AppImage.invite_fre,
                      //         width: 35,
                      //         height: 35,
                      //         fit: BoxFit.contain,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(() => PassbookScreen());
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'invite_friend'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Image.asset(
                      //         AppImage.invite_fre,
                      //         width: 35,
                      //         height: 35,
                      //         fit: BoxFit.contain,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     showDialog(
                      //         context: context,
                      //           title: Text('Choose language'),
                      //           content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      //             GestureDetector(onTap: (){
                      //               _userController.
                      //             },
                      //               child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                      //               color: AppColors.primaryColor),
                      //               child: Padding(padding: EdgeInsets.all(5),child:
                      //                 Text('English'),),),
                      //             ),
                      //             Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                      //                 color: AppColors.primaryColor),
                      //               child: Padding(padding: EdgeInsets.all(5),child:
                      //               Text('Hindi'),),),
                      //             ElevatedButton(onPressed: (){
                      //
                      //             }, child: Text('Hindi'))
                      //           ],),
                      //         )
                      //     );
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Language'.tr,
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColors.primaryColor),
                      //       ),
                      //       Image.asset(
                      //         AppImage.logout,
                      //         width: 35,
                      //         height: 35,
                      //         fit: BoxFit.contain,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ChooseLang());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'choose_language'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.language,
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _showLogoutDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'logout'.tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor),
                            ),
                            Image.asset(
                              AppImage.logout,
                              width: 35,
                              height: 35,
                              fit: BoxFit.contain,
                            )
                          ],
                        ),
                      ),
                      // Row(children: [
                      //   Text('change_language'.tr),
                      // TextButton(onPressed: (){
                      //   _userController.changeLanguage('en', 'US');
                      // }, child: Text('English')),
                      //
                      //   TextButton(onPressed: (){
                      //     _userController.changeLanguage('hi', 'IN');
                      //   }, child: Text('hindi'.tr))
                      // ],),


                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'choose_onew'.tr,
      text: 'hey_User'.tr,
      linkUrl:
          'https://play.google.com/store/apps/details?id=com.recuvame.user',
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
