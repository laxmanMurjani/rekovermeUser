import 'dart:developer';
import 'package:arbyuser/api/api.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/ui/authentication_screen/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import '../model/login_response_model.dart';

class LoggingDioInterceptor implements Interceptor {

  UserController _userController = getX.Get.find();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log("message ==> response  $err ${err.response?.statusCode}    ${err.response?.data}");
    log("message ==> response  ${err.requestOptions.baseUrl}   123 ${err.requestOptions.uri}    ");
    if(err.response?.statusCode == 401 && err.requestOptions.uri.toString() != ApiUrl.login){

      _userController. userToken.value = LoginResponseModel();
      _userController. userToken.refresh();
      getX.Get.offAll(() => LoginScreen());
    }
    handler.next(err);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {

    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    log("message ==> response  $response ${response.statusCode}    ${response.data}");
    if(response.statusCode == 401){
     _userController. userToken.value = LoginResponseModel();
     _userController. userToken.refresh();
     getX.Get.offAll(() => LoginScreen());
    }
    handler.next(response);
  }



}
