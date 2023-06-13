// To parse this JSON data, do
//
//     final getNearestDriverTimeModel = getNearestDriverTimeModelFromJson(jsonString);

import 'dart:convert';

GetNearestDriverTimeModel? getNearestDriverTimeModelFromJson(String str) =>
    GetNearestDriverTimeModel.fromJson(json.decode(str));

String getNearestDriverTimeModelToJson(GetNearestDriverTimeModel? data) =>
    json.encode(data!.toJson());

class GetNearestDriverTimeModel {
  GetNearestDriverTimeModel({
    this.distance,
    this.time,
    this.serviceType,
  });

  double? distance;

  String? time;
  int? serviceType;

  factory GetNearestDriverTimeModel.fromJson(Map<String, dynamic> json) =>
      GetNearestDriverTimeModel(
        distance: json["distance"].toDouble(),
        time: json["time"],
        serviceType: json["service_type"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "time": time,
        "service_type": serviceType,
      };
}
