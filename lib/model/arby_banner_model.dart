// To parse this JSON data, do
//
//     final arbyBannerModel = arbyBannerModelFromJson(jsonString);

import 'dart:convert';

ArbyBannerModel arbyBannerModelFromJson(String str) => ArbyBannerModel.fromJson(json.decode(str));

String arbyBannerModelToJson(ArbyBannerModel data) => json.encode(data.toJson());

class ArbyBannerModel {
  ArbyBannerModel({
    this.banners,
  });

  List<Banner>? banners;

  factory ArbyBannerModel.fromJson(Map<String, dynamic> json) => ArbyBannerModel(
    banners: List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners!.map((x) => x.toJson())),
  };
}

class Banner {
  Banner({
    this.id,
    this.url,
    this.image,
    this.status,
  });

  int? id;
  String? url;
  String? image;
  int? status;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    url: json["url"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "image": image,
    "status": status,
  };
}
