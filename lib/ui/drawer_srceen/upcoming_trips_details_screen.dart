import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/dialog/trip_receipt_dialog.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../dialog/reason_for_cancelling_dialog.dart';

class UpcomingTripDetailsScreen extends StatefulWidget {
  int tripId;

  UpcomingTripDetailsScreen({this.tripId = 0});

  @override
  _UpcomingTripDetailsScreenState createState() =>
      _UpcomingTripDetailsScreenState();
}

class _UpcomingTripDetailsScreenState extends State<UpcomingTripDetailsScreen> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  final DateFormat _dateFormat = DateFormat("dd MMM yyyy\nhh:mm a");
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.getUpcomingTripDetails(id: widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "upcoming_trip_details".tr,
      ),
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        TripDataModel tripDataModel = cont.upcomingTripDetails.value;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15.h, 15.5, 15.h, 0),
                padding: EdgeInsets.only(bottom: 15.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 5),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: CustomFadeInImage(
                          url: tripDataModel.staticMap ?? "",
                          placeHolder: AppImage.root,
                          width: double.infinity,
                          height: 255.h,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 50.w,
                            width: 50.w,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                              // shape: BoxShape.circle,
                            ),
                            child: CustomFadeInImage(
                              url: tripDataModel.provider?.avatar ?? "",
                              placeHolder: AppImage.icUserPlaceholder,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${tripDataModel.provider?.firstName ?? ""} ${tripDataModel.provider?.lastName ?? ""}",
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp),
                                ),
                                SizedBox(height: 3.h),
                                RatingBar.builder(
                                  initialRating: _strToDouble(
                                      s: (tripDataModel
                                                  .rating?.providerRating ??
                                              0)
                                          .toString()),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.5.w),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemSize: 12.w,
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_dateFormat.format(tripDataModel.scheduleAt ?? DateTime.now())}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                "${tripDataModel.bookingId ?? ""}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Text(
                    //     "Address",
                    //     style: TextStyle(
                    //         color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                height: 15.w,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  "${tripDataModel.sAddress ?? ""}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                    // fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: DottedLine(
                                direction: Axis.vertical,
                                dashColor: AppColors.primaryColor,
                                lineLength: 30,
                                dashLength: 5,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                height: 15.w,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepPurpleAccent),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  "${tripDataModel.dAddress}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Text(
                            "pay_via".tr,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.payments_outlined,
                            size: 25.w,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${tripDataModel.paymentMode ?? ""}",
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 12.sp),
                          ),
                          Spacer(),
                          Text(
                            "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                            "comments".tr,
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 12.sp),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${(tripDataModel.rating?.userComment ?? "").isEmpty ? "no_cmments".tr : tripDataModel.rating?.userComment ?? ""}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                                  ReasonForCancelling(
                                      cancelId: tripDataModel.id != null
                                          ? "${tripDataModel.id}"
                                          : null),
                                  isScrollControlled: true)
                              .then((value) => Get.back());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5),
                              ]),
                          child: Center(
                            child: Text(
                              "cancel_ride".tr,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(TripReceiptDialog(),
                              isScrollControlled: true);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5),
                              ]),
                          child: Center(
                            child: Text(
                              "call".tr,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  double _strToDouble({required String s}) {
    double rating = 0;
    try {
      rating = double.parse(s);
    } catch (e) {
      rating = 0;
    }
    return rating;
  }
}
