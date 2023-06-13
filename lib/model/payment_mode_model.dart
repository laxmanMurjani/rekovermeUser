// To parse this JSON data, do
//
//     final paymentModeModel = paymentModeModelFromJson(jsonString);

import 'dart:convert';

PaymentModeModel paymentModeModelFromJson(String str) => PaymentModeModel.fromJson(json.decode(str));

String paymentModeModelToJson(PaymentModeModel data) => json.encode(data.toJson());

class PaymentModeModel {
  PaymentModeModel({
    this.id,
    this.bookingId,
    this.providerId,
    this.selectedPayment,
  });

  int? id;
  String? bookingId;
  int? providerId;
  String? selectedPayment;

  factory PaymentModeModel.fromJson(Map<String, dynamic> json) => PaymentModeModel(
    id: json["id"],
    bookingId: json["booking_id"],
    providerId: json["provider_id"],
    selectedPayment: json["selected_payment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "provider_id": providerId,
    "selected_payment": selectedPayment,
  };
}
