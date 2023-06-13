import 'dart:convert';

List<DisputeModel> disputeModelFromJson(String str) => List<DisputeModel>.from(json.decode(str).map((x) => DisputeModel.fromJson(x)));

String disputeModelToJson(List<DisputeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DisputeModel {
  DisputeModel({
    this.disputeName,
  });

  String? disputeName;

  factory DisputeModel.fromJson(Map<String, dynamic> json) => DisputeModel(
        disputeName: json["dispute_name"],
      );

  Map<String, dynamic> toJson() => {
        "dispute_name": disputeName,
      };
}
