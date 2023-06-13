// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  UserDetailModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.paymentMode,
      this.userType,
      this.email,
      this.gender,
      this.countryCode,
      this.mobile,
      this.picture,
      this.deviceToken,
      this.deviceId,
      this.deviceType,
      this.loginBy,
      this.socialUniqueId,
      this.latitude,
      this.longitude,
      this.stripeCustId,
      this.walletBalance,
      this.rating,
      this.otp,
      this.language,
      this.qrcodeUrl,
      this.referralUniqueId,
      this.referalCount,
      this.updatedAt,
      this.currency,
      this.sos,
      this.appContact,
      this.measurement,
      this.cash,
      this.card,
      this.payumoney,
      this.paypal,
      this.paypalAdaptive,
      this.braintree,
      this.paytm,
      this.stripeSecretKey,
      this.stripePublishableKey,
      this.stripeCurrency,
      this.payumoneyEnvironment,
      this.payumoneyKey,
      this.payumoneySalt,
      this.payumoneyAuth,
      this.paypalEnvironment,
      this.paypalCurrency,
      this.paypalClientId,
      this.paypalClientSecret,
      this.braintreeEnvironment,
      this.braintreeMerchantId,
      this.braintreePublicKey,
      this.braintreePrivateKey,
      this.referralCount,
      this.referralAmount,
      this.referralText,
      this.referralTotalCount,
      this.referralTotalAmount,
      this.referralTotalText,
      this.rideOtp,
      this.creditPoints});

  int? id;
  int? creditPoints;
  String? firstName;
  String? lastName;
  String? paymentMode;
  String? userType;
  String? email;
  String? gender;
  String? countryCode;
  String? mobile;
  String? picture;
  String? deviceToken;
  String? deviceId;
  String? deviceType;
  String? loginBy;
  dynamic socialUniqueId;
  double? latitude;
  double? longitude;
  String? stripeCustId;
  double? walletBalance;
  String? rating;
  int? otp;
  String? language;
  String? qrcodeUrl;
  String? referralUniqueId;
  int? referalCount;
  DateTime? updatedAt;
  String? currency;
  String? sos;
  String? appContact;
  String? measurement;
  int? cash;
  int? card;
  int? payumoney;
  int? paypal;
  int? paypalAdaptive;
  int? braintree;
  int? paytm;
  String? stripeSecretKey;
  String? stripePublishableKey;
  String? stripeCurrency;
  String? payumoneyEnvironment;
  String? payumoneyKey;
  String? payumoneySalt;
  String? payumoneyAuth;
  String? paypalEnvironment;
  String? paypalCurrency;
  String? paypalClientId;
  String? paypalClientSecret;
  String? braintreeEnvironment;
  String? braintreeMerchantId;
  String? braintreePublicKey;
  String? braintreePrivateKey;
  String? referralCount;
  String? referralAmount;
  String? referralText;
  String? referralTotalCount;
  int? referralTotalAmount;
  String? referralTotalText;
  int? rideOtp;

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        paymentMode: json["payment_mode"],
        userType: json["user_type"],
        email: json["email"],
        gender: json["gender"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
        picture: json["picture"],
        deviceToken: json["device_token"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        loginBy: json["login_by"],
        socialUniqueId: json["social_unique_id"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        stripeCustId: json["stripe_cust_id"],
        walletBalance: json["wallet_balance"] == null
            ? 0
            : json["wallet_balance"].toDouble(),
        rating: json["rating"],
        otp: json["otp"],
        language: json["language"],
        qrcodeUrl: json["qrcode_url"],
        referralUniqueId: json["referral_unique_id"],
        referalCount: json["referal_count"],
        updatedAt: DateTime.parse(json["updated_at"]),
        currency: json["currency"],
        sos: json["sos"],
        appContact: json["app_contact"],
        measurement: json["measurement"],
        cash: json["cash"],
        card: json["card"],
        payumoney: json["payumoney"],
        paypal: json["paypal"],
        paypalAdaptive: json["paypal_adaptive"],
        braintree: json["braintree"],
        paytm: json["paytm"],
        stripeSecretKey: json["stripe_secret_key"],
        stripePublishableKey: json["stripe_publishable_key"],
        stripeCurrency: json["stripe_currency"],
        payumoneyEnvironment: json["payumoney_environment"],
        payumoneyKey: json["payumoney_key"],
        payumoneySalt: json["payumoney_salt"],
        payumoneyAuth: json["payumoney_auth"],
        paypalEnvironment: json["paypal_environment"],
        paypalCurrency: json["paypal_currency"],
        paypalClientId: json["paypal_client_id"],
        paypalClientSecret: json["paypal_client_secret"],
        braintreeEnvironment: json["braintree_environment"],
        braintreeMerchantId: json["braintree_merchant_id"],
        braintreePublicKey: json["braintree_public_key"],
        braintreePrivateKey: json["braintree_private_key"],
        referralCount: json["referral_count"],
        referralAmount: json["referral_amount"],
        referralText: json["referral_text"],
        referralTotalCount: json["referral_total_count"],
        referralTotalAmount: json["referral_total_amount"],
        referralTotalText: json["referral_total_text"],
        rideOtp: json["ride_otp"],
        creditPoints: json["credit_points"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "payment_mode": paymentMode,
        "user_type": userType,
        "email": email,
        "gender": gender,
        "country_code": countryCode,
        "mobile": mobile,
        "picture": picture,
        "device_token": deviceToken,
        "device_id": deviceId,
        "device_type": deviceType,
        "login_by": loginBy,
        "social_unique_id": socialUniqueId,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_cust_id": stripeCustId,
        "wallet_balance": walletBalance,
        "rating": rating,
        "otp": otp,
        "language": language,
        "qrcode_url": qrcodeUrl,
        "referral_unique_id": referralUniqueId,
        "referal_count": referalCount,
        "updated_at": updatedAt?.toIso8601String(),
        "currency": currency,
        "sos": sos,
        "app_contact": appContact,
        "measurement": measurement,
        "cash": cash,
        "card": card,
        "payumoney": payumoney,
        "paypal": paypal,
        "paypal_adaptive": paypalAdaptive,
        "braintree": braintree,
        "paytm": paytm,
        "stripe_secret_key": stripeSecretKey,
        "stripe_publishable_key": stripePublishableKey,
        "stripe_currency": stripeCurrency,
        "payumoney_environment": payumoneyEnvironment,
        "payumoney_key": payumoneyKey,
        "payumoney_salt": payumoneySalt,
        "payumoney_auth": payumoneyAuth,
        "paypal_environment": paypalEnvironment,
        "paypal_currency": paypalCurrency,
        "paypal_client_id": paypalClientId,
        "paypal_client_secret": paypalClientSecret,
        "braintree_environment": braintreeEnvironment,
        "braintree_merchant_id": braintreeMerchantId,
        "braintree_public_key": braintreePublicKey,
        "braintree_private_key": braintreePrivateKey,
        "referral_count": referralCount,
        "referral_amount": referralAmount,
        "referral_text": referralText,
        "referral_total_count": referralTotalCount,
        "referral_total_amount": referralTotalAmount,
        "referral_total_text": referralTotalText,
        "ride_otp": rideOtp,
        "credit_points": creditPoints,
      };
}
