import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:arbyuser/api/logging_dio_interceptor.dart';
import 'package:arbyuser/controller/user_controller.dart';
import 'package:arbyuser/enum/error_type.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiService {
  static final Dio _dio = Dio();

  UserController _userController = Get.find();

  ApiService() {
    _dio.interceptors.add(LoggingDioInterceptor());
  }

  Future<void> postRequest({
    required String url,
    dynamic params,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String) onError,
  }) async {
    try {
      print('Method => POST , API URL ==> $url');
      print('Params ==> $params');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };

      _dio.options.headers.addAll(headers);
      var response = await _dio.post(url, data: params);
      log("response  ===>  $response");
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
        // onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error  ===>  $e  ${e.response}  ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, e.message);
      }
      if (e.response != null) {
        print('Error  ===>  ${e.response?.data}  ${e.type}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data['error']);
      }
    }
    return;
  }

  Future<void> getRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => GET , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.get(url);
      log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }
    return;
  }

  Future<void> deleteRequest({
    required String url,
    Map<String, dynamic>? header,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => DELETE , API URL ==> $url');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      if (header != null) {
        _dio.options.headers.addAll(header);
      } else {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.delete(url);
      log('response  ===>  $response');
      if (response.statusCode != 200) {
        onError(ErrorType.none, response.data['message']);
      } else {
        if (response.data is HashMap) {
          if (response.data["status"] != null) {
            if (response.data["status"] == false) {
              onError(ErrorType.none, response.data['message']);
              return;
            }
          }
        }
        Map<String, dynamic> data = Map();
        data["response"] = response.data;
        onSuccess(data);
      }
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none,
            e.response?.data['message'] ?? e.response?.data["error"]);
      }
    }
    return;
  }

  Future<void> putRequest({
    required String url,
    dynamic params,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(ErrorType, String?) onError,
  }) async {
    try {
      print('Method => PUT , API URL ==> $url');
      print('Params ==> $params');
      var headers = {
        'Content-Type': 'application/json',
        "Authorization": "Token ${_userController.userToken.value.accessToken}",
        "X-Requested-With": "XMLHttpRequest"
      };
      _dio.options.headers.addAll(headers);
      var response = await _dio.put(url, data: params);
      log("response   ===>   $response");
      onSuccess(json.decode(response.toString()));
    } on DioError catch (e) {
      print('Error 12 ===>  $e    ${e.type}');
      if (e.type == DioErrorType.other) {
        onError(ErrorType.internet, null);
      }
      if (e.response != null) {
        print('Error12  ===>  ${e.response?.data}');
        onError(ErrorType.none, e.response?.data['message']);
      }
    }
    return;
  }
}

ApiService apiService = ApiService();
