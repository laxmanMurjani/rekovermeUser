import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/dialog/dispute_dialog.dart';
import 'package:arbyuser/ui/dialog/lost_item_dialog.dart';
import 'package:arbyuser/ui/dialog/trip_receipt_dialog.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/cutom_appbar.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:arbyuser/util/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PastTripDetailsScreen extends StatefulWidget {
  int tripId;

  PastTripDetailsScreen({this.tripId = 0});

  @override
  _PastTripDetailsScreenState createState() => _PastTripDetailsScreenState();
}

class _PastTripDetailsScreenState extends State<PastTripDetailsScreen> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  final DateFormat _dateFormat = DateFormat("dd MMM yyyy\nhh:mm a");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getTripDetails(id: widget.tripId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: _homeController.tripDetails.value.id != null
            ? IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                  size: 30,
                ),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width - 10, 100, 0, 0),
                    items: [
                      PopupMenuItem(
                        key: _key,
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 300), () {
                            Get.bottomSheet(
                                DisputeDialog(tripId: widget.tripId),
                                isScrollControlled: true);
                          });
                        },
                        child: Text('dispute'.tr),
                        value: 'dispute'.tr,
                      ),
                      PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 300), () {
                            Get.bottomSheet(LostItemDialog(),
                                isScrollControlled: true);
                          });
                        },
                        child: Text('lost_my_item'.tr),
                        value: 'lost_my_item'.tr,
                      ),
                    ],
                    elevation: 8.0,
                  );
                })
            : null,
        text: "past_trip_details".tr,
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Get.bottomSheet(TripReceiptDialog(), isScrollControlled: true);
        },
        child: Container(
          height: 55,
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(35.r),
            boxShadow: [
              AppBoxShadow.defaultShadow(),
            ],
          ),
          child: Center(
            child: Text(
              "view_receipt".tr,
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp),
            ),
          ),
        ),
      ),
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        TripDataModel tripDataModel = cont.tripDetails.value;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15.w, 15.5.h, 15.w, 0),
                padding: EdgeInsets.only(bottom: 15.h),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                  boxShadow: [
                    AppBoxShadow.defaultShadow(),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TextButton(onPressed:(){
                    // print("tripDataModel.staticMap===>${tripDataModel.staticMap}");
                    // } , child: Text("sdbhsd")),
                    ClipRRect(
                        // borderRadius: BorderRadius.circular(20.r),
                        child: CustomFadeInImage(
                      url: tripDataModel.staticMap ?? "",
                      placeHolder: AppImage.root,
                      width: double.infinity,
                      height: 255.h,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(85),
                            child: CustomFadeInImage(
                              url: "${ApiUrl.baseImageUrl}${tripDataModel.provider?.avatar}" ??
                                  "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                              height: 50.w,
                              width: 50.w,
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
                                    // fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
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
                                "${_dateFormat.format(tripDataModel.finishedAt ?? DateTime.now())}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                "${tripDataModel.bookingId ?? ""}",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
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
                    // SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        children: [
                          timelineRow("Source", '${tripDataModel.sAddress}'),
                          SizedBox(
                            height: 0,
                          ),
                          timelineLastRow(
                              "Destination", '${tripDataModel.dAddress}'),
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.all(3.w),
                          //       height: 15.w,
                          //       width: 15.w,
                          //       decoration: BoxDecoration(
                          //           shape: BoxShape.circle,
                          //           color: Colors.yellow),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //     SizedBox(width: 10.w),
                          //     Expanded(
                          //       child: Text(
                          //         "${tripDataModel.sAddress ?? ""}",
                          //         style: TextStyle(
                          //           color: AppColors.primaryColor,
                          //           fontSize: 12.sp,
                          //           // fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 7.w),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: DottedLine(
                          //       direction: Axis.vertical,
                          //       dashColor: AppColors.primaryColor,
                          //       lineLength: 25.h,
                          //       dashLength: 3.h,
                          //     ),
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.all(3.w),
                          //       height: 15.w,
                          //       width: 15.w,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: AppColors.primaryColor,
                          //       ),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //     SizedBox(width: 10.w),
                          //     Expanded(
                          //       child: Text(
                          //         "${tripDataModel.dAddress}",
                          //         style: TextStyle(
                          //           color: AppColors.primaryColor,
                          //           fontSize: 12.sp,
                          //           // fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(thickness: 2.h, indent: 20.w, endIndent: 20.w),
                    SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //   child: Text(
                    //     "Pay via",
                    //     style: TextStyle(
                    //         color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    // SizedBox(height: 7.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        children: [
                          Text(
                            "pay_via".tr,
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          SizedBox(width: 10.w),
                          Image.asset(
                            AppImage.creditCard,
                            fit: BoxFit.contain,
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${tripDataModel.paymentMode ?? ""}",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12.sp),
                          ),
                          Spacer(),
                          Text(
                            "${tripDataModel.payment?.total ?? "0"} ${_userController.userData.value.currency ?? ""}",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
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
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "${(tripDataModel.rating!.userComment == "null" || tripDataModel.rating!.userComment!.isEmpty) ? "no_comments".tr : tripDataModel.rating?.userComment ?? ""}",
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
              SizedBox(height: 30.h),

              // SizedBox(height: 30.h),
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

  void _dispute() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 5.h),
        height: 100.h,
        width: 200.w,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: AppColors.primaryColor,
                    size: 35,
                  ),
                  SizedBox(width: 100.w),
                  Text(
                    'dispute'.tr,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Divider(thickness: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "you".tr,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "driver_unprofessional".tr,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 20.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "open".tr,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
