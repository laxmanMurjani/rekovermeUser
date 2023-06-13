import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/user_location_type.dart';
import 'package:arbyuser/model/location_response_odel.dart';
import 'package:arbyuser/model/multiple_location_add_model.dart';
import 'package:arbyuser/ui/service_select_screen.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/util/common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog/update_address_dialog.dart';

bool isRideLocationUpdateRead = false;
bool isDriverShow = true;

class LocationScreen extends StatefulWidget {
  bool? isSelectHomeAddress;
  bool isRideLocationUpdate;
  bool? isSelectOtherAddress;

  LocationScreen(
      {this.isSelectHomeAddress,
      this.isSelectOtherAddress = false,
      this.isRideLocationUpdate = false});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with WidgetsBindingObserver {
  final UserController _userController = Get.find();
  final HomeController _homeController = Get.find();

  GoogleMapController? _controller;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final List<Marker> _markers = [];
  PolylineId id = PolylineId('poly');
  final List<Polyline> _polyLine = [];
  LatLng? _cameraMoveLatlng;

  var showBottom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getPastTripData();
    });
    WidgetsBinding.instance.addObserver(this);
    log("message   ==>   12vv  12 ${_homeController.latLngFrom}");

    _homeController.tempLocationFromTo.text =
        _homeController.locationFromTo.text;
    _homeController.tempLocationWhereTo1.text =
        _homeController.locationWhereTo1.text;
    _homeController.isRoundTrip.value = false;

    _homeController.tempLatLngFrom = _homeController.latLngFrom;
    _homeController.tempLatLngWhereTo1 = _homeController.latLngWhereTo1;

    _homeController.tempLatLngFrom = _homeController.latLngFrom;
    log("message   ==>   12vv  12 ${_homeController.latLngFrom}   ${_homeController.tempLatLngFrom}");
    _homeController.multipleLocationAdModelList.clear();
    _homeController.isPickFromMap.value = false;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    if (widget.isSelectOtherAddress! == true) {
      if (widget.isSelectOtherAddress != null || widget.isRideLocationUpdate) {
        MultipleLocationAddModel multipleLocationAddModel =
            MultipleLocationAddModel();

        multipleLocationAddModel.onChange = (String s) async {
          log("message  ==>  $s");
          await _homeController.getLocationFromAddress(address: s);
        };
        // multipleLocationAddModel.remove = () {
        //   _homeController.multipleLocationAdModelList
        //       .remove(multipleLocationAddModel);
        // };
        _homeController.multipleLocationAdModelList
            .add(multipleLocationAddModel);
      }
      Future.delayed(Duration(milliseconds: 500), () {
        _homeController.locationWhereToFocusNode.requestFocus();
      });
    } else {
      if (widget.isSelectHomeAddress != null || widget.isRideLocationUpdate) {
        MultipleLocationAddModel multipleLocationAddModel =
            MultipleLocationAddModel();

        multipleLocationAddModel.onChange = (String s) async {
          log("message  ==>  $s");
          await _homeController.getLocationFromAddress(address: s);
        };
        // multipleLocationAddModel.remove = () {
        //   _homeController.multipleLocationAdModelList
        //       .remove(multipleLocationAddModel);
        // };
        _homeController.multipleLocationAdModelList
            .add(multipleLocationAddModel);
      }
      Future.delayed(Duration(milliseconds: 500), () {
        _homeController.locationWhereToFocusNode.requestFocus();
      });
    }

    setState(() {
      isRideLocationUpdateRead = widget.isRideLocationUpdate;
    });
    // });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        // _homeController.clearData();
        return Future.value(true);
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: GetX<HomeController>(builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return GetX<UserController>(builder: (userCont) {
            bool isInitLatLng = (cont.tempLatLngFrom != null &&
                cont.tempLatLngWhereTo1 != null);
            if (widget.isSelectOtherAddress!) {
              if (widget.isSelectOtherAddress != null ||
                  widget.isRideLocationUpdate) {
                isInitLatLng = true;
              }
            } else {
              if (widget.isSelectHomeAddress != null ||
                  widget.isRideLocationUpdate) {
                isInitLatLng = true;
              }
            }

            if (userCont.error.value.errorType == ErrorType.internet) {
              return NoInternetWidget();
            }
            bool isFocus = false;
            cont.multipleLocationAdModelList.forEach((element) {
              isInitLatLng = (element.latLng != null && isInitLatLng);
              if (!isFocus) {
                isFocus = element.focusNode?.hasFocus == true;
              }
            });

            String? profileUrl;
            if (userCont.userData.value.picture != null) {
              profileUrl =
                  "${ApiUrl.baseImageUrl}${userCont.userData.value.picture ?? ""}";
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isDriverShow = true;
                                  });
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: AppColors.gray.withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Expanded(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Container(
                              //         width: 35.w,
                              //         height: 35.w,
                              //         clipBehavior: Clip.antiAlias,
                              //         decoration: BoxDecoration(
                              //           color: Colors.grey[200],
                              //           shape: BoxShape.circle,
                              //         ),
                              //         child: profileUrl == null
                              //             ? Center(
                              //                 child: Icon(
                              //                     Icons.perm_identity_outlined,
                              //                     color: Colors.grey),
                              //               )
                              //             : CustomFadeInImage(
                              //                 url: profileUrl,
                              //                 placeHolderWidget: Icon(
                              //                   Icons.perm_identity_outlined,
                              //                   color: Colors.grey,
                              //                 ),
                              //                 fit: BoxFit.cover,
                              //               ),
                              //       ),
                              //       SizedBox(width: 5.w),
                              //       Text(
                              //         "${userCont.userData.value.firstName ?? ""} ${userCont.userData.value.lastName ?? ""}",
                              //         style: TextStyle(
                              //           color: AppColors.primaryColor,
                              //           fontSize: 12.sp,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    isDriverShow = false;
                                  });
                                  if (isInitLatLng) {
                                    if (widget.isSelectOtherAddress!) {
                                      if ((widget.isSelectOtherAddress !=
                                                  null ||
                                              widget.isRideLocationUpdate) &&
                                          cont.multipleLocationAdModelList
                                              .isNotEmpty) {
                                        MultipleLocationAddModel
                                            multipleLocationAddModel =
                                            cont.multipleLocationAdModelList[
                                                0];
                                        Map<String, String> params = {};
                                        params["address"] =
                                            "${multipleLocationAddModel.textEditingController?.text ?? ""}";
                                        params["latitude"] =
                                            "${multipleLocationAddModel.latLng?.latitude ?? 0}";
                                        params["longitude"] =
                                            "${multipleLocationAddModel.latLng?.longitude ?? 0}";
                                        params["type"] = "others";
                                        Get.back();

                                        if (widget.isRideLocationUpdate) {
                                          Get.dialog(UpdateAddressDialog(
                                              params: params));
                                        } else {
                                          await _userController.addLocation(
                                              params: params);
                                        }
                                      } else {
                                        Get.back();
                                      }

                                      // Get.to(() => ServiceSelectScreen());
                                      if (widget.isSelectOtherAddress ==
                                              null &&
                                          !widget.isRideLocationUpdate) {
                                        cont.selectedLocationDrawRoute();
                                      }
                                    } else {
                                      if ((widget.isSelectHomeAddress !=
                                                  null ||
                                              widget.isRideLocationUpdate) &&
                                          cont.multipleLocationAdModelList
                                              .isNotEmpty) {
                                        MultipleLocationAddModel
                                            multipleLocationAddModel =
                                            cont.multipleLocationAdModelList[
                                                0];
                                        Map<String, String> params = {};
                                        params["address"] =
                                            "${multipleLocationAddModel.textEditingController?.text ?? ""}";
                                        params["latitude"] =
                                            "${multipleLocationAddModel.latLng?.latitude ?? 0}";
                                        params["longitude"] =
                                            "${multipleLocationAddModel.latLng?.longitude ?? 0}";
                                        params["type"] =
                                            widget.isSelectHomeAddress == true
                                                ? "home"
                                                : "work";
                                        Get.back();

                                        if (widget.isRideLocationUpdate) {
                                          Get.dialog(UpdateAddressDialog(
                                              params: params));
                                        } else {
                                          await _userController.addLocation(
                                              params: params);
                                        }
                                      } else {
                                        Get.back();
                                      }

                                      // Get.to(() => ServiceSelectScreen());
                                      if (widget.isSelectHomeAddress ==
                                              null &&
                                          !widget.isRideLocationUpdate) {
                                        cont.selectedLocationDrawRoute();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(55)),
                                  child: Text(
                                    'Request',
                                    style: TextStyle(
                                        color: isInitLatLng
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 17),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15.h),

                          if (widget.isSelectHomeAddress == null ||
                              widget.isSelectOtherAddress == null &&
                                  !widget.isRideLocationUpdate) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Color(0xffF0EFEF),
                                borderRadius: BorderRadius.circular(10.r),
                                // boxShadow: [
                                //   AppBoxShadow.defaultShadow(),
                                // ]
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 5.w),
                                  Text(
                                    'P :'.tr,
                                    style: TextStyle(
                                        color: AppColors.primaryColor,fontSize: 16),
                                  ),
                                  // SizedBox(width: 2.w),
                                  Expanded(
                                      child: Container(
                                    child: TextFormField(
                                      focusNode: cont.locationFromFocusNode,
                                      controller: cont.tempLocationFromTo,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "from_to".tr,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Color(0xff9F9F9F)),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 12.h,
                                        ),
                                        isDense: true,
                                      ),
                                      onChanged: (s) async {
                                        await cont.getLocationFromAddress(
                                            address: s);
                                      },
                                    ),
                                  )),
                                  InkWell(
                                    onTap: () {
                                      cont.tempLocationFromTo.clear();
                                    },
                                    child: Image.asset(
                                      AppImage.edit,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  // IconButton(
                                  //     onPressed: () {
                                  //
                                  //       print("1111111111");
                                  //     },
                                  //     icon: Icon(Icons.edit))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Color(0xffF0EFEF),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showBottom = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          Text(
                                            'D :'.tr,
                                            style: TextStyle(
                                               fontSize: 16,
                                                color:
                                                    AppColors.primaryColor),
                                          ),

                                          Expanded(
                                              child: Container(
                                            child: TextFormField(
                                              focusNode: cont
                                                  .locationWhereToFocusNode,
                                              controller:
                                                  cont.tempLocationWhereTo1,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    "enter_destination".tr,
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintStyle: TextStyle(
                                                    color: Color(0xff9F9F9F)),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.w,
                                                        vertical: 12.h),
                                              ),
                                              onChanged: (s) async {
                                                await cont
                                                    .getLocationFromAddress(
                                                        address: s);
                                              },
                                            ),
                                          )),
                                          // Icon(Icons.search_rounded,size: 35),
                                          // SizedBox(width: 10.w),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if ((cont.multipleLocationAdModelList
                                          .length <
                                      2))
                                    InkWell(
                                      onTap: () {
                                        MultipleLocationAddModel
                                            multipleLocationAddModel =
                                            MultipleLocationAddModel();

                                        multipleLocationAddModel.onChange =
                                            (String s) async {
                                          log("message  ==>  $s");
                                          await cont.getLocationFromAddress(
                                              address: s);
                                        };
                                        multipleLocationAddModel.remove = () {
                                          cont.multipleLocationAdModelList
                                              .remove(
                                                  multipleLocationAddModel);
                                        };

                                        cont.multipleLocationAdModelList
                                            .add(multipleLocationAddModel);
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 25.w,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                          // Row(
                          //   children: [
                          //     Text("Pick From Map"),
                          //     Spacer(),
                          //     Switch(
                          //       onChanged: toggleSwitch,
                          //       value: isSwitched,
                          //       activeColor: AppColors.primaryColor,
                          //       activeTrackColor: AppColors.primaryColor,
                          //       inactiveThumbColor: Colors.grey,
                          //       inactiveTrackColor: Colors.grey,
                          //     )
                          //   ],
                          // ),
                          ListView.builder(
                            padding: EdgeInsets.only(top: 5.h),
                            itemBuilder: (context, index) {
                              MultipleLocationAddModel
                                  multipleLocationAddModel =
                                  cont.multipleLocationAdModelList[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: multipleLocationAddModel.getWidget(),
                              );
                            },
                            itemCount:
                                cont.multipleLocationAdModelList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),

                          if (cont.searchAddressList.isNotEmpty)
                            SingleChildScrollView(
                              child: Container(
                                height: 120,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 10),
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    AutocompletePrediction
                                        autocompletePrediction =
                                        cont.searchAddressList[index];
                                    return InkWell(
                                      onTap: () {
                                        if (cont
                                            .locationFromFocusNode.hasFocus) {
                                          cont.tempLocationFromTo.text =
                                              autocompletePrediction
                                                      .description ??
                                                  "";
                                        } else if (cont
                                            .locationWhereToFocusNode
                                            .hasFocus) {
                                          cont.tempLocationWhereTo1.text =
                                              autocompletePrediction
                                                      .description ??
                                                  "";
                                        } else {
                                          cont.multipleLocationAdModelList
                                              .forEach((element) {
                                            if (element.focusNode?.hasFocus ==
                                                true) {
                                              element.textEditingController
                                                      ?.text =
                                                  autocompletePrediction
                                                          .description ??
                                                      "";
                                            }
                                          });
                                        }
                                        cont
                                            .getPlaceIdToLatLag(
                                                placeId:
                                                    autocompletePrediction
                                                        .placeId!)
                                            .then((value) {
                                          cont.removeUnFocusManager();
                                          setState(() {});
                                        });
                                        cont.searchAddressList.clear();
                                      },
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(autocompletePrediction
                                                          .description ??
                                                      ""),
                                                  // Text(
                                                  //   autocompletePrediction.description ??
                                                  //       "",
                                                  //   style: TextStyle(
                                                  //     color: Colors.grey,
                                                  //   ),
                                                  // ),
                                                  if (cont.searchAddressList
                                                              .length -
                                                          1 !=
                                                      index)
                                                    Container(
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                              vertical: 5.h),
                                                      width: double.infinity,
                                                      height: 1.h,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: cont.searchAddressList.length,
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                ),
                              ),
                            ),
                          if (widget.isSelectHomeAddress == null ||
                              widget.isSelectOtherAddress == null &&
                                  !widget.isRideLocationUpdate) ...[
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                              //   Row(
                              //   children: [
                              //     Text("round_trip".tr,
                              //         style: TextStyle(
                              //             color: AppColors.primaryColor,
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w500)),
                              //     // Spacer(),
                              //     Switch(
                              //       onChanged: (value) {
                              //         cont.isRoundTrip.value = value;
                              //       },
                              //       value: cont.isRoundTrip.value,
                              //       activeColor: AppColors.primaryColor,
                              //       activeTrackColor:
                              //       AppColors.primaryColor,
                              //       inactiveThumbColor: AppColors.gray,
                              //       inactiveTrackColor: AppColors.lightGray
                              //           .withOpacity(0.8),
                              //       thumbColor: MaterialStatePropertyAll(AppColors.primaryColor),
                              //     )
                              //   ],
                              // ),
                                Row(
                                  children: [
                                    Text("pick_from_map".tr,
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(width: 5,),
                                    InkWell(
                                      onTap: () {
                                        cont.isPickFromMap.value =
                                            !cont.isPickFromMap.value;
                                      },
                                      child: Image.asset(
                                        AppImage.point,
                                        width: 23,

                                        height: 23,
                                      ),
                                    ),

                                    // Switch(
                                    //   onChanged: (v) {
                                    //     cont.isPickFromMap.value = v;
                                    //   },
                                    //   value: cont.isPickFromMap.value,
                                    //   activeColor: AppColors.primaryColor,
                                    //   activeTrackColor: AppColors.primaryColor,
                                    //   inactiveThumbColor: AppColors.gray,
                                    //   inactiveTrackColor:
                                    //       AppColors.lightGray.withOpacity(0.8),
                                    // )
                                  ],
                                ),

                              ],
                            ),
                            if (cont.isPickFromMap.value == false)
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      if (userCont.locationResponseModel.value
                                          .home.isNotEmpty)
                                        InkWell(
                                          onTap: () {
                                            Home _home = userCont
                                                .locationResponseModel
                                                .value
                                                .home[0];
                                            if (cont.locationFromFocusNode
                                                .hasFocus) {
                                              cont.tempLocationFromTo.text =
                                                  _home.address ?? "";
                                              cont.tempLatLngFrom = LatLng(
                                                  _home.latitude ?? 0,
                                                  _home.longitude ?? 0);
                                            } else if (cont
                                                .locationWhereToFocusNode
                                                .hasFocus) {
                                              cont.tempLocationWhereTo1.text =
                                                  _home.address ?? "";
                                              cont.tempLatLngWhereTo1 =
                                                  LatLng(_home.latitude ?? 0,
                                                      _home.longitude ?? 0);
                                            } else {
                                              cont.multipleLocationAdModelList
                                                  .forEach((element) {
                                                if (element.focusNode
                                                        ?.hasFocus ==
                                                    true) {
                                                  element
                                                      .textEditingController
                                                      ?.text = _home
                                                          .address ??
                                                      "";
                                                  element.latLng = LatLng(
                                                      _home.latitude ?? 0,
                                                      _home.longitude ?? 0);
                                                }
                                              });
                                            }
                                            cont.searchAddressList.clear();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(AppImage.home,
                                                  width: 40, height: 40),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                      'home'.tr,
                                                      style: TextStyle(
                                                          color: AppColors.primaryColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                    ),
                                                    Text(
                                                      userCont
                                                              .locationResponseModel
                                                              .value
                                                              .home[0]
                                                              .address ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      // else
                                      //   Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: [
                                      //       Card(
                                      //           child: Padding(
                                      //         padding:
                                      //             const EdgeInsets.all(6.0),
                                      //         child: Icon(
                                      //           Icons.home,
                                      //         ),
                                      //       )),
                                      //       SizedBox(
                                      //         width: 15.w,
                                      //       ),
                                      //       Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           Text(
                                      //             'home'.tr,
                                      //             style: TextStyle(
                                      //                 color: Colors.grey[600],
                                      //                 fontSize: 14,
                                      //                 fontWeight:
                                      //                     FontWeight.w500),
                                      //           ),
                                      //           Text(
                                      //               'home_destination_is_not_added'
                                      //                   .tr,
                                      //               style: TextStyle(
                                      //                   color: Colors.grey,
                                      //                   fontSize: 12)),
                                      //         ],
                                      //       ),
                                      //     ],
                                      //   ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  if (userCont.locationResponseModel.value
                                      .work.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        Home _home = userCont
                                            .locationResponseModel
                                            .value
                                            .work[0];
                                        if (cont
                                            .locationFromFocusNode.hasFocus) {
                                          print("enter 1");
                                          cont.tempLocationFromTo.text =
                                              _home.address ?? "";
                                          cont.tempLatLngFrom = LatLng(
                                              _home.latitude ?? 0,
                                              _home.longitude ?? 0);
                                        } else if (cont
                                            .locationWhereToFocusNode
                                            .hasFocus) {
                                          print("enter 2");
                                          cont.tempLocationWhereTo1.text =
                                              _home.address ?? "";
                                          cont.tempLatLngWhereTo1 = LatLng(
                                              _home.latitude ?? 0,
                                              _home.longitude ?? 0);
                                        } else {
                                          print("enter 3");
                                          cont.multipleLocationAdModelList
                                              .forEach((element) {
                                            if (element.focusNode?.hasFocus ==
                                                true) {
                                              element.textEditingController
                                                      ?.text =
                                                  _home.address ?? "";
                                              element.latLng = LatLng(
                                                  _home.latitude ?? 0,
                                                  _home.longitude ?? 0);
                                            }
                                          });
                                        }
                                        cont.searchAddressList.clear();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            AppImage.work,
                                            height: 40,
                                            width: 40,
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'work'.tr,
                                                  style: TextStyle(
                                                      color: AppColors.primaryColor
                                                      ,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                    userCont
                                                            .locationResponseModel
                                                            .value
                                                            .work[0]
                                                            .address ??
                                                        "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey.shade400,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                  //   Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       Card(
                                  //           child: Padding(
                                  //         padding: const EdgeInsets.all(6.0),
                                  //         child: Icon(
                                  //           Icons.shopping_bag_rounded,
                                  //         ),
                                  //       )),
                                  //       SizedBox(
                                  //         width: 15.w,
                                  //       ),
                                  //       Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             'work',
                                  //             style: TextStyle(
                                  //                 color: Colors.grey[600],
                                  //                 fontSize: 14,
                                  //                 fontWeight:
                                  //                     FontWeight.w500),
                                  //           ),
                                  //           Text(
                                  //               'work_destination_is_not_added'
                                  //                   .tr,
                                  //               style: TextStyle(
                                  //                 color: Colors.grey,
                                  //                 fontSize: 12,
                                  //               )),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // SizedBox(
                                  //   height: 10.h,
                                  // ),
                                  // Divider(
                                  //   indent: 40,
                                  //   endIndent: 40,
                                  // ),
                                  if (userCont.locationResponseModel.value
                                      .others.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        Home _home = userCont
                                            .locationResponseModel
                                            .value
                                            .others[0];
                                        if (cont
                                            .locationFromFocusNode.hasFocus) {
                                          cont.tempLocationFromTo.text =
                                              _home.address ?? "";
                                          cont.tempLatLngFrom = LatLng(
                                              _home.latitude ?? 0,
                                              _home.longitude ?? 0);
                                        } else if (cont
                                            .locationWhereToFocusNode
                                            .hasFocus) {
                                          cont.tempLocationWhereTo1.text =
                                              _home.address ?? "";
                                          cont.tempLatLngWhereTo1 = LatLng(
                                              _home.latitude ?? 0,
                                              _home.longitude ?? 0);
                                        } else {
                                          cont.multipleLocationAdModelList
                                              .forEach((element) {
                                            if (element.focusNode?.hasFocus ==
                                                true) {
                                              element.textEditingController
                                                      ?.text =
                                                  _home.address ?? "";
                                              element.latLng = LatLng(
                                                  _home.latitude ?? 0,
                                                  _home.longitude ?? 0);
                                            }
                                          });
                                        }
                                        cont.searchAddressList.clear();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Card(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.favorite,
                                            ),
                                          )),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'other'.tr,
                                                  style: TextStyle(
                                                      color: AppColors.primaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                    userCont
                                                            .locationResponseModel
                                                            .value
                                                            .others[0]
                                                            .address ??
                                                        "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.grey.shade400,
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   children: [
                                    //     Card(
                                    //         child: Padding(
                                    //       padding: const EdgeInsets.all(6.0),
                                    //       child: Icon(
                                    //         Icons.favorite,
                                    //       ),
                                    //     )),
                                    //     SizedBox(
                                    //       width: 15.w,
                                    //     ),
                                    //     Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text(
                                    //           'other'.tr,
                                    //           style: TextStyle(
                                    //               color: Colors.grey[600],
                                    //               fontSize: 14,
                                    //               fontWeight:
                                    //                   FontWeight.w500),
                                    //         ),
                                    //         Text('address_is_not_added'.tr,
                                    //             style: TextStyle(
                                    //               color: Colors.grey,
                                    //               fontSize: 12,
                                    //             )),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    Column(
                                      children: [
                                        // InkWell(
                                        //   onTap: () {
                                        //     print("sffdf");
                                        //     // getOtherAddressData(
                                        //     //     otherAddressData:
                                        //     //         otherAddressData,
                                        //     //     setStateData: () => () {
                                        //     //           setState(() {});
                                        //     //         });
                                        //   },
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [
                                        //       Card(
                                        //           shape: RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       5)),
                                        //           child: Padding(
                                        //             padding:
                                        //                 const EdgeInsets.all(
                                        //                     6.0),
                                        //             child: Icon(
                                        //               Icons.favorite,
                                        //             ),
                                        //           )),
                                        //       SizedBox(
                                        //         width: 15.w,
                                        //       ),
                                        //       Text(
                                        //         'Other',
                                        //         style: TextStyle(
                                        //             color: Colors.grey[600],
                                        //             fontSize: 14,
                                        //             fontWeight:
                                        //                 FontWeight.w500),
                                        //       ),
                                        //       IconButton(
                                        //           onPressed: null,
                                        //           icon: Icon(
                                        //             Icons.arrow_forward_ios,
                                        //             size: 20,
                                        //             color:
                                        //                 AppColors.primaryColor,
                                        //           ))
                                        //     ],
                                        //   ),
                                        // ),

                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 0,
                                                ),
                                                Text(
                                                  'recent_locations'.tr,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2,),
                                            cont.pastTripDataList.isEmpty
                                                ? Text(
                                                    'No Recent Location',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      cont.tempLocationWhereTo1
                                                          .clear();

                                                      if (cont
                                                          .locationFromFocusNode
                                                          .hasFocus) {
                                                        print("enter 1");
                                                        cont.tempLocationFromTo
                                                            .text = cont
                                                                .pastTripDataList
                                                                .elementAt(0)
                                                                .dAddress! ??
                                                            "";
                                                        cont.tempLatLngFrom = LatLng(
                                                            cont.pastTripDataList
                                                                    .elementAt(
                                                                        0)
                                                                    .dLatitude ??
                                                                0,
                                                            cont.pastTripDataList
                                                                    .elementAt(
                                                                        0)
                                                                    .dLongitude ??
                                                                0);
                                                      } else if (cont
                                                          .locationWhereToFocusNode
                                                          .hasFocus) {
                                                        print("enter 2");
                                                        cont.tempLocationWhereTo1
                                                            .text = cont
                                                                .pastTripDataList
                                                                .elementAt(0)
                                                                .dAddress ??
                                                            "";
                                                        cont.tempLatLngWhereTo1 = LatLng(
                                                            cont.pastTripDataList
                                                                    .elementAt(
                                                                        0)
                                                                    .dLatitude ??
                                                                0,
                                                            cont.pastTripDataList
                                                                    .elementAt(
                                                                        0)
                                                                    .dLongitude ??
                                                                0);
                                                      } else {
                                                        print("enter 3");
                                                        cont.multipleLocationAdModelList
                                                            .forEach(
                                                                (element) {
                                                          if (element
                                                                  .focusNode
                                                                  ?.hasFocus ==
                                                              true) {
                                                            element
                                                                .textEditingController
                                                                ?.text = cont
                                                                    .pastTripDataList
                                                                    .elementAt(
                                                                        0)
                                                                    .dAddress ??
                                                                "";
                                                            element.latLng = LatLng(
                                                                cont.pastTripDataList
                                                                        .elementAt(
                                                                            0)
                                                                        .dLatitude ??
                                                                    0,
                                                                cont.pastTripDataList
                                                                        .elementAt(
                                                                            0)
                                                                        .dLongitude ??
                                                                    0);
                                                          }
                                                        });
                                                      }
                                                      // cont.tempLatLngWhereTo1 = LatLng(
                                                      //     cont
                                                      //             .pastTripDataList
                                                      //             .first
                                                      //             .dLatitude ??
                                                      //         0,
                                                      //     cont
                                                      //             .pastTripDataList
                                                      //             .first
                                                      //             .dLongitude ??
                                                      //         0);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          AppImage.clock,
                                                          fit: BoxFit.contain,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                cont.pastTripDataList
                                                                        .isEmpty
                                                                    ? ""
                                                                    : cont
                                                                        .pastTripDataList
                                                                        .elementAt(
                                                                            0)
                                                                        .dAddress!,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize:
                                                                      13,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .w500
                                                                ),
                                                              ),
                                                              Divider(
                                                                color: Colors
                                                                        .grey[
                                                                    900],
                                                                indent: 5,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            cont.pastTripDataList.isEmpty ||
                                                    cont.pastTripDataList
                                                            .length <
                                                        2
                                                ? SizedBox()
                                                : InkWell(
                                                    onTap: () {
                                                      cont.tempLocationWhereTo1
                                                          .clear();
                                                      cont.tempLocationWhereTo1
                                                              .text =
                                                          cont.pastTripDataList
                                                              .elementAt(1)
                                                              .dAddress!;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          AppImage.clock,
                                                          fit: BoxFit.contain,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                cont.pastTripDataList
                                                                    .elementAt(
                                                                        1)
                                                                    .dAddress!,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize:
                                                                      13,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .w500
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: _kGooglePlex,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    mapToolbarEnabled: false,
                                    zoomControlsEnabled: false,
                                    rotateGesturesEnabled: false,
                                    polylines: Set<Polyline>.of(_polyLine),
                                    markers: Set<Marker>.of(_markers),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                          controller.setMapStyle(userCont.mapStyle.value);
                                      _controller = controller;
                                      determinePosition();
                                    },
                                    onCameraIdle: () {
                                      print("CameraMove ==>   onCameraIdle");
                                      if (_cameraMoveLatlng != null &&
                                          cont.isPickFromMap.value) {
                                        cont.searchAddressList.clear();
                                        if (cont
                                            .locationFromFocusNode.hasFocus) {
                                          cont
                                              .getLocationAddress(
                                                  latLng: _cameraMoveLatlng!,
                                                  isFromAddress: true)
                                              .then((value) {
                                            setState(() {});
                                          });
                                        } else if (cont
                                            .locationWhereToFocusNode
                                            .hasFocus) {
                                          cont
                                              .getLocationAddress(
                                                  latLng: _cameraMoveLatlng!,
                                                  isFromAddress: false)
                                              .then((value) {
                                            setState(() {});
                                          });
                                        } else {
                                          cont.multipleLocationAdModelList
                                              .forEach((element) {
                                            if (element.focusNode?.hasFocus ==
                                                true) {
                                              cont
                                                  .getLocationAddress(
                                                      latLng:
                                                          _cameraMoveLatlng!,
                                                      isFromAddress: null)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            }
                                          });
                                        }
                                      }
                                    },
                                    onCameraMoveStarted: () {
                                      print(
                                          "CameraMove ==>   onCameraMoveStarted");
                                    },
                                    onCameraMove:
                                        (CameraPosition cameraPosition) {
                                      print(
                                          "CameraMove ==>  ${cameraPosition.target}");
                                      _cameraMoveLatlng =
                                          cameraPosition.target;
                                    },
                                    onTap: (LatLng latLng) {
                                      showMarker(latLng: latLng);
                                    },
                                  ),
                                  if (cont.isPickFromMap.value)
                                    Image.asset(
                                      AppImage.icPin,
                                      width: 30.w,color: AppColors.primaryColor,
                                    )
                                ],
                              ),
                              if ((userCont.locationResponseModel.value.home
                                          .isNotEmpty ||
                                      userCont.locationResponseModel.value
                                          .work.isNotEmpty ||
                                      (cont.searchAddressList.isNotEmpty) &&
                                          (cont.locationFromFocusNode
                                                  .hasFocus ||
                                              cont.locationWhereToFocusNode
                                                  .hasFocus ||
                                              isFocus)) &&
                                  !cont.isPickFromMap.value) ...[
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 15.w, left: 15.w, top: 70.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // if (cont.searchAddressList.isNotEmpty)
                                        //   ListView.builder(
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 20.w,
                                        //     ),
                                        //     physics:
                                        //         NeverScrollableScrollPhysics(),
                                        //     itemBuilder: (context, index) {
                                        //       AutocompletePrediction
                                        //           autocompletePrediction =
                                        //           cont.searchAddressList[
                                        //               index];
                                        //       return InkWell(
                                        //         onTap: () {
                                        //           if (cont
                                        //               .locationFromFocusNode
                                        //               .hasFocus) {
                                        //             cont.tempLocationFromTo
                                        //                     .text =
                                        //                 autocompletePrediction
                                        //                         .description ??
                                        //                     "";
                                        //           } else if (cont
                                        //               .locationWhereToFocusNode
                                        //               .hasFocus) {
                                        //             cont.tempLocationWhereTo1
                                        //                     .text =
                                        //                 autocompletePrediction
                                        //                         .description ??
                                        //                     "";
                                        //           } else {
                                        //             cont.multipleLocationAdModelList
                                        //                 .forEach((element) {
                                        //               if (element.focusNode
                                        //                       ?.hasFocus ==
                                        //                   true) {
                                        //                 element.textEditingController
                                        //                         ?.text =
                                        //                     autocompletePrediction
                                        //                             .description ??
                                        //                         "";
                                        //               }
                                        //             });
                                        //           }
                                        //           cont
                                        //               .getPlaceIdToLatLag(
                                        //                   placeId:
                                        //                       autocompletePrediction
                                        //                           .placeId!)
                                        //               .then((value) {
                                        //             cont.removeUnFocusManager();
                                        //             setState(() {});
                                        //           });
                                        //           cont.searchAddressList
                                        //               .clear();
                                        //         },
                                        //         child: Container(
                                        //           child: Row(
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .start,
                                        //             children: [
                                        //               Icon(
                                        //                 Icons.location_on,
                                        //               ),
                                        //               Expanded(
                                        //                 child: Column(
                                        //                   mainAxisSize:
                                        //                       MainAxisSize
                                        //                           .min,
                                        //                   crossAxisAlignment:
                                        //                       CrossAxisAlignment
                                        //                           .start,
                                        //                   children: [
                                        //                     Text(autocompletePrediction
                                        //                             .description ??
                                        //                         ""),
                                        //                     // Text(
                                        //                     //   autocompletePrediction.description ??
                                        //                     //       "",
                                        //                     //   style: TextStyle(
                                        //                     //     color: Colors.grey,
                                        //                     //   ),
                                        //                     // ),
                                        //                     if (cont.searchAddressList
                                        //                                 .length -
                                        //                             1 !=
                                        //                         index)
                                        //                       Container(
                                        //                         margin: EdgeInsets
                                        //                             .symmetric(
                                        //                                 vertical:
                                        //                                     5.h),
                                        //                         width: double
                                        //                             .infinity,
                                        //                         height: 1.h,
                                        //                         color: Colors
                                        //                             .grey
                                        //                             .withOpacity(
                                        //                                 0.5),
                                        //                       )
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       );
                                        //     },
                                        //     itemCount:
                                        //         cont.searchAddressList.length,
                                        //     shrinkWrap: true,
                                        //     // physics: NeverScrollableScrollPhysics(),
                                        //   ),

                                        // if (userCont.locationResponseModel.value
                                        //     .home.isNotEmpty) ...[
                                        //   InkWell(
                                        //     onTap: () {
                                        //       Home _home = userCont
                                        //           .locationResponseModel
                                        //           .value
                                        //           .home[0];
                                        //       if (cont.locationFromFocusNode
                                        //           .hasFocus) {
                                        //         cont.tempLocationFromTo.text =
                                        //             _home.address ?? "";
                                        //         cont.tempLatLngFrom = LatLng(
                                        //             _home.latitude ?? 0,
                                        //             _home.longitude ?? 0);
                                        //       } else if (cont
                                        //           .locationWhereToFocusNode
                                        //           .hasFocus) {
                                        //         cont.tempLocationWhereTo1.text =
                                        //             _home.address ?? "";
                                        //         cont.tempLatLngWhereTo1 = LatLng(
                                        //             _home.latitude ?? 0,
                                        //             _home.longitude ?? 0);
                                        //       } else {
                                        //         cont.multipleLocationAdModelList
                                        //             .forEach((element) {
                                        //           if (element
                                        //                   .focusNode?.hasFocus ==
                                        //               true) {
                                        //             element.textEditingController
                                        //                     ?.text =
                                        //                 _home.address ?? "";
                                        //             element.latLng = LatLng(
                                        //                 _home.latitude ?? 0,
                                        //                 _home.longitude ?? 0);
                                        //           }
                                        //         });
                                        //       }
                                        //       cont.searchAddressList.clear();
                                        //     },
                                        //     child: Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //           horizontal: 20.w),
                                        //       child: Column(
                                        //         crossAxisAlignment:
                                        //             CrossAxisAlignment.start,
                                        //         children: [
                                        //           if (cont.searchAddressList
                                        //               .isNotEmpty)
                                        //             Container(
                                        //               margin:
                                        //                   EdgeInsets.symmetric(
                                        //                       vertical: 5.h),
                                        //               width: double.infinity,
                                        //               height: 1.h,
                                        //               color: Colors.grey
                                        //                   .withOpacity(0.5),
                                        //             ),
                                        //           Row(
                                        //             children: [
                                        //               Image.asset(
                                        //                 AppImage.icHome,
                                        //                 width: 20.w,
                                        //               ),
                                        //               SizedBox(width: 5.w),
                                        //               Expanded(
                                        //                 child: Text(
                                        //                   "home".tr,
                                        //                   style: TextStyle(
                                        //                     fontSize: 13.sp,
                                        //                     fontWeight:
                                        //                         FontWeight.w500,
                                        //                   ),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //           Text(
                                        //             userCont
                                        //                     .locationResponseModel
                                        //                     .value
                                        //                     .home[0]
                                        //                     .address ??
                                        //                 "",
                                        //           )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ],
                                        // if (userCont.locationResponseModel.value
                                        //     .work.isNotEmpty) ...[
                                        //   InkWell(
                                        //     onTap: () {
                                        //       Home _home = userCont
                                        //           .locationResponseModel
                                        //           .value
                                        //           .work[0];
                                        //       if (cont.locationFromFocusNode
                                        //           .hasFocus) {
                                        //         cont.tempLocationFromTo.text =
                                        //             _home.address ?? "";
                                        //         cont.tempLatLngFrom = LatLng(
                                        //             _home.latitude ?? 0,
                                        //             _home.longitude ?? 0);
                                        //       } else if (cont
                                        //           .locationWhereToFocusNode
                                        //           .hasFocus) {
                                        //         cont.tempLocationWhereTo1.text =
                                        //             _home.address ?? "";
                                        //         cont.tempLatLngWhereTo1 = LatLng(
                                        //             _home.latitude ?? 0,
                                        //             _home.longitude ?? 0);
                                        //       } else {
                                        //         cont.multipleLocationAdModelList
                                        //             .forEach((element) {
                                        //           if (element
                                        //                   .focusNode?.hasFocus ==
                                        //               true) {
                                        //             element.textEditingController
                                        //                     ?.text =
                                        //                 _home.address ?? "";
                                        //             element.latLng = LatLng(
                                        //                 _home.latitude ?? 0,
                                        //                 _home.longitude ?? 0);
                                        //           }
                                        //         });
                                        //       }
                                        //       cont.searchAddressList.clear();
                                        //     },
                                        //     child: Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //           horizontal: 20.w),
                                        //       child: Column(
                                        //         crossAxisAlignment:
                                        //             CrossAxisAlignment.start,
                                        //         children: [
                                        //           if (cont.searchAddressList
                                        //                   .isNotEmpty ||
                                        //               userCont
                                        //                   .locationResponseModel
                                        //                   .value
                                        //                   .work
                                        //                   .isNotEmpty)
                                        //             Container(
                                        //               margin:
                                        //                   EdgeInsets.symmetric(
                                        //                       vertical: 5.h),
                                        //               width: double.infinity,
                                        //               height: 1.h,
                                        //               color: Colors.grey
                                        //                   .withOpacity(0.5),
                                        //             ),
                                        //           Row(
                                        //             children: [
                                        //               Image.asset(
                                        //                 AppImage.icWork,
                                        //                 width: 20.w,
                                        //               ),
                                        //               SizedBox(width: 5.w),
                                        //               Expanded(
                                        //                 child: Text(
                                        //                   "work".tr,
                                        //                   style: TextStyle(
                                        //                     fontSize: 13.sp,
                                        //                     fontWeight:
                                        //                         FontWeight.w500,
                                        //                   ),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //           Text(
                                        //             userCont
                                        //                     .locationResponseModel
                                        //                     .value
                                        //                     .work[0]
                                        //                     .address ??
                                        //                 "",
                                        //           )
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ]
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              // Container(
                              //   padding: EdgeInsets.only(
                              //     right: 20.w,
                              //     left: 20.w,
                              //     bottom: 15.h,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: AppColors.shadowColor,
                              //         blurRadius: 6.r,
                              //         offset: Offset(0, 5.h),
                              //       )
                              //     ],
                              //     borderRadius: BorderRadius.vertical(
                              //       bottom: Radius.circular(38.r),
                              //     ),
                              //   ),
                              //   child: widget.isSelectHomeAddress == null &&
                              //           !widget.isRideLocationUpdate
                              //       ? Row(
                              //           children: [
                              //             Text("round_trip".tr),
                              //             Spacer(),
                              //             Switch(
                              //               onChanged: (value) {
                              //                 cont.isRoundTrip.value = value;
                              //               },
                              //               value: cont.isRoundTrip.value,
                              //               activeColor: AppColors.primaryColor,
                              //               activeTrackColor:
                              //                   AppColors.primaryColor,
                              //               inactiveThumbColor: AppColors.gray,
                              //               inactiveTrackColor: AppColors
                              //                   .lightGray
                              //                   .withOpacity(0.8),
                              //             )
                              //           ],
                              //         )
                              //       : SizedBox(
                              //           height: 20.h,
                              //           width: double.infinity,
                              //         ),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        }),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () {
  //       // _homeController.clearData();
  //       return Future.value(true);
  //     },
  //     child: Scaffold(
  //       extendBody: true,
  //       extendBodyBehindAppBar: true,
  //       body: GetX<HomeController>(builder: (cont) {
  //         if (cont.error.value.errorType == ErrorType.internet) {
  //           return NoInternetWidget();
  //         }
  //         return GetX<UserController>(builder: (userCont) {
  //           bool isInitLatLng = (cont.tempLatLngFrom != null &&
  //               cont.tempLatLngWhereTo1 != null);
  //           if (widget.isSelectOtherAddress!) {
  //             if (widget.isSelectOtherAddress != null ||
  //                 widget.isRideLocationUpdate) {
  //               isInitLatLng = true;
  //             }
  //           } else {
  //             if (widget.isSelectHomeAddress != null ||
  //                 widget.isRideLocationUpdate) {
  //               isInitLatLng = true;
  //             }
  //           }
  //
  //           if (userCont.error.value.errorType == ErrorType.internet) {
  //             return NoInternetWidget();
  //           }
  //           bool isFocus = false;
  //           cont.multipleLocationAdModelList.forEach((element) {
  //             isInitLatLng = (element.latLng != null && isInitLatLng);
  //             if (!isFocus) {
  //               isFocus = element.focusNode?.hasFocus == true;
  //             }
  //           });
  //
  //           String? profileUrl;
  //           if (userCont.userData.value.picture != null) {
  //             profileUrl =
  //                 "${ApiUrl.baseImageUrl}${userCont.userData.value.picture ?? ""}";
  //           }
  //           return SingleChildScrollView(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height,
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 20.w,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                     ),
  //                     child: SafeArea(
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           SizedBox(height: 15.h),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               InkWell(
  //                                 onTap: () async {
  //                                   Get.back();
  //                                   await _homeController.getDriverMarkerData(
  //                                       updateData: () => setState(() {}));
  //                                   setState(() {
  //                                     isDriverShow = true;
  //                                   });
  //                                 },
  //                                 child: Icon(
  //                                   Icons.arrow_back_ios,
  //                                   size: 20,
  //                                   color: AppColors.primaryColor,
  //                                 ),
  //                               ),
  //                               SizedBox(width: 10.w),
  //                               // Expanded(
  //                               //   child: Row(
  //                               //     mainAxisAlignment: MainAxisAlignment.center,
  //                               //     children: [
  //                               //       Container(
  //                               //         width: 35.w,
  //                               //         height: 35.w,
  //                               //         clipBehavior: Clip.antiAlias,
  //                               //         decoration: BoxDecoration(
  //                               //           color: Colors.grey[200],
  //                               //           shape: BoxShape.circle,
  //                               //         ),
  //                               //         child: profileUrl == null
  //                               //             ? Center(
  //                               //                 child: Icon(
  //                               //                     Icons.perm_identity_outlined,
  //                               //                     color: Colors.grey),
  //                               //               )
  //                               //             : CustomFadeInImage(
  //                               //                 url: profileUrl,
  //                               //                 placeHolderWidget: Icon(
  //                               //                   Icons.perm_identity_outlined,
  //                               //                   color: Colors.grey,
  //                               //                 ),
  //                               //                 fit: BoxFit.cover,
  //                               //               ),
  //                               //       ),
  //                               //       SizedBox(width: 5.w),
  //                               //       Text(
  //                               //         "${userCont.userData.value.firstName ?? ""} ${userCont.userData.value.lastName ?? ""}",
  //                               //         style: TextStyle(
  //                               //           color: AppColors.primaryColor,
  //                               //           fontSize: 12.sp,
  //                               //         ),
  //                               //       ),
  //                               //     ],
  //                               //   ),
  //                               // ),
  //                               SizedBox(width: 10.w),
  //                               InkWell(
  //                                 onTap: () async {
  //                                   if(_homeController.showDriverLocationList.isNotEmpty){
  //                                     await cont.getNearDriverTimeData();
  //                                   }
  //                                   if (isInitLatLng) {
  //                                     if (widget.isSelectOtherAddress!) {
  //                                       if ((widget.isSelectOtherAddress !=
  //                                                   null ||
  //                                               widget.isRideLocationUpdate) &&
  //                                           cont.multipleLocationAdModelList
  //                                               .isNotEmpty) {
  //                                         MultipleLocationAddModel
  //                                             multipleLocationAddModel =
  //                                             cont.multipleLocationAdModelList[
  //                                                 0];
  //                                         Map<String, String> params = {};
  //                                         params["address"] =
  //                                             "${multipleLocationAddModel.textEditingController?.text ?? ""}";
  //                                         params["latitude"] =
  //                                             "${multipleLocationAddModel.latLng?.latitude ?? 0}";
  //                                         params["longitude"] =
  //                                             "${multipleLocationAddModel.latLng?.longitude ?? 0}";
  //                                         params["type"] = "others";
  //                                         Get.back();
  //
  //                                         if (widget.isRideLocationUpdate) {
  //                                           Get.dialog(UpdateAddressDialog(
  //                                               params: params));
  //                                         } else {
  //                                           await _userController.addLocation(
  //                                               params: params);
  //                                         }
  //                                       } else {
  //                                         Get.back();
  //                                       }
  //
  //                                       // Get.to(() => ServiceSelectScreen());
  //                                       if (widget.isSelectOtherAddress ==
  //                                               null &&
  //                                           !widget.isRideLocationUpdate) {
  //                                         cont.selectedLocationDrawRoute();
  //                                       }
  //                                     } else {
  //                                       if ((widget.isSelectHomeAddress !=
  //                                                   null ||
  //                                               widget.isRideLocationUpdate) &&
  //                                           cont.multipleLocationAdModelList
  //                                               .isNotEmpty) {
  //                                         print(
  //                                             "cont.multipleLocationAdModelList==> ${cont.multipleLocationAdModelList[0]}");
  //                                         MultipleLocationAddModel
  //                                             multipleLocationAddModel =
  //                                             cont.multipleLocationAdModelList[
  //                                                 0];
  //                                         Map<String, String> params = {};
  //                                         params["address"] =
  //                                             "${multipleLocationAddModel.textEditingController?.text ?? ""}";
  //                                         params["latitude"] =
  //                                             "${multipleLocationAddModel.latLng?.latitude ?? 0}";
  //                                         params["longitude"] =
  //                                             "${multipleLocationAddModel.latLng?.longitude ?? 0}";
  //                                         params["type"] =
  //                                             widget.isSelectHomeAddress == true
  //                                                 ? "home"
  //                                                 : "work";
  //                                         Get.back();
  //
  //                                         if (widget.isRideLocationUpdate) {
  //                                           Get.dialog(UpdateAddressDialog(
  //                                               params: params));
  //                                         } else {
  //                                           await _userController.addLocation(
  //                                               params: params);
  //                                         }
  //                                       } else {
  //                                         Get.back();
  //                                       }
  //
  //                                       // Get.to(() => ServiceSelectScreen());
  //                                       if (widget.isSelectHomeAddress ==
  //                                               null &&
  //                                           !widget.isRideLocationUpdate) {
  //                                         cont.selectedLocationDrawRoute();
  //                                       }
  //                                     }
  //                                   }
  //                                   setState(() {
  //                                     isDriverShow = false;
  //                                   });
  //                                 },
  //                                 child: Text(
  //                                   "done".tr,
  //                                   style: TextStyle(
  //                                       color: isInitLatLng
  //                                           ? Colors.black
  //                                           : Colors.grey,
  //                                       fontSize: 17),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(height: 10.h),
  //
  //                           if (widget.isSelectHomeAddress == null ||
  //                               widget.isSelectOtherAddress == null &&
  //                                   !widget.isRideLocationUpdate) ...[
  //                             Container(
  //                               padding: EdgeInsets.all(5),
  //                               decoration: BoxDecoration(
  //                                 color: Color(0xffF0EFEF),
  //                                 borderRadius: BorderRadius.circular(10.r),
  //                                 // boxShadow: [
  //                                 //   AppBoxShadow.defaultShadow(),
  //                                 // ]
  //                               ),
  //                               child: Row(
  //                                 children: [
  //                                   SizedBox(width: 5.w),
  //                                   Text(
  //                                     'from:'.tr,
  //                                     style: TextStyle(
  //                                         color: AppColors.primaryColor),
  //                                   ),
  //                                   SizedBox(width: 5.w),
  //                                   Expanded(
  //                                       child: Container(
  //                                     child: TextFormField(
  //                                       focusNode: cont.locationFromFocusNode,
  //                                       controller: cont.tempLocationFromTo,
  //                                       style: TextStyle(
  //                                         fontSize: 12.sp,
  //                                       ),
  //                                       decoration: InputDecoration(
  //                                         hintText: "from_to".tr,
  //                                         border: InputBorder.none,
  //                                         hintStyle: TextStyle(
  //                                             color: Color(0xff9F9F9F)),
  //                                         contentPadding: EdgeInsets.symmetric(
  //                                           horizontal: 5.w,
  //                                           vertical: 12.h,
  //                                         ),
  //                                         isDense: true,
  //                                       ),
  //                                       onChanged: (s) async {
  //                                         await cont.getLocationFromAddress(
  //                                             address: s);
  //                                       },
  //                                     ),
  //                                   )),
  //                                   IconButton(
  //                                       onPressed: () {
  //                                         cont.tempLocationFromTo.clear();
  //                                         print("1111111111");
  //                                       },
  //                                       icon: Icon(Icons.edit))
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 15.h,
  //                             ),
  //                             widget.isRideLocationUpdate
  //                                 ? SizedBox()
  //                                 : Container(
  //                                     padding: EdgeInsets.all(5),
  //                                     decoration: BoxDecoration(
  //                                       color: Color(0xffF0EFEF),
  //                                       borderRadius:
  //                                           BorderRadius.circular(10.r),
  //                                       // boxShadow: [
  //                                       //   AppBoxShadow.defaultShadow(),
  //                                       // ]
  //                                     ),
  //                                     child: InkWell(
  //                                       onTap: () {
  //                                         setState(() {
  //                                           showBottom = true;
  //                                         });
  //                                       },
  //                                       child: Row(
  //                                         children: [
  //                                           SizedBox(width: 5.w),
  //                                           Text(
  //                                             'to:'.tr,
  //                                             style: TextStyle(
  //                                                 color:
  //                                                     AppColors.primaryColor),
  //                                           ),
  //                                           SizedBox(width: 5.w),
  //                                           Expanded(
  //                                               child: Container(
  //                                             child: TextFormField(
  //                                               focusNode: cont
  //                                                   .locationWhereToFocusNode,
  //                                               controller:
  //                                                   cont.tempLocationWhereTo1,
  //                                               style: TextStyle(
  //                                                 fontSize: 12.sp,
  //                                               ),
  //                                               decoration: InputDecoration(
  //                                                 hintText:
  //                                                     "enter_destination".tr,
  //                                                 border: InputBorder.none,
  //                                                 isDense: true,
  //                                                 hintStyle: TextStyle(
  //                                                     color: Color(0xff9F9F9F)),
  //                                                 contentPadding:
  //                                                     EdgeInsets.symmetric(
  //                                                         horizontal: 10.w,
  //                                                         vertical: 12.h),
  //                                               ),
  //                                               onChanged: (s) async {
  //                                                 await cont
  //                                                     .getLocationFromAddress(
  //                                                         address: s);
  //                                               },
  //                                             ),
  //                                           )),
  //                                           Icon(Icons.search_rounded),
  //                                           SizedBox(width: 10.w),
  //                                           if ((cont
  //                                                   .multipleLocationAdModelList
  //                                                   .length <
  //                                               2))
  //                                             InkWell(
  //                                               onTap: () {
  //                                                 MultipleLocationAddModel
  //                                                     multipleLocationAddModel =
  //                                                     MultipleLocationAddModel();
  //
  //                                                 multipleLocationAddModel
  //                                                         .onChange =
  //                                                     (String s) async {
  //                                                   log("message  ==>  $s");
  //                                                   await cont
  //                                                       .getLocationFromAddress(
  //                                                           address: s);
  //                                                 };
  //                                                 multipleLocationAddModel
  //                                                     .remove = () {
  //                                                   cont.multipleLocationAdModelList
  //                                                       .remove(
  //                                                           multipleLocationAddModel);
  //                                                 };
  //
  //                                                 cont.multipleLocationAdModelList
  //                                                     .add(
  //                                                         multipleLocationAddModel);
  //                                               },
  //                                               child: Container(
  //                                                 width: 35.w,
  //                                                 height: 35.w,
  //                                                 decoration: BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     borderRadius:
  //                                                         BorderRadius.circular(
  //                                                             10.r),
  //                                                     boxShadow: [
  //                                                       AppBoxShadow
  //                                                           .defaultShadow()
  //                                                     ]),
  //                                                 child: Icon(
  //                                                   Icons.add,
  //                                                   size: 20.w,
  //                                                 ),
  //                                               ),
  //                                             )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                           ],
  //                           // Row(
  //                           //   children: [
  //                           //     Text("Pick From Map"),
  //                           //     Spacer(),
  //                           //     Switch(
  //                           //       onChanged: toggleSwitch,
  //                           //       value: isSwitched,
  //                           //       activeColor: AppColors.primaryColor,
  //                           //       activeTrackColor: AppColors.primaryColor,
  //                           //       inactiveThumbColor: Colors.grey,
  //                           //       inactiveTrackColor: Colors.grey,
  //                           //     )
  //                           //   ],
  //                           // ),
  //
  //                           ListView.builder(
  //                             padding: EdgeInsets.only(top: 5.h),
  //                             itemBuilder: (context, index) {
  //                               MultipleLocationAddModel
  //                                   multipleLocationAddModel =
  //                                   cont.multipleLocationAdModelList[index];
  //                               return Padding(
  //                                 padding: EdgeInsets.symmetric(vertical: 10.h),
  //                                 child: multipleLocationAddModel.getWidget(),
  //                               );
  //                             },
  //                             itemCount:
  //                                 cont.multipleLocationAdModelList.length,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             shrinkWrap: true,
  //                           ),
  //
  //                           if (cont.searchAddressList.isNotEmpty)
  //                             SingleChildScrollView(
  //                               child: Container(
  //                                 height: 120,
  //                                 child: ListView.builder(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 12.w, vertical: 10),
  //                                   // physics: NeverScrollableScrollPhysics(),
  //                                   itemBuilder: (context, index) {
  //                                     AutocompletePrediction
  //                                         autocompletePrediction =
  //                                         cont.searchAddressList[index];
  //                                     return InkWell(
  //                                       onTap: () {
  //                                         if (cont
  //                                             .locationFromFocusNode.hasFocus) {
  //                                           cont.tempLocationFromTo.text =
  //                                               autocompletePrediction
  //                                                       .description ??
  //                                                   "";
  //                                         } else if (cont
  //                                             .locationWhereToFocusNode
  //                                             .hasFocus) {
  //                                           cont.tempLocationWhereTo1.text =
  //                                               autocompletePrediction
  //                                                       .description ??
  //                                                   "";
  //                                         } else {
  //                                           cont.multipleLocationAdModelList
  //                                               .forEach((element) {
  //                                             if (element.focusNode?.hasFocus ==
  //                                                 true) {
  //                                               element.textEditingController
  //                                                       ?.text =
  //                                                   autocompletePrediction
  //                                                           .description ??
  //                                                       "";
  //                                             }
  //                                           });
  //                                         }
  //                                         cont
  //                                             .getPlaceIdToLatLag(
  //                                                 placeId:
  //                                                     autocompletePrediction
  //                                                         .placeId!)
  //                                             .then((value) {
  //                                           cont.removeUnFocusManager();
  //                                           setState(() {});
  //                                         });
  //                                         cont.searchAddressList.clear();
  //                                       },
  //                                       child: Container(
  //                                         child: Row(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                           children: [
  //                                             Icon(
  //                                               Icons.location_on,
  //                                             ),
  //                                             Expanded(
  //                                               child: Column(
  //                                                 mainAxisSize:
  //                                                     MainAxisSize.min,
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text(autocompletePrediction
  //                                                           .description ??
  //                                                       ""),
  //                                                   // Text(
  //                                                   //   autocompletePrediction.description ??
  //                                                   //       "",
  //                                                   //   style: TextStyle(
  //                                                   //     color: Colors.grey,
  //                                                   //   ),
  //                                                   // ),
  //                                                   if (cont.searchAddressList
  //                                                               .length -
  //                                                           1 !=
  //                                                       index)
  //                                                     Container(
  //                                                       margin: EdgeInsets
  //                                                           .symmetric(
  //                                                               vertical: 5.h),
  //                                                       width: double.infinity,
  //                                                       height: 1.h,
  //                                                       color: Colors.grey
  //                                                           .withOpacity(0.5),
  //                                                     )
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                   itemCount: cont.searchAddressList.length,
  //                                   shrinkWrap: true,
  //                                   // physics: NeverScrollableScrollPhysics(),
  //                                 ),
  //                               ),
  //                             ),
  //                           if (widget.isSelectHomeAddress == null ||
  //                               widget.isSelectOtherAddress == null &&
  //                                   !widget.isRideLocationUpdate) ...[
  //                             widget.isRideLocationUpdate
  //                                 ? SizedBox()
  //                                 : Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceAround,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           Text("pick_from_map".tr),
  //                                           IconButton(
  //                                               onPressed: () {
  //                                                 cont.isPickFromMap.value =
  //                                                     !cont.isPickFromMap.value;
  //                                                 print(
  //                                                     "cont.isPickFromMap.value===>${cont.isPickFromMap.value}");
  //                                                 FocusScope.of(context)
  //                                                     .unfocus();
  //                                               },
  //                                               icon: Image.asset(
  //                                                 AppImage.pin,
  //                                                 height: 25,
  //                                                 width: 25,
  //                                               ))
  //                                           // Switch(
  //                                           //   onChanged: (v) {
  //                                           //     cont.isPickFromMap.value = v;
  //                                           //   },
  //                                           //   value: cont.isPickFromMap.value,
  //                                           //   activeColor: AppColors.primaryColor,
  //                                           //   activeTrackColor: AppColors.primaryColor,
  //                                           //   inactiveThumbColor: AppColors.gray,
  //                                           //   inactiveTrackColor:
  //                                           //       AppColors.lightGray.withOpacity(0.8),
  //                                           // )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Text("round_trip".tr),
  //                                           // Spacer(),
  //                                           Switch(
  //                                             onChanged: (value) {
  //                                               cont.isRoundTrip.value = value;
  //                                             },
  //                                             value: cont.isRoundTrip.value,
  //                                             activeColor:
  //                                                 AppColors.primaryColor,
  //                                             activeTrackColor:
  //                                                 AppColors.primaryColor,
  //                                             inactiveThumbColor:
  //                                                 AppColors.gray,
  //                                             inactiveTrackColor: AppColors
  //                                                 .lightGray
  //                                                 .withOpacity(0.8),
  //                                           )
  //                                         ],
  //                                       )
  //                                     ],
  //                                   ),
  //                             if (cont.isPickFromMap.value == false)
  //                               widget.isRideLocationUpdate
  //                                   ? SizedBox()
  //                                   : Column(
  //                                       children: [
  //                                         Column(
  //                                           children: [
  //                                             if (userCont.locationResponseModel
  //                                                 .value.home.isNotEmpty)
  //                                               InkWell(
  //                                                 onTap: () {
  //                                                   Home _home = userCont
  //                                                       .locationResponseModel
  //                                                       .value
  //                                                       .home
  //                                                       .last;
  //                                                   if (cont
  //                                                       .locationFromFocusNode
  //                                                       .hasFocus) {
  //                                                     cont.tempLocationFromTo
  //                                                             .text =
  //                                                         _home.address ?? "";
  //                                                     cont.tempLatLngFrom =
  //                                                         LatLng(
  //                                                             _home.latitude ??
  //                                                                 0,
  //                                                             _home.longitude ??
  //                                                                 0);
  //                                                   } else if (cont
  //                                                       .locationWhereToFocusNode
  //                                                       .hasFocus) {
  //                                                     cont.tempLocationWhereTo1
  //                                                             .text =
  //                                                         _home.address ?? "";
  //                                                     cont.tempLatLngWhereTo1 =
  //                                                         LatLng(
  //                                                             _home.latitude ??
  //                                                                 0,
  //                                                             _home.longitude ??
  //                                                                 0);
  //                                                   } else {
  //                                                     cont.multipleLocationAdModelList
  //                                                         .forEach((element) {
  //                                                       if (element.focusNode
  //                                                               ?.hasFocus ==
  //                                                           true) {
  //                                                         element
  //                                                             .textEditingController
  //                                                             ?.text = _home
  //                                                                 .address ??
  //                                                             "";
  //                                                         element.latLng = LatLng(
  //                                                             _home.latitude ??
  //                                                                 0,
  //                                                             _home.longitude ??
  //                                                                 0);
  //                                                       }
  //                                                     });
  //                                                   }
  //                                                   cont.searchAddressList
  //                                                       .clear();
  //                                                 },
  //                                                 child: Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment.start,
  //                                                   children: [
  //                                                     Card(
  //                                                         child: Padding(
  //                                                       padding:
  //                                                           const EdgeInsets
  //                                                               .all(6.0),
  //                                                       child: Icon(
  //                                                         Icons.home,
  //                                                       ),
  //                                                     )),
  //                                                     SizedBox(
  //                                                       width: 15.w,
  //                                                     ),
  //                                                     Expanded(
  //                                                       child: Column(
  //                                                         crossAxisAlignment:
  //                                                             CrossAxisAlignment
  //                                                                 .start,
  //                                                         children: [
  //                                                           Text(
  //                                                             'home'.tr,
  //                                                             style: TextStyle(
  //                                                                 color: Colors
  //                                                                         .grey[
  //                                                                     600],
  //                                                                 fontSize: 14,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500),
  //                                                           ),
  //                                                           Text(
  //                                                               userCont
  //                                                                       .locationResponseModel
  //                                                                       .value
  //                                                                       .home
  //                                                                       .last
  //                                                                       .address ??
  //                                                                   "",
  //                                                               maxLines: 1,
  //                                                               overflow:
  //                                                                   TextOverflow
  //                                                                       .ellipsis,
  //                                                               style: TextStyle(
  //                                                                   color: Colors
  //                                                                       .grey,
  //                                                                   fontSize:
  //                                                                       12)),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               )
  //                                             else
  //                                               Row(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment.start,
  //                                                 children: [
  //                                                   Card(
  //                                                       child: Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.all(
  //                                                             6.0),
  //                                                     child: Icon(
  //                                                       Icons.home,
  //                                                     ),
  //                                                   )),
  //                                                   SizedBox(
  //                                                     width: 15.w,
  //                                                   ),
  //                                                   Column(
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       Text(
  //                                                         'home'.tr,
  //                                                         style: TextStyle(
  //                                                             color: Colors
  //                                                                 .grey[600],
  //                                                             fontSize: 14,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       ),
  //                                                       Text(
  //                                                           'home_destination_is_not_added'
  //                                                               .tr,
  //                                                           style: TextStyle(
  //                                                               color:
  //                                                                   Colors.grey,
  //                                                               fontSize: 12)),
  //                                                     ],
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                           ],
  //                                         ),
  //                                         Divider(
  //                                           indent: 40,
  //                                           endIndent: 40,
  //                                         ),
  //                                         if (userCont.locationResponseModel
  //                                             .value.work.isNotEmpty)
  //                                           InkWell(
  //                                             onTap: () {
  //                                               Home _home = userCont
  //                                                   .locationResponseModel
  //                                                   .value
  //                                                   .work
  //                                                   .last;
  //                                               if (cont.locationFromFocusNode
  //                                                   .hasFocus) {
  //                                                 print("enter 1");
  //                                                 cont.tempLocationFromTo.text =
  //                                                     _home.address ?? "";
  //                                                 cont.tempLatLngFrom = LatLng(
  //                                                     _home.latitude ?? 0,
  //                                                     _home.longitude ?? 0);
  //                                               } else if (cont
  //                                                   .locationWhereToFocusNode
  //                                                   .hasFocus) {
  //                                                 print("enter 2");
  //                                                 cont.tempLocationWhereTo1
  //                                                         .text =
  //                                                     _home.address ?? "";
  //                                                 cont.tempLatLngWhereTo1 =
  //                                                     LatLng(
  //                                                         _home.latitude ?? 0,
  //                                                         _home.longitude ?? 0);
  //                                               } else {
  //                                                 print("enter 3");
  //                                                 cont.multipleLocationAdModelList
  //                                                     .forEach((element) {
  //                                                   if (element.focusNode
  //                                                           ?.hasFocus ==
  //                                                       true) {
  //                                                     element
  //                                                         .textEditingController
  //                                                         ?.text = _home
  //                                                             .address ??
  //                                                         "";
  //                                                     element.latLng = LatLng(
  //                                                         _home.latitude ?? 0,
  //                                                         _home.longitude ?? 0);
  //                                                   }
  //                                                 });
  //                                               }
  //                                               cont.searchAddressList.clear();
  //                                             },
  //                                             child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.start,
  //                                               children: [
  //                                                 Card(
  //                                                     child: Padding(
  //                                                   padding:
  //                                                       const EdgeInsets.all(
  //                                                           6.0),
  //                                                   child: Icon(
  //                                                     Icons
  //                                                         .shopping_bag_rounded,
  //                                                   ),
  //                                                 )),
  //                                                 SizedBox(
  //                                                   width: 15.w,
  //                                                 ),
  //                                                 Expanded(
  //                                                   child: Column(
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       Text(
  //                                                         'work'.tr,
  //                                                         style: TextStyle(
  //                                                             color: Colors
  //                                                                 .grey[600],
  //                                                             fontSize: 14,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       ),
  //                                                       Text(
  //                                                           userCont
  //                                                                   .locationResponseModel
  //                                                                   .value
  //                                                                   .work
  //                                                                   .last
  //                                                                   .address ??
  //                                                               "",
  //                                                           maxLines: 1,
  //                                                           overflow:
  //                                                               TextOverflow
  //                                                                   .ellipsis,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.grey,
  //                                                             fontSize: 12,
  //                                                           )),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           )
  //                                         else
  //                                           Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Card(
  //                                                   child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(6.0),
  //                                                 child: Icon(
  //                                                   Icons.shopping_bag_rounded,
  //                                                 ),
  //                                               )),
  //                                               SizedBox(
  //                                                 width: 15.w,
  //                                               ),
  //                                               Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text(
  //                                                     'work',
  //                                                     style: TextStyle(
  //                                                         color:
  //                                                             Colors.grey[600],
  //                                                         fontSize: 14,
  //                                                         fontWeight:
  //                                                             FontWeight.w500),
  //                                                   ),
  //                                                   Text(
  //                                                       'work_destination_is_not_added'
  //                                                           .tr,
  //                                                       style: TextStyle(
  //                                                         color: Colors.grey,
  //                                                         fontSize: 12,
  //                                                       )),
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         SizedBox(
  //                                           height: 10.h,
  //                                         ),
  //                                         Divider(
  //                                           indent: 40,
  //                                           endIndent: 40,
  //                                         ),
  //                                         if (userCont.locationResponseModel
  //                                             .value.others.isNotEmpty)
  //                                           InkWell(
  //                                             onTap: () {
  //                                               Home _home = userCont
  //                                                   .locationResponseModel
  //                                                   .value
  //                                                   .others
  //                                                   .last;
  //                                               if (cont.locationFromFocusNode
  //                                                   .hasFocus) {
  //                                                 cont.tempLocationFromTo.text =
  //                                                     _home.address ?? "";
  //                                                 cont.tempLatLngFrom = LatLng(
  //                                                     _home.latitude ?? 0,
  //                                                     _home.longitude ?? 0);
  //                                               } else if (cont
  //                                                   .locationWhereToFocusNode
  //                                                   .hasFocus) {
  //                                                 cont.tempLocationWhereTo1
  //                                                         .text =
  //                                                     _home.address ?? "";
  //                                                 cont.tempLatLngWhereTo1 =
  //                                                     LatLng(
  //                                                         _home.latitude ?? 0,
  //                                                         _home.longitude ?? 0);
  //                                               } else {
  //                                                 cont.multipleLocationAdModelList
  //                                                     .forEach((element) {
  //                                                   if (element.focusNode
  //                                                           ?.hasFocus ==
  //                                                       true) {
  //                                                     element
  //                                                         .textEditingController
  //                                                         ?.text = _home
  //                                                             .address ??
  //                                                         "";
  //                                                     element.latLng = LatLng(
  //                                                         _home.latitude ?? 0,
  //                                                         _home.longitude ?? 0);
  //                                                   }
  //                                                 });
  //                                               }
  //                                               cont.searchAddressList.clear();
  //                                             },
  //                                             child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.start,
  //                                               children: [
  //                                                 Card(
  //                                                     child: Padding(
  //                                                   padding:
  //                                                       const EdgeInsets.all(
  //                                                           6.0),
  //                                                   child: Icon(
  //                                                     Icons.favorite,
  //                                                   ),
  //                                                 )),
  //                                                 SizedBox(
  //                                                   width: 15.w,
  //                                                 ),
  //                                                 Expanded(
  //                                                   child: Column(
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       Text(
  //                                                         'other'.tr,
  //                                                         style: TextStyle(
  //                                                             color: Colors
  //                                                                 .grey[600],
  //                                                             fontSize: 14,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       ),
  //                                                       Text(
  //                                                           userCont
  //                                                                   .locationResponseModel
  //                                                                   .value
  //                                                                   .others
  //                                                                   .last
  //                                                                   .address ??
  //                                                               "",
  //                                                           maxLines: 1,
  //                                                           overflow:
  //                                                               TextOverflow
  //                                                                   .ellipsis,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.grey,
  //                                                             fontSize: 12,
  //                                                           )),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           )
  //                                         else
  //                                           Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.start,
  //                                             children: [
  //                                               Card(
  //                                                   child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(6.0),
  //                                                 child: Icon(
  //                                                   Icons.favorite,
  //                                                 ),
  //                                               )),
  //                                               SizedBox(
  //                                                 width: 15.w,
  //                                               ),
  //                                               Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Text(
  //                                                     'other'.tr,
  //                                                     style: TextStyle(
  //                                                         color:
  //                                                             Colors.grey[600],
  //                                                         fontSize: 14,
  //                                                         fontWeight:
  //                                                             FontWeight.w500),
  //                                                   ),
  //                                                   Text(
  //                                                       'address_is_not_added'
  //                                                           .tr,
  //                                                       style: TextStyle(
  //                                                         color: Colors.grey,
  //                                                         fontSize: 12,
  //                                                       )),
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         Column(
  //                                           children: [
  //                                             // InkWell(
  //                                             //   onTap: () {
  //                                             //     print("sffdf");
  //                                             //     // getOtherAddressData(
  //                                             //     //     otherAddressData:
  //                                             //     //         otherAddressData,
  //                                             //     //     setStateData: () => () {
  //                                             //     //           setState(() {});
  //                                             //     //         });
  //                                             //   },
  //                                             //   child: Row(
  //                                             //     mainAxisAlignment:
  //                                             //         MainAxisAlignment.start,
  //                                             //     children: [
  //                                             //       Card(
  //                                             //           shape: RoundedRectangleBorder(
  //                                             //               borderRadius:
  //                                             //                   BorderRadius.circular(
  //                                             //                       5)),
  //                                             //           child: Padding(
  //                                             //             padding:
  //                                             //                 const EdgeInsets.all(
  //                                             //                     6.0),
  //                                             //             child: Icon(
  //                                             //               Icons.favorite,
  //                                             //             ),
  //                                             //           )),
  //                                             //       SizedBox(
  //                                             //         width: 15.w,
  //                                             //       ),
  //                                             //       Text(
  //                                             //         'Other',
  //                                             //         style: TextStyle(
  //                                             //             color: Colors.grey[600],
  //                                             //             fontSize: 14,
  //                                             //             fontWeight:
  //                                             //                 FontWeight.w500),
  //                                             //       ),
  //                                             //       IconButton(
  //                                             //           onPressed: null,
  //                                             //           icon: Icon(
  //                                             //             Icons.arrow_forward_ios,
  //                                             //             size: 20,
  //                                             //             color:
  //                                             //                 AppColors.primaryColor,
  //                                             //           ))
  //                                             //     ],
  //                                             //   ),
  //                                             // ),
  //                                             SizedBox(
  //                                               height: 20,
  //                                             ),
  //                                             Column(
  //                                               children: [
  //                                                 Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment.start,
  //                                                   children: [
  //                                                     SizedBox(
  //                                                       width: 10,
  //                                                     ),
  //                                                     Text(
  //                                                       'recent_locations'.tr,
  //                                                       style: TextStyle(
  //                                                           color: AppColors
  //                                                               .primaryColor,
  //                                                           fontSize: 15,
  //                                                           fontWeight:
  //                                                               FontWeight
  //                                                                   .w500),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                                 SizedBox(
  //                                                   height: 8,
  //                                                 ),
  //                                                 cont.pastTripDataList.isEmpty
  //                                                     ? Text(
  //                                                         'No Recent Location',
  //                                                         style: TextStyle(
  //                                                             color: AppColors
  //                                                                 .primaryColor,
  //                                                             fontSize: 15,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       )
  //                                                     : InkWell(
  //                                                         onTap: () {
  //                                                           cont.tempLocationWhereTo1
  //                                                               .clear();
  //
  //                                                           if (cont
  //                                                               .locationFromFocusNode
  //                                                               .hasFocus) {
  //                                                             print("enter 1");
  //                                                             cont.tempLocationFromTo
  //                                                                 .text = cont
  //                                                                     .pastTripDataList
  //                                                                     .elementAt(
  //                                                                         0)
  //                                                                     .dAddress! ??
  //                                                                 "";
  //                                                             cont.tempLatLngFrom = LatLng(
  //                                                                 cont.pastTripDataList
  //                                                                         .elementAt(
  //                                                                             0)
  //                                                                         .dLatitude ??
  //                                                                     0,
  //                                                                 cont.pastTripDataList
  //                                                                         .elementAt(
  //                                                                             0)
  //                                                                         .dLongitude ??
  //                                                                     0);
  //                                                           } else if (cont
  //                                                               .locationWhereToFocusNode
  //                                                               .hasFocus) {
  //                                                             print("enter 2");
  //                                                             cont.tempLocationWhereTo1
  //                                                                 .text = cont
  //                                                                     .pastTripDataList
  //                                                                     .elementAt(
  //                                                                         0)
  //                                                                     .dAddress ??
  //                                                                 "";
  //                                                             cont.tempLatLngWhereTo1 = LatLng(
  //                                                                 cont.pastTripDataList
  //                                                                         .elementAt(
  //                                                                             0)
  //                                                                         .dLatitude ??
  //                                                                     0,
  //                                                                 cont.pastTripDataList
  //                                                                         .elementAt(
  //                                                                             0)
  //                                                                         .dLongitude ??
  //                                                                     0);
  //                                                           } else {
  //                                                             print("enter 3");
  //                                                             cont.multipleLocationAdModelList
  //                                                                 .forEach(
  //                                                                     (element) {
  //                                                               if (element
  //                                                                       .focusNode
  //                                                                       ?.hasFocus ==
  //                                                                   true) {
  //                                                                 element
  //                                                                     .textEditingController
  //                                                                     ?.text = cont
  //                                                                         .pastTripDataList
  //                                                                         .elementAt(
  //                                                                             0)
  //                                                                         .dAddress ??
  //                                                                     "";
  //                                                                 element.latLng = LatLng(
  //                                                                     cont.pastTripDataList
  //                                                                             .elementAt(
  //                                                                                 0)
  //                                                                             .dLatitude ??
  //                                                                         0,
  //                                                                     cont.pastTripDataList
  //                                                                             .elementAt(0)
  //                                                                             .dLongitude ??
  //                                                                         0);
  //                                                               }
  //                                                             });
  //                                                           }
  //                                                           // cont.tempLatLngWhereTo1 = LatLng(
  //                                                           //     cont
  //                                                           //             .pastTripDataList
  //                                                           //             .first
  //                                                           //             .dLatitude ??
  //                                                           //         0,
  //                                                           //     cont
  //                                                           //             .pastTripDataList
  //                                                           //             .first
  //                                                           //             .dLongitude ??
  //                                                           //         0);
  //                                                         },
  //                                                         child: Row(
  //                                                           children: [
  //                                                             Image.asset(
  //                                                               AppImage.clock,
  //                                                               fit: BoxFit
  //                                                                   .contain,
  //                                                               height: 30,
  //                                                               width: 30,
  //                                                             ),
  //                                                             SizedBox(
  //                                                               width: 20,
  //                                                             ),
  //                                                             Expanded(
  //                                                               child: Column(
  //                                                                 mainAxisAlignment:
  //                                                                     MainAxisAlignment
  //                                                                         .start,
  //                                                                 crossAxisAlignment:
  //                                                                     CrossAxisAlignment
  //                                                                         .start,
  //                                                                 children: [
  //                                                                   Text(
  //                                                                     cont.pastTripDataList
  //                                                                             .isEmpty
  //                                                                         ? ""
  //                                                                         : cont
  //                                                                             .pastTripDataList
  //                                                                             .elementAt(0)
  //                                                                             .dAddress!,
  //                                                                     maxLines:
  //                                                                         2,
  //                                                                     overflow:
  //                                                                         TextOverflow
  //                                                                             .ellipsis,
  //                                                                     style:
  //                                                                         TextStyle(
  //                                                                       color: Colors
  //                                                                           .grey[600],
  //                                                                       fontSize:
  //                                                                           13,
  //                                                                       // fontWeight:
  //                                                                       //     FontWeight
  //                                                                       //         .w500
  //                                                                     ),
  //                                                                   ),
  //                                                                   Divider(
  //                                                                     color: Colors
  //                                                                             .grey[
  //                                                                         900],
  //                                                                     indent: 5,
  //                                                                   )
  //                                                                 ],
  //                                                               ),
  //                                                             )
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                 SizedBox(
  //                                                   height: 4,
  //                                                 ),
  //                                                 cont.pastTripDataList.isEmpty ||
  //                                                 cont.pastTripDataList
  //                                                             .length <
  //                                                         2
  //                                                     ? SizedBox()
  //                                                     : InkWell(
  //                                                         onTap: () {
  //                                                           cont.tempLocationWhereTo1
  //                                                               .clear();
  //                                                           cont.tempLocationWhereTo1
  //                                                                   .text =
  //                                                               cont.pastTripDataList
  //                                                                   .elementAt(
  //                                                                       1)
  //                                                                   .dAddress!;
  //                                                         },
  //                                                         child: Row(
  //                                                           children: [
  //                                                             Image.asset(
  //                                                               AppImage.clock,
  //                                                               fit: BoxFit
  //                                                                   .contain,
  //                                                               height: 30,
  //                                                               width: 30,
  //                                                             ),
  //                                                             SizedBox(
  //                                                               width: 20,
  //                                                             ),
  //                                                             Expanded(
  //                                                               child: Column(
  //                                                                 mainAxisAlignment:
  //                                                                     MainAxisAlignment
  //                                                                         .start,
  //                                                                 crossAxisAlignment:
  //                                                                     CrossAxisAlignment
  //                                                                         .start,
  //                                                                 children: [
  //                                                                   // Text(
  //                                                                   //   'Mozilit',
  //                                                                   //   style: TextStyle(
  //                                                                   //       color: AppColors
  //                                                                   //           .primaryColor,
  //                                                                   //       fontSize:
  //                                                                   //           16,
  //                                                                   //       fontWeight:
  //                                                                   //           FontWeight
  //                                                                   //               .w500),
  //                                                                   // ),
  //                                                                   Text(
  //                                                                     cont.pastTripDataList
  //                                                                         .elementAt(
  //                                                                             1)
  //                                                                         .dAddress!,
  //                                                                     maxLines:
  //                                                                         2,
  //                                                                     overflow:
  //                                                                         TextOverflow
  //                                                                             .ellipsis,
  //                                                                     style:
  //                                                                         TextStyle(
  //                                                                       color: Colors
  //                                                                           .grey[600],
  //                                                                       fontSize:
  //                                                                           13,
  //                                                                       // fontWeight:
  //                                                                       //     FontWeight
  //                                                                       //         .w500
  //                                                                     ),
  //                                                                   ),
  //                                                                 ],
  //                                                               ),
  //                                                             )
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                             SizedBox(
  //                               height: 10.h,
  //                             ),
  //                           ]
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       children: [
  //                         Expanded(
  //                           child: Stack(
  //                             children: [
  //                               Stack(
  //                                 alignment: Alignment.center,
  //                                 children: [
  //                                   GoogleMap(
  //                                     mapType: MapType.normal,
  //                                     initialCameraPosition: _kGooglePlex,
  //                                     myLocationEnabled: true,
  //                                     myLocationButtonEnabled: false,
  //                                     mapToolbarEnabled: false,
  //                                     zoomControlsEnabled: false,
  //                                     rotateGesturesEnabled: false,
  //                                     polylines: Set<Polyline>.of(_polyLine),
  //                                     markers: Set<Marker>.of(_markers),
  //                                     onMapCreated:
  //                                         (GoogleMapController controller) {
  //                                       _controller = controller;
  //                                       determinePosition();
  //                                     },
  //                                     onCameraIdle: () {
  //                                       print("CameraMove ==>${cont
  //                                           .locationFromFocusNode.hasFocus}");
  //
  //                                       if (_cameraMoveLatlng != null &&
  //                                           cont.isPickFromMap.value) {
  //                                         cont.searchAddressList.clear();
  //                                         if (cont
  //                                             .locationFromFocusNode.hasFocus) {
  //                                           print("enter00");
  //                                           print("cameraMoveLatlng====>${_cameraMoveLatlng}");
  //                                           cont
  //                                               .getLocationAddress(
  //                                                   latLng: _cameraMoveLatlng!,
  //                                                   isFromAddress: true)
  //                                               .then((value) {
  //                                             setState(() {});
  //                                           });
  //                                         } else if (cont
  //                                             .locationWhereToFocusNode
  //                                             .hasFocus) {
  //                                           print("enter0");
  //                                           cont
  //                                               .getLocationAddress(
  //                                                   latLng: _cameraMoveLatlng!,
  //                                                   isFromAddress: false)
  //                                               .then((value) {
  //                                             setState(() {});
  //                                           });
  //                                         } else {
  //                                           cont.multipleLocationAdModelList
  //                                               .forEach((element) {
  //                                                 print("enter00");
  //                                             if (element.focusNode?.hasFocus ==
  //                                                 true) {
  //                                               cont
  //                                                   .getLocationAddress(
  //                                                       latLng:
  //                                                           _cameraMoveLatlng!,
  //                                                       isFromAddress: null)
  //                                                   .then((value) {
  //                                                 setState(() {});
  //                                               });
  //                                             }
  //                                           });
  //                                         }
  //                                       }
  //                                     },
  //                                     onCameraMoveStarted: () {
  //                                       print(
  //                                           "CameraMove ==>   onCameraMoveStarted");
  //                                     },
  //                                     onCameraMove:
  //                                         (CameraPosition cameraPosition) {
  //                                       print(
  //                                           "CameraMove ==>  ${cameraPosition.target}");
  //                                       _cameraMoveLatlng =
  //                                           cameraPosition.target;
  //                                     },
  //                                     onTap: (LatLng latLng) {
  //                                       showMarker(latLng: latLng);
  //                                       print("latLng=====>${latLng}");
  //                                     },
  //                                   ),
  //                                   if (cont.isPickFromMap.value)
  //                                     Image.asset(
  //                                       AppImage.icPin,
  //                                       width: 30.w,
  //                                     )
  //                                 ],
  //                               ),
  //                               if ((userCont.locationResponseModel.value.home
  //                                           .isNotEmpty ||
  //                                       userCont.locationResponseModel.value
  //                                           .work.isNotEmpty ||
  //                                       (cont.searchAddressList.isNotEmpty) &&
  //                                           (cont.locationFromFocusNode
  //                                                   .hasFocus ||
  //                                               cont.locationWhereToFocusNode
  //                                                   .hasFocus ||
  //                                               isFocus)) &&
  //                                   !cont.isPickFromMap.value) ...[
  //                                 Container(
  //                                   margin: EdgeInsets.only(
  //                                       right: 15.w, left: 15.w, top: 70.h),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.circular(10.r),
  //                                   ),
  //                                   child: SingleChildScrollView(
  //                                     padding:
  //                                         EdgeInsets.symmetric(vertical: 20.h),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         // if (cont.searchAddressList.isNotEmpty)
  //                                         //   ListView.builder(
  //                                         //     padding: EdgeInsets.symmetric(
  //                                         //       horizontal: 20.w,
  //                                         //     ),
  //                                         //     physics:
  //                                         //         NeverScrollableScrollPhysics(),
  //                                         //     itemBuilder: (context, index) {
  //                                         //       AutocompletePrediction
  //                                         //           autocompletePrediction =
  //                                         //           cont.searchAddressList[
  //                                         //               index];
  //                                         //       return InkWell(
  //                                         //         onTap: () {
  //                                         //           if (cont
  //                                         //               .locationFromFocusNode
  //                                         //               .hasFocus) {
  //                                         //             cont.tempLocationFromTo
  //                                         //                     .text =
  //                                         //                 autocompletePrediction
  //                                         //                         .description ??
  //                                         //                     "";
  //                                         //           } else if (cont
  //                                         //               .locationWhereToFocusNode
  //                                         //               .hasFocus) {
  //                                         //             cont.tempLocationWhereTo1
  //                                         //                     .text =
  //                                         //                 autocompletePrediction
  //                                         //                         .description ??
  //                                         //                     "";
  //                                         //           } else {
  //                                         //             cont.multipleLocationAdModelList
  //                                         //                 .forEach((element) {
  //                                         //               if (element.focusNode
  //                                         //                       ?.hasFocus ==
  //                                         //                   true) {
  //                                         //                 element.textEditingController
  //                                         //                         ?.text =
  //                                         //                     autocompletePrediction
  //                                         //                             .description ??
  //                                         //                         "";
  //                                         //               }
  //                                         //             });
  //                                         //           }
  //                                         //           cont
  //                                         //               .getPlaceIdToLatLag(
  //                                         //                   placeId:
  //                                         //                       autocompletePrediction
  //                                         //                           .placeId!)
  //                                         //               .then((value) {
  //                                         //             cont.removeUnFocusManager();
  //                                         //             setState(() {});
  //                                         //           });
  //                                         //           cont.searchAddressList
  //                                         //               .clear();
  //                                         //         },
  //                                         //         child: Container(
  //                                         //           child: Row(
  //                                         //             crossAxisAlignment:
  //                                         //                 CrossAxisAlignment
  //                                         //                     .start,
  //                                         //             children: [
  //                                         //               Icon(
  //                                         //                 Icons.location_on,
  //                                         //               ),
  //                                         //               Expanded(
  //                                         //                 child: Column(
  //                                         //                   mainAxisSize:
  //                                         //                       MainAxisSize
  //                                         //                           .min,
  //                                         //                   crossAxisAlignment:
  //                                         //                       CrossAxisAlignment
  //                                         //                           .start,
  //                                         //                   children: [
  //                                         //                     Text(autocompletePrediction
  //                                         //                             .description ??
  //                                         //                         ""),
  //                                         //                     // Text(
  //                                         //                     //   autocompletePrediction.description ??
  //                                         //                     //       "",
  //                                         //                     //   style: TextStyle(
  //                                         //                     //     color: Colors.grey,
  //                                         //                     //   ),
  //                                         //                     // ),
  //                                         //                     if (cont.searchAddressList
  //                                         //                                 .length -
  //                                         //                             1 !=
  //                                         //                         index)
  //                                         //                       Container(
  //                                         //                         margin: EdgeInsets
  //                                         //                             .symmetric(
  //                                         //                                 vertical:
  //                                         //                                     5.h),
  //                                         //                         width: double
  //                                         //                             .infinity,
  //                                         //                         height: 1.h,
  //                                         //                         color: Colors
  //                                         //                             .grey
  //                                         //                             .withOpacity(
  //                                         //                                 0.5),
  //                                         //                       )
  //                                         //                   ],
  //                                         //                 ),
  //                                         //               ),
  //                                         //             ],
  //                                         //           ),
  //                                         //         ),
  //                                         //       );
  //                                         //     },
  //                                         //     itemCount:
  //                                         //         cont.searchAddressList.length,
  //                                         //     shrinkWrap: true,
  //                                         //     // physics: NeverScrollableScrollPhysics(),
  //                                         //   ),
  //
  //                                         // if (userCont.locationResponseModel.value
  //                                         //     .home.isNotEmpty) ...[
  //                                         //   InkWell(
  //                                         //     onTap: () {
  //                                         //       Home _home = userCont
  //                                         //           .locationResponseModel
  //                                         //           .value
  //                                         //           .home[0];
  //                                         //       if (cont.locationFromFocusNode
  //                                         //           .hasFocus) {
  //                                         //         cont.tempLocationFromTo.text =
  //                                         //             _home.address ?? "";
  //                                         //         cont.tempLatLngFrom = LatLng(
  //                                         //             _home.latitude ?? 0,
  //                                         //             _home.longitude ?? 0);
  //                                         //       } else if (cont
  //                                         //           .locationWhereToFocusNode
  //                                         //           .hasFocus) {
  //                                         //         cont.tempLocationWhereTo1.text =
  //                                         //             _home.address ?? "";
  //                                         //         cont.tempLatLngWhereTo1 = LatLng(
  //                                         //             _home.latitude ?? 0,
  //                                         //             _home.longitude ?? 0);
  //                                         //       } else {
  //                                         //         cont.multipleLocationAdModelList
  //                                         //             .forEach((element) {
  //                                         //           if (element
  //                                         //                   .focusNode?.hasFocus ==
  //                                         //               true) {
  //                                         //             element.textEditingController
  //                                         //                     ?.text =
  //                                         //                 _home.address ?? "";
  //                                         //             element.latLng = LatLng(
  //                                         //                 _home.latitude ?? 0,
  //                                         //                 _home.longitude ?? 0);
  //                                         //           }
  //                                         //         });
  //                                         //       }
  //                                         //       cont.searchAddressList.clear();
  //                                         //     },
  //                                         //     child: Padding(
  //                                         //       padding: EdgeInsets.symmetric(
  //                                         //           horizontal: 20.w),
  //                                         //       child: Column(
  //                                         //         crossAxisAlignment:
  //                                         //             CrossAxisAlignment.start,
  //                                         //         children: [
  //                                         //           if (cont.searchAddressList
  //                                         //               .isNotEmpty)
  //                                         //             Container(
  //                                         //               margin:
  //                                         //                   EdgeInsets.symmetric(
  //                                         //                       vertical: 5.h),
  //                                         //               width: double.infinity,
  //                                         //               height: 1.h,
  //                                         //               color: Colors.grey
  //                                         //                   .withOpacity(0.5),
  //                                         //             ),
  //                                         //           Row(
  //                                         //             children: [
  //                                         //               Image.asset(
  //                                         //                 AppImage.icHome,
  //                                         //                 width: 20.w,
  //                                         //               ),
  //                                         //               SizedBox(width: 5.w),
  //                                         //               Expanded(
  //                                         //                 child: Text(
  //                                         //                   "home".tr,
  //                                         //                   style: TextStyle(
  //                                         //                     fontSize: 13.sp,
  //                                         //                     fontWeight:
  //                                         //                         FontWeight.w500,
  //                                         //                   ),
  //                                         //                 ),
  //                                         //               )
  //                                         //             ],
  //                                         //           ),
  //                                         //           Text(
  //                                         //             userCont
  //                                         //                     .locationResponseModel
  //                                         //                     .value
  //                                         //                     .home[0]
  //                                         //                     .address ??
  //                                         //                 "",
  //                                         //           )
  //                                         //         ],
  //                                         //       ),
  //                                         //     ),
  //                                         //   ),
  //                                         // ],
  //                                         // if (userCont.locationResponseModel.value
  //                                         //     .work.isNotEmpty) ...[
  //                                         //   InkWell(
  //                                         //     onTap: () {
  //                                         //       Home _home = userCont
  //                                         //           .locationResponseModel
  //                                         //           .value
  //                                         //           .work[0];
  //                                         //       if (cont.locationFromFocusNode
  //                                         //           .hasFocus) {
  //                                         //         cont.tempLocationFromTo.text =
  //                                         //             _home.address ?? "";
  //                                         //         cont.tempLatLngFrom = LatLng(
  //                                         //             _home.latitude ?? 0,
  //                                         //             _home.longitude ?? 0);
  //                                         //       } else if (cont
  //                                         //           .locationWhereToFocusNode
  //                                         //           .hasFocus) {
  //                                         //         cont.tempLocationWhereTo1.text =
  //                                         //             _home.address ?? "";
  //                                         //         cont.tempLatLngWhereTo1 = LatLng(
  //                                         //             _home.latitude ?? 0,
  //                                         //             _home.longitude ?? 0);
  //                                         //       } else {
  //                                         //         cont.multipleLocationAdModelList
  //                                         //             .forEach((element) {
  //                                         //           if (element
  //                                         //                   .focusNode?.hasFocus ==
  //                                         //               true) {
  //                                         //             element.textEditingController
  //                                         //                     ?.text =
  //                                         //                 _home.address ?? "";
  //                                         //             element.latLng = LatLng(
  //                                         //                 _home.latitude ?? 0,
  //                                         //                 _home.longitude ?? 0);
  //                                         //           }
  //                                         //         });
  //                                         //       }
  //                                         //       cont.searchAddressList.clear();
  //                                         //     },
  //                                         //     child: Padding(
  //                                         //       padding: EdgeInsets.symmetric(
  //                                         //           horizontal: 20.w),
  //                                         //       child: Column(
  //                                         //         crossAxisAlignment:
  //                                         //             CrossAxisAlignment.start,
  //                                         //         children: [
  //                                         //           if (cont.searchAddressList
  //                                         //                   .isNotEmpty ||
  //                                         //               userCont
  //                                         //                   .locationResponseModel
  //                                         //                   .value
  //                                         //                   .work
  //                                         //                   .isNotEmpty)
  //                                         //             Container(
  //                                         //               margin:
  //                                         //                   EdgeInsets.symmetric(
  //                                         //                       vertical: 5.h),
  //                                         //               width: double.infinity,
  //                                         //               height: 1.h,
  //                                         //               color: Colors.grey
  //                                         //                   .withOpacity(0.5),
  //                                         //             ),
  //                                         //           Row(
  //                                         //             children: [
  //                                         //               Image.asset(
  //                                         //                 AppImage.icWork,
  //                                         //                 width: 20.w,
  //                                         //               ),
  //                                         //               SizedBox(width: 5.w),
  //                                         //               Expanded(
  //                                         //                 child: Text(
  //                                         //                   "work".tr,
  //                                         //                   style: TextStyle(
  //                                         //                     fontSize: 13.sp,
  //                                         //                     fontWeight:
  //                                         //                         FontWeight.w500,
  //                                         //                   ),
  //                                         //                 ),
  //                                         //               )
  //                                         //             ],
  //                                         //           ),
  //                                         //           Text(
  //                                         //             userCont
  //                                         //                     .locationResponseModel
  //                                         //                     .value
  //                                         //                     .work[0]
  //                                         //                     .address ??
  //                                         //                 "",
  //                                         //           )
  //                                         //         ],
  //                                         //       ),
  //                                         //     ),
  //                                         //   ),
  //                                         // ]
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 )
  //                               ],
  //                               // Container(
  //                               //   padding: EdgeInsets.only(
  //                               //     right: 20.w,
  //                               //     left: 20.w,
  //                               //     bottom: 15.h,
  //                               //   ),
  //                               //   decoration: BoxDecoration(
  //                               //     color: Colors.white,
  //                               //     boxShadow: [
  //                               //       BoxShadow(
  //                               //         color: AppColors.shadowColor,
  //                               //         blurRadius: 6.r,
  //                               //         offset: Offset(0, 5.h),
  //                               //       )
  //                               //     ],
  //                               //     borderRadius: BorderRadius.vertical(
  //                               //       bottom: Radius.circular(38.r),
  //                               //     ),
  //                               //   ),
  //                               //   child: widget.isSelectHomeAddress == null &&
  //                               //           !widget.isRideLocationUpdate
  //                               //       ? Row(
  //                               //           children: [
  //                               //             Text("round_trip".tr),
  //                               //             Spacer(),
  //                               //             Switch(
  //                               //               onChanged: (value) {
  //                               //                 cont.isRoundTrip.value = value;
  //                               //               },
  //                               //               value: cont.isRoundTrip.value,
  //                               //               activeColor: AppColors.primaryColor,
  //                               //               activeTrackColor:
  //                               //                   AppColors.primaryColor,
  //                               //               inactiveThumbColor: AppColors.gray,
  //                               //               inactiveTrackColor: AppColors
  //                               //                   .lightGray
  //                               //                   .withOpacity(0.8),
  //                               //             )
  //                               //           ],
  //                               //         )
  //                               //       : SizedBox(
  //                               //           height: 20.h,
  //                               //           width: double.infinity,
  //                               //         ),
  //                               // ),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //       }),
  //     ),
  //   );
  // }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetSnackBar(
          messageText: Text(
            "location_permissions_denied".tr,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          mainButton: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "allow".tr,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
    }
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.showSnackbar(GetBar(
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        mainButton: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "allow".tr,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ));
      // showError(msg: e.toString());
    }
    if (position != null) {
      showMarker(latLng: LatLng(position.latitude, position.longitude));
      print("cccc===>${position.latitude}");
    }
    return position;
  }

  Future<void> showMarker({required LatLng latLng}) async {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 14.4746,
    );
    //
    // _markers.add(Marker(markerId: const MarkerId("first"), position: latLng));
    _controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // PolylinePoints polylinePoints = PolylinePoints();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //     AppString.googleMapKey,
    //     const PointLatLng(21.1702, 72.8311),
    //     const PointLatLng(21.1418, 72.7709),
    //     travelMode: TravelMode.driving);
    //
    // List<LatLng> points = <LatLng>[];
    // for (var element in result.points) {
    //   points.add(LatLng(element.latitude, element.longitude));
    // }
    //
    // List<PatternItem> pattern = [PatternItem.dash(20), PatternItem.gap(5)];
    // Polyline polyline = Polyline(
    //     startCap: Cap.buttCap,
    //     polylineId: id,
    //     color: Colors.red,
    //     points: points,
    //     width: 3,
    //     patterns: pattern,
    //     endCap: Cap.squareCap);
    // _polyLine.add(polyline);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (_controller != null) {
          _controller?.setMapStyle("[]");
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
