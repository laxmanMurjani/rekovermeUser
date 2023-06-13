import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../controller/user_controller.dart';
import '../../util/app_constant.dart';
import '../widget/cutom_appbar.dart';

class ChooseLang extends StatefulWidget {
  const ChooseLang({Key? key}) : super(key: key);

  @override
  State<ChooseLang> createState() => _ChooseLangState();
}

class _ChooseLangState extends State<ChooseLang> {
  List _language = ["English", "Hindi"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "choose_language".tr,
      ),
      body: GetX<UserController>(builder: (cont){
        return
    Padding(padding: EdgeInsets.only(top: 10),child:
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
            'choose_language'.tr,
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
                    1,
                // _language.length,
                    (index) => GestureDetector(
                  onTap: () {
                    cont.selectedLanguage.value = index;
                    if (_language[index] == "English") {
                      cont.selectedLanguage.value = index;

                      cont.setLanguage();
                    } else if (_language[index] == "Hindi") {
                      cont.selectedLanguage.value = index;

                      Get.updateLocale(Locale('hi', 'IN'));
                      cont.setLanguage();
                    }
                    // else if (_language[index] == "Hindi") {
                    //   cont.selectedLanguage.value = index;
                    //
                    //   Get.updateLocale(Locale('hi', 'IN'));
                    //   cont.setLanguage();
                    // }
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
    ),);
    },
    ));
  }
}
