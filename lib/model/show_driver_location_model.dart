// To parse this JSON data, do
//
//     final showDriversLocationModel = showDriversLocationModelFromJson(jsonString);

import 'dart:convert';

List<ShowDriversLocationModel> showDriversLocationModelFromJson(String str) =>
    List<ShowDriversLocationModel>.from(
        json.decode(str).map((x) => ShowDriversLocationModel.fromJson(x)));

String showDriversLocationModelToJson(List<ShowDriversLocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowDriversLocationModel {
  ShowDriversLocationModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailOtp,
    this.emailVerify,
    this.gender,
    this.countryCode,
    this.mobile,
    this.avatar,
    this.rating,
    this.status,
    this.fleet,
    this.latitude,
    this.longitude,
    this.stripeAccId,
    this.stripeCustId,
    this.paypalEmail,
    this.loginBy,
    this.socialUniqueId,
    this.otp,
    this.walletBalance,
    this.referralUniqueId,
    this.qrcodeUrl,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  int? emailOtp;
  int? emailVerify;
  String? gender;
  String? countryCode;
  String? mobile;
  String? avatar;
  String? rating;
  String? status;
  int? fleet;
  double? latitude;
  double? longitude;
  dynamic stripeAccId;
  dynamic stripeCustId;
  dynamic paypalEmail;
  String? loginBy;
  dynamic socialUniqueId;
  int? otp;
  double? walletBalance;
  String? referralUniqueId;
  String? qrcodeUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;

  factory ShowDriversLocationModel.fromJson(Map<String, dynamic> json) =>
      ShowDriversLocationModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        emailOtp: json["email_otp"],
        emailVerify: json["email_verify"],
        gender: json["gender"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        avatar: json["avatar"],
        rating: json["rating"],
        status: json["status"],
        fleet: json["fleet"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        stripeAccId: json["stripe_acc_id"],
        stripeCustId: json["stripe_cust_id"],
        paypalEmail: json["paypal_email"],
        loginBy: json["login_by"],
        socialUniqueId: json["social_unique_id"],
        otp: json["otp"],
        walletBalance: json["wallet_balance"].toDouble(),
        referralUniqueId: json["referral_unique_id"],
        qrcodeUrl: json["qrcode_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        service: Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_otp": emailOtp,
        "email_verify": emailVerify,
        "gender": gender,
        "country_code": countryCode,
        "mobile": mobile,
        "avatar": avatar,
        "rating": rating,
        "status": status,
        "fleet": fleet,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_acc_id": stripeAccId,
        "stripe_cust_id": stripeCustId,
        "paypal_email": paypalEmail,
        "login_by": loginBy,
        "social_unique_id": socialUniqueId,
        "otp": otp,
        "wallet_balance": walletBalance,
        "referral_unique_id": referralUniqueId,
        "qrcode_url": qrcodeUrl,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "service": service!.toJson(),
      };
}

class Service {
  Service({
    this.id,
    this.providerId,
    this.serviceTypeId,
    this.status,
    this.serviceNumber,
    this.serviceModel,
  });

  int? id;
  int? providerId;
  int? serviceTypeId;
  String? status;
  String? serviceNumber;
  String? serviceModel;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        providerId: json["provider_id"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
        serviceNumber: json["service_number"],
        serviceModel: json["service_model"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "service_type_id": serviceTypeId,
        "status": status,
        "service_number": serviceNumber,
        "service_model": serviceModel,
      };
}
