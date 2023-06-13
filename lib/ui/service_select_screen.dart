import 'dart:async';
import 'dart:developer';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/fare_response_model.dart';
import 'package:arbyuser/model/services_model.dart';
import 'package:arbyuser/ui/widget/custom_drawer.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class ServiceSelectScreen extends StatefulWidget {
  const ServiceSelectScreen({Key? key}) : super(key: key);

  @override
  State<ServiceSelectScreen> createState() => _ServiceSelectScreenState();
}

class _ServiceSelectScreenState extends State<ServiceSelectScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  int _pageSelected = 0;
  PageController _pageController = PageController(initialPage: 0);

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final List<Marker> _markers = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    _markers.add(const Marker(
        markerId: MarkerId("first"),
        position: LatLng(37.42796133580664, -122.085749655962)));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _homeController.getServices();
      if (_homeController.serviceModelList.isNotEmpty) {
        await _homeController.getFairServiceDetailsApiCall(
            servicesModel: _homeController.serviceModelList[0]);
        setState(() {});
      }
    });
  }

  bool isSubmit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: GetX<HomeController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cont.googleMapInitCameraPosition.value,
              myLocationEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(cont.googleMapPolyLine),
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                cont.googleMapController = controller;
                determinePosition();
              },
            ),
            Positioned(
              top: 80.h,
              left: 25.w,
              right: 25.w,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50.w,
                        width: 50.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          AppImage.back,
                          width: 25.w,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Icon(
                            Icons.gps_fixed_outlined,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isSubmit == false
                ? Positioned(
                    bottom: 10.h,
                    left: 15.w,
                    right: 15.w,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 125.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                ServicesModel serviceModel =
                                    cont.serviceModelList[index];
                                bool isSelected =
                                    cont.serviceTypeSelectedIndex.value ==
                                        index;
                                FareResponseModel fareResponseModel =
                                    cont.fareResponseModel.value;
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.w),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (cont.serviceTypeSelectedIndex.value !=
                                          index) {
                                        cont.serviceTypeSelectedIndex.value =
                                            index;
                                        await cont.getFairServiceDetailsApiCall(
                                            servicesModel:
                                                cont.serviceModelList[index]);
                                        setState(() {});
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "${fareResponseModel.estimatedFare ?? ""} ${_userController.userData.value.currency ?? ""}",
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          height: 80.w,
                                          width: 80.w,
                                          padding: EdgeInsets.all(5.w),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: !isSelected
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                          ),
                                          child: Center(
                                            child: CustomFadeInImage(
                                              url: serviceModel.image ?? "",
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        if (isSelected)
                                          Text(
                                            "${fareResponseModel.distance ?? ""} kms"
                                                .tr,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400),
                                          )
                                        else
                                          SizedBox(height: 13.h),
                                        SizedBox(height: 2.h),
                                        Text(
                                          serviceModel.name ?? "",
                                          style: TextStyle(
                                              color: isSelected
                                                  ? AppColors.primaryColor
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: cont.serviceModelList.length,
                              shrinkWrap: true,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSubmit = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 15.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(35.r),
                              ),
                              child: Center(
                                child: Text(
                                  "submit".tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 10.h,
                    right: 15.w,
                    left: 15.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Icon(
                              Icons.access_time_rounded,
                            ),
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Container(
                          height: 150.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5.w),
                                      height: 50.w,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: CustomFadeInImage(
                                        url: cont.fareResponseModel.value
                                                .service?.image ??
                                            "",
                                      ),
                                    ),
                                    SizedBox(width: 15.h),
                                    Text(
                                      cont.fareResponseModel.value.service
                                              ?.name ??
                                          "",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${cont.fareResponseModel.value.estimatedFare ?? ""} ${_userController.userData.value.currency ?? ""}",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  children: [
                                    Text(
                                      "apply_coupan".tr,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 40.h,
                                      width: 2.w,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 15.w),
                                    GestureDetector(
                                      onTap: () {
                                        showMaterialModalBottomSheet(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              builder: (context, StatState) {
                                            return Container(
                                              padding:
                                                  EdgeInsets.only(top: 5.h),
                                              height: 130.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: PageView(
                                                        onPageChanged: (value) {
                                                          print(value);
                                                          setState(() {
                                                            _pageSelected =
                                                                value;
                                                          });
                                                        },
                                                        controller:
                                                            _pageController,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        15),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        20),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      blurRadius:
                                                                          5)
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "cpD01".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                Divider(
                                                                  thickness: 2,
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "10%_Off_Max_50"
                                                                              .tr,
                                                                          style: TextStyle(
                                                                              color: AppColors.primaryColor,
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                          "valid_Till_13,June_2021"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Spacer(),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .primaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "use_code"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        15),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        20),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      blurRadius:
                                                                          5)
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "cpD01".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                Divider(
                                                                  thickness: 2,
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "10%_Off_Max_50"
                                                                              .tr,
                                                                          style: TextStyle(
                                                                              color: AppColors.primaryColor,
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                          "valid_Till_13,June_2021"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Spacer(),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .primaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "use_code"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: List.generate(
                                                        2,
                                                        (index) => Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              height: 9,
                                                              width: 9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: _pageSelected ==
                                                                        index
                                                                    ? AppColors
                                                                        .primaryColor
                                                                    : Colors
                                                                        .grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                            )),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                      child: Text(
                                        "view_Code".tr,
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 35.h,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(15.r)),
                                  color: Colors.grey[100],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "payment : ".tr,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                    Text(
                                      "case".tr,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSubmit = false;
                                  });
                                },
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.r),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey, blurRadius: 3)
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "cancel".tr,
                                      style: TextStyle(
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  cont.sendRequest();
                                },
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "request".tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          ],
        );
      }),
    );
  }

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetBar(
          messageText: Text(
            "location_denied".tr,
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
                  color: Colors.orange,
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
                color: Colors.orange,
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
      _homeController.tempLatLngFrom =
          LatLng(position.latitude, position.longitude);
      showMarker(latLng: LatLng(position.latitude, position.longitude));
    }
    return position;
  }

  Future<void> showMarker({required LatLng latLng}) async {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 14.4746,
    );

    _markers.add(Marker(markerId: const MarkerId("first"), position: latLng));
    _homeController.googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    _homeController.getLocationAddress(latLng: latLng).then((value) {
      _homeController.setData();
    });

    // setState(() {});
  }

  List<LatLng> _createPoints() {
    List<LatLng> points = <LatLng>[];
    points.add(LatLng(1.875249, 0.845140));
    points.add(LatLng(4.851221, 1.715736));
    points.add(LatLng(8.196142, 2.094979));
    points.add(LatLng(12.196142, 3.094979));
    points.add(LatLng(16.196142, 4.094979));
    points.add(LatLng(20.196142, 5.094979));
    return points;
  }
}
