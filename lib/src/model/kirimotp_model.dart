// To parse this JSON data, do
//
//     final kirimOtpModel = kirimOtpModelFromJson(jsonString);

import 'dart:convert';

KirimOtpModel kirimOtpModelFromJson(String str) => KirimOtpModel.fromJson(json.decode(str));

String kirimOtpModelToJson(KirimOtpModel data) => json.encode(data.toJson());

class KirimOtpModel {
  KirimOtpModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory KirimOtpModel.fromJson(Map<String, dynamic> json) => KirimOtpModel(
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
