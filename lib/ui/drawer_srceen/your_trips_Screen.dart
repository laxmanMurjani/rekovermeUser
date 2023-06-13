import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/enum/user_location_type.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/drawer_srceen/past_trips_details_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/upcoming_trips_details_screen.dart';
import 'package:arbyuser/ui/home_screen.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';

import '../dialog/reason_for_cancelling_dialog.dart';

class YourTripsScreen extends StatefulWidget {
  bool? isUpComingScreenShow;

  YourTripsScreen({this.isUpComingScreenShow});

  @override
  _YourTripsScreenState createState() => _YourTripsScreenState();
}

class _YourTripsScreenState extends State<YourTripsScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy KK:mm a");

  int selectedIndex = 0;

  PageController? _pageController;
  @override
  initState() {
    // if (widget.isUpComingScreenShow!) {
    //   setState(() {
    //     selectedIndex = 1;
    //   });
    //   if (_pageController!.hasClients) {
    //     _pageController!.jumpToPage(selectedIndex);
    //     // _pageController!.animateToPage(1,
    //     //     duration: Duration(milliseconds: 500), curve: Curves.ease);
    //   }
    // }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getPastTripData();
      await _homeController.getUpcomingTripData();
    });
    _pageController =
        PageController(initialPage: widget.isUpComingScreenShow! ? 1 : 0);
    if (!widget.isUpComingScreenShow!) {
      setState(() {
        selectedIndex = 0;
      });
    } else {
      setState(() {
        selectedIndex = 1;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(child: Container(
          padding: EdgeInsets.only(left: 30.w, right: 20.w),
          height: 80.h,
          decoration: BoxDecoration(
            color: AppColors.skyBlue,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 6.r,
                  offset: Offset(0, 3.h)),
            ],
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(38.r),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Get.offAll(HomeScreen());
                      _homeController.userUiSelectionType.value =
                          UserUiSelectionType.none;
                      // if(_homeController.userUiSelectionType.value == UserUiSelectionType.locationSelection){
                      _homeController.locationWhereTo1.clear();
                      _homeController.tempLocationFromTo.clear();
                      _homeController.tempLocationWhereTo1.clear();
                    },
                    child: Image.asset(
                      AppImage.backArrow,
                      color: Colors.black,
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    )),
                Text(
                  "your_trips".tr,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
               SizedBox()
              ],
            ),
          ),
        ), preferredSize: Size(double.infinity, 100)),
        // appBar: CustomAppBar(
        //   text: "your_trips".tr,
        // ),
        // leading: InkWell(
        //     onTap: () {
        //       Get.back();
        //       setState(() {
        //         _homeController.userUiSelectionType.value =
        //             UserUiSelectionType.none;
        //       });
        //       Get.offAll(HomeScreen());
        //     },
        //     child: Image.asset(AppImage.back))),
        body: GetX<HomeController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _pageController!.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);

                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 5),
                      width: MediaQuery.of(context).size.width * 0.45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? AppColors.skyBlue
                              : Color(0xFFF1F2F3),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(18))),
                      child: Text(
                        "past".tr,
                        style: TextStyle(
                            color: selectedIndex == 0
                                ? AppColors.primary
                                : AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _pageController!.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);

                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? AppColors.primaryColor
                              : Color(0xFFF1F2F3),
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(18))),
                      child: Text(
                        "upcoming".tr,
                        style: TextStyle(
                            color: selectedIndex == 1
                                ? AppColors.white
                                : AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                // flex: 40,
                child: PageView(
                  controller: _pageController,
                  children: [
                    cont.pastTripDataList.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "no_past_Trips_found".tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            itemCount: cont.pastTripDataList.length,
                            itemBuilder: (context, index) {
                              TripDataModel tripDataModel =
                                  cont.pastTripDataList[index];
                              log("ccccc===>${cont.pastTripDataList[0].staticMap}");
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => PastTripDetailsScreen(
                                        tripId: tripDataModel.id,
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  width: MediaQuery.of(context).size.width,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      AppBoxShadow.defaultShadow(),
                                    ],
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        // borderRadius: BorderRadius.circular(15.r),
                                        // child: Image.asset(
                                        //   AppImage.root,
                                        //   fit: BoxFit.cover,
                                        //   height: 150.h,
                                        //   width: MediaQuery.of(context).size.width,
                                        // ),
                                        clipBehavior: Clip.antiAlias,
                                        child: CustomFadeInImage(
                                          url: "${tripDataModel.staticMap}" ??
                                              "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                                          width: double.infinity,
                                          height: 125.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // TextButton(onPressed: () {
                                      //
                                      //   print("tripDataModel.staticMap====>${tripDataModel.staticMap}");
                                      // }, child: Text("ddddd")),
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_dateFormat.format(tripDataModel.finishedAt ?? DateTime.now())}",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${tripDataModel.bookingId ?? ""}",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.lightGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 35.h,
                                              width: 1.5.w,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              color: AppColors.underLineColor,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  "${tripDataModel.serviceType?.name ?? ""}",
                                                  style: TextStyle(
                                                    color: AppColors.lightGray,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    cont.upcomingTripDataList.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "no_upcoming_trips_found".tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            itemCount: cont.upcomingTripDataList.length,
                            itemBuilder: (context, index) {
                              TripDataModel tripDataModel =
                                  cont.upcomingTripDataList[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => UpcomingTripDetailsScreen(
                                        tripId: tripDataModel.id,
                                      ))?.then((value) {
                                    cont.getUpcomingTripData();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  width: MediaQuery.of(context).size.width,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      AppBoxShadow.defaultShadow(),
                                    ],
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        // borderRadius: BorderRadius.circular(30.r),
                                        // child: Image.asset(
                                        //   AppImage.root,
                                        //   fit: BoxFit.cover,
                                        //   height: 150.h,
                                        //   width: MediaQuery.of(context).size.width,
                                        // ),
                                        clipBehavior: Clip.antiAlias,
                                        child: CustomFadeInImage(
                                          url: tripDataModel.staticMap ??
                                              "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                                          width: double.infinity,
                                          height: 125.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_dateFormat.format(tripDataModel.updatedAt ?? DateTime.now())}",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),

                                                  Text(
                                                    "${tripDataModel.bookingId ?? ""}",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.lightGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.bottomSheet(
                                                        ReasonForCancelling(
                                                            cancelId: tripDataModel
                                                                        .id !=
                                                                    null
                                                                ? "${tripDataModel.id}"
                                                                : null),
                                                        isScrollControlled:
                                                            true)
                                                    .then((value) => cont
                                                        .getUpcomingTripData());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                    vertical: 3.h),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r)),
                                                child: Text("cancel".tr),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
          // return Column(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(25.r),
          //         border: Border.all(
          //           color: AppColors.shadowColor,
          //         ),
          //       ),
          //       child: TabBar(
          //         controller: _tabController,
          //         labelColor: AppColors.primaryColor,
          //         unselectedLabelColor: Colors.grey,
          //         indicatorColor: Colors.transparent,
          //         indicatorWeight: 0,
          //         indicator: BoxDecoration(
          //           color: Colors.white,
          //           boxShadow: [
          //             AppBoxShadow.defaultShadow(),
          //           ],
          //           borderRadius: BorderRadius.circular(25.r),
          //         ),
          //         tabs: List.generate(
          //           _tabs.length,
          //           (index) => Container(
          //               height: 50, child: Center(child: Text(_tabs[index]))),
          //         ),
          //       ),
          //     ),
          //     TabBarView(
          //       controller: _tabController,
          //       children: [
          //         cont.pastTripDataList.isEmpty
          //             ? Container(
          //                 alignment: Alignment.center,
          //                 child: Text(
          //                   "no_past_Trips_found".tr,
          //                   style: TextStyle(
          //                     color: Colors.grey,
          //                     fontSize: 16.sp,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //               )
          //             : ListView.builder(
          //                 shrinkWrap: true,
          //                 padding: EdgeInsets.symmetric(
          //                     horizontal: 15.w, vertical: 10.h),
          //                 itemCount: cont.pastTripDataList.length,
          //                 itemBuilder: (context, index) {
          //                   TripDataModel tripDataModel =
          //                       cont.pastTripDataList[index];
          //                   return GestureDetector(
          //                     onTap: () {
          //                       Get.to(() => PastTripDetailsScreen(
          //                             tripId: tripDataModel.id,
          //                           ));
          //                     },
          //                     child: Container(
          //                       margin: EdgeInsets.symmetric(vertical: 10.h),
          //                       padding: EdgeInsets.only(bottom: 10.h),
          //                       width: MediaQuery.of(context).size.width,
          //                       clipBehavior: Clip.antiAlias,
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         boxShadow: [
          //                           AppBoxShadow.defaultShadow(),
          //                         ],
          //                         borderRadius: BorderRadius.circular(30.r),
          //                       ),
          //                       child: Column(
          //                         children: [
          //                           ClipRRect(
          //                             // borderRadius: BorderRadius.circular(15.r),
          //                             // child: Image.asset(
          //                             //   AppImage.root,
          //                             //   fit: BoxFit.cover,
          //                             //   height: 150.h,
          //                             //   width: MediaQuery.of(context).size.width,
          //                             // ),
          //                             clipBehavior: Clip.antiAlias,
          //                             child: CustomFadeInImage(
          //                               url: tripDataModel.staticMap ?? "",
          //                               width: double.infinity,
          //                               placeHolder: AppImage.root,
          //                               height: 125.h,
          //                               fit: BoxFit.cover,
          //                             ),
          //                           ),
          //                           SizedBox(height: 10.h),
          //                           Padding(
          //                             padding:
          //                                 EdgeInsets.symmetric(horizontal: 25.w),
          //                             child: Row(
          //                               children: [
          //                                 Expanded(
          //                                   child: Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       Text(
          //                                         "${_dateFormat.format(tripDataModel.finishedAt ?? DateTime.now())}",
          //                                         style: TextStyle(
          //                                           color: AppColors.primaryColor,
          //                                         ),
          //                                       ),
          //                                       Text(
          //                                         "${tripDataModel.bookingId ?? ""}",
          //                                         style: TextStyle(
          //                                           color: AppColors.lightGray,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                                 Container(
          //                                   height: 35.h,
          //                                   width: 1.5.w,
          //                                   margin: EdgeInsets.symmetric(
          //                                       horizontal: 20.w),
          //                                   color: AppColors.underLineColor,
          //                                 ),
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.end,
          //                                   children: [
          //                                     Text(
          //                                       "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
          //                                       style: TextStyle(
          //                                           color: AppColors.primaryColor,
          //                                           fontWeight: FontWeight.w400),
          //                                     ),
          //                                     Text(
          //                                       "${tripDataModel.serviceType?.name ?? ""}",
          //                                       style: TextStyle(
          //                                         color: AppColors.lightGray,
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               ),
          //         cont.upcomingTripDataList.isEmpty
          //             ? Container(
          //                 alignment: Alignment.center,
          //                 child: Text(
          //                   "no_upcoming_trips_found".tr,
          //                   style: TextStyle(
          //                     color: Colors.grey,
          //                     fontSize: 16.sp,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //               )
          //             : ListView.builder(
          //                 shrinkWrap: true,
          //                 padding: EdgeInsets.symmetric(
          //                     horizontal: 15.w, vertical: 10.h),
          //                 itemCount: cont.upcomingTripDataList.length,
          //                 itemBuilder: (context, index) {
          //                   TripDataModel tripDataModel =
          //                       cont.upcomingTripDataList[index];
          //                   return GestureDetector(
          //                     onTap: () {
          //                       Get.to(() => UpcomingTripDetailsScreen(
          //                             tripId: tripDataModel.id,
          //                           ))?.then((value) {
          //                         cont.getUpcomingTripData();
          //                       });
          //                     },
          //                     child: Container(
          //                       margin: EdgeInsets.symmetric(vertical: 10.h),
          //                       padding: EdgeInsets.only(bottom: 10.h),
          //                       width: MediaQuery.of(context).size.width,
          //                       clipBehavior: Clip.antiAlias,
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         boxShadow: [
          //                           AppBoxShadow.defaultShadow(),
          //                         ],
          //                         borderRadius: BorderRadius.circular(30.r),
          //                       ),
          //                       child: Column(
          //                         children: [
          //                           ClipRRect(
          //                             // borderRadius: BorderRadius.circular(30.r),
          //                             // child: Image.asset(
          //                             //   AppImage.root,
          //                             //   fit: BoxFit.cover,
          //                             //   height: 150.h,
          //                             //   width: MediaQuery.of(context).size.width,
          //                             // ),
          //                             clipBehavior: Clip.antiAlias,
          //                             child: CustomFadeInImage(
          //                               url: tripDataModel.staticMap ?? "",
          //                               width: double.infinity,
          //                               placeHolder: AppImage.root,
          //                               height: 125.h,
          //                               fit: BoxFit.cover,
          //                             ),
          //                           ),
          //                           SizedBox(height: 10.h),
          //                           Padding(
          //                             padding:
          //                                 EdgeInsets.symmetric(horizontal: 15.w),
          //                             child: Row(
          //                               children: [
          //                                 Expanded(
          //                                   child: Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       Text(
          //                                         "${_dateFormat.format(tripDataModel.updatedAt ?? DateTime.now())}",
          //                                         style: TextStyle(
          //                                           color: AppColors.primaryColor,
          //                                         ),
          //                                       ),
          //                                       Text(
          //                                         "${tripDataModel.bookingId ?? ""}",
          //                                         style: TextStyle(
          //                                           color: AppColors.lightGray,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                                 InkWell(
          //                                   onTap: () {
          //                                     Get.bottomSheet(
          //                                             ReasonForCancelling(
          //                                                 cancelId: tripDataModel
          //                                                             .id !=
          //                                                         null
          //                                                     ? "${tripDataModel.id}"
          //                                                     : null),
          //                                             isScrollControlled: true)
          //                                         .then((value) =>
          //                                             cont.getUpcomingTripData());
          //                                   },
          //                                   child: Container(
          //                                     padding: EdgeInsets.symmetric(
          //                                         horizontal: 15.w,
          //                                         vertical: 3.h),
          //                                     decoration: BoxDecoration(
          //                                         border: Border.all(
          //                                             color: Colors.grey),
          //                                         borderRadius:
          //                                             BorderRadius.circular(5.r)),
          //                                     child: Text("cancel".tr),
          //                                   ),
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               ),
          //       ],
          //     ),
          //   ],
          // );
        }),
      ),
    );
  }
}
