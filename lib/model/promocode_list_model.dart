// To parse this JSON data, do
//
//     final promoCodeListModel = promoCodeListModelFromJson(jsonString);

import 'dart:convert';

PromoCodeListModel promoCodeListModelFromJson(String str) => PromoCodeListModel.fromJson(json.decode(str));

String promoCodeListModelToJson(PromoCodeListModel data) => json.encode(data.toJson());

class PromoCodeListModel {
  PromoCodeListModel({
    this.promoList = const [],
  });

  List<PromoList> promoList;

  factory PromoCodeListModel.fromJson(Map<String, dynamic> json) => PromoCodeListModel(
    promoList:json["promo_list"] == null? []: List<PromoList>.from(json["promo_list"].map((x) => PromoList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "promo_list": List<dynamic>.from(promoList.map((x) => x.toJson())),
  };
}

class PromoList {
  PromoList({
    this.id,
    this.promoCode,
    this.percentage,
    this.maxAmount,
    this.promoDescription,
    this.expiration,
    this.status,
    this.deletedAt,
    this.createdAt,
  });

  int? id;
  String? promoCode;
  dynamic percentage;
  dynamic maxAmount;
  String? promoDescription;
  DateTime? expiration;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;

  factory PromoList.fromJson(Map<String, dynamic> json) => PromoList(
    id: json["id"],
    promoCode: json["promo_code"],
    percentage: json["percentage"],
    maxAmount: json["max_amount"],
    promoDescription: json["promo_description"],
    expiration: DateTime.parse(json["expiration"]),
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "promo_code": promoCode,
    "percentage": percentage,
    "max_amount": maxAmount,
    "promo_description": promoDescription,
    "expiration": expiration?.toIso8601String(),
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
  };
}
