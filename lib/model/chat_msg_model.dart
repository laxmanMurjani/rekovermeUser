// To parse this JSON data, do
//
//     final chatMsgModel = chatMsgModelFromJson(jsonString);

import 'dart:convert';

ChatMsgModel chatMsgModelFromJson(String str) => ChatMsgModel.fromJson(json.decode(str));

String chatMsgModelToJson(ChatMsgModel data) => json.encode(data.toJson());

class ChatMsgModel {
  ChatMsgModel({
    this.read,
    this.driverId,
    this.sender,
    this.text,
    this.type,
    this.userId,
    this.url,
    this.timestamp,
  });

  int? read;
  int? driverId;
  String? sender;
  String? text;
  String? type;
  int? userId;
  String? url;
  int? timestamp;

  factory ChatMsgModel.fromJson(Map<String, dynamic> json) => ChatMsgModel(
    read: json["read"],
    driverId: json["driverId"],
    sender: json["sender"],
    text: json["text"],
    type: json["type"],
    userId: json["userId"],
    url: json["url"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "read": read,
    "driverId": driverId,
    "sender": sender,
    "text": text,
    "type": type,
    "userId": userId,
    "url": url,
    "timestamp": timestamp,
  };
}
