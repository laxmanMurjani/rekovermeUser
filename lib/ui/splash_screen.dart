import 'dart:async';
import 'dart:ui';

import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:arbyuser/ui/authentication_screen/sign_in_up_screen.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:arbyuser/util/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  final UserController _userController = Get.find();
  GoogleMapController? _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    determinePosition();
    contactPermissions();
    super.initState();
    _userController.setLanguage();
    Timer(const Duration(seconds: 3), () {
      if (_userController.userToken.value.accessToken != null) {
        // _userController.currentUserApi();
        // Get.off(()=> HomeScreen());
        _userController.getUserProfileData();
      } else {
        Get.off(() => LoginScreen());
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);


    print("test===>${state }");
    if(state == AppLifecycleState.resumed || state == AppLifecycleState.paused
        || state == AppLifecycleState.inactive || state == AppLifecycleState.detached
    ){
      print("test===>${state == AppLifecycleState.resumed}");
      determinePosition();
    }
  }

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
            "location_permissions_denied",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          mainButton: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "allow",
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
              "allow",
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: Center(
        child: Image.asset(
          AppImage.rekovermeLogo,
          height: MediaQuery.of(context).size.width*0.8,
          width: MediaQuery.of(context).size.width*0.8,
          // height: 195,
          // width: 233,
        ),
      ),
    );
  }
}
