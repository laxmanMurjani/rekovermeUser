// import 'dart:developer';
//
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_place/google_place.dart';
// import 'package:arbyuser/api/api.dart';
// import 'package:arbyuser/controller/home_controller.dart';
// import 'package:arbyuser/controller/user_controller.dart';
// import 'package:arbyuser/enum/user_location_type.dart';
// import 'package:arbyuser/model/location_response_odel.dart';
// import 'package:arbyuser/model/multiple_location_add_model.dart';
// import 'package:arbyuser/ui/profile_page.dart';
// import 'package:arbyuser/ui/saved_contacts.dart';
// import 'package:arbyuser/ui/service_select_screen.dart';
// import 'package:arbyuser/ui/widget/custom_fade_in_image.dart';
// import 'package:arbyuser/ui/widget/no_internet_widget.dart';
// import 'package:arbyuser/util/app_constant.dart';
// import 'package:arbyuser/enum/error_type.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'dialog/update_address_dialog.dart';
//
// class OtherAddressLocationScreen extends StatefulWidget {
//   bool? isSelectHomeAddress;
//   bool isRideLocationUpdate;
//   bool? isSelectOtherAddress;
//
//   OtherAddressLocationScreen(
//       {this.isSelectHomeAddress,
//       this.isSelectOtherAddress,
//       this.isRideLocationUpdate = false});
//
//   @override
//   _OtherAddressLocationScreenState createState() =>
//       _OtherAddressLocationScreenState();
// }
//
// class _OtherAddressLocationScreenState extends State<OtherAddressLocationScreen>
//     with WidgetsBindingObserver {
//   final UserController _userController = Get.find();
//   final HomeController _homeController = Get.find();
//
//   GoogleMapController? _controller;
//
//   final CameraPosition _kGooglePlex = const CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   final List<Marker> _markers = [];
//   PolylineId id = PolylineId('poly');
//   final List<Polyline> _polyLine = [];
//   LatLng? _cameraMoveLatlng;
//
//   var showBottom = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addObserver(this);
//     log("message   ==>   12vv  12 ${_homeController.latLngFrom}");
//
//     _homeController.tempLocationFromTo.text =
//         _homeController.locationFromTo.text;
//     _homeController.tempLocationWhereTo1.text =
//         _homeController.locationWhereTo1.text;
//     _homeController.isRoundTrip.value = false;
//
//     _homeController.tempLatLngFrom = _homeController.latLngFrom;
//     _homeController.tempLatLngWhereTo1 = _homeController.latLngWhereTo1;
//
//     _homeController.tempLatLngFrom = _homeController.latLngFrom;
//     log("message   ==>   12vv  12 ${_homeController.latLngFrom}   ${_homeController.tempLatLngFrom}");
//     _homeController.multipleLocationAdModelList.clear();
//     _homeController.isPickFromMap.value = false;
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//
//     if (widget.isSelectHomeAddress != null || widget.isRideLocationUpdate) {
//       MultipleLocationAddModel multipleLocationAddModel =
//           MultipleLocationAddModel();
//
//       multipleLocationAddModel.onChange = (String s) async {
//         log("message  ==>  $s");
//         await _homeController.getLocationFromAddress(address: s);
//       };
//       // multipleLocationAddModel.remove = () {
//       //   _homeController.multipleLocationAdModelList
//       //       .remove(multipleLocationAddModel);
//       // };
//       _homeController.multipleLocationAdModelList.add(multipleLocationAddModel);
//     }
//     Future.delayed(Duration(milliseconds: 500), () {
//       _homeController.locationWhereToFocusNode.requestFocus();
//     });
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         // _homeController.clearData();
//         return Future.value(true);
//       },
//       child: Scaffold(
//         extendBody: true,
//         extendBodyBehindAppBar: true,
//         body: GetX<HomeController>(builder: (cont) {
//           if (cont.error.value.errorType == ErrorType.internet) {
//             return NoInternetWidget();
//           }
//           return GetX<UserController>(builder: (userCont) {
//             bool isInitLatLng = (cont.tempLatLngFrom != null &&
//                 cont.tempLatLngWhereTo1 != null);
//             if (widget.isSelectHomeAddress != null ||
//                 widget.isRideLocationUpdate) {
//               isInitLatLng = true;
//             }
//             if (widget.isSelectOtherAddress != null ||
//                 widget.isRideLocationUpdate) {
//               isInitLatLng = true;
//             }
//
//             if (userCont.error.value.errorType == ErrorType.internet) {
//               return NoInternetWidget();
//             }
//             bool isFocus = false;
//             cont.multipleLocationAdModelList.forEach((element) {
//               isInitLatLng = (element.latLng != null && isInitLatLng);
//               if (!isFocus) {
//                 isFocus = element.focusNode?.hasFocus == true;
//               }
//             });
//
//             String? profileUrl;
//             if (userCont.userData.value.picture != null) {
//               profileUrl =
//                   "${ApiUrl.baseImageUrl}${userCont.userData.value.picture ?? ""}";
//             }
//             return Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: SafeArea(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(height: 15.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Get.back();
//                               },
//                               child: Icon(
//                                 Icons.arrow_back_ios,
//                                 size: 20,
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//
//                             // Expanded(
//                             //   child: Row(
//                             //     mainAxisAlignment: MainAxisAlignment.center,
//                             //     children: [
//                             //       Container(
//                             //         width: 35.w,
//                             //         height: 35.w,
//                             //         clipBehavior: Clip.antiAlias,
//                             //         decoration: BoxDecoration(
//                             //           color: Colors.grey[200],
//                             //           shape: BoxShape.circle,
//                             //         ),
//                             //         child: profileUrl == null
//                             //             ? Center(
//                             //                 child: Icon(
//                             //                     Icons.perm_identity_outlined,
//                             //                     color: Colors.grey),
//                             //               )
//                             //             : CustomFadeInImage(
//                             //                 url: profileUrl,
//                             //                 placeHolderWidget: Icon(
//                             //                   Icons.perm_identity_outlined,
//                             //                   color: Colors.grey,
//                             //                 ),
//                             //                 fit: BoxFit.cover,
//                             //               ),
//                             //       ),
//                             //       SizedBox(width: 5.w),
//                             //       Text(
//                             //         "${userCont.userData.value.firstName ?? ""} ${userCont.userData.value.lastName ?? ""}",
//                             //         style: TextStyle(
//                             //           color: AppColors.primaryColor,
//                             //           fontSize: 12.sp,
//                             //         ),
//                             //       ),
//                             //     ],
//                             //   ),
//                             // ),
//                             SizedBox(width: 10.w),
//                             InkWell(
//                               onTap: () async {
//                                 print("objecsdst");
//                                 final pref =
//                                     await SharedPreferences.getInstance();
//                                 await pref.remove('otherAddress');
//                                 await pref.setString("otherAddress",
//                                     cont.tempLocationFromTo.text);
//                                 Get.off(ProfilePage());
//                               },
//                               child: Text(
//                                 "done".tr,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 17),
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 30.h),
//                         if (widget.isSelectHomeAddress == null &&
//                             !widget.isRideLocationUpdate) ...[
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: Color(0xffF0EFEF),
//                               borderRadius: BorderRadius.circular(10.r),
//                               // boxShadow: [
//                               //   AppBoxShadow.defaultShadow(),
//                               // ]
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(width: 5.w),
//                                 Text(
//                                   'Where To:',
//                                   style:
//                                       TextStyle(color: AppColors.primaryColor),
//                                 ),
//                                 SizedBox(width: 5.w),
//                                 Expanded(
//                                     child: Container(
//                                   child: TextFormField(
//                                     focusNode: cont.locationFromFocusNode,
//                                     controller: cont.tempLocationFromTo,
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                     ),
//                                     decoration: InputDecoration(
//                                       hintText: "Where To".tr,
//                                       border: InputBorder.none,
//                                       hintStyle:
//                                           TextStyle(color: Color(0xff9F9F9F)),
//                                       contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 5.w,
//                                         vertical: 12.h,
//                                       ),
//                                       isDense: true,
//                                     ),
//                                     onChanged: (s) async {
//                                       await cont.getLocationFromAddress(
//                                           address: s);
//                                     },
//                                   ),
//                                 )),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 15.h,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Stack(
//                           children: [
//                             Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 GoogleMap(
//                                   mapType: MapType.normal,
//                                   initialCameraPosition: _kGooglePlex,
//                                   myLocationEnabled: true,
//                                   myLocationButtonEnabled: false,
//                                   mapToolbarEnabled: false,
//                                   zoomControlsEnabled: false,
//                                   rotateGesturesEnabled: false,
//                                   polylines: Set<Polyline>.of(_polyLine),
//                                   markers: Set<Marker>.of(_markers),
//                                   onMapCreated:
//                                       (GoogleMapController controller) {
//                                     _controller = controller;
//                                     determinePosition();
//                                   },
//                                   onCameraIdle: () {
//                                     print("CameraMove ==>   onCameraIdle");
//                                     if (_cameraMoveLatlng != null &&
//                                         cont.isPickFromMap.value) {
//                                       cont.searchAddressList.clear();
//                                       if (cont.locationFromFocusNode.hasFocus) {
//                                         cont
//                                             .getLocationAddress(
//                                                 latLng: _cameraMoveLatlng!,
//                                                 isFromAddress: true)
//                                             .then((value) {
//                                           setState(() {});
//                                         });
//                                       } else if (cont
//                                           .locationWhereToFocusNode.hasFocus) {
//                                         cont
//                                             .getLocationAddress(
//                                                 latLng: _cameraMoveLatlng!,
//                                                 isFromAddress: false)
//                                             .then((value) {
//                                           setState(() {});
//                                         });
//                                       } else {
//                                         cont.multipleLocationAdModelList
//                                             .forEach((element) {
//                                           if (element.focusNode?.hasFocus ==
//                                               true) {
//                                             cont
//                                                 .getLocationAddress(
//                                                     latLng: _cameraMoveLatlng!,
//                                                     isFromAddress: null)
//                                                 .then((value) {
//                                               setState(() {});
//                                             });
//                                           }
//                                         });
//                                       }
//                                     }
//                                   },
//                                   onCameraMoveStarted: () {
//                                     print(
//                                         "CameraMove ==>   onCameraMoveStarted");
//                                   },
//                                   onCameraMove:
//                                       (CameraPosition cameraPosition) {
//                                     print(
//                                         "CameraMove ==>  ${cameraPosition.target}");
//                                     _cameraMoveLatlng = cameraPosition.target;
//                                   },
//                                   onTap: (LatLng latLng) {
//                                     showMarker(latLng: latLng);
//                                   },
//                                 ),
//                                 if (cont.isPickFromMap.value)
//                                   Image.asset(
//                                     AppImage.icPin,
//                                     width: 30.w,
//                                   )
//                               ],
//                             ),
//                             if ((userCont.locationResponseModel.value.home
//                                         .isNotEmpty ||
//                                     userCont.locationResponseModel.value.work
//                                         .isNotEmpty ||
//                                     (cont.searchAddressList.isNotEmpty) &&
//                                         (cont.locationFromFocusNode.hasFocus ||
//                                             cont.locationWhereToFocusNode
//                                                 .hasFocus ||
//                                             isFocus)) &&
//                                 !cont.isPickFromMap.value) ...[
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 child: SingleChildScrollView(
//                                   padding: EdgeInsets.symmetric(vertical: 20.h),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       if (cont.searchAddressList.isNotEmpty)
//                                         ListView.builder(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 20.w,
//                                           ),
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           itemBuilder: (context, index) {
//                                             AutocompletePrediction
//                                                 autocompletePrediction =
//                                                 cont.searchAddressList[index];
//                                             return InkWell(
//                                               onTap: () {
//                                                 if (cont.locationFromFocusNode
//                                                     .hasFocus) {
//                                                   cont.tempLocationFromTo.text =
//                                                       autocompletePrediction
//                                                               .description ??
//                                                           "";
//                                                 } else if (cont
//                                                     .locationWhereToFocusNode
//                                                     .hasFocus) {
//                                                   cont.tempLocationWhereTo1
//                                                           .text =
//                                                       autocompletePrediction
//                                                               .description ??
//                                                           "";
//                                                 } else {
//                                                   cont.multipleLocationAdModelList
//                                                       .forEach((element) {
//                                                     if (element.focusNode
//                                                             ?.hasFocus ==
//                                                         true) {
//                                                       element.textEditingController
//                                                               ?.text =
//                                                           autocompletePrediction
//                                                                   .description ??
//                                                               "";
//                                                     }
//                                                   });
//                                                 }
//                                                 cont
//                                                     .getPlaceIdToLatLag(
//                                                         placeId:
//                                                             autocompletePrediction
//                                                                 .placeId!)
//                                                     .then((value) {
//                                                   cont.removeUnFocusManager();
//                                                   setState(() {});
//                                                 });
//                                                 cont.searchAddressList.clear();
//                                               },
//                                               child: Container(
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.location_on,
//                                                     ),
//                                                     Expanded(
//                                                       child: Column(
//                                                         mainAxisSize:
//                                                             MainAxisSize.min,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(autocompletePrediction
//                                                                   .description ??
//                                                               ""),
//                                                           if (cont.searchAddressList
//                                                                       .length -
//                                                                   1 !=
//                                                               index)
//                                                             Container(
//                                                               margin: EdgeInsets
//                                                                   .symmetric(
//                                                                       vertical:
//                                                                           5.h),
//                                                               width: double
//                                                                   .infinity,
//                                                               height: 1.h,
//                                                               color: Colors.grey
//                                                                   .withOpacity(
//                                                                       0.5),
//                                                             )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           itemCount:
//                                               cont.searchAddressList.length,
//                                           shrinkWrap: true,
//                                           // physics: NeverScrollableScrollPhysics(),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             );
//           });
//         }),
//       ),
//     );
//   }
//
//   Future<Position?> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.showSnackbar(GetSnackBar(
//           messageText: Text(
//             "location_permissions_denied".tr,
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           mainButton: InkWell(
//             onTap: () {},
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Text(
//                 "allow".tr,
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ));
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       await openAppSettings();
//     }
//     Position? position;
//     try {
//       position = await Geolocator.getCurrentPosition();
//     } catch (e) {
//       Get.showSnackbar(GetBar(
//         messageText: Text(
//           e.toString(),
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         mainButton: InkWell(
//           onTap: () {},
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Text(
//               "allow".tr,
//               style: TextStyle(
//                 color: AppColors.primaryColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ));
//       // showError(msg: e.toString());
//     }
//     if (position != null) {
//       showMarker(latLng: LatLng(position.latitude, position.longitude));
//     }
//     return position;
//   }
//
//   Future<void> showMarker({required LatLng latLng}) async {
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(latLng.latitude, latLng.longitude),
//       zoom: 14.4746,
//     );
//     //
//     // _markers.add(Marker(markerId: const MarkerId("first"), position: latLng));
//     _controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//
//     // PolylinePoints polylinePoints = PolylinePoints();
//     // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     //     AppString.googleMapKey,
//     //     const PointLatLng(21.1702, 72.8311),
//     //     const PointLatLng(21.1418, 72.7709),
//     //     travelMode: TravelMode.driving);
//     //
//     // List<LatLng> points = <LatLng>[];
//     // for (var element in result.points) {
//     //   points.add(LatLng(element.latitude, element.longitude));
//     // }
//     //
//     // List<PatternItem> pattern = [PatternItem.dash(20), PatternItem.gap(5)];
//     // Polyline polyline = Polyline(
//     //     startCap: Cap.buttCap,
//     //     polylineId: id,
//     //     color: Colors.red,
//     //     points: points,
//     //     width: 3,
//     //     patterns: pattern,
//     //     endCap: Cap.squareCap);
//     // _polyLine.add(polyline);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//
//     switch (state) {
//       case AppLifecycleState.resumed:
//         if (_controller != null) {
//           _controller?.setMapStyle("[]");
//         }
//         break;
//       case AppLifecycleState.inactive:
//         break;
//       case AppLifecycleState.paused:
//         break;
//       case AppLifecycleState.detached:
//         break;
//     }
//   }
// }
