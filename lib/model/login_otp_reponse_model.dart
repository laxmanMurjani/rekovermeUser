// To parse this JSON data, do
//
//     final loginOtpResponseModel = loginOtpResponseModelFromJson(jsonString);

import 'dart:convert';

LoginOtpResponseModel loginOtpResponseModelFromJson(String str) => LoginOtpResponseModel.fromJson(json.decode(str));

String loginOtpResponseModelToJson(LoginOtpResponseModel data) => json.encode(data.toJson());

class LoginOtpResponseModel {
    LoginOtpResponseModel({
        this.tokenType,
        this.success,
    });

    String? tokenType;
    Success? success;

    factory LoginOtpResponseModel.fromJson(Map<String, dynamic> json) => LoginOtpResponseModel(
        tokenType: json["token_type"],
        success: Success.fromJson(json["success"]),
    );

    Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "success": success!.toJson(),
    };
}

class Success {
    Success({
        this.token,
    });

    String? token;

    factory Success.fromJson(Map<String, dynamic> json) => Success(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
