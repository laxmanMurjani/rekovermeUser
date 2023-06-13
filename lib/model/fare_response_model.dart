import 'dart:convert';

FareResponseModel fareResponseModelFromJson(String str) => FareResponseModel.fromJson(json.decode(str));

String fareResponseModelToJson(FareResponseModel data) => json.encode(data.toJson());

class FareResponseModel {
  FareResponseModel({
    this.estimatedFare,
    this.distance,
    this.minute,
    this.time,
    this.taxPrice,
    this.basePrice,
    this.serviceType,
    this.service,
    this.geoFencingId,
    this.geoService,
    this.surge,
    this.surgeValue,
    this.walletBalance,
  });

  dynamic estimatedFare;
  dynamic distance;
  int? minute;
  dynamic time;
  dynamic taxPrice;
  dynamic basePrice;
  int? serviceType;
  Service? service;
  int? geoFencingId;
  GeoService? geoService;
  int? surge;
  String? surgeValue;
  dynamic walletBalance;

  factory FareResponseModel.fromJson(Map<String, dynamic> json) => FareResponseModel(
    estimatedFare: json["estimated_fare"],
    distance: json["distance"],
    minute: json["minute"],
    time: json["time"],
    taxPrice: json["tax_price"],
    basePrice: json["base_price"],
    serviceType: json["service_type"],
    service: Service.fromJson(json["service"]),
    geoFencingId: json["geo_fencing_id"],
    geoService: GeoService.fromJson(json["geo_service"]),
    surge: json["surge"],
    surgeValue: json["surge_value"],
    walletBalance: json["wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "estimated_fare": estimatedFare,
    "distance": distance,
    "minute": minute,
    "time": time,
    "tax_price": taxPrice,
    "base_price": basePrice,
    "service_type": serviceType,
    "service": service?.toJson(),
    "geo_fencing_id": geoFencingId,
    "geo_service": geoService?.toJson(),
    "surge": surge,
    "surge_value": surgeValue,
    "wallet_balance": walletBalance,
  };
}

class GeoService {
  GeoService({
    this.id,
    this.geoFencingId,
    this.serviceTypeId,
    this.distance,
    this.price,
    this.minute,
    this.hour,
    this.nonGeoPrice,
    this.cityLimits,
    this.fixed,
    this.oldRangesPrice,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic geoFencingId;
  dynamic serviceTypeId;
  dynamic distance;
  dynamic price;
  int? minute;
  int? hour;
  dynamic nonGeoPrice;
  dynamic cityLimits;
  dynamic fixed;
  dynamic oldRangesPrice;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GeoService.fromJson(Map<String, dynamic> json) => GeoService(
    id: json["id"],
    geoFencingId: json["geo_fencing_id"],
    serviceTypeId: json["service_type_id"],
    distance: json["distance"],
    price: json["price"],
    minute: json["minute"],
    hour: json["hour"],
    nonGeoPrice: json["non_geo_price"],
    cityLimits: json["city_limits"],
    fixed: json["fixed"],
    oldRangesPrice: json["old_ranges_price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "geo_fencing_id": geoFencingId,
    "service_type_id": serviceTypeId,
    "distance": distance,
    "price": price,
    "minute": minute,
    "hour": hour,
    "non_geo_price": nonGeoPrice,
    "city_limits": cityLimits,
    "fixed": fixed,
    "old_ranges_price": oldRangesPrice,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Service {
  Service({
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

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    providerName: json["provider_name"],
    image: json["image"],
    marker: json["marker"],
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "provider_name": providerName,
    "image": image,
    "marker": marker,
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
  };
}
