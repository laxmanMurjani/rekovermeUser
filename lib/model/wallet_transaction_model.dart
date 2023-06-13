// To parse this JSON data, do
//
//     final walletTransationModel = walletTransationModelFromJson(jsonString);

import 'dart:convert';

WalletTransationModel walletTransationModelFromJson(String str) =>
    WalletTransationModel.fromJson(json.decode(str));

String walletTransationModelToJson(WalletTransationModel data) =>
    json.encode(data.toJson());

class WalletTransationModel {
  WalletTransationModel({
    this.walletTransation = const [],
    this.walletBalance,
  });

  List<WalletTransation> walletTransation;
  double? walletBalance;

  factory WalletTransationModel.fromJson(Map<String, dynamic> json) =>
      WalletTransationModel(
        walletTransation: json["wallet_transation"] == null
            ? []
            : List<WalletTransation>.from(json["wallet_transation"]
                .map((x) => WalletTransation.fromJson(x))),
        walletBalance: json["wallet_balance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "wallet_transation":
            List<dynamic>.from(walletTransation.map((x) => x.toJson())),
        "wallet_balance": walletBalance,
      };
}

class WalletTransation {
  WalletTransation({
    this.id,
    this.userId,
    this.transactionId,
    this.transactionAlias,
    this.transactionDesc,
    this.type,
    this.amount,
    this.openBalance,
    this.closeBalance,
    this.paymentMode,
    this.createdAt,
  });

  int? id;
  int? userId;
  int? transactionId;
  String? transactionAlias;
  String? transactionDesc;
  String? type;
  double? amount;
  double? openBalance;
  double? closeBalance;
  String? paymentMode;
  DateTime? createdAt;

  factory WalletTransation.fromJson(Map<String, dynamic> json) =>
      WalletTransation(
        id: json["id"],
        userId: json["user_id"],
        transactionId: json["transaction_id"],
        transactionAlias: json["transaction_alias"],
        transactionDesc: json["transaction_desc"],
        type: json["type"],
        amount: json["amount"].toDouble(),
        openBalance: json["open_balance"].toDouble(),
        closeBalance: json["close_balance"].toDouble(),
        paymentMode: json["payment_mode"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "transaction_id": transactionId,
        "transaction_alias": transactionAlias,
        "transaction_desc": transactionDesc,
        "type": type,
        "amount": amount,
        "open_balance": openBalance,
        "close_balance": closeBalance,
        "payment_mode": paymentMode,
        "created_at": createdAt?.toIso8601String(),
      };
}
