// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

List<ServicesModel> servicesModelFromJson(String str) => List<ServicesModel>.from(json.decode(str).map((x) => ServicesModel.fromJson(x)));

String servicesModelToJson(List<ServicesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesModel {
  ServicesModel({
    this.id,
    this.name,
    this.providerName,
    this.image,
    this.marker,
    this.capacity,
    this.fixed,
    this.price,
    this.minute,
    this.hour,
    this.distance,
    this.calculator,
    this.description,
    this.waitingFreeMins,
    this.waitingMinCharge,
    this.status,
    this.moduleType,
  });

  int? id;
  String? name;
  String? providerName;
  String? image;
  String? marker;
  int? capacity;
  int? fixed;
  int? price;
  int? minute;
  int? hour;
  int? distance;
  String? calculator;
  dynamic description;
  int? waitingFreeMins;
  int? waitingMinCharge;
  int? status;
  String? moduleType;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
    id: json["id"],
    name: json["name"],
    providerName: json["provider_name"] == null ? null : json["provider_name"],
    image: json["image"] == null ? null : json["image"],
    marker: json["marker"] == null ? null : json["marker"],
    capacity: json["capacity"],
    fixed: json["fixed"],
    price: json["price"],
    minute: json["minute"],
    hour: json["hour"],
    distance: json["distance"],
    calculator: json["calculator"],
    description: json["description"],
    waitingFreeMins: json["waiting_free_mins"],
    waitingMinCharge: json["waiting_min_charge"],
    status: json["status"],
    moduleType: json["module_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "provider_name": providerName == null ? null : providerName,
    "image": image == null ? null : image,
    "marker": marker == null ? null : marker,
    "capacity": capacity,
    "fixed": fixed,
    "price": price,
    "minute": minute,
    "hour": hour,
    "distance": distance,
    "calculator": calculator,
    "description": description,
    "waiting_free_mins": waitingFreeMins,
    "waiting_min_charge": waitingMinCharge,
    "status": status,
    "module_type": moduleType,
  };
}
