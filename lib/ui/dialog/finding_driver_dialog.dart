import 'dart:async';

import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/ui/bookfor_someone_else.dart';
import 'package:arbyuser/ui/dialog/reason_for_cancelling_dialog.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class FindingDriverDialog extends StatefulWidget {
  const FindingDriverDialog({Key? key}) : super(key: key);

  @override
  State<FindingDriverDialog> createState() => _FindingDriverDialogState();
}

class _FindingDriverDialogState extends State<FindingDriverDialog> {

  final
  HomeController _homeController = Get.find();
  int _counter = 60;
  late Timer _timer;

  void _startTimer() {
    _counter = int.parse(_homeController.checkRequestResponseModel.value.provider_select_timeout?? '60');
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _startTimer();
    super.initState();
  }



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
                SizedBox(height: 10.h),
                // Text("${_counter.toString()} "+"sec".tr,
                //   style:
                //   TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: AppColors.primary),),
                SizedBox(height: 10.h),
                Text(_homeController.isRideSelected.value == true?
                  "You deserve the best, Connecting you with the best driver" :
                  'You deserve the best, Connecting you with the best serviceman',
                  style:
                  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,color: AppColors.primaryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  height: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: LinearProgressIndicator(
                      backgroundColor: Color(0xffD9D9D9),
                      // color: ,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.skyBlue,
                      ),
                      // minHeight: 18,
                      // value: 0.75,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: 80,
                    width: 80,
                    child: Image.asset(
                      AppImage.roadVehicle,
                    )),

                // SizedBox(height: 15.h),
                // Text(
                //   "Search_a_driver_nice".tr,
                //   style:
                //       TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text("${_counter.toString()} "+"seg".tr,
                //   style:
                //   TextStyle(fontSize: 40, fontWeight: FontWeight.w500,color: AppColors.primaryColor2),),
                // SizedBox(
                //   height: 30,
                // ),
                // Image.asset(
                //   AppImage.searchCar,
                //   height: 80,
                //   // width: 120,
                //   fit: BoxFit.cover,
                // ),
                // SizedBox(
                //   height: 30,
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
                SizedBox(
                  height: 10,
                ),
                (_homeController.checkRequestResponseModel.value.data.first.bkd_for_reqid != null &&
                    _homeController.checkRequestResponseModel.value.data.first.breakdown == 0
                ) ? SizedBox() :  GestureDetector(
                  onTap: () {
                    setState(() {
                      isBookForSomeOne = false;
                    });
                    Get.bottomSheet(
                      ReasonForCancelling(),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.symmetric(
                      horizontal: 30.w,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20) // boxShadow: [
                        //   BoxShadow(
                        //       color: Colors.grey,
                        //       blurRadius: 3)
                        // ],
                        ),
                    alignment: Alignment.center,
                    child: Text(
                      "cancel".tr,
                      style:
                          TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
