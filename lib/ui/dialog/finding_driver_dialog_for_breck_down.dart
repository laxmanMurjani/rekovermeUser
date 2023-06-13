import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class FindingDriverForBreakDownDialog extends StatefulWidget {
  const FindingDriverForBreakDownDialog({Key? key}) : super(key: key);

  @override
  State<FindingDriverForBreakDownDialog> createState() => FindingDriverForBreakDownDialogState();
}

class FindingDriverForBreakDownDialogState extends State<FindingDriverForBreakDownDialog> {
  final HomeController _homeController = Get.find();
  @override

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0x705C5C5C)),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(0.0)),
            ),
            child: Column(
              children: [
                Divider(
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.32,
                  endIndent: MediaQuery.of(context).size.width * 0.32,
                ),
                SizedBox(height: 15.h),
            ( _homeController.checkRequestResponseModel.value.checkBreakDown_status == "started" ||
                _homeController.checkRequestResponseModel.value.checkBreakDown_status == "notassign") ?   Text(
                  "Sorry_for_the_technical_Beakdown".tr,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ) :   Text(
                  "You_deserve_the_best_Connecting_you_with_the_best_driver".tr,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                ( _homeController.checkRequestResponseModel.value.checkBreakDown_status == "started" ||
                    _homeController.checkRequestResponseModel.value.checkBreakDown_status == "notassign") ? SizedBox() : Container(
                  // margin: EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  height: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      // color: ,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                      // minHeight: 18,
                      // value: 0.75,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ( _homeController.checkRequestResponseModel.value.checkBreakDown_status == "started" ||
                    _homeController.checkRequestResponseModel.value.checkBreakDown_status == "notassign") ?  Image.asset(
                  AppImage.taxi,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ) :  Image.asset(
                  AppImage.taxi,
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // TweenAnimationBuilder<Duration>(
                //     duration: Duration(minutes: 20),
                //     tween:
                //         Tween(begin: Duration(minutes: 20), end: Duration.zero),
                //     onEnd: () {
                //       print('Timer ended');
                //     },
                //     builder:
                //         (BuildContext context, Duration value, Widget? child) {
                //       final minutes = value.inMinutes;
                //       final seconds = value.inSeconds % 60;
                //       return Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 5),
                //           child: Text('Drop off by $minutes:$seconds',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: AppColors.primaryColor,
                //                   // fontWeight: FontWeight.w500,
                //                   fontSize: 14)));
                //     }),
                // Text(
                //   'Drop off by 19:50',
                //   style: TextStyle(
                //     fontSize: 16.sp,
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       isBookForSomeOne = false;
                //     });
                //     Get.bottomSheet(
                //       ReasonForCancelling(),
                //     );
                //   },
                //   child: Container(
                //     margin: EdgeInsets.symmetric(
                //       horizontal: 30.w,
                //     ),
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
                //     decoration: BoxDecoration(
                //         color: AppColors.primaryColor,
                //         borderRadius: BorderRadius.circular(20) // boxShadow: [
                //         //   BoxShadow(
                //         //       color: Colors.grey,
                //         //       blurRadius: 3)
                //         // ],
                //         ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SizedBox(
                //           width: 15,
                //         ),
                //         Text(
                //           "cancel".tr,
                //           style:
                //               TextStyle(color: Colors.white, fontSize: 16.sp),
                //         ),
                //         SizedBox(width: 20),
                //         Card(
                //           color: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(50.0),
                //           ),
                //           child: Icon(
                //             Icons.close,
                //             size: 20,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
