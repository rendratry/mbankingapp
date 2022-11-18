// To parse this JSON data, do
//
//     final avaModel = avaModelFromJson(jsonString);

import 'dart:convert';

AvaModel avaModelFromJson(String str) => AvaModel.fromJson(json.decode(str));

String avaModelToJson(AvaModel data) => json.encode(data.toJson());

class AvaModel {
  AvaModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory AvaModel.fromJson(Map<String, dynamic> json) => AvaModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.ket,
  });

  String ket;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    ket: json["ket"],
  );

  Map<String, dynamic> toJson() => {
    "ket": ket,
  };
}
