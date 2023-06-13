import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/location_response_odel.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/ui/dialog/address_delete_dialog.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List _language = ["English", "Dutch"];
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "setting".tr),
      body: GetX<UserController>(
        builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          Home? _homeAddress;
          Home? _workAddress;

          if (cont.locationResponseModel.value.home.isNotEmpty) {
            _homeAddress = cont.locationResponseModel.value.home[0];
          }
          if (cont.locationResponseModel.value.work.isNotEmpty) {
            _workAddress = cont.locationResponseModel.value.work[0];
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 25.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      AppBoxShadow.defaultShadow(),
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "favorites".tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            AppImage.icHome,
                            height: 15.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "home".tr,
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              if (_homeAddress == null) {
                                await Get.to(
                                  () => LocationScreen(
                                    isSelectHomeAddress: true,
                                  ),
                                );
                              } else {
                                await _showAddressDeleteDialog(
                                    addressId: _homeAddress.id);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Center(
                                child: Text(
                                  _homeAddress == null ? "ADD" : "DELETE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (_homeAddress != null)
                        Text(
                          "${_homeAddress.address ?? ""}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      // SizedBox(height: 5.h),
                      Divider(
                        thickness: 2,
                      ),
                      // SizedBox(height: 5.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            AppImage.icWork,
                            height: 15.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "work".tr,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if (_workAddress == null) {
                                await Get.to(
                                  () => LocationScreen(
                                    isSelectHomeAddress: false,
                                  ),
                                );
                              } else {
                                await _showAddressDeleteDialog(
                                    addressId: _workAddress.id);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Center(
                                child: Text(
                                  _workAddress == null ? "add".tr : "delete".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (_workAddress != null)
                        Text(
                          "${_workAddress.address ?? ""}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      AppBoxShadow.defaultShadow(),
                    ],
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "choose_language".tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // SizedBox(height: 7.h),
                      Divider(
                        thickness: 2,
                      ),
                      Column(
                        children: List.generate(
                            _language.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    cont.selectedLanguage.value = index;
                                    if (_language[index] == "English") {
                                      cont.selectedLanguage.value = index;

                                      cont.setLanguage();
                                    } else if (_language[index] == "Dutch") {
                                      cont.selectedLanguage.value = index;

                                      Get.updateLocale(Locale('nl', 'NL'));
                                      cont.setLanguage();
                                    } else if (_language[index] == "Hindi") {
                                      cont.selectedLanguage.value = index;

                                      Get.updateLocale(Locale('hi', 'IN'));
                                      cont.setLanguage();
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 7.h),
                                      Row(
                                        children: [
                                          Container(
                                            height: 15.w,
                                            width: 15.w,
                                            decoration: BoxDecoration(
                                              // color: _selected == index
                                              //     ? AppColors.primaryColor
                                              //     : Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2.w),
                                            ),
                                            child: cont.selectedLanguage
                                                        .value ==
                                                    index
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.w),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            _language[index],
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 12.sp),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 7),
                                      if (index != _language.length - 1)
                                        Divider(
                                          thickness: 2.h,
                                        )
                                    ],
                                  ),
                                )),
                      ),
                      SizedBox(height: 10.h)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddressDeleteDialog({int? addressId}) async {
    await Get.dialog(
      AddressDeleteDialog(
        addressId: addressId,
        deleteButton: () async {
          await _userController.deleteLocation(id: "${addressId ?? 0}");
          await _userController.getLocation();
        },
      ),
    );
  }
}
