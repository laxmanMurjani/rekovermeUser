import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/api/api_service.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/home_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:arbyuser/model/arby_banner_model.dart';
import 'package:arbyuser/model/card_list_model.dart';
import 'package:arbyuser/model/help_response_model.dart';
import 'package:arbyuser/model/location_response_odel.dart';
import 'package:arbyuser/model/login_response_model.dart';
import 'package:arbyuser/model/notification_manager_model.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/model/user_detail_model.dart';
import 'package:arbyuser/model/wallet_add_model.dart';
import 'package:arbyuser/model/wallet_transaction_model.dart';
import 'package:arbyuser/ui/authentication_screen/forgot_password.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:arbyuser/ui/authentication_screen/otp_screen.dart';
import 'package:arbyuser/ui/authentication_screen/phone_number_screen.dart';
import 'package:arbyuser/ui/authentication_screen/profile_number_otp_screen.dart';
import 'package:arbyuser/ui/home_screen.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/login_otp_reponse_model.dart';
import '../util/user_details.dart';

class UserController extends BaseController {
  RxString mapStyle = "".obs;
  RxBool isShowLogin = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController giveFeedbackTitleController = TextEditingController();
  TextEditingController giveFeedbackDescriptionController =
      TextEditingController();
  TextEditingController driverFeedbackController = TextEditingController();
  TextEditingController etoFeedbackController = TextEditingController();

  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  RxString countryCode = "+593".obs;
  GoogleMapController? _controller;
  Rx<LoginResponseModel> userToken = LoginResponseModel().obs;
  Rx<UserDetailModel> userData = UserDetailModel().obs;
  Rx<ArbyBannerModel> arbyBanner = ArbyBannerModel().obs;
  Rx<HelpResponseModel> helpResponseModel = HelpResponseModel().obs;
  Rx<LocationResponseModel> locationResponseModel = LocationResponseModel().obs;
  final UserDetails _userDetails = UserDetails();
  RxList<PromoList> promoCodeList = <PromoList>[].obs;
  RxList<NotificationManagerModel> notificationManagerList =
      <NotificationManagerModel>[].obs;
  Rx<WalletTransationModel> walletTransationModel = WalletTransationModel().obs;
  String? imageFilePah;
  RxInt currentCarouselSliderPosition = 0.obs;
  RxList<Datum> cardList = <Datum>[].obs;
  WalletAddModel _walletAddModel = WalletAddModel();
  RxInt selectedLanguage = 0.obs;
  RxString googleAuthToken = ''.obs;
  RxString facebookAuthToken = ''.obs;

  @override
  void onInit() {
    super.onInit();

    rootBundle.loadString('assets/mapa.txt').then((string) {
      mapStyle.value = string;
    });
    _userDetails.getSaveUserDetails.then((value) {
      log("userTokenAccess ====>   ${value.toJson()}");
      userToken.value = value;
    });
    userToken.listen((data) {
      _userDetails.saveUserDetails(data);
    });

    getSaveLanguages.then((value) {
      selectedLanguage.value = value;
      setLanguage();
    });

    selectedLanguage.listen((data) {
      saveLanguage(data);
    });
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
      print("positionaa====>${position.longitude}");
      print("positionaa====>${position.latitude}");
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
      print("cccc1111===>${position.latitude}");
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

  Future<int> get getSaveLanguages async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? language = sharedPreferences.getInt("languages");
    return language!;
  }

  Future<void> saveLanguage(int selectedLanguage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt("languages", selectedLanguage);
  }

  void setLanguage() {
    if (selectedLanguage.value == 0) {
      Get.updateLocale(Locale('en', 'US'));
    } else if (selectedLanguage.value == 1) {
      Get.updateLocale(Locale('hi', 'IN'));
    }
    // else if (selectedLanguage.value ==2) {
    //   Get.updateLocale(Locale('hi', 'IN'));
    // }
  }

  void changeLanguage (var param1, var param2){
    var locale = Locale(param1, param2);
    Get.updateLocale(locale);
  }

  Future<void> registerUser() async {
    removeUnFocusManager();
    try {
      if (emailController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter your Email address",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your Email address");
        return;
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailController.text)) {
        Get.snackbar("Alert", "Please enter a valid email id",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter a valid email id");
        return;
      }
      if (firstNameController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter your first name",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your first name");
        return;
      }
      if (lastNameController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter your last name",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your last name");
        return;
      }
      if (phoneNumberController.text.isEmpty) {
        Get.snackbar("Alert", "Please enter your mobile number",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Please enter your mobile number");
        return;
      }
      // if (phoneNumberController.text.length!=9 && countryCode=='+593') {
      //   Get.snackbar("Alert", "Please enter valid 9 digit mobile number",
      //       backgroundColor: Colors.redAccent.withOpacity(0.8),
      //       colorText: Colors.white);
      //   // showError(msg: "Please enter valid 10 digit mobile number");
      //   return;
      // }
      if (passwordController.text.length < 6) {
        Get.snackbar("Alert", "Password length must be between 6–15 characters.",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        // showError(msg: "Password length must be between 6–15 characters.");
        return;
      }
      if(!passwordController.text.contains((RegExp(r'[0-9]'))) ||
          !passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
        Get.snackbar("Make strong password", "Password must be alphanumeric with special characters",
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white);
        return;
      }

      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();
      Map<String, dynamic> params = Map();
      params["country_code"] = countryCode.value;
      params["password"] = passwordController.text;
      params["password_confirmation"] = conPasswordController.text;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_token"] = token;
      params["mobile"] = phoneNumberController.text;
      params["first_name"] = firstNameController.text;
      params["last_name"] = lastNameController.text;
      params["device_type"] = ApiUrl.deviceType;
      params["login_by"] = "manual";
      params["email"] = emailController.text;

      await apiService.postRequest(
        url: ApiUrl.signUp,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          Map<String, dynamic> para = Map();
          para["country_code"] = countryCode.value;
          para["mobile"] = phoneNumberController.text;
          sendOtp(params: para);

          // dismissLoader();
          // userToken.value =
          //     loginResponseModelFromJson(jsonEncode(data["response"]));
          // userToken.refresh();
          // getUserProfileData();
        },
        onError: (ErrorType errorType, String msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser() async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["password"] = passwordController.text;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["grant_type"] = "password";
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["client_secret"] = ApiUrl.clientSecret;
      params["client_id"] = ApiUrl.clientId;
      params["username"] = emailController.text;

      await apiService.postRequest(
          url: ApiUrl.login,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithGoogle(
      {required String accessToken, Map<String, dynamic>? data}) async {
    removeUnFocusManager();
    print("kaha pe atak rahahe");
    try {
      // showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "google";
      params["accessToken"] = "${accessToken}";
      if(phoneNumberController.text.isNotEmpty){
        params["mobile"] = phoneNumberController.text;
        params["country_code"] = countryCode.value;
      }else{
        params["mobile"] = "";
        params["country_code"] = countryCode.value;
      }
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }
      print("googleParam====>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.googleLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            print("googleParam====>${userToken.value}");
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params,isAuthSignIn: true,));
            } else {
              // showError(msg: msg);
              Get.snackbar("Alert", msg,
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  colorText: Colors.white);
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithApple(
      {required String socialUniqueId, Map<String, dynamic>? data}) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "apple";
      params["social_unique_id"] = "$socialUniqueId";
      params["mobile"] = phoneNumberController;
      params["country_code"] = countryCode.value;
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
          url: ApiUrl.appleLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params));
            } else {
              showError(msg: msg);
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithFacebook(
      {required String accessToken, Map<String, dynamic>? data}) async {
    removeUnFocusManager();

    try {
      // showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["login_by"] = "facebook";
      params["accessToken"] = "${accessToken}";
      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode.value;
      params["device_token"] = token;
      params["device_type"] = ApiUrl.deviceType;
      params["device_id"] = "aa0cd79f26dd98b8";
      if (data != null) {
        params.addAll(data);
      }

      await apiService.postRequest(
          url: ApiUrl.facebookLogin,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value =
                loginResponseModelFromJson(jsonEncode(data["response"]));
            userToken.refresh();
            getUserProfileData();
          },
          onError: (ErrorType errorType, String msg) {
            if (msg.toLowerCase().contains("mobile not found")) {
              dismissLoader();
              Get.to(() => PhoneNumberScreen(params: params,isFaceBookAuthSignIn: true,));
            } else {
              showError(msg: msg);
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendOtp({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode.value;

      await apiService.postRequest(
          url: ApiUrl.sendOtp,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                () => OtpScreen(
                      params: params,
                    ),
                arguments: [phoneNumberController.text, countryCode.value]);
          },
          onError: (ErrorType errorType, String msg) {
            dismissLoader();
            print('object12 ${msg}');
            // showError(msg: msg);
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendOtpWithGoogleSignIn({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode.value;
      print("checkParameter===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.sendOtpWithAuth,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                () => OtpScreen(
                      params: params,isAuthLogin: true,
                    ),
                arguments: [phoneNumberController.text, countryCode.value]);
          },
          onError: (ErrorType errorType, String msg) {
            print('object12 ${msg}');
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendOtpWithFaceBookSignIn({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      params["mobile"] = phoneNumberController.text;
      params["country_code"] = countryCode.value;
      print("checkParameter===>${jsonEncode(params)}");
      await apiService.postRequest(
          url: ApiUrl.sendOtpWithAuth,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                () => OtpScreen(
                      params: params,isFaceBookLogin: true,
                    ),
                arguments: [phoneNumberController.text, countryCode.value]);
          },
          onError: (ErrorType errorType, String msg) {
            print('object12 ${msg}');
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyOTp(String otp) async {
    removeUnFocusManager();
    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumberController.text;
      params["otp"] = otp;
      params["device_token"] = token;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_type"] = ApiUrl.deviceType;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            print("vvvvvvv===>${data["response"]["token_type"]}");
            userToken.value = LoginResponseModel(
                accessToken: data["response"]["success"]["token"],
                tokenType: data["response"]["token_type"]);
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            var tkn = a.success!.token;
            print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            userToken.refresh();
            getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            // showError(msg: msg);
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
          });
    } catch (e) {
      print(e);
    }
  }
  Future<void> verifyOTpWithAuth(String otp) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumberController.text;
      params["otp"] = otp;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOtpWithAuth,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            print("googleAuthTocken===>${googleAuthToken.value}");
            print("googleAuthTocken===>${data["response"]["token_type"]}");
            // userToken.value =
            //     loginResponseModelFromJson(googleAuthToken.value);

            loginWithGoogle(accessToken: googleAuthToken.value);
            // userToken.value = LoginResponseModel(
            //   accessToken: googleAuthToken.value,
            //     // accessToken: data["response"]["success"]["token"],
            //     tokenType: "Bearer"
            // );
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            // var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            // var tkn = a.success!.token;
            // print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            // userToken.refresh();
            // getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            // showError(msg: msg);
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyOTpWithFaceBook(String otp) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumberController.text;
      params["otp"] = otp;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOtpWithAuth,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            print("googleAuthTocken===>${googleAuthToken.value}");
            print("googleAuthTocken===>${data["response"]["token_type"]}");
            // userToken.value =
            //     loginResponseModelFromJson(googleAuthToken.value);

            loginWithFacebook(accessToken: facebookAuthToken.value);
            // userToken.value = LoginResponseModel(
            //   accessToken: googleAuthToken.value,
            //     // accessToken: data["response"]["success"]["token"],
            //     tokenType: "Bearer"
            // );
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            // var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            // var tkn = a.success!.token;
            // print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            // userToken.refresh();
            // getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyResendOTp(String otp, String phoneNumber) async {
    removeUnFocusManager();

    try {
      showLoader();
      String? token = await FirebaseMessaging.instance.getToken();
      print("phoneNumber ===> $phoneNumber");
      Map<String, dynamic> params = Map();
      params["mobile"] = phoneNumber;
      params["otp"] = otp;
      params["device_token"] = token;
      params["device_id"] = "aa0cd79f26dd98b8";
      params["device_type"] = ApiUrl.deviceType;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTP,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            userToken.value = LoginResponseModel(
                accessToken: data["response"]["success"]["token"],
                tokenType: data["response"]["token_type"]);
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            var tkn = a.success!.token;
            print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            userToken.refresh();
            getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            // showError(msg: msg);
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendProfileOtp() async {
    removeUnFocusManager();
    try {
      showLoader();
      Map<String, dynamic> params = Map();
      params["oldmobile"] = userData.value.mobile;
      params["newmobile"] = phoneNumberController.text;
      params["country_code"] = countryCode.value;
      await apiService.postRequest(
          url: ApiUrl.sendOTPProfile,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            params["otp"] = data["response"]["otp"];
            Get.to(
                    () => ProfileNumberOtpScreen(
                  params: params,
                ),
                arguments: [phoneNumberController.text, countryCode.value]);
          },
          onError: (ErrorType errorType, String msg) {
            print('object12 ${msg}');
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });


    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyProfileNumberOTP(String otp) async {
    removeUnFocusManager();

    try {
      showLoader();
      print("phoneNumber ===> ${userData.value.mobile}");
      Map<String, dynamic> params = Map();
      params["oldmobile"] = userData.value.mobile;
      params["newmobile"] = phoneNumberController.text;
      params["otp"] = otp;

      print('bodysss ${params}');

      await apiService.postRequest(
          url: ApiUrl.verifyOTPProfile,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            updateProfile();
            // userToken.value = LoginResponseModel(
            //     accessToken: data["response"]["success"]["token"],
            //     tokenType: data["response"]["token_type"]);
            // loginResponseModelFromJson(jsonEncode(data["response"]));
            // var a = loginOtpResponseModelFromJson(jsonEncode(data["response"]));
            // var tkn = a.success!.token;
            // print('token 11 ${userToken.value}');
            // userToken.value = tkn as LoginResponseModel;

            // userToken.refresh();
            // getUserProfileData();
            // getUserData1(tkn);
            // getUserProfileData1(tkn!);
            // Get.offAll(() => HomeScreen());
          },
          onError: (ErrorType errorType, String msg) {
            // dismissLoader();
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> forgotPassword() async {
    removeUnFocusManager();
    if (emailController.text.isEmpty) {
      showError(msg: "Please enter your email address..");
      return;
    }

    try {
      showLoader();
      Map<String, dynamic> params = Map();
      params["email"] = emailController.text;

      await apiService.postRequest(
          url: ApiUrl.forgotPassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            showSnack(msg: data["response"]["message"]);
            Get.to(() => ForgotPassword(
                  response: data["response"],
                ));
          },
          onError: (ErrorType errorType, String msg) {
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword({required Map<String, dynamic> params}) async {
    removeUnFocusManager();

    try {
      showLoader();

      await apiService.postRequest(
          url: ApiUrl.resetPassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) {
            clearFormData();
            Get.back();
            showSnack(msg: data["response"]["message"]);
          },
          onError: (ErrorType errorType, String msg) {
            Get.snackbar("Alert", msg,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWalletCreditPointsData({bool isScreenChange = true}) async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.userDetails,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            userData.value = UserDetailModel.fromJson(data["response"]);
            userData.refresh();
            log("message   ==>  ${jsonEncode(data)}");
          },
          onError: (ErrorType errorType, String? msg) {
            Get.snackbar("Alert", msg!,
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                colorText: Colors.white);
            // showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      dismissLoader();
      // showError(msg: e.toString());
    }
  }

  Future<void> getUserProfileData({bool isScreenChange = true}) async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.userDetails,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            userData.value = UserDetailModel.fromJson(data["response"]);
            // Stripe.publishableKey = userData.value.stripePublishableKey ?? "";

            userData.refresh();
            log("message   ==>  ${jsonEncode(data)}");
            if (isScreenChange) {
              log("message andar chala jata he");
              Get.offAll(() => HomeScreen());
            }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
            userToken.value = LoginResponseModel();
            userToken.refresh();
            Get.offAll(() => LoginScreen());
          });
    } catch (e) {
      log("message   ==>  ${e}");
      dismissLoader();
      Get.off(() => LoginScreen());
      // showError(msg: e.toString());
    }
  }

  Future<void> getArbyBanner() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: "https://www.arbyme.com/api/user/banners",
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            arbyBanner.value = ArbyBannerModel.fromJson(data["response"]);
            // Stripe.publishableKey = userData.value.stripePublishableKey ?? "";

            log("message ss  ==>${data["response"]}");

          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
            userToken.value = LoginResponseModel();
            userToken.refresh();
            Get.offAll(() => LoginScreen());
          });
    } catch (e) {
      log("message   ==>  ${e}");
      dismissLoader();
      Get.off(() => LoginScreen());
      // showError(msg: e.toString());
    }
  }

  Future<void> getPromoCodeList() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.promoCodesList,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            promoCodeList.clear();
            PromoCodeListModel tempPromoCodeList =
                promoCodeListModelFromJson(jsonEncode(data["response"]));
            promoCodeList.addAll(tempPromoCodeList.promoList);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      dismissLoader();
      // showError(msg: e.toString());
    }
  }

  Future<void> getNotificationList() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.notifications,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            notificationManagerList.clear();
            List<NotificationManagerModel> tempNotificationList =
                notificationManagerModelFromJson(jsonEncode(data["response"]));
              notificationManagerList.addAll(tempNotificationList);



          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getWalletTransaction() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.passBook,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            walletTransationModel.value =
                walletTransationModelFromJson(jsonEncode(data["response"]));
            userData.value.walletBalance =
                walletTransationModel.value.walletBalance;
            walletTransationModel.refresh();
            // notificationManagerList.clear();
            // List<NotificationManagerModel> tempNotificationList = notificationManagerModelFromJson(jsonEncode(data["response"]));
            // notificationManagerList.addAll(tempNotificationList);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getHelp() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.help,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            helpResponseModel.value =
                helpResponseModelFromJson(jsonEncode(data["response"]));
            helpResponseModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getLocation() async {
    try {
      // showLoader();
      await apiService.getRequest(
          url: ApiUrl.location,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            locationResponseModel.value =
                locationResponseModelFromJson(jsonEncode(data["response"]));
            locationResponseModel.refresh();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> deleteLocation({required String id}) async {
    try {
      showLoader();
      await apiService.deleteRequest(
          url: ApiUrl.location + "/$id",
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            showSnack(msg: "${data["response"]["message"]}");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> addLocation({Map<String, String> params = const {}}) async {
    try {
      showLoader();
      await apiService.postRequest(
          url: ApiUrl.location,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            // locationResponseModel.value = locationResponseModelFromJson(jsonEncode(data["response"]));
            // locationResponseModel.refresh();
            await getLocation();
            showSnack(msg: "${data["response"]["message"]}");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      HomeController _homeController = Get.find();
      showLoader();
      Map<String, dynamic> params = {};
      params["first_name"] = firstNameController.text;
      params["last_name"] = lastNameController.text;
      params["email"] = emailController.text;
      params["mobile"] = phoneNumberController.text;
      params["country_code"] = userData.value.countryCode ?? "";

      if (imageFilePah != null) {
        params["picture"] = await dio.MultipartFile.fromFile(imageFilePah!);
      }
      dio.FormData formData = new dio.FormData.fromMap(params);
      await apiService.postRequest(
          url: ApiUrl.updateProfile,
          params: formData,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            _homeController.isCaptureImage.value = false;
            await getUserProfileData(isScreenChange: false);
            Get.back();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> changePassword() async {
    try {
      removeUnFocusManager();

      if (oldPasswordController.text.isEmpty) {
        showError(msg: "Please enter current password");
        return;
      }
      if (passwordController.text.isEmpty) {
        showError(msg: "Please enter password");
        return;
      }
      if (passwordController.text.length < 6) {
        showError(msg: "Password length must be between 6–15 characters.");
        return;
      }
      if (passwordController.text == oldPasswordController.text) {
        showError(msg: "Old and new password must be different");
        return;
      }
      if (conPasswordController.text.isEmpty) {
        showError(msg: "Please enter confirm password");
        return;
      }
      if (conPasswordController.text != passwordController.text) {
        showError(msg: "Password should be same");
        return;
      }
      showLoader();
      Map<String, dynamic> params = {};
      params["old_password"] = oldPasswordController.text;
      params["password"] = passwordController.text;
      params["password_confirmation"] = conPasswordController.text;

      await apiService.postRequest(
          url: ApiUrl.changePassword,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            showSnack(msg: data["response"]["message"]);

            // clearFormData();
            passwordController.text = "";
            conPasswordController.text = "";
            oldPasswordController.text = "";
            Get.back();
            Get.back();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> createCard({Map<String, dynamic> cardParams = const {}}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["number"] = "";
      params["exp_month"] = "";
      params["exp_year"] = "";
      params["cvc"] = "";
      params["customer_id"] = userData.value.stripeCustId ?? "";
      params["is_defalut"] = true;
      params.addAll(cardParams);

      dio.FormData formData = new dio.FormData.fromMap(params);
      await apiService.postRequest(
          url: ApiUrl.createCard,
          params: formData,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            getCardList();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> getCardList() async {
    try {
      showLoader();

      await apiService.getRequest(
          url: "${ApiUrl.cardList}/${userData.value.stripeCustId ?? ""}",
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            cardList.clear();
            CardDataModel cardDataModel =
                cardDataModelFromJson(jsonEncode(data["response"]));
            if (cardDataModel.data != null) {
              cardList.addAll(cardDataModel.data!.data);
            }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> walletAddMoney({required String money}) async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["amount"] = "${money}";
      params["customer_id"] = userData.value.stripeCustId ?? "";
      await apiService.postRequest(
          url: "${ApiUrl.walletAdd}",
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            _walletAddModel =
                walletAddModelFromJson(jsonEncode(data["response"]));

            if (_walletAddModel.data != null) {
              // Stripe.publishableKey = _walletAddModel.data?.publishableKey??"";
              // try {
              //   await Stripe.instance.applySettings();
              //   await Stripe.instance.initPaymentSheet(
              //     paymentSheetParameters: SetupPaymentSheetParameters(
              //       paymentIntentClientSecret:
              //           _walletAddModel.data?.clientSecret ?? "",
              //       merchantDisplayName: "arbyuser",
              //       customerId: userData.value.stripeCustId ?? "",
              //       style: ThemeMode.dark,
              //     ),
              //   );
              //   await Stripe.instance.presentPaymentSheet().then((value) {
              //     print("after ==> snub 544 564");
              //     log("after ==> snub 544 564");
              //   });
              //   // Future.delayed(
              //   //   Duration(
              //   //     seconds: 20,
              //   //   ),
              //   //   () async {
              //   //     print("after ==> snub ");
              //   //     log("after ==> snub ");
              //   //     await Stripe.instance.confirmPaymentSheetPayment();
              //   //   },
              //   // );
              //   showSnack(msg: 'Payment succesfully completed');
              // } on Exception catch (e) {
              //   if (e is StripeException) {
              //     showError(
              //         msg: "Error from Stripe: ${e.error.localizedMessage}");
              //   } else {
              //     showError(msg: "Unforeseen error: ${e}");
              //   }
              // }
            }
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["id"] = "${userData.value.id}";
      await apiService.postRequest(
          url: ApiUrl.logout,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            userToken.value = LoginResponseModel();
            userData.value = UserDetailModel();
            await _userDetails.logoutUser();
            // Get.offAll(() => SignInUpScreen());
            Get.offAll(() => LoginScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<void> givenFeedback(String title, String description) async {
    try {
      showLoader();
      Map<String, String> params = {};
      params["user_id"] = "${userData.value.id}";
      params["title"] = title;
      params["description"] = description;
      params["type"] = "user";

      await apiService.postRequest(
          url: ApiUrl.giveFeedback,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
            Get.back();
            Get.snackbar("Successfully", data["response"]["message"],
                backgroundColor: Colors.green, colorText: Colors.white);
            print("complete feedback");

            // userToken.value = LoginResponseModel();
            // userData.value = UserDetailModel();
            // await _userDetails.logoutUser();
            // // Get.offAll(() => SignInUpScreen());
            // Get.offAll(() => LoginScreen());
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  void clearFormData() {
    emailController.text = "";
    firstNameController.text = "";
    lastNameController.text = "";
    phoneNumberController.text = "";
    passwordController.text = "";
    conPasswordController.text = "";
    oldPasswordController.text = "";
    otpController.text = "";
    countryCode.value = "";
  }

  void addCard() {
    // Stripe.publishableKey = userData.value.stripePublishableKey ?? "";

    // Stripe.instance.createPaymentMethod(
    //   PaymentMethodParams.card(
    //     billingDetails: BillingDetails(),
    //   ),
    // );
    // Stripe.instance.createToken(CreateTokenParams.card(params: CardTokenParams.));
    // Stripe.instance.handleCardAction(paymentIntentClientSecret)
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $phoneNumber");
    }
  }

  Future<void> sendMail({required String mail}) async {
    Uri uri = Uri.parse("mailto:$mail");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $mail");
    }
  }

  Future<void> deleteAccount() async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["id"] = userData.value.id;
      await apiService.postRequest(
          url: ApiUrl.deleteAccount,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            await logout();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }
}
