import 'dart:convert';

List<NotificationManagerModel> notificationManagerModelFromJson(String str) => List<NotificationManagerModel>.from(json.decode(str).map((x) => NotificationManagerModel.fromJson(x)));

String notificationManagerModelToJson(List<NotificationManagerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationManagerModel {
  NotificationManagerModel({
    this.id,
    this.notifyType,
    this.image,
    this.description,
    this.expiryDate,
    this.status,
  });

  int? id;
  String? notifyType;
  String? image;
  String? description;
  DateTime? expiryDate;
  String? status;

  factory NotificationManagerModel.fromJson(Map<String, dynamic> json) => NotificationManagerModel(
    id: json["id"],
    notifyType: json["notify_type"],
    image: json["image"],
    description: json["description"],
    expiryDate: DateTime.parse(json["expiry_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "notify_type": notifyType,
    "image": image,
    "description": description,
    "expiry_date": expiryDate?.toIso8601String(),
    "status": status,
  };
}
