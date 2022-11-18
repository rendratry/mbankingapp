// To parse this JSON data, do
//
//     final falseModel = falseModelFromJson(jsonString);

import 'dart:convert';

FalseModel falseModelFromJson(String str) => FalseModel.fromJson(json.decode(str));

String falseModelToJson(FalseModel data) => json.encode(data.toJson());

class FalseModel {
  FalseModel({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory FalseModel.fromJson(Map<String, dynamic> json) => FalseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
