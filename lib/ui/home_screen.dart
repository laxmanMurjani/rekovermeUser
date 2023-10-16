import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:arbyuser/ui/drawer_srceen/help_screen.dart';
import 'package:arbyuser/ui/widget/launching_soon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/user_location_type.dart';
import 'package:arbyuser/model/check_request_response_model.dart';
import 'package:arbyuser/model/get_nearest_user_model.dart';
import 'package:arbyuser/model/location_response_odel.dart';
import 'package:arbyuser/model/multiple_location_add_model.dart';
import 'package:arbyuser/model/payment_option_model.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/ui/Locationscreen.dart';
import 'package:arbyuser/ui/bookfor_someone_else.dart';
import 'package:arbyuser/ui/chat_screen.dart';
import 'package:arbyuser/ui/dialog/coupan_dialog.dart';
import 'package:arbyuser/ui/dialog/finding_driver_dialog.dart';
import 'package:arbyuser/ui/dialog/finding_driver_dialog_for_breck_down.dart';
import 'package:arbyuser/ui/dialog/rating_dialog.dart';
import 'package:arbyuser/ui/dialog/sos_alert_dialog.dart';
import 'package:arbyuser/ui/dialog/update_address_dialog.dart';
import 'package:arbyuser/ui/drawer_srceen/payment_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/profile_screen.dart';
import 'package:arbyuser/ui/drawer_srceen/upcoming_trips_details_screen.dart';
import 'package:arbyuser/ui/other_address_save_locationscreen.dart';
import 'package:arbyuser/ui/profile_page.dart';
import 'package:arbyuser/ui/saved_contacts.dart';
import 'package:arbyuser/ui/saved_contacts_for_book.dart';
import 'package:arbyuser/ui/widget/custom_button.dart';

import 'package:arbyuser/ui/widget/custom_drawer.dart';
import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
import 'package:arbyuser/ui/widget/no_internet_widget.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/util/common.dart';
import 'package:arbyuser/util/custom_radio_button.dart';
import 'package:arbyuser/util/firebase_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api.dart';
import '../model/fare_response_model.dart';
import '../model/services_model.dart';
import 'dialog/reason_for_cancelling_dialog.dart';
import 'drawer_srceen/notification_manager.dart';
import 'drawer_srceen/wallet_screen.dart';
import 'drawer_srceen/your_trips_Screen.dart';

String radioItem = "Cash";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final HomeController _homeController = Get.find();
  final UserController _userController = Get.find();

  GlobalKey _repaintBoundaryKey = new GlobalKey();
  int selected = 0;
  bool isSubmit = false;
  bool isMySelf = true;
  bool isBookForSome = false;
  bool isMounted = true;

  List<PaymentOptionModel> paymentRadioButtonList = [
    PaymentOptionModel(
      index: 0,
      name: "Cash",
    ),
    // PaymentOptionModel(
    //   index: 1,
    //   name: "Online(UPI, Card, Net banking)",
    // ),
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _pageSelected = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _googleMapController = Completer();
  DateFormat _arrivalTimeFormat = DateFormat("hh:mm a");
  DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  DateTime? _selectedDate;
  TimeOfDay? _selectedTimeOfDay;
  bool _shouldScaleDown = false;
  Timer? _requestTimer;
  String totalRidesNumber = '';
  String chetUnRead = '0';
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  List<GetNearestDriverTimeModel> totalList = [];

  // @override
  // void initState() {
  //   getCurrentLocation();
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     // _homeController.getServices();
  //     await _homeController.checkRequest();
  //     await _userController.getLocation();
  //     _userController.getPromoCodeList();
  //     // if(_homeController.)
  //   });
  //   _requestTimer = Timer.periodic(Duration(seconds: 5), (_) async {
  //     await _homeController.checkRequest();
  //     // await _userController.getLocation();
  //     print("checkRequestResponseModel.value===>${_homeController.checkRequestResponseModel.value.fadeedback_count}");
  //     Future.delayed(
  //       Duration(seconds: 9),
  //           () async {
  //         if(_homeController.userCurrentLocation != null ){
  //           print("checkEnter");
  //           // if (_homeController.showDriverLocationList.isEmpty) {
  //
  //           await _homeController.getDriversLocationData(() => setState(() {}));
  //           print("0000===>${_homeController.showDriverLocationList.length}");
  //
  //           if(_homeController.showDriverLocationList.isNotEmpty){
  //             await _homeController.getNearDriverTimeData();
  //           }
  //
  //           // }
  //         }
  //       },
  //     );
  //     if (_homeController.checkRequestResponseModel.value.data.isNotEmpty) {
  //       _databaseReference = _firebaseDatabase.ref(
  //           (_homeController.checkRequestResponseModel.value.data[0].id ?? "0")
  //               .toString());
  //       _databaseReference.onValue.listen((event) {
  //         _databaseReference
  //             .orderByChild("read")
  //             .equalTo(1)
  //             .get()
  //             .then((value) {
  //           print("chil00d.key===>${value.children.length}");
  //           print("chil00d.key===>${value.children.length.isEqual(0)}");
  //           chetUnRead = value.children.length.isEqual(0)
  //               ? "0"
  //               : value.children.length.toString();
  //           setState(() {});
  //         });
  //       });
  //     }
  //
  //   });
  // }

  @override
  void initState() {
    // getCurrentLocation();
    FirebaseService.loginUpdateToken("");
    print("enter init home");
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _homeController.getServices();
      await _homeController.checkRequest();
      await _userController.getLocation();
      // await _userController.getArbyBanner();
      _userController.getPromoCodeList();
      // print(
      //     "chil00d.key===>${_homeController.checkRequestResponseModel.value.data[0].id}");

      // if(_homeController.)

    });

    _requestTimer = Timer.periodic(Duration(seconds: 3), (_) async {
      await _homeController.checkRequest();
      if (_homeController
                  .checkRequestResponseModel.value.provider_select_timeout !=
              null &&
          _homeController.timeLeftToRespond.value.isEqual(60)) {
        _homeController.timeLeftToRespond.value = int.parse(_homeController
            .checkRequestResponseModel.value.provider_select_timeout);
      }
      Future.delayed(
        Duration(seconds: 9),
        () async {
          if (_homeController.userCurrentLocation != null) {
            print("checkEnter");
            if (_homeController.showDriverLocationList.isEmpty) {
              // await _homeController.getDriversLocationData(() => setState(() {}));
              // print("0000===>${_homeController.showDriverLocationList.length}");

              if (_homeController.showDriverLocationList.isNotEmpty) {
                await _homeController.getNearDriverTimeData();
              }
            }
          }

          // if (_homeController.showDriverLocationList.isEmpty) {
          // Timer.periodic(Duration(seconds: 40), (_) async {
          //   await _homeController.getDriversLocationData();
          //   await _homeController.getDriverMarkerData(
          //       updateData: () => setState(() {}));
          //   print(
          //       "lengthCheck===>${_homeController.showDriverLocationList.length}");
          //   for (int i = 0;
          //       i <= _homeController.showDriverLocationList.length - 1;
          //       i++) {
          //     await _homeController.getNearByDriversTimeData(
          //         d_latitude:
          //             _homeController.showDriverLocationList[i].latitude,
          //         d_longitude:
          //             _homeController.showDriverLocationList[i].longitude,
          //         s_latitude: _homeController.userCurrentLocation!.latitude,
          //         s_longitude: _homeController.userCurrentLocation!.longitude,
          //         serviceType: _homeController
          //             .showDriverLocationList[i].service?.serviceTypeId);
          //   }
          // });

          // }
        },
      );
      if (_homeController.checkRequestResponseModel.value.data.isNotEmpty) {
        _databaseReference = _firebaseDatabase.ref(
            (_homeController.checkRequestResponseModel.value.data[0].id ?? "0")
                .toString());
        _databaseReference.onValue.listen((event) {
          _databaseReference
              .orderByChild("read")
              .equalTo(1)
              .get()
              .then((value) {
            print("chil00d.key===>${value.children.length}");
            print("chil00d.key===>${value.children.length.isEqual(0)}");
            chetUnRead = value.children.length.isEqual(0)
                ? "0"
                : value.children.length.toString();
            setState(() {});
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      key: _scaffoldKey,

      // drawer: CustomDrawer(),
      // bottomSheet:,
      body: GetX<HomeController>(builder: (cont) {
        log("Location  ====>   ${cont.userUiSelectionType.value}");
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        double _sliderHeight = 165.h;
        if (cont.statusType.value == StatusType.STARTED ||
            cont.statusType.value == StatusType.ARRIVED) {
          _sliderHeight = 200.h;
        }
        if (cont.checkRequestResponseModel.value.data.isNotEmpty) {
          if (cont.checkRequestResponseModel.value.data[0].rideOtp == 1) {
            _sliderHeight = _sliderHeight + 15.h;
          }
        }

        return GetX<UserController>(builder: (userCont) {
          return WillPopScope(
            onWillPop: () {
              _shouldScaleDown = false;
              if (cont.userUiSelectionType.value ==
                      UserUiSelectionType.scheduleRide ||
                  cont.userUiSelectionType.value ==
                      UserUiSelectionType.vehicleDetails) {
                cont.userUiSelectionType.value =
                    UserUiSelectionType.serviceType;
                return Future.value(false);
              }

              if (cont.userUiSelectionType.value ==
                  UserUiSelectionType.serviceType) {
                isSubmit = false;
                cont.clearData();
                cont.userUiSelectionType.value =
                    UserUiSelectionType.locationSelection;
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: 
                    cont.userUiSelectionType.value ==
                            UserUiSelectionType.serviceType
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              cont.fareResponseModel.value.time
                                      .toString()
                                      .contains("hours")
                                  ? Image.asset(
                                      AppImage.arbyTime,
                                      height: 70,
                                      width: 80,
                                    )
                                  : Image.asset(
                                      AppImage.arbyTime,
                                      height: 70,
                                      width: 90,
                                    ),
                              cont.fareResponseModel.value.time
                                      .toString()
                                      .contains("hours")
                                  ? Text(
                                      "${cont.fareResponseModel.value.time.toString().split(" ")[0]}${cont.fareResponseModel.value.time.toString().split(" ")[1]}\n${cont.fareResponseModel.value.time.toString().split(" ")[2]}${cont.fareResponseModel.value.time.toString().split(" ")[3]}",
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 10,
                                      ))
                                  : Text(
                                      cont.fareResponseModel.value.time
                                          .toString(),
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 10,
                                      )),
                            ],
                          )
                      :
                    Container(
                                width: 25.w,
                                height: 25.w,
                                padding: EdgeInsets.all(2.w),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: AppColors.primaryColor2),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.primaryColor2,
                                            blurRadius: 12.w)
                                      ]),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // border: Border.all(color: Color(0xffFF5A5A)),
                                    ),
                                    child: userCont.userData.value.picture ==
                                            null
                                        ? Image.asset(AppImage.profilePic)
                                        : CustomFadeInImage(
                                            url:
                                                "${ApiUrl.baseImageUrl}${userCont.userData.value.picture}",
                                            fit: BoxFit.cover,
                                            placeHolder:
                                                AppImage.icUserPlaceholder,
                                            imageLoaded: () async {
                                              if (!cont.isCaptureImage.value) {
                                                await Future.delayed(Duration(
                                                    milliseconds: 1000));
                                                _capturePng();
                                                cont.isCaptureImage.value =
                                                    true;
                                              }
                                            },
                                          ),
                                  ),
                                ),
                              ),
                  ),
                ),

                // _homeController.checkRequestResponseModel.value.data.isNotEmpty
                //     ?
                // GoogleMap(
                //         mapType: MapType.normal,
                //         initialCameraPosition:
                //             cont.googleMapInitCameraPosition.value,
                //         myLocationEnabled:
                //             // false,
                //             false,
                //         myLocationButtonEnabled: false,
                //         mapToolbarEnabled: false,
                //         zoomControlsEnabled: false,
                //         compassEnabled: true,
                //         rotateGesturesEnabled: true,
                //         polylines: Set<Polyline>.of(cont.googleMapPolyLine),
                //         markers: Set<Marker>.of(cont.googleMarkers.values),
                //         onMapCreated: (GoogleMapController controller) async {
                //           _googleMapController.complete(controller);
                //           cont.googleMapController = controller;
                //           determinePosition();
                //         },
                //       ),
                    // :
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: cont.googleMapInitCameraPosition.value,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  rotateGesturesEnabled: false,
                  polylines: Set<Polyline>.of(cont.googleMapPolyLine),
                  markers: Set<Marker>.of(cont.googleMarkers.values),
                  onMapCreated: (GoogleMapController controller) async {
                    controller.setMapStyle(userCont.mapStyle.value);
                    _googleMapController.complete(controller);
                    cont.googleMapController = controller;
                    determinePosition();
                  },
                ),

                Positioned(
                    top: 30,
                    child: Row(children: [
                      if (cont.userUiSelectionType.value !=
                              UserUiSelectionType.serviceType &&
                          cont.userUiSelectionType.value !=
                              UserUiSelectionType.vehicleDetails &&
                          cont.userUiSelectionType.value !=
                              UserUiSelectionType.scheduleRide &&
                          cont.userUiSelectionType.value !=
                              UserUiSelectionType.findingDriver)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.skyBlue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(55)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          ProfileScreen());
                                                      print(
                                                          "checkP===>${'${ApiUrl.baseImageUrl}${_userController.userData.value.picture}'}");
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      child: Container(
                                                        height: 45.w,
                                                        width: 45.w,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: Colors.red,
                                                                border:
                                                                    Border.all(
                                                                  color: AppColors
                                                                      .skyBlue,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.h)),
                                                        padding:
                                                            EdgeInsets.all(1),
                                                        child: _userController
                                                                    .userData
                                                                    .value
                                                                    .picture ==
                                                                null
                                                            ? CircleAvatar(
                                                                radius: 25,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .white,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        AppImage
                                                                            .profilePic),
                                                              )
                                                            : CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  '${ApiUrl.baseImageUrl}${_userController.userData.value.picture}',
                                                                ),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .white,
                                                                // child: CustomFadeInImage(
                                                                //     url:
                                                                //         '${ApiUrl.baseImageUrl}${_userController.userData.value.picture}',
                                                                //     fit: BoxFit
                                                                //         .contain,
                                                                //     placeHolder:
                                                                //         AppImage
                                                                //             .icUserPlaceholder,
                                                                //   ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'hi'.tr,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .primary),
                                                        ),
                                                      ),
                                                      Text(
                                                          '${_userController.userData.value.firstName ?? ""} ${_userController.userData.value.lastName ?? ""} ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))
                                                      // if (cont.userUiSelectionType
                                                      //         .value !=
                                                      //     UserUiSelectionType
                                                      //         .driverAvailable)
                                                      //   Text('where_to_go'.tr,
                                                      //       style: TextStyle(
                                                      //           fontSize: 14,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w500,
                                                      //           color: AppColors
                                                      //               .primaryColor)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      NotificationManagerScreen());
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12.0),
                                                  child: Image.asset(
                                                      AppImage.bell,
                                                      height: 25,
                                                      width: 25),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    ExpandChild(
                                        arrowColor: AppColors.primaryColor,
                                        expandArrowStyle: ExpandArrowStyle.icon,
                                        expandDirection: Axis.vertical,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),

                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.13,
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          decoration: BoxDecoration(
                                            color: AppColors.skyBlue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                          ),
                                          // height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => YourTripsScreen(
                                                      isUpComingScreenShow:
                                                          false));
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 7,
                                                        bottom: 7,
                                                        left: 0,
                                                        right: 0),
                                                    height: 70,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Image.asset(
                                                          AppImage.pastRide,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          'past_rides'.tr,
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => HelpScreen());
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(7),
                                                    height: 70,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Image.asset(
                                                          AppImage.help,
                                                          height: 35,
                                                          width: 35,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          'help'.tr,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => ProfilePage());
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(7),
                                                    height: 70,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Image.asset(
                                                          AppImage.account,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          'account'.tr,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _homeController.getDriverMarkerData(
                                    updateData: () => setState(() {}));
                                setState(() {
                                  isDriverShow = true;
                                });
                                setState(() {
                                  isBookForSomeOne = false;
                                });
                                _shouldScaleDown = false;
                                if (cont.userUiSelectionType.value ==
                                        UserUiSelectionType.scheduleRide ||
                                    cont.userUiSelectionType.value ==
                                        UserUiSelectionType.vehicleDetails) {
                                  cont.userUiSelectionType.value =
                                      UserUiSelectionType.serviceType;
                                  return;
                                }
                                if (cont.userUiSelectionType.value ==
                                    UserUiSelectionType.serviceType) {
                                  isSubmit = false;
                                  cont.clearData();
                                  cont.userUiSelectionType.value =
                                      UserUiSelectionType.locationSelection;
                                  return;
                                }
                                cont.clearData();
                                cont.userUiSelectionType.value =
                                    UserUiSelectionType.locationSelection;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                child: Center(
                                  child: Image.asset(
                                    AppImage.back,
                                    width: 40.w,
                                  ),
                                ),
                              ),
                            ),
                            if (cont.fareResponseModel.value.surge == 1) ...[
                              // Container(
                              //   color: AppColors.white,
                              //   alignment: Alignment.center,
                              //   width: MediaQuery.of(context).size.width * 0.75,
                              //   height: 80,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 10, vertical: 5),
                              //   child: Text(
                              //     "Demand is off the charts! Fares have increased to get more Ubers on the road.",
                              //     style: TextStyle(
                              //         color: AppColors.primaryColor,
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 16),
                              //     maxLines: 5,
                              //     overflow: TextOverflow.ellipsis,
                              //     textAlign: TextAlign.center,
                              //   ),
                              // )
                            ]
                          ],
                        ),
                      // if () ...[
                      //
                      //   // Get.bottomSheet(FindingDriverForBreakDownDialog(),
                      //   //     enableDrag: false,
                      //   //     isDismissible: false,
                      //   //     isScrollControlled: true);
                      // ],

                      if (cont.currentRideAddress.isNotEmpty &&
                          cont.statusType.value == StatusType.PICKEDUP) ...[
                        Expanded(
                          child: Container(
                            height: 40.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                12.r,
                              ),
                              boxShadow: [
                                AppBoxShadow.defaultShadow(),
                              ],
                            ),
                            child: Text(
                              cont.currentRideAddress.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => LocationScreen(
                                  isRideLocationUpdate: true,
                                ));
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  12.r,
                                ),
                                boxShadow: [
                                  AppBoxShadow.defaultShadow(),
                                ]),
                            child: const Icon(Icons.directions),
                          ),
                        ),
                      ],
                    ])),
                // Positioned(
                //   top: 150.h,
                //   left: 25.w,
                //   right: 5.w,
                //   child: Container(
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         if (cont.userUiSelectionType.value !=
                //                 UserUiSelectionType.serviceType &&
                //             cont.userUiSelectionType.value !=
                //                 UserUiSelectionType.vehicleDetails &&
                //             cont.userUiSelectionType.value !=
                //                 UserUiSelectionType.scheduleRide)
                //           GestureDetector(
                //             onTap: () {
                //               _scaffoldKey.currentState!.openDrawer();
                //             },
                //             child: Container(
                //               height: 40.w,
                //               width: 40.w,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(12.r),
                //                   boxShadow: [
                //                     AppBoxShadow.defaultShadow(),
                //                   ]),
                //               child: Center(
                //                 child: Image.asset(
                //                   AppImage.icMenu,
                //                   width: 18.w,
                //                 ),
                //               ),
                //             ),
                //           )
                //         else
                //           GestureDetector(
                //             onTap: () {
                //               _shouldScaleDown = false;
                //               if (cont.userUiSelectionType.value ==
                //                       UserUiSelectionType.scheduleRide ||
                //                   cont.userUiSelectionType.value ==
                //                       UserUiSelectionType.vehicleDetails) {
                //                 cont.userUiSelectionType.value =
                //                     UserUiSelectionType.serviceType;
                //                 return;
                //               }
                //               if (cont.userUiSelectionType.value ==
                //                   UserUiSelectionType.serviceType) {
                //                 isSubmit = false;
                //                 cont.clearData();
                //                 cont.userUiSelectionType.value =
                //                     UserUiSelectionType.locationSelection;
                //                 return;
                //               }
                //               cont.clearData();
                //               cont.userUiSelectionType.value =
                //                   UserUiSelectionType.locationSelection;
                //             },
                //             child: Container(
                //               height: 40.w,
                //               width: 40.w,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(
                //                     12.r,
                //                   ),
                //                   boxShadow: [
                //                     AppBoxShadow.defaultShadow(),
                //                   ]),
                //               child: Center(
                //                 child: Image.asset(
                //                   AppImage.back,
                //                   width: 20.w,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         if (cont.currentRideAddress.isNotEmpty &&
                //             cont.statusType.value == StatusType.PICKEDUP) ...[
                //           Expanded(
                //             child: Container(
                //               height: 40.w,
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 10.w, vertical: 5.h),
                //               margin: EdgeInsets.symmetric(horizontal: 5.w),
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(
                //                   12.r,
                //                 ),
                //                 boxShadow: [
                //                   AppBoxShadow.defaultShadow(),
                //                 ],
                //               ),
                //               child: Text(
                //                 cont.currentRideAddress.value,
                //                 overflow: TextOverflow.ellipsis,
                //                 maxLines: 2,
                //                 style: TextStyle(
                //                   fontSize: 12.sp,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               Get.to(() => LocationScreen(
                //                     isRideLocationUpdate: true,
                //                   ));
                //             },
                //             child: Container(
                //               width: 40.w,
                //               height: 40.w,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(
                //                     12.r,
                //                   ),
                //                   boxShadow: [
                //                     AppBoxShadow.defaultShadow(),
                //                   ]),
                //               child: const Icon(Icons.directions),
                //             ),
                //           ),
                //         ],
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 75,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: double.infinity,
                //     child: Image.asset(
                //       'assets/images/top_home.png',
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 200,
                //   child: GestureDetector(
                //     onTap: () {
                //       determinePosition();
                //     },
                //     child: Container(
                //       height: 40.w,
                //       width: 40.w,
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(10.r),
                //           boxShadow: [
                //             BoxShadow(
                //               color: AppColors.primaryColor.withOpacity(0.06),
                //               offset: Offset(0, 12.h),
                //               blurRadius: 16.r,
                //             )
                //           ]),
                //       child: Center(
                //         child: Image.asset(
                //           AppImage.icGPS,
                //           width: 25.w,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                if (cont.statusType.value == StatusType.PICKEDUP) ...[
                  Positioned(
                    top: 115,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35)),
                          child: Column(
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 5.w),
                                  Text('To:',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500)),

                                  Expanded(
                                      child: Container(
                                    child: TextFormField(
                                      focusNode: cont.locationWhereToFocusNode,
                                      controller: cont.locationWhereTo1,
                                      readOnly: true,
                                      // readOnly: isRideLocationUpdateRead
                                      //     ? true
                                      //     : false,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            "${cont.locationWhereTo1.text.isEmpty ? cont.currentRideAddress : ''}",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xff9F9F9F)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 12.h),
                                      ),
                                      // onTap: () {
                                      //   cont.locationWhereTo1.text =
                                      //       cont.currentRideAddress.value;
                                      // },
                                      onChanged: (s) async {
                                        await cont.getLocationFromAddress(
                                            address: s);

                                        cont.locationWhereTo1.text =
                                            cont.currentRideAddress.value;
                                      },
                                    ),
                                  )),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  // cont.locationWhereTo1.text.isEmpty
                                  //     ? IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(Icons.edit))
                                  //     :
                                  InkWell(
                                      onTap: () async {
                                        // cont.locationWhereTo1.clear();
                                        print("OnTapEDIT");
                                        Get.to(LocationScreen(
                                          isRideLocationUpdate: true,
                                        ))?.then((value) =>
                                            cont.locationWhereTo1.clear());
                                      },
                                      child: Image.asset(
                                        AppImage.pencil,
                                        height: 50,
                                        width: 50,
                                      )),
                                ],
                              ),
                              if (cont.searchAddressList.isNotEmpty)
                                Container(
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
                                          cont.locationWhereTo1.text =
                                              autocompletePrediction
                                                      .description ??
                                                  "";
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
                            ],
                          ),
                        ),
                        // if (cont.searchAddressList.isNotEmpty)
                        // Container(
                        //   height: 120,
                        //   child: ListView.builder(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 12.w, vertical: 10),
                        //     // physics: NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       AutocompletePrediction autocompletePrediction =
                        //           cont.searchAddressList[index];
                        //       return InkWell(
                        //         onTap: () {
                        //           cont.locationWhereTo1.text =
                        //               autocompletePrediction.description ?? "";
                        //           cont
                        //               .getPlaceIdToLatLag(
                        //                   placeId:
                        //                       autocompletePrediction.placeId!)
                        //               .then((value) {
                        //             cont.removeUnFocusManager();
                        //             setState(() {});
                        //           });
                        //           cont.searchAddressList.clear();
                        //         },
                        //         child: Container(
                        //           child: Row(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Icon(
                        //                 Icons.location_on,
                        //               ),
                        //               Expanded(
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
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
                        //                     if (cont.searchAddressList.length -
                        //                             1 !=
                        //                         index)
                        //                       Container(
                        //                         margin: EdgeInsets.symmetric(
                        //                             vertical: 5.h),
                        //                         width: double.infinity,
                        //                         height: 1.h,
                        //                         color: Colors.grey
                        //                             .withOpacity(0.5),
                        //                       )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     itemCount: cont.searchAddressList.length,
                        //     shrinkWrap: true,
                        //     // physics: NeverScrollableScrollPhysics(),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],

                if (cont.userUiSelectionType.value ==
                    UserUiSelectionType.locationSelection)
                  DraggableScrollableSheet(
                    initialChildSize: (userCont
                                .locationResponseModel.value.home.isEmpty &&
                            userCont.locationResponseModel.value.work.isEmpty &&
                            userCont.locationResponseModel.value.others.isEmpty)
                        ? 0.385
                        : 0.46,
                    minChildSize: (userCont
                                .locationResponseModel.value.home.isEmpty &&
                            userCont.locationResponseModel.value.work.isEmpty &&
                            userCont.locationResponseModel.value.others.isEmpty)
                        ? 0.385
                        : 0.46,
                    maxChildSize: .6,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                          child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 22),
                              child: GestureDetector(
                                onTap: () {
                                  determinePosition();
                                },
                                child: Container(
                                  height: 35.w,
                                  width: 35.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(55.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.06),
                                          offset: Offset(0, 12.h),
                                          blurRadius: 16.r,
                                        )
                                      ]),
                                  child: Center(
                                      child: Image.asset(
                                    AppImage.point,
                                    width: 23,
                                    height: 23,
                                  )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                          ),
                          Container(
                            height: (userCont.locationResponseModel.value.home
                                        .isEmpty &&
                                    userCont.locationResponseModel.value.work
                                        .isEmpty &&
                                    userCont.locationResponseModel.value.others
                                        .isEmpty)
                                ? MediaQuery.of(context).size.height * 0.255
                                : MediaQuery.of(context).size.height * 0.383,
                            decoration: BoxDecoration(
                              color: AppColors.skyBlue,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Divider(
                                  //   indent:
                                  //       MediaQuery.of(context).size.width * 0.3,
                                  //   endIndent:
                                  //       MediaQuery.of(context).size.width * 0.3,
                                  //   thickness: 1,
                                  // ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(cont.availableModules.isEmpty? 'Where would you like to get your \ncar picked up from?' :
                                          'How can we assist you?',
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (userCont.locationResponseModel.value
                                          .home.isNotEmpty)
                                        GestureDetector(
                                          onTap: () async {
                                            if (cont.userCurrentLocation !=
                                                null) {
                                              if (_homeController
                                                  .showDriverLocationList
                                                  .isNotEmpty) {
                                                await cont
                                                    .getNearDriverTimeData();
                                              }
                                              setState(() {
                                                isDriverShow = false;
                                              });
                                              Home home = userCont
                                                  .locationResponseModel
                                                  .value
                                                  .home
                                                  .last;
                                              cont.tempLatLngWhereTo1 = LatLng(
                                                  home.latitude ?? 0,
                                                  home.longitude ?? 0);
                                              cont.tempLocationWhereTo1.text =
                                                  home.address ?? "";
                                              cont.selectedLocationDrawRoute();
                                              isSubmit = false;
                                              _shouldScaleDown = false;
                                            } else {
                                              Get.snackbar("Alert",
                                                  "Please wait, your current location found",
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  colorText: Colors.white);
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(AppImage.home,
                                                  width: 40, height: 40),
                                              SizedBox(height: 5),
                                              Text(
                                                'home'.tr,
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ),
                                      if (userCont.locationResponseModel.value
                                          .work.isNotEmpty)
                                        GestureDetector(
                                          onTap: () async {
                                            if (cont.userCurrentLocation !=
                                                null) {
                                              if (_homeController
                                                  .showDriverLocationList
                                                  .isNotEmpty) {
                                                await cont
                                                    .getNearDriverTimeData();
                                              }
                                              setState(() {
                                                isDriverShow = false;
                                              });
                                              Home home = userCont
                                                  .locationResponseModel
                                                  .value
                                                  .work
                                                  .last;
                                              cont.tempLatLngWhereTo1 = LatLng(
                                                  home.latitude ?? 0,
                                                  home.longitude ?? 0);
                                              cont.tempLocationWhereTo1.text =
                                                  home.address ?? "";
                                              cont.selectedLocationDrawRoute();
                                              isSubmit = false;
                                              _shouldScaleDown = false;
                                            } else {
                                              Get.snackbar("Alert",
                                                  "Please wait, your current location found",
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  colorText: Colors.white);
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(AppImage.work,
                                                  width: 40, height: 40),
                                              SizedBox(height: 5),
                                              Text(
                                                'work'.tr,
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ),
                                      if (userCont.locationResponseModel.value
                                          .others.isNotEmpty)
                                        GestureDetector(
                                          onTap: () async {
                                            if (cont.userCurrentLocation !=
                                                null) {
                                              if (_homeController
                                                  .showDriverLocationList
                                                  .isNotEmpty) {
                                                await cont
                                                    .getNearDriverTimeData();
                                              }
                                              setState(() {
                                                isDriverShow = false;
                                              });
                                              Home home = userCont
                                                  .locationResponseModel
                                                  .value
                                                  .others
                                                  .last;
                                              cont.tempLatLngWhereTo1 = LatLng(
                                                  home.latitude ?? 0,
                                                  home.longitude ?? 0);
                                              cont.tempLocationWhereTo1.text =
                                                  home.address ?? "";
                                              cont.selectedLocationDrawRoute();
                                              isSubmit = false;
                                              _shouldScaleDown = false;
                                            } else {
                                              Get.snackbar("Alert",
                                                  "Please wait, your current location found",
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8),
                                                  colorText: Colors.white);
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(AppImage.favorite,
                                                  height: 40, width: 40),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'other'.tr,
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.grey[100],
                                  //     borderRadius: BorderRadius.circular(10),
                                  //   ),
                                  //   child: const TextField(
                                  //     decoration: InputDecoration(
                                  //       prefixIcon: Icon(Icons.search),
                                  //       // labelText: "Enter Destination",
                                  //       hintText: "Enter Destination",
                                  //       enabledBorder: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(20.0)),
                                  //         borderSide: BorderSide(
                                  //           color: Colors.grey,
                                  //         ),
                                  //       ),
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(10.0)),
                                  //         borderSide:
                                  //             BorderSide(color: Colors.grey),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // if (userCont.locationResponseModel
                                      //         .value.home.isNotEmpty ||
                                      //     userCont.locationResponseModel
                                      //         .value.work.isNotEmpty)
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceEvenly,
                                      //   children: [
                                      //       if (userCont
                                      //           .locationResponseModel
                                      //           .value
                                      //           .home
                                      //           .isNotEmpty)
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             Home home = userCont
                                      //                 .locationResponseModel
                                      //                 .value
                                      //                 .home[0];
                                      //             cont.tempLatLngWhereTo1 =
                                      //                 LatLng(
                                      //                     home.latitude ??
                                      //                         0,
                                      //                     home.longitude ??
                                      //                         0);
                                      //             cont.tempLocationWhereTo1
                                      //                     .text =
                                      //                 home.address ?? "";
                                      //             cont.selectedLocationDrawRoute();
                                      //             isSubmit = false;
                                      //             _shouldScaleDown = false;
                                      //           },
                                      //           child: Column(
                                      //             children: [
                                      //               Container(
                                      //                 height: 40.w,
                                      //                 width: 40.w,
                                      //                 decoration:
                                      //                     BoxDecoration(
                                      //                   color: Colors.white,
                                      //                   border: Border.all(
                                      //                       color: Colors
                                      //                           .grey),
                                      //                   shape:
                                      //                       BoxShape.circle,
                                      //                 ),
                                      //                 child: Center(
                                      //                   child: Image.asset(
                                      //                     AppImage.icHome,
                                      //                     height: 23.w,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               Text(
                                      //                 "home".tr,
                                      //                 style: TextStyle(
                                      //                     color:
                                      //                         Colors.black,
                                      //                     fontWeight:
                                      //                         FontWeight
                                      //                             .w500,
                                      //                     fontSize: 12.sp),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       if (userCont
                                      //           .locationResponseModel
                                      //           .value
                                      //           .work
                                      //           .isNotEmpty)
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             Home home = userCont
                                      //                 .locationResponseModel
                                      //                 .value
                                      //                 .work[0];
                                      //             cont.tempLatLngWhereTo1 =
                                      //                 LatLng(
                                      //                     home.latitude ??
                                      //                         0,
                                      //                     home.longitude ??
                                      //                         0);
                                      //             cont.tempLocationWhereTo1
                                      //                     .text =
                                      //                 home.address ?? "";
                                      //             cont.selectedLocationDrawRoute();
                                      //             isSubmit = false;
                                      //             _shouldScaleDown = false;
                                      //           },
                                      //           child: Column(
                                      //             children: [
                                      //               Container(
                                      //                 height: 40.w,
                                      //                 width: 40.w,
                                      //                 decoration:
                                      //                     BoxDecoration(
                                      //                   color: Colors.white,
                                      //                   border: Border.all(
                                      //                       color: Colors
                                      //                           .grey),
                                      //                   shape:
                                      //                       BoxShape.circle,
                                      //                 ),
                                      //                 child: Center(
                                      //                   child: Image.asset(
                                      //                     AppImage.icWork,
                                      //                     height: 23.w,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               Text(
                                      //                 "work".tr,
                                      //                 style: TextStyle(
                                      //                   color: AppColors.primaryColor,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                   fontSize: 12.sp,
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //     ],
                                      //   ),
                                      // SizedBox(height: 5.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => LocationScreen());
                                                isSubmit = false;
                                                _shouldScaleDown = false;
                                              },
                                              child: Container(
                                                  // height: 55.h,
                                                  // padding:
                                                  //     EdgeInsets.symmetric(
                                                  //   horizontal: 20.w,
                                                  //   vertical: 10.h,
                                                  // ),
                                                  // alignment:
                                                  //     Alignment.center,
                                                  // width: double.infinity,
                                                  // decoration: BoxDecoration(
                                                  //   color: Colors.grey[200],
                                                  //   borderRadius:
                                                  //       BorderRadius
                                                  //           .circular(10.r),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: AppColors.primaryColor
                                                  //         .withOpacity(0.06),
                                                  //     offset: Offset(0, 12.h),
                                                  //     blurRadius: 10.r,
                                                  //   )
                                                  // ],
                                                  // ),
                                                  // child:
                                                  // TextField(
                                                  //   controller:
                                                  //       cont.locationFromTo,
                                                  //   style: TextStyle(
                                                  //     color: AppColors.primaryColor,
                                                  //     fontSize: 14.sp,
                                                  //     fontWeight:
                                                  //         FontWeight.w400,
                                                  //   ),
                                                  //   decoration:
                                                  //       InputDecoration(
                                                  //           hintText:
                                                  //               "from_to"
                                                  //                   .tr,
                                                  //           isDense: true,
                                                  //           contentPadding:
                                                  //               EdgeInsets
                                                  //                   .zero,
                                                  //           border:
                                                  //               InputBorder
                                                  //                   .none,
                                                  //           prefixIcon:
                                                  //               Icon(
                                                  //             Icons
                                                  //                 .location_on,
                                                  //             color: Colors
                                                  //                 .black,
                                                  //             size: 25,
                                                  //           ),
                                                  //           hintStyle:
                                                  //               TextStyle(
                                                  //             color: Colors
                                                  //                 .black,
                                                  //             fontSize:
                                                  //                 14.sp,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .w500,
                                                  //           )),
                                                  //   minLines: 1,
                                                  //   maxLines: 2,
                                                  //   readOnly: true,
                                                  //   enabled: false,
                                                  // ),
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     determinePosition();
                                          //   },
                                          //   child: Container(
                                          //     height: 40.w,
                                          //     width: 40.w,
                                          //     decoration: BoxDecoration(
                                          //         color: Colors.white,
                                          //         borderRadius:
                                          //             BorderRadius.circular(10.r),
                                          //         boxShadow: [
                                          //           BoxShadow(
                                          //             color: AppColors.primaryColor
                                          //                 .withOpacity(0.06),
                                          //             offset: Offset(0, 12.h),
                                          //             blurRadius: 16.r,
                                          //           )
                                          //         ]),
                                          //     child: Center(
                                          //       child: Image.asset(
                                          //         AppImage.icGPS,
                                          //         width: 25.w,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 3.h),
                                      cont.availableModules.isNotEmpty?
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: SizedBox(height:MediaQuery.of(context).size.height*0.155,
                                          child: ListView.builder(
                                              itemCount: cont.availableModules.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context, int index) {
                                                return cont.availableModules[index]['status'] == 1?
                                                    GestureDetector(onTap: (){
                                                      index==0? {
                                                                    cont.isRideSelected.value = true,
                                                                    Get.to(() => LocationScreen()),
                                                                    isSubmit = false,
                                                                    _shouldScaleDown = false
                                                      } : {
                                                        // cont.tempLocationWhereTo1.clear(),
                                                        // cont.locationWhereTo1.clear(),
                                                        cont.latLngWhereTo1 = null,
                                                        cont.latLngWhereTo2 = LatLng(0, 0),
                                                        cont.latLngWhereTo3 = LatLng(0, 0),
                                                        cont.isRideSelected.value = false,
                                                        Get.to(() => LocationScreen()),
                                                        isSubmit = false,
                                                        _shouldScaleDown = false
                                                        //Get.to(()=> LaunchingSoon())
                                                      };
                                                    },
                                                      child: assistWidget('${ApiUrl.baseImageUrl}/storage/${cont.availableModules[index]['image']}',
                                                          cont.availableModules[index]['url']),
                                                    ) : SizedBox();
                                              }),
                                        ),
                                      //),
                                        // Row(mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        //     isModelAvailable('Towing')==1?
                                        //     GestureDetector(onTap: (){
                                        //             Get.to(() => LocationScreen());
                                        //             isSubmit = false;
                                        //             _shouldScaleDown = false;
                                        //     },child: assistWidget(AppImage.assist11,'Towing')) : SizedBox(),
                                        //
                                        //     isModelAvailable('Road Side Service')==1? SizedBox(width:
                                        //       MediaQuery.of(context).size.width*0.07,) : SizedBox(),
                                        //
                                        //     isModelAvailable('Road Side Service')==1?
                                        //     GestureDetector(onTap: (){
                                        //       Get.to(()=> LaunchingSoon());
                                        //     },child: assistWidget(AppImage.assist22,'Road Side Service')) : SizedBox(),
                                        //   ],),
                                      ) :
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            cont.isRideSelected.value = true;
                                            Get.to(() => LocationScreen());
                                            isSubmit = false;
                                            _shouldScaleDown = false;
                                          },
                                          child: Container(
                                            height: 50.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                                vertical: 10.h),
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: AppColors.primaryColor
                                              //         .withOpacity(0.06),
                                              //     offset: Offset(0, 12.h),
                                              //     blurRadius: 10.r,
                                              //   )
                                              // ],
                                            ),
                                            child: TextField(
                                              controller: cont.locationWhereTo1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                hintText:
                                                    'Enter Destination',
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    AppImage.search,
                                                    width: 27,
                                                    height: 27,
                                                    fit: BoxFit.contain,
                                                    color:
                                                        Colors.black,
                                                  ),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 15.sp),
                                                border: InputBorder.none,
                                              ),
                                              minLines: 1,
                                              maxLines: 2,
                                              readOnly: true,
                                              enabled: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                  //SizedBox(height: 8),
                                  // _userController.arbyBanner.value.banners ==
                                  //             null ||
                                  //         _userController
                                  //             .arbyBanner.value.banners!.isEmpty
                                  //     ? SizedBox()
                                  //     : Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           ClipRRect(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(30),
                                  //             child: Image.network(
                                  //               ApiUrl.baseImageUrl +
                                  //                   "storage/${_userController.arbyBanner.value.banners!.first.image}",
                                  //               fit: BoxFit.contain,
                                  //               height: 113,
                                  //               width: MediaQuery.of(context)
                                  //                       .size
                                  //                       .width *
                                  //                   0.6,
                                  //             ),
                                  //           ),
                                  //           ClipRRect(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(30),
                                  //             child: Image.network(
                                  //               ApiUrl.baseImageUrl +
                                  //                   "storage/${_userController.arbyBanner.value.banners!.last.image}",
                                  //               height: 113,
                                  //               width: MediaQuery.of(context)
                                  //                       .size
                                  //                       .width *
                                  //                   0.3,
                                  //               fit: BoxFit.fitWidth,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.to(() => LocationScreen());
                                  //     isSubmit = false;
                                  //     _shouldScaleDown = false;
                                  //   },
                                  //   child: Card(
                                  //     child: Container(
                                  //       height: 50.h,
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 10.w, vertical: 10.h),
                                  //       alignment: Alignment.center,
                                  //       width: double.infinity,
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         borderRadius:
                                  //             BorderRadius.circular(10.r),
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             color:
                                  //                 Colors.black.withOpacity(0.06),
                                  //             offset: Offset(0, 12.h),
                                  //             blurRadius: 16.r,
                                  //           )
                                  //         ],
                                  //       ),
                                  //       child: TextField(
                                  //         controller: cont.locationWhereTo1,
                                  //         textAlign: TextAlign.start,
                                  //         style: TextStyle(
                                  //           color: AppColors.primaryColor,
                                  //           fontSize: 14.sp,
                                  //           fontWeight: FontWeight.w400,
                                  //         ),
                                  //         textAlignVertical:
                                  //             TextAlignVertical.center,
                                  //         decoration: InputDecoration(
                                  //           isDense: true,
                                  //           contentPadding: EdgeInsets.zero,
                                  //           hintText: "Enter Destination",
                                  //           prefixIcon: Icon(
                                  //             Icons.search_rounded,
                                  //             size: 25,
                                  //           ),
                                  //           hintStyle: TextStyle(
                                  //               color: Colors.grey,
                                  //               fontSize: 12.sp),
                                  //           border: InputBorder.none,
                                  //         ),
                                  //         minLines: 1,
                                  //         maxLines: 2,
                                  //         readOnly: true,
                                  //         enabled: false,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text(
                                  //       'Recent Locations',
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.w500,
                                  //           fontSize: 14),
                                  //     ),
                                  //     ListTile(
                                  //       leading:
                                  //           Icon(Icons.watch_later_sharp),
                                  //       title: Text(
                                  //         'Mozilit',
                                  //         style: TextStyle(fontSize: 14),
                                  //       ),
                                  //       subtitle: Text(
                                  //         '49, Shiv Nagar, Block E10, Peer Muchalla, Zirakpur, Punjab',
                                  //         style: TextStyle(fontSize: 12),
                                  //       ),
                                  //     ),
                                  //     Divider(
                                  //       indent: 60,
                                  //     ),
                                  //     ListTile(
                                  //       leading:
                                  //           Icon(Icons.watch_later_sharp),
                                  //       title: Text(
                                  //         'Mozilit',
                                  //         style: TextStyle(fontSize: 14),
                                  //       ),
                                  //       subtitle: Text(
                                  //         '49, Shiv Nagar, Block E10, Peer Muchalla, Zirakpur, Punjab',
                                  //         style: TextStyle(fontSize: 12),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Container(
                                  //   height: 90,
                                  //   width: double.infinity,
                                  //   color: Colors.white,
                                  //   child: Image.asset(
                                  //     AppImage.home_banner,
                                  //     fit: BoxFit.fill,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: () {
                                  //         Get.to(() => YourTripsScreen());
                                  //       },
                                  //       child: Card(
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10)),
                                  //         child: Container(
                                  //             padding: EdgeInsets.all(7),
                                  //             height: 60,
                                  //             width: 80,
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         10)),
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceAround,
                                  //               children: [
                                  //                 Icon(
                                  //                   Icons.format_align_left,
                                  //                   size: 25,
                                  //                 ),
                                  //                 Text(
                                  //                   'Past Rides',
                                  //                   style:
                                  //                       TextStyle(fontSize: 11),
                                  //                 )
                                  //               ],
                                  //             )),
                                  //       ),
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () {
                                  //         Get.to(() => WalletScreen());
                                  //       },
                                  //       child: Card(
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10)),
                                  //         child: Container(
                                  //             padding: EdgeInsets.all(7),
                                  //             height: 60,
                                  //             width: 80,
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         10)),
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceAround,
                                  //               children: [
                                  //                 Icon(
                                  //                   Icons.wallet_rounded,
                                  //                   size: 25,
                                  //                 ),
                                  //                 Text(
                                  //                   'Wallet',
                                  //                   style:
                                  //                       TextStyle(fontSize: 12),
                                  //                 )
                                  //               ],
                                  //             )),
                                  //       ),
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () {
                                  //         Get.to(() => ProfilePage());
                                  //       },
                                  //       child: Card(
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10)),
                                  //         child: Container(
                                  //             padding: EdgeInsets.all(7),
                                  //             height: 60,
                                  //             width: 80,
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.white,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         10)),
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceAround,
                                  //               children: [
                                  //                 Icon(
                                  //                   Icons
                                  //                       .account_circle_rounded,
                                  //                   size: 25,
                                  //                 ),
                                  //                 Text(
                                  //                   'Account',
                                  //                   style:
                                  //                       TextStyle(fontSize: 12),
                                  //                 )
                                  //               ],
                                  //             )),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 25,
                                  // )
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                    },
                  ),

                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 15.w, vertical: 10),
                //     margin: EdgeInsets.only(bottom: 50.h),
                //     width: MediaQuery.of(context).size.width,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         if (userCont
                //                 .locationResponseModel.value.home.isNotEmpty ||
                //             userCont
                //                 .locationResponseModel.value.work.isNotEmpty)
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: [
                //               if (userCont
                //                   .locationResponseModel.value.home.isNotEmpty)
                //                 GestureDetector(
                //                   onTap: () {
                //                     Home home = userCont
                //                         .locationResponseModel.value.home[0];
                //                     cont.tempLatLngWhereTo1 = LatLng(
                //                         home.latitude ?? 0,
                //                         home.longitude ?? 0);
                //                     cont.tempLocationWhereTo1.text =
                //                         home.address ?? "";
                //                     cont.selectedLocationDrawRoute();
                //                     isSubmit = false;
                //                     _shouldScaleDown = false;
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                         height: 40.w,
                //                         width: 40.w,
                //                         decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           border:
                //                               Border.all(color: Colors.grey),
                //                           shape: BoxShape.circle,
                //                         ),
                //                         child: Center(
                //                           child: Image.asset(
                //                             AppImage.icHome,
                //                             height: 23.w,
                //                           ),
                //                         ),
                //                       ),
                //                       Text(
                //                         "home".tr,
                //                         style: TextStyle(
                //                             color: AppColors.primaryColor,
                //                             fontWeight: FontWeight.w500,
                //                             fontSize: 12.sp),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               if (userCont
                //                   .locationResponseModel.value.work.isNotEmpty)
                //                 GestureDetector(
                //                   onTap: () {
                //                     Home home = userCont
                //                         .locationResponseModel.value.work[0];
                //                     cont.tempLatLngWhereTo1 = LatLng(
                //                         home.latitude ?? 0,
                //                         home.longitude ?? 0);
                //                     cont.tempLocationWhereTo1.text =
                //                         home.address ?? "";
                //                     cont.selectedLocationDrawRoute();
                //                     isSubmit = false;
                //                     _shouldScaleDown = false;
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                         height: 40.w,
                //                         width: 40.w,
                //                         decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           border:
                //                               Border.all(color: Colors.grey),
                //                           shape: BoxShape.circle,
                //                         ),
                //                         child: Center(
                //                           child: Image.asset(
                //                             AppImage.icWork,
                //                             height: 23.w,
                //                           ),
                //                         ),
                //                       ),
                //                       Text(
                //                         "work".tr,
                //                         style: TextStyle(
                //                           color: AppColors.primaryColor,
                //                           fontWeight: FontWeight.w500,
                //                           fontSize: 12.sp,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //             ],
                //           ),
                //         SizedBox(height: 5.h),
                //         Row(
                //           children: [
                //             Expanded(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   Get.to(() => LocationScreen());
                //                   isSubmit = false;
                //                   _shouldScaleDown = false;
                //                 },
                //                 child: Container(
                //                   height: 55.h,
                //                   padding: EdgeInsets.symmetric(
                //                     horizontal: 20.w,
                //                     vertical: 13.h,
                //                   ),
                //                   alignment: Alignment.center,
                //                   width: double.infinity,
                //                   decoration: BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius: BorderRadius.circular(30.r),
                //                     boxShadow: [
                //                       BoxShadow(
                //                         color: AppColors.primaryColor
                //                             .withOpacity(0.06),
                //                         offset: Offset(0, 12.h),
                //                         blurRadius: 16.r,
                //                       )
                //                     ],
                //                   ),
                //                   child: TextField(
                //                     controller: cont.locationFromTo,
                //                     style: TextStyle(
                //                       color: AppColors.primaryColor,
                //                       fontSize: 14.sp,
                //                       fontWeight: FontWeight.w400,
                //                     ),
                //                     decoration: InputDecoration(
                //                         hintText: "from_to".tr,
                //                         isDense: true,
                //                         contentPadding: EdgeInsets.zero,
                //                         border: InputBorder.none,
                //                         hintStyle: TextStyle(
                //                           color: AppColors.primaryColor,
                //                           fontSize: 14.sp,
                //                           fontWeight: FontWeight.w500,
                //                         )),
                //                     minLines: 1,
                //                     maxLines: 2,
                //                     readOnly: true,
                //                     enabled: false,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             SizedBox(width: 10.w),
                //             GestureDetector(
                //               onTap: () {
                //                 determinePosition();
                //               },
                //               child: Container(
                //                 height: 40.w,
                //                 width: 40.w,
                //                 decoration: BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius: BorderRadius.circular(10.r),
                //                     boxShadow: [
                //                       BoxShadow(
                //                         color: AppColors.primaryColor
                //                             .withOpacity(0.06),
                //                         offset: Offset(0, 12.h),
                //                         blurRadius: 16.r,
                //                       )
                //                     ]),
                //                 child: Center(
                //                   child: Image.asset(
                //                     AppImage.icGPS,
                //                     width: 25.w,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 15.h),
                //         GestureDetector(
                //           onTap: () {
                //             Get.to(() => LocationScreen());
                //             isSubmit = false;
                //             _shouldScaleDown = false;
                //           },
                //           child: Container(
                //             height: 55.h,
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 20.w, vertical: 13.h),
                //             alignment: Alignment.center,
                //             width: double.infinity,
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(30.r),
                //               boxShadow: [
                //                 BoxShadow(
                //                   color:
                //                       AppColors.primaryColor.withOpacity(0.06),
                //                   offset: Offset(0, 12.h),
                //                   blurRadius: 16.r,
                //                 )
                //               ],
                //             ),
                //             child: TextField(
                //               controller: cont.locationWhereTo1,
                //               textAlign: TextAlign.start,
                //               style: TextStyle(
                //                 color: AppColors.primaryColor,
                //                 fontSize: 14.sp,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //               textAlignVertical: TextAlignVertical.center,
                //               decoration: InputDecoration(
                //                 isDense: true,
                //                 contentPadding: EdgeInsets.zero,
                //                 hintText: "where_to?".tr,
                //                 hintStyle: TextStyle(
                //                     color: AppColors.primaryColor,
                //                     fontSize: 14.sp),
                //                 border: InputBorder.none,
                //               ),
                //               minLines: 1,
                //               maxLines: 2,
                //               readOnly: true,
                //               enabled: false,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                if (cont.userUiSelectionType.value ==
                    UserUiSelectionType.serviceType)
                  isSubmit == false
                      ? Positioned(
                          bottom: 0.h,
                          left: 0.w,
                          right: 0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    determinePosition();
                                  },
                                  child: Container(
                                    height: 35.w,
                                    width: 35.w,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle
                                        // borderRadius:
                                        //     BorderRadius.circular(5.r),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black
                                        //         .withOpacity(0.06),
                                        //     offset: Offset(0, 12.h),
                                        //     blurRadius: 16.r,
                                        //   )
                                        // ]
                                        ),
                                    child: Image.asset(AppImage.point,
                                        width: 23,
                                        height: 23,
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(40.0),
                                      bottomLeft: Radius.circular(0.0)),
                                  boxShadow: [
                                    AppBoxShadow.defaultShadow(),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Divider(
                                    //   thickness: 2,
                                    //   indent:
                                    //       MediaQuery.of(context).size.width *
                                    //           0.32,
                                    //   endIndent:
                                    //       MediaQuery.of(context).size.width *
                                    //           0.32,
                                    // ),
                                    SizedBox(height: 15.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          cont.isRideSelected.value?
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              'trip_details'.tr,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ) : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              'Where do you need the Mechanic?'.tr,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),

                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       // padding: EdgeInsets.all(4.w),
                                          //       height: 10.w,
                                          //       width: 10.w,
                                          //       decoration: BoxDecoration(
                                          //         shape: BoxShape.circle,
                                          //         color: AppColors.primaryColor,
                                          //       ),
                                          //       // child: Container(
                                          //       //   decoration: BoxDecoration(
                                          //       //       shape: BoxShape.circle,
                                          //       //       color: Colors.white),
                                          //       // ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 15,
                                          //     ),
                                          //     Flexible(
                                          //       child: Column(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         children: [
                                          //           Text('Home',
                                          //               style: TextStyle(
                                          //                   fontSize: 14,
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w500)),
                                          //           Text(
                                          //               '${cont.locationFromTo.text}',
                                          //               style: TextStyle(
                                          //                   fontSize: 12)),
                                          //         ],
                                          //       ),
                                          //     )
                                          //   ],
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(left: 5.w),
                                          //   child: Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: Container(
                                          //       height: 25.h,
                                          //       width: 1.w,
                                          //       color: AppColors.primaryColor,
                                          //     ),
                                          //     // DottedLine(
                                          //     //   direction: Axis.vertical,
                                          //     //   dashcolor: AppColors.primaryColor,
                                          //     //   lineLength: 15.h,
                                          //     //   dashLength: 3,
                                          //     // ),
                                          //   ),
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       // padding: EdgeInsets.only(4.w),
                                          //       height: 10.w,
                                          //       width: 10.w,
                                          //       decoration: BoxDecoration(
                                          //         shape: BoxShape.circle,
                                          //         color: AppColors.primaryColor,
                                          //       ),
                                          //       // child: Container(
                                          //       //   decoration: BoxDecoration(
                                          //       //     shape: BoxShape.circle,
                                          //       //   ),
                                          //       // ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 15,
                                          //     ),
                                          //     Flexible(
                                          //       child: Column(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         children: [
                                          //           Text('Mozilit',
                                          //               style: TextStyle(
                                          //                   fontSize: 14,
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w500)),
                                          //           Text(
                                          //               '${cont.locationWhereTo1.text}',
                                          //               style: TextStyle(
                                          //                   fontSize: 12)),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 10,
                                          //     ),

                                          //   ],
                                          // )
                                          cont.isRideSelected.value?
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    timelineRow("source".tr,
                                                        '${cont.locationFromTo.text}'),
                                                    SizedBox(
                                                      height: 0,
                                                    ),
                                                    timelineLastRow(
                                                        "destination".tr,
                                                        '${cont.locationWhereTo1.text}'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 50,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Text(""),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          LocationScreen());
                                                      isSubmit = false;
                                                      _shouldScaleDown = false;
                                                    },
                                                    child: Text('Change',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontSize: 15,
                                                            fontWeight: ui
                                                                .FontWeight
                                                                .w500)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ) : 
                                              Row(children: [
                                                Image.asset(AppImage.rekoLocation,height:25,width:25 ),
                                                SizedBox(width: 8,),
                                                Expanded(
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                                    SizedBox(height: 2,),
                                                    Text('Current Location',style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.primaryColor)),
                                                    SizedBox(height: 2,),
                                                    Text(cont.locationFromTo.text,
                                                        overflow: TextOverflow.ellipsis,style: TextStyle(
                                                          fontSize: 12.sp,
                                                        )),
                                                    SizedBox(height: 5,),
                                                  ],),
                                                ),
                                                GestureDetector(onTap: (){
                                                  Get.to(() =>
                                                      LocationScreen());
                                                  isSubmit = false;
                                                  _shouldScaleDown = false;
                                                },
                                                  child: Text('Change',style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 15,
                                                      fontWeight: ui
                                                          .FontWeight
                                                          .w500)),
                                                )
                                              ],)
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: AppColors.primaryColor,
                                      indent: 70,
                                      endIndent: 70,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 50.w),
                                      child: Text(
                                        cont.isRideSelected.value? "select_car".tr : 'Select Service',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      height: 120.h,

                                      child: ListView.builder(
                                        itemCount: cont.serviceModelList.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: _serviceWidgetList(
                                                cont: cont, index: index),
                                          );
                                        },
                                      ),
                                      // child: PageView.builder(
                                      //   scrollDirection: Axis.vertical,
                                      //   itemBuilder: (context, index) {
                                      //     return SizedBox(
                                      //       width: double.infinity,
                                      //       child: Padding(
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 20.w),
                                      //         child: Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment
                                      //                   .spaceBetween,
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: _serviceWidgetList(
                                      //               cont: cont, index: index),
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   itemCount: ((cont.serviceModelList
                                      //               .length ~/
                                      //           3) +
                                      //       (cont.serviceModelList.length %
                                      //           3)),
                                      // ),
                                    ),
                                    SizedBox(height: 15.h),
                                    GestureDetector(
                                      onTap: () {
                                        print("isSubmit==>$isSubmit");
                                        setState(() {
                                          isSubmit = true;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 45),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 13.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        child: Text(
                                          "continue".tr,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Positioned(
                          bottom: 0.h,
                          right: 0.w,
                          left: 0.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          cont.userUiSelectionType.value =
                                              UserUiSelectionType.scheduleRide;
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Image.asset(AppImage.time,
                                              height: 50, width: 50),
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     // cont.userUiSelectionType.value =
                                      //     //     UserUiSelectionType.scheduleRide;
                                      //   },
                                      //   child: Container(
                                      //     margin: EdgeInsets.only(left: 10),
                                      //     height: 45.w,
                                      //     width: 45.w,
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.white,
                                      //         borderRadius:
                                      //             BorderRadius.circular(10.r),
                                      //         boxShadow: [
                                      //           AppBoxShadow.defaultShadow(),
                                      //         ]),
                                      //     child: Center(
                                      //       child: Icon(
                                      //         Icons.person_add_alt,
                                      //         size: 30.w,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      determinePosition();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 35.w,
                                      width: 35.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Image.asset(AppImage.point,
                                          width: 23, height: 23),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(40.0),
                                      bottomLeft: Radius.circular(0.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    AppBoxShadow.defaultShadow(),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 10.h),
                                    // Divider(
                                    //   thickness: 2,
                                    //   indent:
                                    //       MediaQuery.of(context).size.width *
                                    //           0.32,
                                    //   endIndent:
                                    //       MediaQuery.of(context).size.width *
                                    //           0.32,
                                    // ),
                                    SizedBox(height: 15.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Text(
                                              'trip_details'.tr,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          cont.isRideSelected.value?
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    timelineSecondRow("home".tr,
                                                        '${cont.locationFromTo.text}'),
                                                    timelineLastSecondRow(
                                                        "destination".tr,
                                                        '${cont.locationWhereTo1.text}'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 50,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Text(""),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          LocationScreen());
                                                      isSubmit = false;
                                                      _shouldScaleDown = false;
                                                    },
                                                    child: Text('Change',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontSize: 15,
                                                            fontWeight: ui
                                                                .FontWeight
                                                                .w500)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ) : Row(children: [
                                            Image.asset(AppImage.rekoLocation,height:25,width:25 ),
                                            SizedBox(width: 8,),
                                            Expanded(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                                SizedBox(height: 2,),
                                                Text('Current Location',style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.primaryColor)),
                                                SizedBox(height: 2,),
                                                Text(cont.locationFromTo.text,
                                                    overflow: TextOverflow.ellipsis,style: TextStyle(
                                                      fontSize: 12.sp,
                                                    )),
                                                SizedBox(height: 5,),
                                              ],),
                                            ),
                                            // GestureDetector(onTap: (){
                                            //   Get.to(() =>
                                            //       LocationScreen());
                                            //   isSubmit = false;
                                            //   _shouldScaleDown = false;
                                            // },
                                            //   child: Text('Change',style: TextStyle(
                                            //       color: AppColors
                                            //           .primaryColor,
                                            //       fontSize: 15,
                                            //       fontWeight: ui
                                            //           .FontWeight
                                            //           .w500)),
                                            // )
                                          ],),

                                          // Row(
                                          //   children: [
                                          //     Column(
                                          //       children: [
                                          //         Container(
                                          //           // padding: EdgeInsets.all(4.w),
                                          //           height: 10.w,
                                          //           width: 10.w,
                                          //           decoration: BoxDecoration(
                                          //             shape: BoxShape.circle,
                                          //             color: AppColors
                                          //                 .primaryColor,
                                          //           ),
                                          //           // child: Container(
                                          //           //   decoration: BoxDecoration(
                                          //           //       shape: BoxShape.circle,
                                          //           //       color: Colors.white),
                                          //           // ),
                                          //         ),
                                          //         Container(
                                          //           height: 25.h,
                                          //           width: 1.w,
                                          //           color:
                                          //               AppColors.primaryColor,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     SizedBox(
                                          //       width: 15,
                                          //     ),
                                          //     Flexible(
                                          //       child: Column(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         children: [
                                          //           Column(
                                          //             children: [
                                          //               Text(
                                          //                 'Home',
                                          //                 style: TextStyle(
                                          //                     fontSize: 14,
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w500),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //           Text(
                                          //               '${cont.locationFromTo.text}',
                                          //               style: TextStyle(
                                          //                   fontSize: 12)),
                                          //         ],
                                          //       ),
                                          //     )
                                          //   ],
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(left: 5.w),
                                          //   child: Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: Container(
                                          //       height: 25.h,
                                          //       width: 1.w,
                                          //       color: AppColors.primaryColor,
                                          //     ),
                                          //     // DottedLine(
                                          //     //   direction: Axis.vertical,
                                          //     //   dashcolor: AppColors.primaryColor,
                                          //     //   lineLength: 15.h,
                                          //     //   dashLength: 3,
                                          //     // ),
                                          //   ),
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Column(
                                          //       children: [
                                          //         Container(
                                          //           height: 25.h,
                                          //           width: 1.w,
                                          //           color:
                                          //               AppColors.primaryColor,
                                          //         ),
                                          //         Container(
                                          //           // padding: EdgeInsets.all(4.w),
                                          //           height: 10.w,
                                          //           width: 10.w,
                                          //           decoration: BoxDecoration(
                                          //             shape: BoxShape.circle,
                                          //             color: AppColors
                                          //                 .primaryColor,
                                          //           ),
                                          //           // child: Container(
                                          //           //   decoration: BoxDecoration(
                                          //           //     shape: BoxShape.circle,
                                          //           //   ),
                                          //           // ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     SizedBox(
                                          //       width: 15,
                                          //     ),
                                          //     Flexible(
                                          //       child: Column(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         children: [
                                          //           Text('Mozilit',
                                          //               style: TextStyle(
                                          //                   fontSize: 14,
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w500)),
                                          //           Text(
                                          //               '${cont.locationWhereTo1.text}',
                                          //               style: TextStyle(
                                          //                   fontSize: 12)),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       width: 30,
                                          //     ),
                                          //     InkWell(
                                          //       onTap: () {
                                          //         Get.to(
                                          //             () => LocationScreen());
                                          //         isSubmit = false;
                                          //         _shouldScaleDown = false;
                                          //       },
                                          //       child: Text('Change',
                                          //           style: TextStyle(
                                          //               color: AppColors
                                          //                   .primaryColor,
                                          //               fontSize: 14,
                                          //               fontWeight: ui
                                          //                   .FontWeight.w500)),
                                          //     )
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 5.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      decoration: BoxDecoration(
                                        // color: Color(0xffD9D9D9),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        children: [
                                          // TextButton(onPressed: () {
                                          //   print("sds==>${cont
                                          //       .fareResponseModel
                                          //       .value
                                          //       .service!.image!}");
                                          // }, child: Text("dsdsdd")),
                                          cont.isRideSelected == false?
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8,right: 8,top: 20,bottom: 20),
                                            child: Container(height: 22,width: 22,decoration:
                                            BoxDecoration(color: AppColors.primaryColor,
                                                shape: BoxShape.circle, border: Border.all(
                                                    width: 3, color: AppColors.primaryColor
                                                )),),
                                          ) :
                                          cont.fareResponseModel.value.service
                                                      ?.image ==
                                                  null
                                              ? Image.asset(
                                                  AppImage.profilePic,
                                                  height: 80,
                                                  width: 85,
                                                )
                                              : CustomFadeInImage(
                                                  height: 70,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                  url: cont
                                                          .fareResponseModel
                                                          .value
                                                          .service
                                                          ?.image ??
                                                      "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png",
                                                ),
                                          // SizedBox(width: 5.h),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cont.fareResponseModel.value
                                                        .service?.name ??
                                                    "",
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              cont.isRideSelected == false? SizedBox() :
                                              Text(
                                                "${cont.fareResponseModel.value.distance ?? ""}"
                                                        .tr +
                                                    "${cont.fareResponseModel.value.distance == null ? "" : " miles"}",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            "${_userController.userData.value.currency ?? ""} ${couponCodeApply(homeController: cont)}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    // Divider(
                                    //   indent: 20,
                                    //   endIndent: 20,
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 15.w),
                                    //   child: Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 8, vertical: 4),
                                    //     decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(20),
                                    //         color: Color(0xffD9D9D9)),
                                    //     child: Row(
                                    //       children: [
                                    //         SizedBox(
                                    //           width: 5.w,
                                    //         ),
                                    //         Text(
                                    //           "apply_coupon".tr,
                                    //           style: TextStyle(
                                    //               color: Colors.grey,
                                    //               fontSize: 12.sp),
                                    //         ),
                                    //         Spacer(),
                                    //         Container(
                                    //           height: 30.h,
                                    //           width: 2.w,
                                    //           color: Colors.grey,
                                    //         ),
                                    //         SizedBox(width: 15.w),
                                    //         GestureDetector(
                                    //           onTap: () {
                                    //             Get.bottomSheet(CoupanDialog())
                                    //                 .then((value) {
                                    //               setState(() {});
                                    //             });
                                    //           },
                                    //           child: Container(
                                    //             width: 90.w,
                                    //             alignment: Alignment.center,
                                    //             padding: EdgeInsets.symmetric(
                                    //                 vertical: 10.w),
                                    //             child: Text(
                                    //               "${cont.selectedPromoCode?.promoCode ?? "view_code".tr}",
                                    //               style: TextStyle(
                                    //                   color: Color(0xff5B96AF),
                                    //                   fontWeight:
                                    //                       FontWeight.w500,
                                    //                   fontSize: 14),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 60.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "cash".tr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Image.asset(AppImage.moneyCash,
                                                  width: 25, height: 25),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0),
                                          child: Image.asset(
                                            AppImage.arrowRight,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.shade100),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "apply_coupon".tr,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.sp),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 25.h,
                                            width: 2.w,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5.w),
                                          GestureDetector(
                                            onTap: () {
                                              Get.bottomSheet(CoupanDialog())
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            },
                                            child: Container(
                                              width: 80.w,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.w),
                                              child: Text(
                                                "${cont.selectedPromoCode?.promoCode ?? "view_code".tr}",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 0.h),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(15.r)),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 10.h),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //     horizontal: 15.w,
                                          //   ),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Row(
                                          //         children: [
                                          //           Text(
                                          //             "payment_:_".tr,
                                          //             style: TextStyle(
                                          //                 color: AppColors
                                          //                     .primaryColor),
                                          //           ),
                                          //           Text(
                                          //             "${cont.paymentModeMap["payment_mode"]}",
                                          //             style: TextStyle(
                                          //                 color: AppColors
                                          //                     .primaryColor),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       InkWell(
                                          //           onTap: () {
                                          //             Get.to(() =>
                                          //                     PaymentScreen())
                                          //                 ?.then((value) {
                                          //               if (value != null) {
                                          //                 if (value is Map) {
                                          //                   print(
                                          //                       "value ==>  $value");
                                          //                   cont.paymentModeMap
                                          //                       .clear();
                                          //                   cont.paymentModeMap
                                          //                           .value =
                                          //                       value;
                                          //                 }
                                          //               }
                                          //             });
                                          //           },
                                          //           child: Text('Change',
                                          //               style: TextStyle(
                                          //                   color: Colors
                                          //                       .black)))
                                          //     ],
                                          //   ),
                                          // ),
                                          if ((double.tryParse(
                                                      "${cont.fareResponseModel.value.walletBalance ?? "0"}") ??
                                                  0) >
                                              0) ...[
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: cont
                                                      .isWalletSelected.value,
                                                  onChanged: (bool? v) {
                                                    if (double.parse(
                                                            couponCodeApply(
                                                                    homeController:
                                                                        cont)
                                                                .toString()) <=
                                                        double.parse(cont
                                                            .fareResponseModel
                                                            .value
                                                            .walletBalance
                                                            .toString())) {
                                                      if (v != null) {
                                                        cont.isWalletSelected
                                                            .value = v;
                                                      }
                                                    } else {
                                                      Get.showSnackbar(
                                                          GetSnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        message:
                                                            "Your wallet amount is insufficient to book this ride!",
                                                        title: "Message",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        duration: Duration(
                                                            seconds: 4),
                                                      ));
                                                    }
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "use_wallet".tr,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${cont.fareResponseModel.value.walletBalance ?? "0"} ${_userController.userData.value.currency ?? ""}",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 13.w)
                                              ],
                                            )
                                          ] else ...[
                                            SizedBox(height: 10.h)
                                          ],
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSubmit = false;
                                              isBookForSomeOne = false;
                                            });
                                          },
                                          child: Container(
                                            width: 170,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 11.h),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(55)),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //       color: Colors.grey,
                                              //       blurRadius: 3)
                                              // ],
                                            ),
                                            child: Text(
                                              "cancel".tr,
                                              style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 18.sp),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 0),
                                        GestureDetector(
                                          onTap: () {
                                            // if(cont.selectedRadioIndex.value == 0){
                                            //   cont.paymentModeRequest("cash");
                                            // } else{
                                            //   cont.paymentModeRequest("online");
                                            // }
                                            print(
                                                "_homeController.isBookSomeOne.value===> ${_homeController.isBookSomeOne.value}");
                                            print(
                                                "_homeController.bookSomeNumber.value===> ${_homeController.bookSomeNumber.value}");
                                            print(
                                                "_homeController.bookSomeNumber.value===> ${_homeController.bookSomeName.value}");
                                            if (_homeController
                                                    .isBookSomeOne.value &&
                                                _homeController.bookSomeNumber
                                                    .value.isNotEmpty) {
                                              if (_homeController.bookSomeNumber
                                                      .value.length ==
                                                  12) {
                                                _homeController
                                                    .sendRequest(params: {
                                                  "book_someone_name":
                                                      _homeController
                                                              .bookSomeName
                                                              .value
                                                              .isEmpty
                                                          ? ""
                                                          : _homeController
                                                              .bookSomeName
                                                              .value,
                                                  "else_mobile":
                                                      "+${_homeController.bookSomeNumber.value.isEmpty ? "" : _homeController.bookSomeNumber.value}"
                                                });
                                                Get.back();
                                              } else {
                                                _homeController
                                                    .sendRequest(params: {
                                                  "book_someone_name":
                                                      _homeController
                                                              .bookSomeName
                                                              .value
                                                              .isEmpty
                                                          ? ""
                                                          : _homeController
                                                              .bookSomeName
                                                              .value,
                                                  "else_mobile":
                                                      "+91${_homeController.bookSomeNumber.value.isEmpty ? "" : _homeController.bookSomeNumber.value}"
                                                });
                                                Get.back();
                                              }
                                            } else {
                                              print(
                                                  "book for some one nahi he===>${cont.selectedRadioIndex.value}");

                                              cont.sendRequest();
                                              cont.timeLeftToRespond.value =
                                                  int.parse(_homeController
                                                      .checkRequestResponseModel
                                                      .value
                                                      .provider_select_timeout?? '30');
                                              // cont.startTimer();

                                            }
                                            cont.timeLeftToRespond
                                                .value = int.parse(_homeController
                                                    .checkRequestResponseModel
                                                    .value
                                                    .provider_select_timeout ??
                                                '60');
                                          },
                                          child: Container(
                                            width: 170,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 11.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(55)),
                                              boxShadow: [
                                                AppBoxShadow.defaultShadow(),
                                              ],
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "request".tr,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),

                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     Expanded(
                              //       child: GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             isSubmit = false;
                              //           });
                              //         },
                              //         child: Container(
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 15.w, vertical: 11.h),
                              //           decoration: BoxDecoration(
                              //             color: Colors.grey[200],
                              //             borderRadius: BorderRadius.only(
                              //                 bottomLeft: Radius.circular(20),
                              //                 bottomRight: Radius.circular(0),
                              //                 topLeft: Radius.circular(20),
                              //                 topRight: Radius.circular(0)),
                              //             // boxShadow: [
                              //             //   BoxShadow(
                              //             //       color: Colors.grey,
                              //             //       blurRadius: 3)
                              //             // ],
                              //           ),
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: [
                              //               Card(
                              //                 shape: RoundedRectangleBorder(
                              //                   borderRadius:
                              //                       BorderRadius.circular(15.0),
                              //                 ),
                              //                 child: Icon(
                              //                   Icons.close,
                              //                   size: 20,
                              //                 ),
                              //               ),
                              //               SizedBox(width: 15),
                              //               Text(
                              //                 "cancel".tr,
                              //                 style: TextStyle(
                              //                     color: AppColors.primaryColor,
                              //                     fontSize: 16.sp),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(width: 0),
                              //     Expanded(
                              //       child: GestureDetector(
                              //         onTap: () {
                              //           cont.sendRequest();
                              //         },
                              //         child: Container(
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 15.w, vertical: 11.h),
                              //           decoration: BoxDecoration(
                              //             color: AppColors.primaryColor,
                              //             borderRadius: BorderRadius.only(
                              //                 bottomLeft: Radius.circular(0),
                              //                 bottomRight: Radius.circular(20),
                              //                 topLeft: Radius.circular(0),
                              //                 topRight: Radius.circular(20)),
                              //             boxShadow: [
                              //               AppBoxShadow.defaultShadow(),
                              //             ],
                              //           ),
                              //           child: Center(
                              //             child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Text(
                              //                   "request".tr,
                              //                   style: TextStyle(
                              //                       color: Colors.white,
                              //                       fontSize: 16.sp),
                              //                 ),
                              //                 SizedBox(width: 15),
                              //                 Icon(
                              //                   Icons.arrow_forward_ios_rounded,
                              //                   size: 20,
                              //                   color: Colors.white,
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 10),
                            ],
                          ),
                        ),
                if (cont.userUiSelectionType.value ==
                    UserUiSelectionType.vehicleDetails)
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            AppBoxShadow.defaultShadow(),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              "rate_card".tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                            Container(
                              width: 70.w,
                              height: 70.w,
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(),
                              child:
                                  cont.fareResponseModel.value.service?.image ==
                                          null
                                      ? Image.asset(AppImage.profilePic)
                                      : CustomFadeInImage(
                                          url: cont.fareResponseModel.value
                                                  .service?.image ??
                                              "https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png",
                                        ),
                            ),
                            Text(
                              "${cont.fareResponseModel.value.service?.name ?? ""}",
                              style: TextStyle(),
                            ),
                            SizedBox(height: 5.h),
                            _vehicleDetailsRow(
                                title: "base_fare".tr,
                                value:
                                    "${cont.fareResponseModel.value.geoService?.fixed ?? 0} ${userCont.userData.value.currency ?? ""}"),
                            _vehicleDetailsRow(
                                title:
                                    "fare / ${userCont.userData.value.measurement ?? ""}"
                                        .tr,
                                value:
                                    "${cont.fareResponseModel.value.geoService?.price ?? 0} ${userCont.userData.value.currency ?? ""}"),
                            _vehicleDetailsRow(
                                title: "fare_type".tr, value: "-"),
                            _vehicleDetailsRow(
                              title: "capacity",
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppImage.icUser,
                                    width: 14.w,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "${cont.fareResponseModel.value.service?.capacity ?? 0}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(
                            //       horizontal: 15.w, vertical: 5.h),
                            //   width: double.infinity,
                            //   height: 1.h,
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey,
                            //   ),
                            // ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: CustomButton(
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                text: "done".tr,
                                fontSize: 14.sp,
                                onTap: () {
                                  cont.userUiSelectionType.value =
                                      UserUiSelectionType.serviceType;
                                },
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (cont.userUiSelectionType.value ==
                    UserUiSelectionType.scheduleRide)
                  Positioned(
                    bottom: 40.h,
                    right: 15.w,
                    left: 15.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                              boxShadow: [
                                AppBoxShadow.defaultShadow(),
                              ]),
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                "schedule_a_ride".tr,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: _selectDate,
                                child: Text(
                                  "${_selectedDate != null ? _dateFormat.format(_selectedDate ?? DateTime.now()) : "choose_a_date".tr}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: _selectTime,
                                child: Text(
                                  "${_selectedTimeOfDay != null ? "${intToStringPrifix(value: _selectedTimeOfDay?.hourOfPeriod)}:${intToStringPrifix(value: _selectedTimeOfDay?.minute)} ${_selectedTimeOfDay?.period.name.toUpperCase()}" : "Choose a time"}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  if (_selectedDate == null) {
                                    cont.showError(
                                        msg: "please_select_date".tr);
                                    return;
                                  }
                                  if (_selectedTimeOfDay == null) {
                                    cont.showError(
                                        msg: "please_select_time".tr);
                                    return;
                                  }
                                  Map<String, String> params = Map();
                                  params["schedule_date"] = _dateFormat
                                      .format(_selectedDate ?? DateTime.now());
                                  params["schedule_time"] =
                                      "${intToStringPrifix(value: _selectedTimeOfDay?.hour)}:${intToStringPrifix(value: _selectedTimeOfDay?.minute)}";
                                  cont.sendRequest(params: params);
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  Get.to(YourTripsScreen(
                                    isUpComingScreenShow: true,
                                  ));
                                },
                                child: Container(
                                  height: 40.h,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: (_selectedDate != null &&
                                            _selectedTimeOfDay != null)
                                        ? AppColors.splashGreenBg
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Schedule A Ride",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (cont.checkRequestResponseModel.value.data.isNotEmpty) ...[
                  if (cont.userUiSelectionType.value ==
                      UserUiSelectionType.findingDriver)
                    FindingDriverDialog(),
                  if (cont.userUiSelectionType.value ==
                          UserUiSelectionType.driverAvailable &&
                      WidgetsBinding.instance.window.viewInsets.bottom <= 0.0)
                    Positioned(
                      bottom: 0.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        // height: 200.h,
                        // width: _size.width - (25 * 2).w,
                        // margin: EdgeInsets.symmetric(horizontal: 25.w),
                        // width: 200.w,
                        // decoration: BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cont.statusType.value == StatusType.PICKEDUP)
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                              //   child: InkWell(
                              //     onTap: () {
                              //       // cont.userUiSelectionType.value =
                              //       //     UserUiSelectionType.scheduleRide;
                              //       Get.dialog(SOSAlertDialog(
                              //         dialCallButton: () {
                              //           cont.makePhoneCall(
                              //               phoneNumber:
                              //                   "${cont.checkRequestResponseModel.value.sos ?? ""}");
                              //         },
                              //       ));
                              //     },
                              //     child: Row(
                              //       children: [
                              //         Image.asset(AppImage.sosSiren,
                              //             height: 50, width: 50),
                              //         SizedBox(width: 10),
                              //         Container(
                              //           width: 180,
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 10, vertical: 7),
                              //           decoration: BoxDecoration(
                              //             color: AppColors.primaryColor2
                              //                 .withOpacity(0.8),
                              //             borderRadius: BorderRadius.all(
                              //               Radius.circular(10),
                              //             ),
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Image.asset(
                              //                 AppImage.protect,
                              //                 height: 20,
                              //                 width: 20,
                              //                 color: AppColors.white,
                              //               ),
                              //               SizedBox(width: 10),
                              //               Text(
                              //                 "Panic_button".tr,
                              //                 style: TextStyle(
                              //                     fontWeight: FontWeight.w400,
                              //                     color: AppColors.white),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                            SizedBox(height: 10.h),
                            if (cont.statusType.value ==
                                StatusType.PICKEDUP) ...[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(ChatScreen(),
                                          arguments: [
                                            cont
                                                .checkRequestResponseModel
                                                .value
                                                .data[0]
                                                .provider
                                                ?.avatar,
                                            "${cont.checkRequestResponseModel.value.data[0].provider?.firstName ?? ""} ${cont.checkRequestResponseModel.value.data[0].provider?.lastName ?? ""}",
                                            "${cont.checkRequestResponseModel.value.data[0].provider?.countryCode ?? ""}${cont.checkRequestResponseModel.value.data[0].provider?.mobile ?? ""}"
                                          ]);
                                    },
                                    child: Stack(
                                      children: [
                                        Container(height: 52, width: 52,decoration:
                                        BoxDecoration(color: AppColors.skyBlue,shape: BoxShape.circle),child:
                                        Align(alignment: Alignment.center,child: Icon(Icons.message,
                                        ),),),
                                        // ClipRRect(borderRadius: BorderRadius.circular(100),
                                        //   child: Image.asset(
                                        //       AppImage.skyBlueMsg,
                                        //       // color: AppColors.primaryColor,
                                        //       width: 55,
                                        //       height: 55,fit: BoxFit.contain,),
                                        // ),
                                        chetUnRead == "0"
                                            ? SizedBox()
                                            : Container(
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                          height: 15,
                                          width: 15,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: Text(chetUnRead,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  InkWell(
                                    onTap: () {
                                      cont.makePhoneCall(
                                          phoneNumber:
                                          "${cont.checkRequestResponseModel.value.data[0].provider?.countryCode ?? ""}${cont.checkRequestResponseModel.value.data[0].provider?.mobile ?? ""}");
                                    },
                                    child: Image.asset(
                                        AppImage.phone,
                                        width: 55,
                                        height: 55),
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            ],

                            Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  AppBoxShadow.defaultShadow(),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5.h),
                                        // if (cont.userUiSelectionType.value ==
                                        //         UserUiSelectionType
                                        //             .driverAvailable ||
                                        //     cont.statusType.value ==
                                        //         StatusType.PICKEDUP)
                                        //   Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         vertical: 7.h,
                                        //         horizontal: 10.w),
                                        //     margin: EdgeInsets.symmetric(
                                        //         vertical: 10.h,
                                        //         horizontal: 20.w),
                                        //     decoration: BoxDecoration(
                                        //       // color: Colors.white,
                                        //       borderRadius:
                                        //           BorderRadius.circular(10.r),
                                        //       // boxShadow: [
                                        //       //   AppBoxShadow.defaultShadow(),
                                        //       // ],
                                        //     ),
                                        //     // child: Row(
                                        //     //   children: [
                                        //     //     Image.asset(
                                        //     //       AppImage.icArrivedSelect,
                                        //     //       width: 30.w,
                                        //     //     ),
                                        //     //     if (cont.statusType.value ==
                                        //     //         StatusType.PICKEDUP) ...[
                                        //     //       Expanded(
                                        //     //           child: Divider(
                                        //     //         color: AppColors.drawer,
                                        //     //         thickness: 1.5.h,
                                        //     //       )),
                                        //     //       Image.asset(
                                        //     //         AppImage.icPickupSelect,
                                        //     //         width: 30.w,
                                        //     //       ),
                                        //     //     ] else ...[
                                        //     //       SizedBox(width: 10.w),
                                        //     //       Expanded(
                                        //     //         child: DottedLine(
                                        //     //           direction:
                                        //     //               Axis.horizontal,
                                        //     //           lineLength:
                                        //     //               double.infinity,
                                        //     //           lineThickness: 2.w,
                                        //     //           dashLength: 7.w,
                                        //     //           dashColor: Colors.black,
                                        //     //           dashRadius: 0.0,
                                        //     //           dashGapLength: 5.w,
                                        //     //         ),
                                        //     //       ),
                                        //     //       SizedBox(width: 5.w),
                                        //     //       Image.asset(
                                        //     //         AppImage.icPickup,
                                        //     //         width: 30.w,
                                        //     //       ),
                                        //     //     ],
                                        //     //     SizedBox(width: 10.w),
                                        //     //     Expanded(
                                        //     //       child: DottedLine(
                                        //     //         direction:
                                        //     //             Axis.horizontal,
                                        //     //         lineLength:
                                        //     //             double.infinity,
                                        //     //         lineThickness: 2.w,
                                        //     //         dashLength: 7.w,
                                        //     //         dashColor: Colors.black,
                                        //     //         dashRadius: 0.0,
                                        //     //         dashGapLength: 5.w,
                                        //     //       ),
                                        //     //     ),
                                        //     //     SizedBox(width: 8.w),
                                        //     //     Image.asset(
                                        //     //       AppImage.icFinished,
                                        //     //       width: 30.w,
                                        //     //     ),
                                        //     //   ],
                                        //     // ),
                                        //   )
                                        // else
                                        //   Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         vertical: 7.h,
                                        //         horizontal: 10.w),
                                        //     margin: EdgeInsets.symmetric(
                                        //         vertical: 10.h,
                                        //         horizontal: 20.w),
                                        //     decoration: BoxDecoration(
                                        //       // color: Colors.white,
                                        //       borderRadius:
                                        //           BorderRadius.circular(10.r),
                                        //       // boxShadow: [
                                        //       //   AppBoxShadow.defaultShadow(),
                                        //       // ],
                                        //     ),
                                        //
                                        //
                                        //
                                        //     // child: Row(
                                        //     //   children: [
                                        //     //     Image.asset(
                                        //     //       AppImage.flag,
                                        //     //       width: 30.w,
                                        //     //     ),
                                        //     //     SizedBox(width: 10.w),
                                        //     //     Expanded(
                                        //     //       child: DottedLine(
                                        //     //         direction:
                                        //     //             Axis.horizontal,
                                        //     //         lineLength:
                                        //     //             double.infinity,
                                        //     //         lineThickness: 2.w,
                                        //     //         dashLength: 7.w,
                                        //     //         dashColor: Colors.black,
                                        //     //         dashRadius: 0.0,
                                        //     //         dashGapLength: 5.w,
                                        //     //       ),
                                        //     //     ),
                                        //     //     SizedBox(width: 5.w),
                                        //     //     Image.asset(
                                        //     //       AppImage.flagUser,
                                        //     //       width: 30.w,
                                        //     //     ),
                                        //     //     SizedBox(width: 10.w),
                                        //     //     Expanded(
                                        //     //       child: DottedLine(
                                        //     //         direction:
                                        //     //             Axis.horizontal,
                                        //     //         lineLength:
                                        //     //             double.infinity,
                                        //     //         lineThickness: 2.w,
                                        //     //         dashLength: 7.w,
                                        //     //         dashColor: Colors.black,
                                        //     //         dashRadius: 0.0,
                                        //     //         dashGapLength: 5.w,
                                        //     //       ),
                                        //     //     ),
                                        //     //     SizedBox(width: 8.w),
                                        //     //     Image.asset(
                                        //     //       AppImage.flag1,
                                        //     //       width: 30.w,
                                        //     //     ),
                                        //     //   ],
                                        //     // ),
                                        //
                                        //
                                        //   ),
                                        // Divider(
                                        //   indent: MediaQuery.of(context)
                                        //           .size
                                        //           .width *
                                        //       0.3,
                                        //   endIndent: MediaQuery.of(context)
                                        //           .size
                                        //           .width *
                                        //       0.3,
                                        //   thickness: 1,
                                        // ),

                                        SizedBox(height: 10.h),
                                        if (cont.statusType.value ==
                                            StatusType.STARTED)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    cont.isRideSelected.value == true?
                                                    'driver_is_arriving...'.tr : 'Serviceman is arriving',
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          AppImage.clock,
                                                          height: 25,
                                                          width: 25),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${_arrivalTimeFormat.format(DateTime.now().add(Duration(seconds: cont.providerDurationSecond.value)))}",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: AppColors
                                                                .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (cont
                                                          .checkRequestResponseModel
                                                          .value
                                                          .data[0]
                                                          .rideOtp ==
                                                      1)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppImage.otp,
                                                            height: 45,
                                                            width: 45),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "OTP : ${cont.checkRequestResponseModel.value.data[0].otp ?? ""}"
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color: AppColors
                                                                .primaryColor2,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        if (cont.statusType.value ==
                                            StatusType.ARRIVED)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(cont.isRideSelected.value == true?
                                                      'driver_has_arrived.'.tr : 'Serviceman has arrived',
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          AppImage.clock,
                                                          height: 25,
                                                          width: 25),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${_arrivalTimeFormat.format(DateTime.now().add(Duration(seconds: cont.providerDurationSecond.value)))}",
                                                        style: TextStyle(
                                                            fontSize: 17.sp,
                                                            color: AppColors
                                                                .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (cont
                                                          .checkRequestResponseModel
                                                          .value
                                                          .data[0]
                                                          .rideOtp ==
                                                      1)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppImage.otp,
                                                            height: 45,
                                                            width: 45),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "otp : ${cont.checkRequestResponseModel.value.data[0].otp ?? ""}"
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color: AppColors
                                                                .primaryColor2,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        if (cont.statusType.value ==
                                            StatusType.PICKEDUP)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Your trip has started',
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (cont
                                                          .checkRequestResponseModel
                                                          .value
                                                          .data[0]
                                                          .rideOtp ==
                                                      1)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                            AppImage.otp,
                                                            height: 45,
                                                            width: 45),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "OTP : ${cont.checkRequestResponseModel.value.data[0].otp ?? ""}"
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color: AppColors
                                                                .primaryColor2,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),

                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        // Divider(),
                                        // Align(
                                        //   alignment: Alignment.centerRight,
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       _shouldScaleDown =
                                        //           !_shouldScaleDown;
                                        //       setState(() {});
                                        //     },
                                        //     child: Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //           horizontal: 10.w,
                                        //           vertical: 2.h),
                                        //       child: RotatedBox(
                                        //         quarterTurns:
                                        //             _shouldScaleDown ? 1 : 3,
                                        //         child: Image.asset(
                                        //           AppImage.back,
                                        //           width: 20,
                                        //           height: 20,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: AppColors.gray
                                                  .withOpacity(0.3),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              cont
                                                          .checkRequestResponseModel
                                                          .value
                                                          .data[0]
                                                          .provider
                                                          ?.avatar ==
                                                      null
                                                  ? CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                AppColors
                                                    .white,
                                                backgroundImage:
                                                AssetImage(
                                                    AppImage
                                                        .profilePic),
                                              )
                                                  : CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                AppColors
                                                    .white,
                                                backgroundImage:
                                                NetworkImage(
                                                  "${ApiUrl.baseImageUrl}${cont.checkRequestResponseModel.value.data[0].provider?.avatar}",
                                                ),
                                              ),

                                              SizedBox(width: 15.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Divider(),
                                                    Text(
                                                      "${cont.checkRequestResponseModel.value.data[0].provider?.firstName ?? ""} ${cont.checkRequestResponseModel.value.data[0].provider?.lastName ?? ""}",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Text(
                                                      "${cont.checkRequestResponseModel.value.data[0].serviceType?.name ?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    //     Text(
                                                    //       "${cont.checkRequestResponseModel.value.data[0].providerService?.car_camp_name ?? ""} - ${cont.checkRequestResponseModel.value.data[0].providerService?.car_color ?? ""}",
                                                    //       style: TextStyle(
                                                    //           fontSize: 10.sp,
                                                    //           color: AppColors
                                                    //               .primaryColor,
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .w500),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    Text(
                                                      "${cont.checkRequestResponseModel.value.data[0].providerService?.serviceNumber ?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppColors
                                                            .primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${cont.checkRequestResponseModel.value.data[0].provider?.rating ?? "0"}',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 17),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.orange
                                                        .withOpacity(0.7),
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  cont.isRideSelected.value == false? SizedBox() :
                                                  cont.checkRequestResponseModel
                                                              .value
                                                              .data[0]
                                                              .serviceType!
                                                              .image ==
                                                          null
                                                      ? Image.asset(
                                                          AppImage.logo1)
                                                      : CustomFadeInImage(
                                                          url:
                                                              "${cont.checkRequestResponseModel.value.data[0].serviceType!.image}",
                                                          width: 120,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                          placeHolder:
                                                              AppImage.logo1,
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        // Row(
                                        //   children: [
                                        //     // SizedBox(width: 5.w),
                                        //     RatingBar.builder(
                                        //       initialRating: _strToDouble(
                                        //           s: cont
                                        //                   .checkRequestResponseModel
                                        //                   .value
                                        //                   .data[0]
                                        //                   .provider
                                        //                   ?.rating ??
                                        //               "0"),
                                        //       minRating: 1,
                                        //       direction: Axis.horizontal,
                                        //       allowHalfRating: true,
                                        //       ignoreGestures: true,
                                        //       itemCount: 5,
                                        //       itemPadding:
                                        //           EdgeInsets.symmetric(
                                        //               horizontal: 0.5.w),
                                        //       itemBuilder: (context, _) =>
                                        //           Icon(
                                        //         Icons.star,
                                        //         color: Colors.amber,
                                        //       ),
                                        //       itemSize: 12.w,
                                        //       onRatingUpdate: (rating) {},
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(height: 5.h),
                                        // if (cont.checkRequestResponseModel
                                        //         .value.data[0].rideOtp ==
                                        //     1)
                                        //   Text(
                                        //     "otp: ${cont.checkRequestResponseModel.value.data[0].otp ?? ""}"
                                        //         .tr,
                                        //     style: TextStyle(
                                        //       fontSize: 12.sp,
                                        //       color: AppColors.primaryColor,
                                        //       fontWeight: FontWeight.w500,
                                        //     ),
                                        //   ),
                                        if (cont.statusType.value ==
                                                StatusType.STARTED ||
                                            cont.statusType.value ==
                                                StatusType.ARRIVED) ...[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: cont
                                                            .checkRequestResponseModel
                                                            .value
                                                            .data
                                                            .first
                                                            .bkd_for_reqid !=
                                                        null
                                                    ? () {
                                                        Get.snackbar("Alert",
                                                            "You can not cancel the ride because you are on a breakdown ride.",
                                                            backgroundColor:
                                                                Colors.red
                                                                    .withOpacity(
                                                                        0.8),
                                                            colorText:
                                                                Colors.white);
                                                      }
                                                    : () {
                                                        Get.bottomSheet(
                                                          ReasonForCancelling(),
                                                        );
                                                      },
                                                child: Container(
                                                  width: 160,
                                                  height: 45,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35),
                                                  ),
                                                  child: Text(
                                                    'cancel'.tr,
                                                    style: TextStyle(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(ChatScreen(),
                                                      arguments: [
                                                        cont
                                                            .checkRequestResponseModel
                                                            .value
                                                            .data[0]
                                                            .provider
                                                            ?.avatar,
                                                        "${cont.checkRequestResponseModel.value.data[0].provider?.firstName ?? ""} ${cont.checkRequestResponseModel.value.data[0].provider?.lastName ?? ""}",
                                                        "${cont.checkRequestResponseModel.value.data[0].provider?.countryCode ?? ""}${cont.checkRequestResponseModel.value.data[0].provider?.mobile ?? ""}"
                                                      ]);
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(height: 52, width: 52,decoration: 
                                                      BoxDecoration(color: Colors.grey[200],shape: BoxShape.circle),child: 
                                                    Align(alignment: Alignment.center,child: Icon(Icons.message,
                                                        ),),),
                                                    // ClipRRect(borderRadius: BorderRadius.circular(100),
                                                    //   child: Image.asset(
                                                    //       AppImage.skyBlueMsg,
                                                    //       // color: AppColors.primaryColor,
                                                    //       width: 55,
                                                    //       height: 55,fit: BoxFit.contain,),
                                                    // ),
                                                    chetUnRead == "0"
                                                        ? SizedBox()
                                                        : Container(
                                                      margin:
                                                      EdgeInsets.symmetric(horizontal: 10),
                                                      height: 15,
                                                      width: 15,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle),
                                                      child: Text(chetUnRead,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 10)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cont.makePhoneCall(
                                                      phoneNumber:
                                                          "${cont.checkRequestResponseModel.value.data[0].provider?.countryCode ?? ""}${cont.checkRequestResponseModel.value.data[0].provider?.mobile ?? ""}");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7),
                                                  height: 65,
                                                  width: 70,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Image.asset(
                                                      AppImage.phone,
                                                      width: 55,
                                                      height: 55),
                                                ),
                                              ),

                                              // Expanded(
                                              //   child: InkWell(
                                              //     onTap: () {
                                              //       Get.bottomSheet(
                                              //         ReasonForCancelling(),
                                              //       );
                                              //     },
                                              //     child: Container(
                                              //       alignment:
                                              //           Alignment.center,
                                              //       child: Text(
                                              //         "cancel_trip".tr,
                                              //         style: TextStyle(
                                              //           color: Colors.red,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // Container(
                                              //   height: 20.h,
                                              //   width: 1.w,
                                              //   color: Colors.grey
                                              //       .withOpacity(0.6),
                                              // ),
                                              // Expanded(
                                              //   child: Row(
                                              //     children: [
                                              //       Expanded(
                                              //           child: InkWell(
                                              //         onTap: () {
                                              //           cont.makePhoneCall(
                                              //               phoneNumber:
                                              //                   "${cont.checkRequestResponseModel.value.data[0].provider?.countryCode ?? ""}${cont.checkRequestResponseModel.value.data[0].provider?.mobile ?? ""}");
                                              //         },
                                              //         child: Container(
                                              //           child: Image.asset(
                                              //             AppImage.call,
                                              //             width: 20.w,
                                              //             height: 20.w,
                                              //           ),
                                              //         ),
                                              //       )),
                                              //       Container(
                                              //         height: 20.h,
                                              //         width: 1.w,
                                              //         color: Colors.grey
                                              //             .withOpacity(0.6),
                                              //       ),
                                              //       Expanded(
                                              //           child: InkWell(
                                              //         onTap: () {
                                              //           Get.to(() =>
                                              //               ChatScreen());
                                              //         },
                                              //         child: Container(
                                              //           child: Image.asset(
                                              //             AppImage.message,
                                              //             width: 20.w,
                                              //             height: 20.w,
                                              //           ),
                                              //         ),
                                              //       )),
                                              //     ],
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ],
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (cont.statusType.value ==
                                            StatusType.PICKEDUP)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "arrival".tr,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "eta".tr,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Image.asset(
                                                        AppImage.clock,
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        "${_arrivalTimeFormat.format(DateTime.now().add(Duration(seconds: cont.providerDurationSecond.value)))}",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: AppColors
                                                                .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cont.shareUrl();
                                                },
                                                child: Container(
                                                  width: 180,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10.h),
                                                  child: Text(
                                                    "share_status".tr,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.sp),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        SizedBox(
                                          height: 10.h,
                                        )
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                  //   decoration: BoxDecoration(
                                  //       color: Color(0xffF0F0F0)
                                  //   ),
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Row(
                                  //           children: [
                                  //             Text(
                                  //               "PAYMENT",
                                  //               style: TextStyle(
                                  //                 fontSize: 16.sp,
                                  //               ),
                                  //             ),
                                  //             SizedBox(width: 10.w),
                                  //             Expanded(
                                  //                 child: Column(
                                  //                   crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Text("Visa ... 0001"),
                                  //                     Text(
                                  //                       "\$ 4.00",
                                  //                       style:
                                  //                       TextStyle(color: Colors.grey),
                                  //                     ),
                                  //                   ],
                                  //                 )),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         height: 30.h,
                                  //         width: 2.w,
                                  //         color: Colors.grey,
                                  //         margin:
                                  //         EdgeInsets.symmetric(horizontal: 5.w),
                                  //       ),
                                  //       Container(
                                  //         width: 80.w,
                                  //         alignment: Alignment.center,
                                  //         child: Text(
                                  //           "Change",
                                  //           style: TextStyle(
                                  //               color: AppColors.primaryColor,
                                  //               fontWeight: FontWeight.w500,
                                  //               fontSize: 16.sp
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            // Container(
                            //   width: double.infinity,
                            //   margin: EdgeInsets.symmetric(vertical: 15.h),
                            //   clipBehavior: Clip.antiAlias,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 15.w, vertical: 10.h),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     boxShadow: [
                            //       AppBoxShadow.defaultShadow(),
                            //     ],
                            //     borderRadius: BorderRadius.circular(25.r),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "eta".tr,
                            //         style: TextStyle(
                            //           fontSize: 14.sp,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //       SizedBox(width: 10.w),
                            //       Expanded(
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               "${_arrivalTimeFormat.format(DateTime.now().add(Duration(seconds: cont.providerDurationSecond.value)))} arrival",
                            //               style: TextStyle(
                            //                 fontSize: 12.sp,
                            //               ),
                            //             ),
                            //             // SizedBox(
                            //             //   width: double.infinity,
                            //             //   height: 1.h,
                            //             // ),
                            //             // Text(
                            //             //   "Driver is ${cont.providerDurationTime.value} away",
                            //             //   style: TextStyle(
                            //             //     fontSize: 12.sp,
                            //             //     color: Colors.grey,
                            //             //   ),
                            //             // ),
                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         margin: EdgeInsets.symmetric(
                            //             horizontal: 10.w),
                            //         width: 2.w,
                            //         height: 20.h,
                            //         color: Colors.grey,
                            //       ),
                            //       InkWell(
                            //         onTap: () {
                            //           cont.shareUrl();
                            //         },
                            //         child: Container(
                            //           padding:
                            //               EdgeInsets.symmetric(vertical: 5.h),
                            //           child: Text(
                            //             "share_status".tr,
                            //             style: TextStyle(
                            //                 color: AppColors.primaryColor,
                            //                 fontSize: 12.sp),
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 10.h,
                            // )
                          ],
                        ),
                      ),
                    ),
                ],
                _homeController.checkRequestResponseModel.value
                                .checkBreakDown_status ==
                            "started" ||
                        _homeController.checkRequestResponseModel.value
                                .checkBreakDown_status ==
                            "notassign" ||
                        _homeController.checkRequestResponseModel.value
                                .checkBreakDown_status ==
                            "searching"
                    ? FindingDriverForBreakDownDialog()
                    : SizedBox()
              ],
            ),
          );
        });
      }),
    );
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;

    // Test if location services are enabled.

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetSnackBar(
          messageText: Text(
            "location_permissions_are_denied".tr,
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
      Get.showSnackbar(GetSnackBar(
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
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _homeController.tempLatLngFrom = latLng;
      _homeController.userCurrentLocation = latLng;

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude),
        zoom: 14.4746,
      );
      _homeController.googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      if (_homeController.userImageMarker != null) {
        showMarker(latLng: latLng);
      } else {
        _capturePng();
      }
    }
    return position;
  }

  Future<void> showMarker({required LatLng latLng}) async {
    if (_homeController.userImageMarker != null) {
      Marker userMarker = Marker(
        markerId: _homeController.userMarkerId,
        position: latLng,
        icon: BitmapDescriptor.fromBytes(_homeController.userImageMarker!),
      );
      _homeController.googleMarkers[_homeController.userMarkerId] = userMarker;
    } else {
      // await _capturePng();
      // if (_homeController.userImageMarker != null) {
      //   _homeController.googleMarkers.add(Marker(
      //       markerId: const MarkerId("first"),
      //       position: latLng,
      //       icon:
      //           BitmapDescriptor.fromBytes(_homeController.userImageMarker!)));
      // } else {
      Marker userMarker = Marker(
        markerId: _homeController.userMarkerId,
        position: latLng,
      );
      _homeController.googleMarkers[_homeController.userMarkerId] = userMarker;
      // }
    }

    await _homeController.getLocationAddress(latLng: latLng).then((value) {
      _homeController.setData();
    });
    if (isMounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _requestTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        if (_homeController.googleMapController != null) {
          _homeController.googleMapController?.setMapStyle("[]");
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

  double _strToDouble({required String s}) {
    double rating = 0;
    try {
      rating = double.parse(s);
    } catch (e) {
      rating = 0;
    }
    return rating;
  }

  Future<void> _selectDate() async {
    DateTime _dateTime = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
        lastDate: DateTime(_dateTime.year, _dateTime.month, _dateTime.day)
            .add(Duration(days: 30)));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay _timeOfDay = TimeOfDay.now();
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: _timeOfDay,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child ?? Container(),
          );
        });

    if (picked_s != null)
      setState(() {
        _selectedTimeOfDay = picked_s;
      });
  }

  Future<Uint8List?> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      _homeController.userImageMarker = pngBytes;
      var bs64 = base64Encode(pngBytes!);
      print("pngBytes===>${pngBytes}");
      print(bs64);
      if (_homeController.userCurrentLocation != null) {
        showMarker(latLng: _homeController.userCurrentLocation!);
      }
      return pngBytes;
    } catch (e) {
      _homeController.isCaptureImage.value = false;
      print(e);
    }
    return null;
  }

  Widget _vehicleDetailsRow({String? title, String? value, Widget? child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? "",
              style: TextStyle(
                fontSize: 12.sp,
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child ??
              Text(
                value ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  // fontWeight: FontWeight.w500,
                ),
              )
        ],
      ),
    );
  }

  List<Widget> _serviceWidgetList(
      {required HomeController cont,
      required int index,
      int oneRowNoOfItem = 3}) {
    List<Widget> serviceList = [];
    int count = 0;
    for (int i = (index * oneRowNoOfItem);
        i <
            (((index * oneRowNoOfItem) + oneRowNoOfItem) <
                    cont.serviceModelList.length
                ? ((index * oneRowNoOfItem) + oneRowNoOfItem)
                : cont.serviceModelList.length);
        i++) {
      ServicesModel serviceModel = cont.serviceModelList[i];
      bool isSelected = cont.serviceTypeSelectedIndex.value == i;
      FareResponseModel fareResponseModel = cont.fareResponseModel.value;
      serviceList.add(GestureDetector(
          onTap: () async {
            if (cont.serviceTypeSelectedIndex.value != i) {
              cont.serviceTypeSelectedIndex.value = i;
              await cont.getFairServiceDetailsApiCall(
                  servicesModel: cont.serviceModelList[i]);
              setState(() {});
            } else {
              cont.userUiSelectionType.value =
                  UserUiSelectionType.vehicleDetails;
            }
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: EdgeInsets.only(
              right: 15,
            ),
            decoration: BoxDecoration(
              // boxShadow: [
              //   if (isSelected) AppBoxShadow.defaultShadow(),
              // ],
              border: Border.all(
                color: !isSelected ? Colors.white : Colors.grey.shade100,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: !isSelected ? Colors.white : Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 7,),
                    cont.isRideSelected == false?
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8,top: 20,bottom: 20),
                          child: Container(height: 22,width: 22,decoration:
                          BoxDecoration(color: !isSelected ? Colors.white : AppColors.primaryColor,
                              shape: BoxShape.circle, border: Border.all(
                            width: 3, color: AppColors.primaryColor
                          )),),
                        ) :
                    serviceModel.image == null
                        ? Image.asset(AppImage.profilePic,
                            height: 80, width: 80, fit: BoxFit.contain)
                        : CustomFadeInImage(
                            url: serviceModel.image ?? "",
                            height: 70,
                            width: 95,
                            fit: BoxFit.contain,
                          ),
                    SizedBox(width: 5,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceModel.name ?? "",
                          style: TextStyle(
                            color: Color(0xFF393A3C),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 2),
                        // if (isSelected)
                        cont.isRideSelected == false? SizedBox() :
                        Text(
                          "${fareResponseModel.distance ?? ""} miles".tr,
                          style: TextStyle(
                              color: Color(0xFF393A3C),
                              fontWeight: FontWeight.w400),
                        ),
                        // SizedBox(height: 2),
                        // Text(
                        //   _homeController.nearByDriverTimeList1.isEmpty
                        //       ? ""
                        //       : _homeController
                        //       .durationToString(_homeController
                        //       .nearByDriverTimeList1.first)
                        //       .split(":")
                        //       .last ==
                        //       "00"
                        //       ? "01 minutes"
                        //       : _homeController
                        //       .durationToString(_homeController
                        //       .nearByDriverTimeList1.first)
                        //       .split(":")
                        //       .first ==
                        //       "00"
                        //       ? "${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").last} minutes"
                        //       : "${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").first} hours ${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").last} minutes",
                        //   style: TextStyle(
                        //     color: Color(0xFF393A3C),
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: 10.sp,
                        //   ),
                        // ),
                        // else
                        //   SizedBox(height: 0),
                        // SizedBox(height: 13.h),
                      ],
                    ),
                    // SizedBox(
                    //   width: 12,
                    // ),
                  ],
                ),
                isSelected?
                Text(
                  " ${_userController.userData.value.currency ?? ""} ${fareResponseModel.estimatedFare ?? ""}",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF393A3C),
                      fontWeight: FontWeight.w500),
                ) : SizedBox(),
              ],
            ),
          )

          //   child: Container(
          //     width: 180,
          //     height: 170,
          //     margin: EdgeInsets.symmetric(vertical: 10),
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 15,
          //     ),
          //     decoration: BoxDecoration(
          //       boxShadow: [
          //         if (isSelected) AppBoxShadow.defaultShadow(),
          //       ],
          //       border: Border.all(
          //         color: !isSelected
          //             ? Colors.white
          //             : AppColors.primaryColor2.withOpacity(0.4),
          //       ),
          //       borderRadius: BorderRadius.all(Radius.circular(15)),
          //       color: Color(0xFFF7F7F7),
          //       // color: Colors.red,
          //     ),
          //     child: Stack(
          //       children: [
          //         Container(
          //           // color: Colors.red,
          //           child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: serviceModel.image == null
          //                 ? Image.asset(AppImage.profilePic)
          //                 : CustomFadeInImage(
          //                     url: serviceModel.image ?? "",
          //                     height: 130,
          //                     width: 150,
          //                     fit: BoxFit.contain,
          //                   ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.topRight,
          //           child: Padding(
          //             padding: const EdgeInsets.only(top: 8.0, right: 8),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   serviceModel.name ?? "",
          //                   style: TextStyle(
          //                     color: Color(0xFF393A3C),
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 13.sp,
          //                   ),
          //                 ),
          //                 SizedBox(height: 2),
          //                 // if (isSelected)
          //                 Text(
          //                   "${fareResponseModel.distance ?? ""} kms".tr,
          //                   style: TextStyle(
          //                       color: Color(0xFF393A3C),
          //                       fontWeight: FontWeight.w400),
          //                 ),
          //                 // SizedBox(height: 2),
          //                 // Text(
          //                 //   _homeController.nearByDriverTimeList1.isEmpty
          //                 //       ? ""
          //                 //       : _homeController
          //                 //                   .durationToString(_homeController
          //                 //                       .nearByDriverTimeList1.first)
          //                 //                   .split(":")
          //                 //                   .last ==
          //                 //               "00"
          //                 //           ? "01 minutes"
          //                 //           : _homeController
          //                 //                       .durationToString(_homeController
          //                 //                           .nearByDriverTimeList1.first)
          //                 //                       .split(":")
          //                 //                       .first ==
          //                 //                   "00"
          //                 //               ? "${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").last} minutes"
          //                 //               : "${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").first} hours ${_homeController.durationToString(_homeController.nearByDriverTimeList1.first).split(":").last} minutes",
          //                 //   style: TextStyle(
          //                 //     color: Color(0xFF393A3C),
          //                 //     fontWeight: FontWeight.w300,
          //                 //     fontSize: 10.sp,
          //                 //   ),
          //                 // ),
          //                 Text(
          //                   !isSelected
          //                       ? ""
          //                       : "${_userController.userData.value.currency ?? ""} ${fareResponseModel.estimatedFare ?? ""}",
          //                   style: TextStyle(
          //                       color: Color(0xFF393A3C),
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //                 // else
          //                 //   SizedBox(height: 0),
          //                 // SizedBox(height: 13.h),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   // ),
          // )
          ));
    }

    return serviceList;
  }

  double couponCodeApply({required HomeController homeController}) {
    double totalAmount = double.tryParse(
            "${homeController.fareResponseModel.value.estimatedFare ?? "0"}") ??
        0;
    if (homeController.selectedPromoCode != null) {
      double couponMaxAmount = double.tryParse(
              "${homeController.selectedPromoCode?.maxAmount ?? "0"}") ??
          0;
      double disPer = double.tryParse(
              "${homeController.selectedPromoCode?.percentage ?? "0"}") ??
          0;
      double discountFare = (totalAmount * disPer) / 100;
      if (discountFare > couponMaxAmount) {
        totalAmount = totalAmount - couponMaxAmount;
      } else {
        totalAmount = totalAmount - discountFare;
      }
    }
    return totalAmount;
  }

  Widget couponWidget() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          Container(
              height: 290,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              child: CoupanDialog()),
        ).then((value) {
          isSelectedCoupon
              ? Get.snackbar('Coupon', "Coupon Applied",
                  backgroundColor: Colors.green,
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white)
              : SizedBox();
          setState(() {});
        });
      },
      child: Row(
        children: [
          Image.asset(AppImage.coupons,
              height: 35, width: 35, fit: BoxFit.contain),
          SizedBox(width: 7),
          Text(
            "coupons".tr,
            // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
            // "view_code".tr}",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget cashWidget(Function cashOnTap, HomeController cont) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  )),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Column(
                children: [
                  Container(
                    // height: 200,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Text(
                          "payment_methods".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        SizedBox(height: 10.h),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: paymentRadioButtonList.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: index,
                              groupValue: cont.selectedRadioIndex.value,
                              selected: index == cont.selectedRadioIndex.value,
                              onChanged: (int? value) {
                                cont.selectedRadioIndex.value = value!;
                                radioItem = paymentRadioButtonList[index].name!;
                                setState(() {});
                                Get.back();
                              },
                              title: Text(paymentRadioButtonList[index].name!),
                            );
                          },
                        )
                        // Column(
                        //   children: paymentRadioButtonList
                        //       .map((e) => Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 8.0),
                        //             child: RadioListTile<int>(
                        //               selected: true,
                        //               controlAffinity:
                        //                   ListTileControlAffinity.trailing,
                        //               dense: true,
                        //               title: Transform.translate(
                        //                 offset: const Offset(-20, 0),
                        //                 child: Text(
                        //                   e.name!.tr,
                        //                   style: TextStyle(
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.w500,
                        //                       fontSize: 15),
                        //                 ),
                        //               ),
                        //               value: e.index!,
                        //               groupValue: id,
                        //               activeColor: AppColors.primaryColor,
                        //               onChanged: (int? value) {
                        //                 setState(() {
                        //                   radioItem = e.name!;
                        //                   id = e.index!;
                        //                   selectedRadioIndex = value!;
                        //                 });
                        //               },
                        //             ),
                        //           ))
                        //       .toList(),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       height: 15,
                  //       width: 15,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle, color: Colors.white),
                  //     ),
                  //     SizedBox(
                  //       width: 15,
                  //     ),
                  //     Container(
                  //       height: 15,
                  //       width: 15,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle, color: Colors.black),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            );
          },
        ));
      },
      child: Row(
        children: [
          Image.asset(AppImage.creditCard,
              height: 35, width: 35, fit: BoxFit.contain),
          SizedBox(width: 7),
          Text(
            radioItem == "Cash" ? "Cash".tr : "Online ",
            // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
            // "view_code".tr}",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget mySelfWidget({
    Function? saveContactOnTap,
    Function? bookForSomeoneElse,
    Function? mySelfContinueOnTap,
  }) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                // _contacts == null
                //     ? SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.077)
                //     :
                SizedBox(height: MediaQuery.of(context).size.height * 0.044),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(0.0)),
                    color: Colors.white,
                    boxShadow: [
                      AppBoxShadow.defaultShadow(),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      Get.back();
                                      await _homeController.getDriverMarkerData(
                                          updateData: () => setState(() {}));
                                      setState(() {
                                        isDriverShow = true;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_ios)),
                                Text(
                                  'someone_else_taking_the_ride?'.tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'choose a contact so that they also get driver number, vehicle details and ride OTP via SMS'
                                  .tr,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (isMySelf) {
                            setState(() {
                              isBookForSome = false;
                            });
                          } else {
                            setState(() {
                              isBookForSome = true;
                            });
                          }

                          print("isMySelf==> ${isMySelf}");
                        },
                        child: Row(children: [
                          Container(
                            height: 25,
                            width: 25,
                            margin: EdgeInsets.only(left: 25, right: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 2),
                            ),
                            child: !isMySelf
                                ? SizedBox()
                                : Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryColor),
                                  ),
                          ),
                          Image.asset(AppImage.mySelf,
                              width: 35, height: 35, fit: BoxFit.contain),
                          SizedBox(width: 25),
                          Text(
                            (_homeController.isBookSomeOne.value &&
                                    _homeController.isBookSomeOne.value &&
                                    _homeController
                                        .bookSomeNumber.value.isNotEmpty)
                                ? "book_for_someone".tr
                                : "myself".tr,
                            // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                            // "view_code".tr}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          )
                        ]),
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 58),
                      //   child: InkWell(
                      //     onTap: saveContactOnTap!.call(),
                      //     child: ListTile(
                      //       leading: Image.asset(AppImage.saveContact,
                      //           fit: BoxFit.contain, width: 25, height: 25),
                      //       title: Text(
                      //         "saved_contacts".tr,
                      //         // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                      //         // "view_code".tr}",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 14),
                      //       ),
                      //       trailing: Icon(Icons.arrow_forward_ios_sharp,
                      //           color: AppColors.primaryColor, size: 25),
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   indent: 20,
                      //   endIndent: 20,
                      // ),
                      // _contacts == null
                      //     ? SizedBox()
                      //     : InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             isBookForSome = !isBookForSome;
                      //           });
                      //           if (isBookForSome) {
                      //             setState(() {
                      //               isMySelf = false;
                      //             });
                      //           } else {
                      //             setState(() {
                      //               isMySelf = true;
                      //             });
                      //           }
                      //           print("isBookForSome==> $isBookForSome");
                      //         },
                      //         child: Row(children: [
                      //           Container(
                      //             height: 25,
                      //             width: 25,
                      //             margin: EdgeInsets.only(left: 25, right: 20),
                      //             alignment: Alignment.center,
                      //             decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               border: Border.all(
                      //                   color: AppColors.primaryColor,
                      //                   width: 2),
                      //             ),
                      //             child: !isBookForSome
                      //                 ? SizedBox()
                      //                 : Container(
                      //                     height: 14,
                      //                     width: 14,
                      //                     decoration: BoxDecoration(
                      //                         shape: BoxShape.circle,
                      //                         color: AppColors.primaryColor),
                      //                   ),
                      //           ),
                      //           Text(
                      //             _contacts!.displayName!,
                      //             // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                      //             // "view_code".tr}",
                      //             style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 14),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Text(
                      //             _contacts!.phones!.isEmpty ||
                      //                     _contacts!.phones == null
                      //                 ? ""
                      //                 : _contacts!.phones!.first.value!
                      //                     .split("-")
                      //                     .join()
                      //                     .trim(),
                      //             // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                      //             // "view_code".tr}",
                      //             style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 14),
                      //           )
                      //         ]),
                      //       ),
                      Padding(
                        padding: const EdgeInsets.only(left: 58.0),
                        child: InkWell(
                          onTap: bookForSomeoneElse!.call(),
                          //bookForSomeoneElse!.call();},
                          child: ListTile(
                            leading: Image.asset(AppImage.people,
                                fit: BoxFit.contain, width: 40, height: 40),
                            title: Text(
                              "book_for_someone_else".tr,
                              // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                              // "view_code".tr}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_sharp,
                                color: AppColors.primaryColor, size: 25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: mySelfContinueOnTap!.call(),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 55),
                          alignment: Alignment.center,
                          height: 55,
                          width: 275,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "continue".tr,
                            // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
                            // "view_code".tr}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
      },
      child: Row(
        children: [
          Image.asset(AppImage.mySelf,
              height: 35, width: 35, fit: BoxFit.contain),
          SizedBox(width: 7),
          Text(
            isBookForSomeOne ? "Other" : "myself".tr,
            // "view_code".tr}","${cont.selectedPromoCode?.promoCode ??
            // "view_code".tr}",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget assistWidget(image, title){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.025),
      child: Container(height: MediaQuery.of(context).size.height*0.155,
        width: MediaQuery.of(context).size.height*0.155,
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(15),boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                color: Colors.black26,
                blurRadius: 3,
              ) //
            ]),child: Column(
          children: [
            ClipRRect(borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),topRight: Radius.circular(15)
            ),
              child: Container(
                height: MediaQuery.of(context).size.height*0.11,
                child: CachedNetworkImage(imageUrl: image,fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height*0.11),),
            ),
            ClipRRect(borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)
            ),
              child: Container(height: MediaQuery.of(context).size.height*0.045,
                width: double.infinity,
                color: Color(0xFF002744),child:
                Align(alignment: Alignment.center,child:
                Text(title,style: TextStyle(color: Color(0xFFB3EEE8),
                    fontSize: 14, fontWeight: FontWeight.w400),),),),
            )
          ],
        ),),
    );
  }

  int isModelAvailable(model){
    int ret = 0;
    for(var map in _homeController.availableModules){
      if(map['url']==model){
        if(map['status']==1){
          ret = 1;
        }
      }
    }
    return ret;
    }
}
