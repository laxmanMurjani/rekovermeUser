// To parse this JSON data, do
//
//     final locationResponseModel = locationResponseModelFromJson(jsonString);

import 'dart:convert';

LocationResponseModel locationResponseModelFromJson(String str) => LocationResponseModel.fromJson(json.decode(str));

String locationResponseModelToJson(LocationResponseModel data) => json.encode(data.toJson());

class LocationResponseModel {
  LocationResponseModel({
    this.home = const [],
    this.work = const [],
    this.others = const [],
    this.recent = const [],
  });

  List<Home> home;
  List<Home> work;
  List<Home> others;
  List<Home> recent;

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) => LocationResponseModel(
    home:json["home"] == null?[]: List<Home>.from(json["home"].map((x) => Home.fromJson(x))),
    work: json["work"] == null?[]:List<Home>.from(json["work"].map((x) => Home.fromJson(x))),
    others:json["others"] == null?[]: List<Home>.from(json["others"].map((x) => Home.fromJson(x))),
    recent:json["recent"] == null?[]: List<Home>.from(json["recent"].map((x) => Home.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "home": List<dynamic>.from(home.map((x) => x.toJson())),
    "work": List<dynamic>.from(work.map((x) => x.toJson())),
    "others": List<dynamic>.from(others.map((x) => x.toJson())),
    "recent": List<dynamic>.from(recent.map((x) => x.toJson())),
  };
}

class Home {
  Home({
    this.id,
    this.userId,
    this.address,
    this.latitude,
    this.longitude,
    this.type,
  });

  int? id;
  int? userId;
  String? address;
  double? latitude;
  double? longitude;
  String? type;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
    id: json["id"],
    userId: json["user_id"],
    address: json["address"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "type": type,
  };
}
