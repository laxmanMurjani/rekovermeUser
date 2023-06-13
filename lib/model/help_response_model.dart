
import 'dart:convert';

HelpResponseModel helpResponseModelFromJson(String str) => HelpResponseModel.fromJson(json.decode(str));

String helpResponseModelToJson(HelpResponseModel data) => json.encode(data.toJson());

class HelpResponseModel {
  HelpResponseModel({
    this.contactNumber,
    this.contactEmail,
  });

  String? contactNumber;
  String? contactEmail;

  factory HelpResponseModel.fromJson(Map<String, dynamic> json) => HelpResponseModel(
    contactNumber: json["contact_number"],
    contactEmail: json["contact_email"],
  );

  Map<String, dynamic> toJson() => {
    "contact_number": contactNumber,
    "contact_email": contactEmail,
  };
}
