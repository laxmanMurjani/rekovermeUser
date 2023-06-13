import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/api/api_service.dart';
import 'package:arbyuser/controller/base_controller.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/user_location_type.dart';
import 'package:arbyuser/model/check_request_response_model.dart';
import 'package:arbyuser/model/dispute_model.dart';
import 'package:arbyuser/model/fare_response_model.dart';
import 'package:arbyuser/model/get_nearest_user_model.dart';
import 'package:arbyuser/model/multiple_location_add_model.dart';
import 'package:arbyuser/model/payment_mode_model.dart';
import 'package:arbyuser/model/promocode_list_model.dart';
import 'package:arbyuser/model/services_model.dart';
import 'package:arbyuser/model/show_driver_location_model.dart';
import 'package:arbyuser/model/show_saved_contact_model.dart';
import 'package:arbyuser/model/trip_data_model.dart';
import 'package:arbyuser/ui/dialog/invoice_dialog.dart';
import 'package:arbyuser/ui/home_screen.dart';
import 'package:arbyuser/util/app_constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_directions_api/google_directions_api.dart' as direction;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' as vectorMath;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

import '../enum/error_type.dart';


class HomeController extends BaseController {
  final UserController _userController = Get.find();
  RxList<ServicesModel> serviceModelList = <ServicesModel>[].obs;
  TextEditingController locationFromTo = TextEditingController();
  TextEditingController locationWhereTo1 = TextEditingController();
  TextEditingController dialogFeedbackTitleController = TextEditingController();
  TextEditingController dialogFeedbackDescriptionController =
      TextEditingController();

  TextEditingController tempLocationFromTo = TextEditingController();
  TextEditingController tempLocationWhereTo1 = TextEditingController();

  ScrollController serviceListScrollController = ScrollController();

  RxList<AutocompletePrediction> searchAddressList =
      <AutocompletePrediction>[].obs;
  GooglePlace googlePlace = GooglePlace(AppString.googleMapKey);
  FocusNode locationFromFocusNode = FocusNode();
  FocusNode locationWhereToFocusNode = FocusNode();
  FocusNode recentLocation = FocusNode();
  PolylineId id = PolylineId('poly');
  Uint8List? userImageMarker;
  LatLng? userCurrentLocation;

  LatLng? latLngFrom;
  LatLng? latLngWhereTo1;
  LatLng? tempLatLngFrom;
  LatLng? tempLatLngWhereTo1;
  LatLng latLngWhereTo2 = LatLng(0, 0);
  LatLng latLngWhereTo3 = LatLng(0, 0);
  RxBool isPickFromMap = false.obs;
  RxBool isRoundTrip = false.obs;
  RxBool contactPickup = false.obs;
  RxBool driverRating = false.obs;
  RxBool etoRating = false.obs;

  RxInt serviceTypeSelectedIndex = 0.obs;
  RxInt selectedRadioIndex = 0.obs;
  RxBool isCaptureImage = false.obs;
  RxBool isBookSomeOne = false.obs;
  RxBool isPaymentSuccess = false.obs;

  GoogleMapController? googleMapController;
  Rx<CameraPosition> googleMapInitCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    // target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ).obs;

  RxList<Polyline> googleMapPolyLine = <Polyline>[].obs;
  RxMap<MarkerId, Marker> googleMarkers = <MarkerId, Marker>{}.obs;
  Rx<FareResponseModel> fareResponseModel = FareResponseModel().obs;
  Rx<CheckRequestResponseModel> checkRequestResponseModel = CheckRequestResponseModel().obs;
  Rx<PaymentModeModel> paymentModeModel = PaymentModeModel().obs;
  RxList<Reason> reasonList = <Reason>[].obs;
  Iterable markers = [];
  RxList<String> saveOtherAddress = <String>[].obs;

  RxList<SavedContactList> savedContactList = <SavedContactList>[].obs;

  Rx<UserUiSelectionType> userUiSelectionType =
      UserUiSelectionType.locationSelection.obs;
  bool _isDrawProvideToUserPolyLine = false;
  Rx<StatusType> statusType = StatusType.STARTED.obs;
  LatLng? carAnimLatLng;

  MarkerId userMarkerId = const MarkerId("user");
  MarkerId _markerId = const MarkerId("first");
  MarkerId _startPointCap = const MarkerId("startPointCap");
  MarkerId _endPointCap = const MarkerId("endPointCap");

  RxList<TripDataModel> pastTripDataList = <TripDataModel>[].obs;
  RxList<TripDataModel> upcomingTripDataList = <TripDataModel>[].obs;
  RxList<ShowDriversLocationModel> showDriverLocationList =
      <ShowDriversLocationModel>[].obs;
  RxList<GetNearestDriverTimeModel> getNearestDriverTimeModel =
      <GetNearestDriverTimeModel>[].obs;
  Rx<TripDataModel> tripDetails = TripDataModel().obs;
  Rx<TripDataModel> upcomingTripDetails = TripDataModel().obs;
  PromoList? selectedPromoCode = null;
  RxString providerDurationTime = "".obs;
  RxString selectedPaymentMode = "".obs;
  RxString nearByDriverTime = "".obs;
  RxList<String> nearByDriverTimeList = <String>[].obs;
  RxList<int> nearByDriverTimeList1 = <int>[].obs;
  RxInt providerDurationSecond = 0.obs;
  RxList<MultipleLocationAddModel> multipleLocationAdModelList = <MultipleLocationAddModel>[].obs;

  RxInt _currentDestinationId = 0.obs;
  RxList<DisputeModel> disputeList = <DisputeModel>[].obs;
  RxMap<dynamic, dynamic> paymentModeMap = {"payment_mode": "CASH"}.obs;
  PolylinePoints _polylinePoints = PolylinePoints();
  RxBool isWalletSelected = false.obs;

  RxString currentRideAddress = "".obs;

  LatLng? _currentRideSourceLatLng;

  RxString bookSomeNumber = "".obs;
  RxString bookSomeName = "".obs;
  RxInt timeLeftToRespond = 0.obs;
  Timer? _timer;
  // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppString.googleMapKey);

  @override
  void onInit() {
    super.onInit();

    checkRequestResponseModel.listen((p0) async {
      try {

        // if(checkRequestResponseModel.value.data.isNotEmpty){
        //   print("object1111");
        //   paymentModeRequestForInvoice();
        // }


        if (p0.data.isNotEmpty) {
          reasonList.clear();
          reasonList.addAll(p0.data[0].reasons);

          if (p0.data[0].provider == null) {
            // if (!_isFindingDriver) {
            userUiSelectionType.value = UserUiSelectionType.findingDriver;
            // Get.bottomSheet(FindingDriverDialog(), settings: RouteSettings());
            // _isFindingDriver = true;
            // }
            // if(userUiSelectionType.value == UserUiSelectionType.findingDriver){
          

                startTimer();

                userUiSelectionType.value =
                  UserUiSelectionType.findingDriver;
            // }


            print("provider00===>${p0.data[0].provider}");
          } else {
            print("provider11===>${p0.data[0].provider}");
            Datum data = p0.data[0];
            Provider provider = data.provider!;

            if (userUiSelectionType.value !=
                    UserUiSelectionType.driverAvailable &&
                googleMapController != null) {
              userUiSelectionType.value = UserUiSelectionType.driverAvailable;

              providerDrawPolyLine(
                s_lat: provider.latitude,
                s_lng: provider.longitude,
                d_lat: data.sLatitude,
                d_lng: data.sLongitude,
              );
            }

            if (provider.latitude != null &&
                provider.longitude != null &&
                googleMapController != null) {
              showMarker(
                  latLng:
                      LatLng(provider.latitude ?? 0, provider.longitude ?? 0),
                  oldLatLng: carAnimLatLng ??
                      LatLng(provider.latitude ?? 0, provider.longitude ?? 0));
              carAnimLatLng =
                  LatLng(provider.latitude ?? 0, provider.longitude ?? 0);
            }
            if (data.status == StatusType.ARRIVED &&
                googleMapController != null) {
              if (statusType.value != StatusType.ARRIVED) {
                providerDrawPolyLine(
                  s_lat: provider.latitude,
                  s_lng: provider.longitude,
                  d_lat: data.sLatitude,
                  d_lng: data.sLongitude,
                );
              }
            }
            if (data.status == StatusType.ARRIVED ||
                data.status == StatusType.STARTED) {
              _getDirectionDetails(
                sourceLatLng:
                    LatLng(provider.latitude ?? 0, provider.longitude ?? 0),
                destinationLatLng:
                    LatLng(data.sLatitude ?? 0, data.sLongitude ?? 0),
              );
            }

            if (data.status == StatusType.PICKEDUP &&
                googleMapController != null) {
              bool _isForEachDone = false;
              if (p0.multiDestination.isNotEmpty) {
                for (int i = 0; i < p0.multiDestination.length; i++) {
                  MultiDestination multiDestination = p0.multiDestination[i];

                  if (!_isForEachDone && multiDestination.isPickedup == 0) {
                    _isForEachDone = true;
                    if (multiDestination.id != _currentDestinationId.value) {
                      _currentDestinationId.value = multiDestination.id;
                      log("message  ==> 123 ${multiDestination.id}");
                      if (i != 0) {
                        log("message  ==> 123 456 ${multiDestination.id}");
                        MultiDestination sourceDestination =
                            p0.multiDestination[i - 1];
                        providerDrawPolyLine(
                          s_lat: sourceDestination.latitude,
                          s_lng: sourceDestination.longitude,
                          d_lat: multiDestination.latitude,
                          d_lng: multiDestination.longitude,
                        );

                        currentRideAddress.value =
                            sourceDestination.dAddress ?? "";
                      } else {
                        log("message  ==> 123 456 789 ${multiDestination.id}");
                        providerDrawPolyLine(
                          s_lat: data.sLatitude,
                          s_lng: data.sLongitude,
                          d_lat: multiDestination.latitude,
                          d_lng: multiDestination.longitude,
                        );
                        currentRideAddress.value =
                            multiDestination.dAddress ?? "";
                      }
                    }
                  }
                }
              } else {
                if (statusType.value != StatusType.PICKEDUP) {
                  providerDrawPolyLine(
                    s_lat: data.sLatitude,
                    s_lng: data.sLongitude,
                    d_lat: data.dLatitude,
                    d_lng: data.dLongitude,
                  );
                  currentRideAddress.value = data.dAddress ?? "";
                }
              }
            }

            if (data.status == StatusType.PICKEDUP) {
              _getDirectionDetails(
                sourceLatLng:
                    LatLng(provider.latitude ?? 0, provider.longitude ?? 0),
                destinationLatLng:
                    LatLng(data.dLatitude ?? 0, data.dLongitude ?? 0),
              );
            }
            // if (data.status == StatusType.DROPPED &&
            //     googleMapController != null) {
            //   if (statusType.value != StatusType.DROPPED) {
            //     providerDrawPolyLine(
            //       s_lat: data.sLatitude,
            //       s_lng: data.sLongitude,
            //       d_lat: data.dLatitude,
            //       d_lng: data.dLongitude,
            //     );
            //     Get.bottomSheet(InvoiceDialog(),
            //         enableDrag: false,
            //         isDismissible: false,
            //         isScrollControlled: true);
            //   }
            // }
            if(data.breakdown == 1){
              print("checkBreakdown");

              if(data.paid == 0){
                print("objectsdsdsd");
                // Get.bottomSheet(FindingDriverForBreakDownDialog(),
                //     enableDrag: false,
                //     isDismissible: false,
                //     isScrollControlled: true);


              }

              else if(data.paid == 1){
                Get.offAll(HomeScreen());
                print("complete work");
                if ((data.status == StatusType.DROPPED ||
                    data.status == StatusType.COMPLETED) &&
                    googleMapController != null) {
                  log("StatusType ==>   ${statusType.value}  ${data.status}");
                  if (statusType.value != StatusType.COMPLETED &&
                      statusType.value != StatusType.DROPPED &&
                      statusType.value != StatusType.RATING) {
                    log("StatusType ==>12   ${statusType.value}  ${data.status}");
                    // providerDrawPolyLine(
                    //   s_lat: data.sLatitude,
                    //   s_lng: data.sLongitude,
                    //   d_lat: data.dLatitude,
                    //   d_lng: data.dLongitude,
                    // );
                    // Get.bottomSheet(InvoiceDialog(),
                    //     enableDrag: false,
                    //     isDismissible: false,
                    //     isScrollControlled: true);
                  }
                }
                if (data.status != null && googleMapController != null) {
                  if (statusType.value != StatusType.RATING) {
                    statusType.value = data.status!;
                    String? msg =await  providerRate(rating: "5", comment: "null");
                  }
                }
              }

            }else {
              if ((data.status == StatusType.DROPPED ||
                  data.status == StatusType.COMPLETED) &&
                  googleMapController != null) {
                log("StatusType ==>   ${statusType.value}  ${data.status}");
                if (statusType.value != StatusType.COMPLETED &&
                    statusType.value != StatusType.DROPPED &&
                    statusType.value != StatusType.RATING) {
                  log("StatusType ==>12   ${statusType.value}  ${data.status}");
                  // providerDrawPolyLine(
                  //   s_lat: data.sLatitude,
                  //   s_lng: data.sLongitude,
                  //   d_lat: data.dLatitude,
                  //   d_lng: data.dLongitude,
                  // );
                  Get.bottomSheet(InvoiceDialog(),
                      enableDrag: false,
                      isDismissible: false,
                      isScrollControlled: true);
                }
              }
              if (data.status != null && googleMapController != null) {
                if (statusType.value != StatusType.RATING) {
                  statusType.value = data.status!;
                }
              }
            }

          }
        } else {
          if (userUiSelectionType.value == UserUiSelectionType.serviceType ||
              userUiSelectionType.value == UserUiSelectionType.vehicleDetails ||
              userUiSelectionType.value == UserUiSelectionType.scheduleRide) {
          } else {
            paymentModeMap = {"payment_mode": "CASH"}.obs;
            isWalletSelected.value = false;
            statusType.value = StatusType.EMPTY;
            googleMapPolyLine.clear();
            if (googleMarkers.length > 1) {
              googleMarkers.clear();
              isCaptureImage.value = false;
            }
            _isDrawProvideToUserPolyLine = false;
            // latLngWhereTo1 = null;
            // locationWhereTo1.text = "";
            // if (_isFindingDriver) {
            //   Get.back();
            //   _isFindingDriver = false;
            // }
            userUiSelectionType.value = UserUiSelectionType.locationSelection;
          }
        }
      } catch (e) {
        log("message   ==>   ${e}");
      }
      userUiSelectionType.refresh();
    }, onError: () {
      log("message   ==>   ERROR");
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeftToRespond.value--;
      if (timeLeftToRespond.value <= 0) {
        timer.cancel();
        checkRequest();
      }
    });
  }

  Future<void> getServices() async {
    try {
      showLoader();
      await apiService.getRequest(
          url: ApiUrl.services,
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            serviceTypeSelectedIndex.value = 0;
            List<ServicesModel> serviceList =
                servicesModelFromJson(jsonEncode(data["response"]));
            serviceModelList.clear();
            serviceModelList.addAll(serviceList);
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
      showError(msg: e.toString());
    }
  }

  Future<void> getDriversLocationData(Function? updateData) async {
    try {
      // showLoader();
      await apiService.getRequest(
          url:
              "${ApiUrl.showProviders}?latitude=${userCurrentLocation!.latitude}&longitude=${userCurrentLocation!.longitude}&service=1",
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            showDriverLocationList.clear();
            showDriverLocationList.value =
                showDriversLocationModelFromJson(jsonEncode(data["response"]));
            print("objectshowDriverLocationList===>${showDriverLocationList.first.firstName} ${showDriverLocationList.first.lastName}");
            print("objectshowDriverLocationList===>${showDriverLocationList.first.latitude}");
            print("00000===>${showDriverLocationList.length}");

            getDriverMarkerData(updateData: updateData);

          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
      showError(msg: e.toString());
    }
  }

  Future<void> getNearDriverTimeData() async {
    try {
      // showLoader();
      await apiService.getRequest(
          url:
              "${ApiUrl.showNearByDriver}?s_latitude=${userCurrentLocation!.latitude}&s_longitude=${userCurrentLocation!.longitude}&service=1",
          onSuccess: (Map<String, dynamic> data) {
            dismissLoader();
            // showDriverLocationList.clear();
            // showDriverLocationList.value =
            //     showDriversLocationModelFromJson(jsonEncode(data["response"]));
            print("dddd===>${data["response"]}");
            nearByDriverTime.value = data["response"];
            nearByDriverTimeList.value = nearByDriverTime.value.split(",");
            nearByDriverTimeList.removeLast();
            print("dddd===>${nearByDriverTimeList.value.last}");
            nearByDriverTimeList1.value = nearByDriverTimeList.map(int.parse).toList();
            print("nearByDriverTimeList1===>${nearByDriverTimeList1.last}");
            nearByDriverTimeList1.sort((a, b) => a.compareTo(b));
            print("newCompleteList===>${nearByDriverTimeList1.first}");
            durationToString(nearByDriverTimeList1.first);
            print("timeLeft===>${durationToString(nearByDriverTimeList1.first).split(":").first} h");
            print("timeLeft===>${durationToString(nearByDriverTimeList1.first).split(":").last} m");
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      print(e);
      showError(msg: e.toString());
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  // Future<void> getNearByDriversTimeData({
  //   double? d_latitude,
  //   double? s_longitude,
  //   double? d_longitude,
  //   double? s_latitude,
  //   int? serviceType,
  // }) async {
  //   try {
  //     // showLoader();
  //     await apiService.getRequest(
  //         url:
  //             "${ApiUrl.apiBaseUrl}/show_driver_emt?d_latitude=${d_latitude}&s_longitude=${s_longitude}&service_type=${serviceType}&d_longitude=${d_longitude}&s_latitude=${s_latitude}",
  //         onSuccess: (Map<String, dynamic> data) {
  //           dismissLoader();
  //           // getNearestDriverTimeModel.clear();
  //           getNearestDriverTimeModel.add(getNearestDriverTimeModelFromJson(
  //               jsonEncode(data["response"]))!);
  //           // print("checking1===>${totalList.first}");
  //           // print("checking0===>${getNearestDriverTimeModel[1].distance}");
  //           // print("checking0===>${getNearestDriverTimeModel[2].distance}");
  //           // print("checking0===>${getNearestDriverTimeModel[3].distance}");
  //         },
  //         onError: (ErrorType errorType, String? msg) {
  //           showError(msg: msg);
  //         });
  //   } catch (e) {
  //     print(e);
  //     showError(msg: e.toString());
  //   }
  // }

  getDriverMarkerData({Function? updateData}) async {
    print("000000===>${showDriverLocationList.length}");

    ByteData data = await rootBundle.load(AppImage.taxi);
    log("uuuuu=>${data.buffer.asUint8List().length}");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 80);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List markIcons =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();



      Iterable _markers =
      Iterable.generate(showDriverLocationList.length-1, (index) {
        ShowDriversLocationModel result = showDriverLocationList[index];
        // Map location = result["geometry"]["location"];
        LatLng latLngMarker = LatLng(result.latitude!, result.longitude!);

        return Marker(
          markerId: MarkerId("marker$index"),
          position: latLngMarker,
          icon: BitmapDescriptor.fromBytes(markIcons),
        );

      });
      markers = _markers;

      updateData!.call();
  }

  Future<List<Placemark>> getLocationAddress(
      {required LatLng latLng, bool? isFromAddress = true}) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placeMarks.isNotEmpty) {
      Placemark placeMark = placeMarks[0];
      log("message  ==>  ${placeMark.toJson()}");
      if (isFromAddress == true) {
        tempLatLngFrom = latLng;
        tempLocationFromTo.text =
            "${placeMark.street}, ${placeMark.thoroughfare}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
        // locationFromTo.text = tempLocationFromTo.text;
      } else if (isFromAddress == false) {
        tempLatLngWhereTo1 = latLng;
        tempLocationWhereTo1.text =
            "${placeMark.street}, ${placeMark.thoroughfare}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
        // locationWhereTo1.text =tempLocationWhereTo1.text;
      }

      if (isFromAddress == null) {
        multipleLocationAdModelList.forEach((element) {
          if (element.focusNode?.hasFocus == true) {
            element.textEditingController?.text =
                "${placeMark.street}, ${placeMark.thoroughfare}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
            element.latLng = latLng;
          }
        });
      }
    }
    refresh();

    return placeMarks;
  }

  Future<List<AutocompletePrediction>> getLocationFromAddress({
    required String address,
    bool isFromAddress = true,
  }) async {
    try {
      AutocompleteResponse? addressList =
          await googlePlace.autocomplete.get(address);
      // List<Placemark> placeMarks = [];
      searchAddressList.clear();
      // List<Location> locations = await locationFromAddress(address);
      //
      // for (int i = 0; i < locations.length; i++) {
      //   placeMarks.addAll(await getLocationAddress(
      //       latLng: LatLng(locations[i].latitude, locations[i].longitude),
      //       isFromAddress: false));
      //   log("message  ==>   1 ${placeMarks.length}");
      // }
      //
      // searchAddressList.addAll(placeMarks);
      // log("message  ==>   ${placeMarks.length}");

      if (addressList != null) {
        if (addressList.predictions != null) {
          searchAddressList.addAll(addressList.predictions!);
          searchAddressList.forEach((element) async {
            log("message  ==>   ${element.placeId}    ${element.id}");
            if (searchAddressList.isNotEmpty) {
              // DetailsResponse? result = await googlePlace.details.get(
              //     element.placeId!,
              //     fields: "name,rating,formatted_phone_number,geometry");
              // log("message  ==>   result   ${result?.result?.geometry?.location?.lat}  ${result?.result?.geometry?.location?.lng}");
            }
          });
          return addressList.predictions!;
        }
      } else {
        searchAddressList.clear();
        return [];
      }
    } catch (e) {
      searchAddressList.clear();
      return [];
    }
    searchAddressList.clear();
    return [];
  }

  Future<void> getPlaceIdToLatLag({required String placeId}) async {
    DetailsResponse? result = await googlePlace.details
        .get(placeId, fields: "name,rating,formatted_phone_number,geometry");
    LatLng latLng = LatLng(result!.result!.geometry!.location!.lat!,
        result.result!.geometry!.location!.lng!);
    if (locationFromFocusNode.hasFocus) {
      tempLatLngFrom = latLng;
    } else if (locationWhereToFocusNode.hasFocus) {
      tempLatLngWhereTo1 = latLng;
    } else {
      multipleLocationAdModelList.forEach((element) {
        if (element.focusNode?.hasFocus == true) {
          element.latLng = latLng;
        }
      });
    }
    refresh();
  }

  void setData() {
    locationFromTo.text = tempLocationFromTo.text;
    locationWhereTo1.text = tempLocationWhereTo1.text;
    latLngFrom = tempLatLngFrom;
    latLngWhereTo1 = tempLatLngWhereTo1;
  }

  void clearData() {
    // tempLocationFromTo.text = "";
    tempLocationWhereTo1.text = "";
    locationWhereTo1.text = "";
    // tempLatLngFrom = null;
    tempLatLngWhereTo1 = null;
    googleMapPolyLine.clear();
    isCaptureImage.value = false;
    googleMarkers.clear();
    multipleLocationAdModelList.clear();
  }


  Future<void> providerDrawPolyLine({
    double? s_lat,
    double? s_lng,
    double? d_lat,
    double? d_lng,
    List<LatLng> latLngList = const [],
  }) async {
    double? maxLat = null, minLat = null, minLon = null, maxLon = null;
    bool hasPoints = false;
    try {
      _currentRideSourceLatLng = LatLng(s_lat ?? 0, s_lng ?? 0);
      googleMapPolyLine.clear();
      googleMarkers.clear();
      isCaptureImage.value = false;
      List<PolylineWayPoint> polyLineList = [];
      latLngList.forEach((element) {
        PolylineWayPoint polylineWayPoint = PolylineWayPoint(
          location: "${element.latitude},${element.longitude}",
        );
        polyLineList.add(polylineWayPoint);
      });

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(s_lat ?? 0, s_lng ?? 0),
        zoom: 14.4746,
      );
      googleMapInitCameraPosition.value = cameraPosition;
      print("s_lat===> $s_lat");
      print("s_lat===> $s_lng");
      print("d_lat===> $d_lat");
      print("d_lat===> $d_lng");
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        AppString.googleMapKey,
        PointLatLng(s_lat ?? 0, s_lng ?? 0),
        PointLatLng(d_lat ?? 0, d_lng ?? 0),
        wayPoints: polyLineList,
        travelMode: TravelMode.driving,
      );

      List<LatLng> points = <LatLng>[];
      int count = 0;
      for (var element in result.points) {
        points.add(LatLng(element.latitude, element.longitude));
        maxLat = maxLat != null
            ? math.max(element.latitude, maxLat)
            : element.latitude;
        minLat = minLat != null
            ? math.min(element.latitude, minLat)
            : element.latitude;

        // Longitude
        maxLon = maxLon != null
            ? math.max(element.longitude, maxLon)
            : element.longitude;
        minLon = minLon != null
            ? math.min(element.longitude, minLon)
            : element.longitude;

        hasPoints = true;
        count++;
        log("message   ==>  $count   ${element.longitude} ${element.latitude}");
      }

      Uint8List? markerIcon =
      await getBytesFromAsset(AppImage.multiDestIcon, 50);
      List<PatternItem> pattern = [PatternItem.dash(1), PatternItem.gap(0)];
      latLngList.forEach((element) async {
        if (element.latitude != d_lat && element.longitude != d_lng) {
          if (markerIcon != null) {
            Marker _userMarker = Marker(
                markerId: _markerId,
                // rotation: _bearingBetweenLocations(oldLatLng, latLng),
                position: element,
                anchor: Offset(0.5, 0.5),
                // ripple: true,
                icon: BitmapDescriptor.fromBytes(markerIcon));
            googleMarkers[_markerId] = _userMarker;
          }
        }
      });

      Uint8List? startMarkerIcon =
      await getBytesFromAsset(AppImage.src_icon, 30);
      Uint8List? endMarkerIcon = await getBytesFromAsset(AppImage.des_icon, 30);
      Uint8List? multiMarkerIcon =
      await getBytesFromAsset(AppImage.multiDestIcon, 30);
      print("points[0]====>${points[0]}");
      if (points.isNotEmpty) {
        if (startMarkerIcon != null) {
          Marker _startCapMarker = Marker(
            markerId: _startPointCap,
            anchor: Offset(0.5, 0.5),
            position: points[0],
            icon: BitmapDescriptor.fromBytes(startMarkerIcon),
          );
          googleMarkers[_startPointCap] = _startCapMarker;
        }

        if (multiMarkerIcon != null) {
          latLngList.forEach((element) {
            if ((element.latitude != (d_lat ?? 0)) &&
                (element.longitude != (d_lng ?? 0))) {
              Marker _startCapMarker = Marker(
                markerId: MarkerId("${element.longitude},${element.latitude}"),
                anchor: Offset(0.5, 0.5),
                position: LatLng(element.latitude, element.longitude),
                icon: BitmapDescriptor.fromBytes(multiMarkerIcon),
              );
              googleMarkers[
              MarkerId("${element.longitude},${element.latitude}")] =
                  _startCapMarker;
            }
          });
        }

        if (endMarkerIcon != null) {
          Marker _endCapMarker = Marker(
            anchor: Offset(0.5, 0.5),
            markerId: _endPointCap,
            position: points[points.length - 1],
            icon: BitmapDescriptor.fromBytes(endMarkerIcon),
          );
          googleMarkers[_endPointCap] = _endCapMarker;
        }
      }
      Polyline polyline = Polyline(
        startCap: Cap.customCapFromBitmap(
          await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            AppImage.dot,
          ),
        ),
        polylineId: id,
        color: Colors.black,
        points: points,
        width: 3,
        patterns: pattern,
        endCap: Cap.customCapFromBitmap(
          await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), AppImage.dot),
        ),
      );
      googleMapPolyLine.add(polyline);

      if (hasPoints) {
        LatLngBounds builder = new LatLngBounds(
            southwest: LatLng(minLat ?? 0, minLon ?? 0),
            northeast: LatLng(maxLat ?? 0, maxLon ?? 0));
        googleMapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(builder, 80));
      }
      refresh();
    } catch (e) {
      log("message   ==>     $e");
    }
  }


  Future<void> getFairServiceDetailsApiCall(
      {ServicesModel? servicesModel}) async {
    log("Uri ===>  " +
        Uri.decodeFull(
            "payment_mode=CASH&service_type=1&d_longitude=72.5713621&distance=259.2&s_latitude=21.2392538&multi_destination=%5B%7B%22d_address%22%3A%22Yogi%20Chowk%2C%20Sanman%20Society%2C%20Vrundavan%20Society%2C%20Yoginagar%20Society%2C%20Surat%2C%20Gujarat%2C%20India%22%2C%22d_latitude%22%3A21.2125569%2C%22d_longitude%22%3A72.88947259999999%2C%22final_destination%22%3A0%7D%2C%7B%22d_address%22%3A%22Ahmedabad%2C%20Gujarat%2C%20India%22%2C%22d_latitude%22%3A23.022505%2C%22d_longitude%22%3A72.5713621%2C%22final_destination%22%3A1%7D%5D&d_latitude=23.022505&d_address=Ahmedabad%2C%20Gujarat%2C%20India&s_address=215%2C%20Skyview%20Business%20Horizon%2C%20nr"));

    log("message  Uri ===>   " +
        Uri.decodeFull(
            "fare=134.0&payment_mode=CASH&distance=4.7&d_latitude=21.2125569&schedule_date=2022-05-15&s_address=215%2C%20Skyview%20Business%20Horizon%2C%20nr.%20Syamdham%20Scoiety%2C%20Surat%2C%20Gujarat%20395006%2C%20India&s_longitude=72.9115312&minute=10&geo_fencing_id=55&d_longitude=72.88947259999999&service_type=1&schedule_time=16%3A22&s_latitude=21.2392538&multi_destination=%5B%7B%22d_address%22%3A%22Yogi%20Chowk%2C%20Sanman%20Society%2C%20Vrundavan%20Society%2C%20Yoginagar%20Society%2C%20Surat%2C%20Gujarat%2C%20India%22%2C%22d_latitude%22%3A21.2125569%2C%22d_longitude%22%3A72.88947259999999%2C%22final_destination%22%3A1%7D%5D&d_address=Yogi%20Chowk%2C%20Sanman%20Society%2C%20Vrundavan%20Society%2C%20Yoginagar%20Society%2C%20Surat%2C%20Gujarat%2C%20India"));
    try {
      showLoader();
      Map<String, dynamic> params = Map();

      selectedPromoCode = null;
      params["payment_mode"] = "CASH";
      paymentModeMap.forEach((key, value) {
        params["$key"] = "$value";
      });
      // params.addAll(paymentModeMap);
      // params["distance"] = "4.9";
      if (servicesModel != null) {
        params["service_type"] = servicesModel.id.toString();
      }

      if (latLngFrom != null) {
        params["s_longitude"] = latLngFrom?.longitude.toString();
        params["s_latitude"] = latLngFrom?.latitude.toString();
        params["s_address"] = locationFromTo.text;
      }
      // if (latLngWhereTo1 != null) {
      //   params["d_longitude"] = latLngWhereTo1?.longitude.toString();
      //   params["d_latitude"] = latLngWhereTo1?.latitude.toString();
      //   params["d_address"] = locationWhereTo1.text;
      // }
      List<Map<String, String>> multiDestinationList = [];
      if (latLngWhereTo1 != null) {
        multiDestinationList.add({
          "d_address": locationWhereTo1.text,
          "d_latitude": "${latLngWhereTo1?.latitude}",
          "d_longitude": "${latLngWhereTo1?.longitude}",
          "final_destination":
              "${multipleLocationAdModelList.isEmpty && !isRoundTrip.value ? "1" : "0"}"
        });
      }
      for (int i = 0; i < multipleLocationAdModelList.length; i++) {
        MultipleLocationAddModel multipleLocationAddModel =
            multipleLocationAdModelList[i];
        Map<String, String> multiDestPar = Map();
        multiDestPar["d_address"] =
            multipleLocationAddModel.textEditingController?.text ?? "";
        multiDestPar["d_latitude"] =
            "${multipleLocationAddModel.latLng?.latitude}";
        multiDestPar["d_longitude"] =
            "${multipleLocationAddModel.latLng?.longitude}";
        multiDestPar["final_destination"] =
            "${(i == (multipleLocationAdModelList.length - 1) && !isRoundTrip.value) ? "1" : "0"}";
        log("message ==>  ApiUrl.fare   ${(i == (multipleLocationAdModelList.length - 1) && !isRoundTrip.value) ? "1" : "0"}       ${(i == (multipleLocationAdModelList.length - 1) && !isRoundTrip.value)}");
        multiDestinationList.add(multiDestPar);
      }
      if (multiDestinationList.isNotEmpty) {
        params.addAll(multiDestinationList.last);
      }
      if (isRoundTrip.value) {
        Map<String, String> multiDestPar = Map();
        multiDestPar["d_address"] = locationFromTo.text;
        multiDestPar["d_latitude"] = "${latLngFrom?.latitude}";
        multiDestPar["d_longitude"] = "${latLngFrom?.longitude}";
        multiDestPar["final_destination"] = "1";
        multiDestinationList.add(multiDestPar);
      }
      params["multi_destination"] = jsonEncode(multiDestinationList);
      String queryString = Uri(queryParameters: params).query;
      log("message ==>  ApiUrl.fare   ${isRoundTrip.value}  ${jsonEncode(params)}    $queryString   ${Uri.decodeFull(queryString)}");
      await apiService.postRequest(
        url: "${ApiUrl.fare}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          isWalletSelected.value = false;
          fareResponseModel.value =
              fareResponseModelFromJson(jsonEncode(data["response"]));
          fareResponseModel.refresh();
        },
        onError: (ErrorType errorType, String msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> sendRequest({Map<String, String> params = const {}}) async {
    try {
      showLoader();
      // Map<String, dynamic> params = Map();
      print("params===> ${params}");
      if (params.isEmpty) {
        params = Map();
      }

      params["fare"] = "${fareResponseModel.value.estimatedFare ?? "0"}";
      params["payment_mode"] = "CASH";
      params["selected_payment"] = radioItem == "Cash" ? "cash" : "online";
      print("radioItem===>${params["selected_payment"]}");
      paymentModeMap.forEach((key, value) {
        params["$key"] = "$value";
      });
      params["distance"] = "${fareResponseModel.value.distance ?? "0"}";
      params["minute"] = "${fareResponseModel.value.minute ?? "0"}";
      params["promocode_id"] = "0";
      if (selectedPromoCode != null) {
        params["promocode_id"] = "${selectedPromoCode?.id}";
      }
      params["geo_fencing_id"] = "${fareResponseModel.value.geoFencingId}";
      params["service_type"] = "${fareResponseModel.value.serviceType}";
      params["use_wallet"] = "0";
      if (isWalletSelected.value) {
        params["use_wallet"] = "1";
      }

      if (latLngFrom != null) {
        params["s_longitude"] = "${latLngFrom?.longitude}";
        params["s_latitude"] = "${latLngFrom?.latitude}";
        params["s_address"] = locationFromTo.text;
      }
      List<Map<String, String>> multiDestinationList = [];
      if (latLngWhereTo1 != null) {
        multiDestinationList.add({
          "d_address": locationWhereTo1.text,
          "d_latitude": "${latLngWhereTo1?.latitude}",
          "d_longitude": "${latLngWhereTo1?.longitude}",
          "final_destination":
              "${multipleLocationAdModelList.isEmpty && !isRoundTrip.value ? "1" : "0"}"
        });
      }
      for (int i = 0; i < multipleLocationAdModelList.length; i++) {
        MultipleLocationAddModel multipleLocationAddModel =
            multipleLocationAdModelList[i];
        Map<String, String> multiDestPar = Map();
        multiDestPar["d_address"] =
            multipleLocationAddModel.textEditingController?.text ?? "";
        multiDestPar["d_latitude"] =
            "${multipleLocationAddModel.latLng?.latitude}";
        multiDestPar["d_longitude"] =
            "${multipleLocationAddModel.latLng?.longitude}";
        multiDestPar["final_destination"] =
            "${i == (multipleLocationAdModelList.length - 1) && !isRoundTrip.value ? "1" : "0"}";
        multiDestinationList.add(multiDestPar);
      }
      if (multiDestinationList.isNotEmpty) {
        params.addAll(multiDestinationList.last);
      }
      if (isRoundTrip.value) {
        Map<String, String> multiDestPar = Map();
        multiDestPar["d_address"] = locationFromTo.text;
        multiDestPar["d_latitude"] = "${latLngFrom?.latitude}";
        multiDestPar["d_longitude"] = "${latLngFrom?.longitude}";
        multiDestPar["final_destination"] = "1";
        multiDestinationList.add(multiDestPar);
      }
      // params.addAll(multiDestinationList.last);
      params["multi_destination"] = jsonEncode(multiDestinationList);
      String queryString = Uri(queryParameters: params).query;
      await apiService.postRequest(
        // url: "${ApiUrl.request}?${queryString}",
        url: "${ApiUrl.request}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          checkRequest();
          // Future.delayed(Duration(seconds: 2),() async {
          //   if(selectedRadioIndex.value == 0){
          //     print("enter conditiopn====>${selectedRadioIndex.value}");
          //     paymentModeRequest("cash");
          //   } else{
          //     print("enter conditiopn====>${selectedRadioIndex.value}");
          //     paymentModeRequest("online");
          //   }
          // });

        },
        onError: (ErrorType errorType, String msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    bookSomeNumber.value = '';
  }

  // Future<void> paymentModeRequestForInvoice() async {
  //   try {
  //     showLoader();
  //      Map<String, dynamic> params = Map();
  //     params["request_id"] = "${checkRequestResponseModel.value.data.first.id ?? "0"}";
  //     // params["selected_payment"] = "cash";
  //     print("printParamPayment====>${jsonEncode(params)}");
  //     await apiService.postRequest(
  //       // url: "${ApiUrl.request}?${queryString}",
  //       url: "${ApiUrl.paymentMode}",
  //       params: params,
  //       onSuccess: (Map<String, dynamic> data) {
  //         dismissLoader();
  //         print("jsonEncode===>${jsonEncode(data["response"])}");
  //         paymentModeModel.value = paymentModeModelFromJson(jsonEncode(data["response"]));
  //         print("paymentModeModel.value====>${paymentModeModel.value.selectedPayment}");
  //         selectedPaymentMode.value = paymentModeModel.value.selectedPayment!;
  //         print("selectedPaymentMode.value====>${selectedPaymentMode.value}");
  //       },
  //       onError: (ErrorType errorType, String msg) {
  //         showError(msg: msg);
  //       },
  //     );
  //   } catch (e) {
  //     showError(msg: e.toString());
  //   }
  //   bookSomeNumber.value = '';
  // }

  Future<void> paymentModeChangeRequest(selectedPayment) async {
    try {
      showLoader();
       Map<String, dynamic> params = Map();

      params["request_id"] = "${checkRequestResponseModel.value.data.first.payment!.requestId ?? "0"}";
      params["selected_payment"] = selectedPayment;

      await apiService.postRequest(
        // url: "${ApiUrl.request}?${queryString}",
        url: "${ApiUrl.paymentMode}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          paymentModeModel.value = paymentModeModelFromJson(jsonEncode(data["response"]));
          print("paymentModeModel.value====>${paymentModeModel.value.selectedPayment}");
        },
        onError: (ErrorType errorType, String msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    bookSomeNumber.value = '';
  }

  Future<void> checkRequest() async {
    try {
      await apiService.getRequest(
        url: ApiUrl.requestCheck,
        onSuccess: (Map<String, dynamic> data) {
          try {
            checkRequestResponseModel.value =
                checkRequestResponseModelFromJson(jsonEncode(data["response"]));

          } catch (e) {
            log("message  ===========>  45555   ERROR ==>  $e");
          }
          // checkRequestResponseModel.refresh();

          // Get.bottomSheet(FindingDriverDialog());
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<String?> cancelRequest({Reason? reason, String? cancelId}) async {
    String? msg = null;
    try {
      Map<String, dynamic> params = Map();
      if (checkRequestResponseModel.value.data.isEmpty && cancelId == null) {
        showError(msg: "Something went wrong...");
        return msg;
      }
      params["request_id"] =
          cancelId ?? checkRequestResponseModel.value.data[0].id.toString();

      showLoader();
      await apiService.postRequest(
        url: ApiUrl.requestCancel,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          print("cancelRequest  ==>  ${jsonEncode(data)}");
          msg = data["response"]["message"];
          dismissLoader();
          clearData();
          checkRequest();
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> providerRate(
      {required String rating, required String comment}) async {
    String? msg = null;
    try {
      Map<String, dynamic> params = Map();
      removeUnFocusManager();
      if (checkRequestResponseModel.value.data.isEmpty) {
        showError(msg: "Something went wrong...");
        return msg;
      }
      showLoader();

      params["request_id"] =
          checkRequestResponseModel.value.data[0].id.toString();
      params["rating"] = rating;
      params["comment"] = comment;
      print("ssssss  ==>  ${jsonEncode(params)}");
      await apiService.postRequest(
        url: ApiUrl.providerRate,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          print("providerRate  ==>  ${jsonEncode(data)}");
          msg = data["response"]["message"];
          dismissLoader();

          clearData();
          userUiSelectionType.value = UserUiSelectionType.locationSelection;
          Get.back();

          await FirebaseDatabase.instance
              .ref("${params["request_id"]}")
              .remove();
          // checkRequest();
          showSnack(msg: 'Rated driver successfully');
          // Timer(Duration(milliseconds: 500), () {
          //   showSnack(msg: 'Rated driver successfully');
          // });
        },
        onError: (ErrorType? errorType, String? msg) {
          print("sdjksjdksjd===> $msg");
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> etoFeedback({required String comment}) async {
    String? msg = null;
    try {
      Map<String, dynamic> params = Map();
      removeUnFocusManager();

      print(
          "provider_id==> ${checkRequestResponseModel.value.data[0].providerId}");
      print("provider_id==> ${checkRequestResponseModel.value.data[0].userId}");
      showLoader();
      params["request_id"] =
          checkRequestResponseModel.value.data[0].id.toString();
      params["provider_id"] =
          checkRequestResponseModel.value.data[0].providerId.toString();
      params["user_id"] =
          checkRequestResponseModel.value.data[0].userId.toString();
      params["user_feedback_for_eto"] = comment;

      await apiService.postRequest(
        url: ApiUrl.etoRate,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          print("providerRate  ==>  ${jsonEncode(data)}");
          msg = data["response"]["message"];
          dismissLoader();

          clearData();
          userUiSelectionType.value = UserUiSelectionType.locationSelection;
          Get.back();
          await FirebaseDatabase.instance
              .ref("${params["request_id"]}")
              .remove();
          // checkRequest();
        },
        onError: (ErrorType? errorType, String? msg) {
          print("errrrorr===> $msg");
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<void> showMarker(
      {required LatLng latLng, required LatLng oldLatLng}) async {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 18.0,
    );

    Uint8List? markerIcon = await getBytesFromAsset(AppImage.truckImage, 100);

    int startTime = DateTime.now().millisecondsSinceEpoch;
    LatLng startLatLng = LatLng(0, 0);
    double startRotation = 0;
    if (googleMarkers.isNotEmpty) {
      startLatLng = googleMarkers[_markerId]?.position ?? LatLng(0, 0);
      startRotation = googleMarkers[_markerId]?.rotation ?? 0;
    }
    int duration = 100;

    Timer.periodic(Duration(milliseconds: 16), (timer) {
      int elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
      double t = (elapsed.toDouble() / duration);

      double lng = t * oldLatLng.longitude + (1 - t) * startLatLng.longitude;
      double lat = t * oldLatLng.latitude + (1 - t) * startLatLng.latitude;

      double rotation = (t * _bearingBetweenLocations(oldLatLng, latLng) +
          (1 - t) * startRotation);

      if (markerIcon != null) {
        Marker marker = Marker(
          markerId: _markerId,
          anchor: Offset(0.5, 0.5),
          rotation: 0,
          // anchor: Offset(0.5, 0.5),
          // rotation: rotation,
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        );
        googleMarkers[_markerId] = marker;
      }
      if (t > 1.0) {
        timer.cancel();
      }
    });

    /*googleMarkers.clear();
    if (markerIcon != null) {
      googleMarkers.add(RippleMarker(
          markerId: _markerId,
          rotation: _bearingBetweenLocations(oldLatLng, latLng),
          position: latLng,
          ripple: true,
          icon: BitmapDescriptor.fromBytes(markerIcon)));
      // markers[_markerId] = RippleMarker(
      //     markerId: _markerId,
      //     // rotation: _bearingBetweenLocations(oldLatLng, latLng),
      //     position: latLng,
      //     ripple: true,
      //     icon: BitmapDescriptor.fromBytes(markerIcon));
      // googleMapController
      //     ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }*/
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  double _bearingBetweenLocations(LatLng latLng1, LatLng latLng2) {
    double PI = 3.14159;
    double lat1 = latLng1.latitude * PI / 180;
    double long1 = latLng1.longitude * PI / 180;
    double lat2 = latLng2.latitude * PI / 180;
    double long2 = latLng2.longitude * PI / 180;

    double dLon = (long2 - long1);

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double brng = math.atan2(y, x);

    brng = vectorMath.degrees(brng);
    brng = (brng + 360) % 360;
    print("checkBRNG===>${brng}");
    return brng;
  }

  Future<void> getPastTripData() async {
    try {
      showLoader();
      await apiService.getRequest(
        url: ApiUrl.trips,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<TripDataModel> tripList =
              tripDataModelFromJson(jsonEncode(data["response"]));
          pastTripDataList.clear();
          pastTripDataList.addAll(tripList);
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> getUpcomingTripData() async {
    try {
      showLoader();
      await apiService.getRequest(
        url: ApiUrl.upcomingTrips,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<TripDataModel> tripList =
              tripDataModelFromJson(jsonEncode(data["response"]));
          upcomingTripDataList.clear();
          upcomingTripDataList.addAll(tripList);
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> updateRequest() async {
    try {
      if (checkRequestResponseModel.value.data.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      showLoader();
      Map<String, dynamic> params = Map();
      params["request_id"] =
          checkRequestResponseModel.value.data[0].id.toString();
      await apiService.postRequest(
        url: ApiUrl.updateRequest,
        params: params,
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          // List<TripDataModel> tripList =
          // tripDataModelFromJson(jsonEncode(data["response"]));
          // upcomingTripDataList.clear();
          // upcomingTripDataList.addAll(tripList);
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> getTripDetails({int? id}) async {
    try {
      showLoader();
      Map<String, String> params = Map();
      params["request_id"] = "$id";
      String queryParams = Uri(queryParameters: params).query;
      await apiService.getRequest(
        url: "${ApiUrl.tripDetails}?$queryParams",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<TripDataModel> tripList =
              tripDataModelFromJson(jsonEncode(data["response"]));
          if (tripList.isNotEmpty) {
            tripDetails.value = tripList[0];
          }
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> getUpcomingTripDetails({int? id}) async {
    try {
      showLoader();
      Map<String, String> params = Map();
      params["request_id"] = "$id";
      String queryParams = Uri(queryParameters: params).query;
      await apiService.getRequest(
        url: "${ApiUrl.upcomingTripDetails}?$queryParams",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<TripDataModel> tripList =
              tripDataModelFromJson(jsonEncode(data["response"]));
          if (tripList.isNotEmpty) {
            upcomingTripDetails.value = tripList[0];
          }
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> getReasonList() async {
    try {
      showLoader();
      await apiService.getRequest(
        url: "${ApiUrl.reasons}",
        onSuccess: (Map<String, dynamic> data) {
          dismissLoader();
          List<Reason> tempReasonList = List<Reason>.from(
              data["response"].map((x) => Reason.fromJson(x)));
          reasonList.clear();
          reasonList.addAll(tempReasonList);
        },
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> sendChat({required String id, required String msg}) async {
    try {
      Map<String, String> params = {};
      params["user_id"] = id;
      params["message"] = msg;
      await apiService.postRequest(
        url: "${ApiUrl.chat}",
        params: params,
        onSuccess: (Map<String, dynamic> data) {},
        onError: (ErrorType? errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      showError(msg: e.toString());
    }
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError(msg: "Could not launch $phoneNumber");
    }
  }



  void _getDirectionDetails(
      {required LatLng sourceLatLng, required LatLng destinationLatLng}) {
    final directinoService = direction.DirectionsService();

    List<PolylineWayPoint> polyLineList = [];
    PolylineWayPoint polylineWayPoint =
    PolylineWayPoint(location: "23.0225,72.5714", stopOver: false);
    // polyLineList.add(polylineWayPoint);

    final request = direction.DirectionsRequest(
      origin: '${sourceLatLng.latitude},${sourceLatLng.longitude}',
      destination:
      '${destinationLatLng.latitude},${destinationLatLng.longitude}',
      travelMode: direction.TravelMode.driving,
    );

    directinoService.route(request, (direction.DirectionsResult response,
        direction.DirectionsStatus? status) {
      // log("message   ==>  ${response.status}   ${response.availableTravelModes?.length} ${response.geocodedWaypoints?.length} ${response.routes?.length}");
      // if (response.availableTravelModes != null) {
      //   response.availableTravelModes?.forEach((direction.TravelMode element) {
      //     log("message  ==>  TravelMode  ${element.toString()}");
      //   });
      // }
      //
      // if (response.geocodedWaypoints != null) {
      //   response.geocodedWaypoints
      //       ?.forEach((direction.GeocodedWaypoint element) {
      //     log("message  ==>  GeocodedWaypoint  ${element.toString()}");
      //   });
      // }
      //
      // if (response.routes != null) {
      //   response.routes?.forEach((direction.DirectionsRoute element) {
      //     log("message  ==>  DirectionsRoute  ${element.toString()}     ${element.legs?.length}");
      //     if (element.legs != null) {
      //       element.legs?.forEach((element) {
      //         log("message  ==>  element.legs  ${element.distance?.text} ${element.distance?.value}  \n time ${element.arrivalTime} ${element.departureTime}  \n time1233 ${element.duration?.text}  ${element.duration?.value}   \n  ${element.durationInTraffic?.text}  ${element.durationInTraffic?.value}  \n  ${element.endAddress} \n  ${element.endLocation}  \n  ${element.startAddress}  ${element.startLocation}  \n  ${element.steps?.length}   \n\n");
      //         element.steps?.forEach((element) {
      //           log("message  ==>  element.steps  ${element.steps?.length}  ${element.startLocation}  ${element.endLocation}  ${element.duration?.text}  ${element.duration?.value}  ${element.distance?.text}  ${element.distance?.value} poly -=> ${element.polyline?.points}");
      //         });
      //       });
      //     }
      //   });
      // }

      if (status == direction.DirectionsStatus.ok) {
        // do something with successful response
        if (response.routes != null) {
          response.routes?.forEach((direction.DirectionsRoute element) {
            log("message  ==>  DirectionsRoute  ${element.toString()}     ${element.legs?.length}");
            if (element.legs != null) {
              element.legs?.forEach((element) {
                providerDurationTime.value = element.duration?.text ?? "";
                providerDurationSecond.value =
                    (element.duration?.value ?? 0).toInt();
                log("message  ==>  element.legs  ${element.distance?.text} ${element.distance?.value}  \n time ${element.arrivalTime} ${element.departureTime}  \n time1233 ${element.duration?.text}  ${element.duration?.value}   \n  ${element.durationInTraffic?.text}  ${element.durationInTraffic?.value}  \n  ${element.endAddress} \n  ${element.endLocation}  \n  ${element.startAddress}  ${element.startLocation}  \n  ${element.steps?.length}   \n\n");
                // element.steps?.forEach((element) {
                //   log("message  ==>  element.steps  ${element.steps?.length}  ${element.startLocation}  ${element.endLocation}  ${element.duration?.text}  ${element.duration?.value}  ${element.distance?.text}  ${element.distance?.value} poly -=> ${element.polyline?.points}");
                // });
              });
            }
          });
        }
      } else {
        // do something with error response

      }
    });
  }

  void shareUrl() {
    if (checkRequestResponseModel.value.data.isNotEmpty) {
      Datum datum = checkRequestResponseModel.value.data[0];
      String data =
          "Rekoverme : ${datum.user?.firstName ?? ""} ${datum.user?.lastName ?? ""} is riding in ${datum.serviceType?.name ?? ""} would like to share his ride Rekoverme.com/track/${datum.id ?? "0"}";

      FlutterShare.share(title: "Mozlit Driver Share Ride", text: data);
    }
  }

  Future<void> selectedLocationDrawRoute() async {
    setData();
    await getServices();

    if (latLngFrom != null && latLngWhereTo1 != null) {
      List<LatLng> latLngList = [];
      latLngList
          .add(LatLng(latLngWhereTo1!.latitude, latLngWhereTo1!.longitude));
      if (multipleLocationAdModelList.isNotEmpty) {
        for (int i = 0; i < multipleLocationAdModelList.length; i++) {
          if (multipleLocationAdModelList[i].latLng != null) {
            latLngList.add(multipleLocationAdModelList[i].latLng!);
          }
        }
      }
      if (isRoundTrip.value) {
        latLngList
            .add(LatLng(latLngFrom?.latitude ?? 0, latLngFrom?.longitude ?? 0));
      }
      providerDrawPolyLine(
          s_lat: latLngFrom?.latitude,
          s_lng: latLngFrom?.longitude,
          d_lat: latLngList.last.latitude,
          d_lng: latLngList.last.longitude,
          latLngList: latLngList);
    }

    if (serviceModelList.isNotEmpty) {
      await getFairServiceDetailsApiCall(servicesModel: serviceModelList[0]);
      userUiSelectionType.value = UserUiSelectionType.serviceType;
      userUiSelectionType.refresh();
    }
  }

  Future<void> getDisputeList() async {
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["dispute_type"] = "user";

      await apiService.postRequest(
        url: ApiUrl.disputeList,
        params: params,
        onSuccess: (Map<String, dynamic> data) async {
          dismissLoader();

          List<DisputeModel> tempDisputeList =
              disputeModelFromJson(jsonEncode(data["response"]));
          disputeList.clear();
          disputeList.addAll(tempDisputeList);
        },
        onError: (ErrorType errorType, String? msg) {
          showError(msg: msg);
        },
      );
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
  }

  Future<String?> sendDispute({required DisputeModel disputeModel}) async {
    String? msg;
    try {
      showLoader();
      Map<String, dynamic> params = {};
      params["dispute_type"] = "user";
      TripDataModel tripDataModel = tripDetails.value;

      params["dispute_name"] = disputeModel.disputeName ?? "";
      params["comments"] = "";
      params["user_id"] = "${tripDataModel.userId ?? "0"}";
      params["provider_id"] = "${tripDataModel.providerId ?? "0"}";
      params["request_id"] = "${tripDataModel.id ?? "0"}";

      await apiService.postRequest(
          url: ApiUrl.dispute,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            msg = data["response"]["message"];
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
      // showError(msg: e.toString());
    }
    return msg;
  }

  Future<String?> sendDropItem({required String lostItem}) async {
    String? msg;
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};
      UserController userController = UserController();
      TripDataModel tripDataModel = tripDetails.value;

      params["lost_item_name"] = lostItem;
      params["user_id"] = "${tripDataModel.userId ?? "0"}";
      params["request_id"] = "${tripDataModel.id ?? "0"}";

      await apiService.postRequest(
          url: ApiUrl.dropItem,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            msg = data["response"]["message"];
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
    return msg;
  }

  Future<void> updateAddress(
      {required Map<String, dynamic> addressData}) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};

      if (checkRequestResponseModel.value.data.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      params["request_id"] =
          checkRequestResponseModel.value.data[0].id.toString();
      params.addAll(addressData);

      await apiService.postRequest(
          url: ApiUrl.extendTrip,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            // msg = data["response"]["message"];
            providerDrawPolyLine(
              s_lat: _currentRideSourceLatLng?.latitude,
              s_lng: _currentRideSourceLatLng?.longitude,
              d_lat: double.tryParse(addressData["latitude"].toString()),
              d_lng: double.tryParse(addressData["longitude"].toString()),
            );
            currentRideAddress.value = addressData["address"];
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }

  Future<void> payment({required Map<String, dynamic> paymentData}) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};

      if (checkRequestResponseModel.value.data.isEmpty) {
        showError(msg: "Something went wrong...");
        return;
      }
      params["request_id"] =
          checkRequestResponseModel.value.data[0].id.toString();
      params.addAll(paymentData);

      await apiService.postRequest(
          url: ApiUrl.payment,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            Get.back();
          },
          onError: (ErrorType errorType, String? msg) {
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }

  showSavedContact() async {
    try {
      removeUnFocusManager();
      // showLoader();
      Map<String, dynamic> params = {};

      // if (checkRequestResponseModel.value.data.isEmpty) {
      //   showError(msg: "Something went wrong...");
      //   return;
      // }

      params["user_id"] = "${_userController.userData.value.id ?? "0"}";

      await apiService.postRequest(
          url: ApiUrl.showContact,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            savedContactList.clear();
            ShowSavedContactModel showSavedContactModels =
                showSavedContactModelFromJson(jsonEncode(data["response"]));
            if (showSavedContactModels.data != null) {
              savedContactList.addAll(showSavedContactModels.data!);
            }
          },
          onError: (ErrorType errorType, String? msg) {
            print("errror");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }

  Future<void> addSaveContactList(name, number) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};

      // if (checkRequestResponseModel.value.data.isEmpty) {
      //   showError(msg: "Something went wrong...");
      //   return;
      // }

      params["user_id"] = "${_userController.userData.value.id ?? "0"}";
      params["name"] = "${name ?? ""}";
      params["mobile"] = "${number ?? ""}";

      await apiService.postRequest(
          url: ApiUrl.addSaveContactList,
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            print("objectddddd"); // showContactListModel.value =
            //     showSavedContactModelFromJson(jsonEncode('data'));
            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.green,
              message: "Contact Saved Successfully!",
              title: "Saved Contact",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            ));
            contactPickup.value = false;
          },
          onError: (ErrorType errorType, String? msg) {
            print("msgmsg===> $msg");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }

  Future<void> editSaveContactList(name, number, contactId) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};

      // if (checkRequestResponseModel.value.data.isEmpty) {
      //   showError(msg: "Something went wrong...");
      //   return;
      // }

      params["user_id"] = "${_userController.userData.value.id ?? "0"}";
      params["name"] = "${name ?? ""}";
      params["mobile"] = "${number ?? ""}";
      params["contact_id"] = "${contactId ?? ""}";

      print("user_id===>${_userController.userData.value.id}");
      print("name===>${name}");
      print("mobile===>${number}");
      print("contact_id===>${contactId}");
      await apiService.postRequest(
          url: "${ApiUrl.editSaveContactList}/${contactId}",
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            print("objectddddd"); // showContactListModel.value =
            //     showSavedContactModelFromJson(jsonEncode('data'));
            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.green,
              message: "Contact Edit Successfully!",
              title: "Edit Contact",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            ));
            // contactPickup.value = false;
          },
          onError: (ErrorType errorType, String? msg) {
            print("msgmsg===> $msg");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }

  Future<void> deleteSaveContactList(contactId) async {
    try {
      removeUnFocusManager();
      showLoader();
      Map<String, dynamic> params = {};

      // if (checkRequestResponseModel.value.data.isEmpty) {
      //   showError(msg: "Something went wrong...");
      //   return;
      // }
      //
      // params["user_id"] = "${_userController.userData.value.id ?? "0"}";
      print("contactId====> $contactId");
      // params["contact_id"] = "${contactId ?? ""}";

      await apiService.postRequest(
          url: "${ApiUrl.deleteSaveContactList}/$contactId",
          params: params,
          onSuccess: (Map<String, dynamic> data) async {
            dismissLoader();
            print("objectddddd"); // showContactListModel.value =
            //     showSavedContactModelFromJson(jsonEncode('data'));
            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.green,
              message: "Contact Delete Successfully!",
              title: "Delete Contact",
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            ));
            // contactPickup.value = false;
          },
          onError: (ErrorType errorType, String? msg) {
            print("msgmsg===> $msg");
            showError(msg: msg);
          });
    } catch (e) {
      log("message   ==>  ${e}");
      showError(msg: e.toString());
    }
  }
}
