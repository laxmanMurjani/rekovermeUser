// To parse this JSON data, do
//
//     final showSavedContactModel = showSavedContactModelFromJson(jsonString);

import 'dart:convert';

ShowSavedContactModel showSavedContactModelFromJson(String str) =>
    ShowSavedContactModel.fromJson(json.decode(str));

String showSavedContactModelToJson(ShowSavedContactModel data) =>
    json.encode(data.toJson());

class ShowSavedContactModel {
  ShowSavedContactModel({
    this.status,
    this.data,
  });

  bool? status;
  List<SavedContactList>? data;

  factory ShowSavedContactModel.fromJson(Map<String, dynamic> json) =>
      ShowSavedContactModel(
        status: json["status"],
        data: List<SavedContactList>.from(
            json["data"].map((x) => SavedContactList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SavedContactList {
  SavedContactList({
    this.id,
    this.userId,
    this.name,
    this.countryCode,
    this.mobile,
  });

  int? id;
  String? userId;
  String? name;
  String? countryCode;
  String? mobile;

  factory SavedContactList.fromJson(Map<String, dynamic> json) =>
      SavedContactList(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        countryCode: json["country_code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "country_code": countryCode,
        "mobile": mobile,
      };
}
