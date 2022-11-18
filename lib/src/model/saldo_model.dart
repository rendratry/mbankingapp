// To parse this JSON data, do
//
//     final saldoModel = saldoModelFromJson(jsonString);

import 'dart:convert';

SaldoModel saldoModelFromJson(String str) => SaldoModel.fromJson(json.decode(str));

String saldoModelToJson(SaldoModel data) => json.encode(data.toJson());

class SaldoModel {
  SaldoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory SaldoModel.fromJson(Map<String, dynamic> json) => SaldoModel(
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
    required this.nama,
    required this.rekening,
    required this.saldo,
  });

  String nama;
  String rekening;
  String saldo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    nama: json["nama"],
    rekening: json["rekening"],
    saldo: json["saldo"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "rekening": rekening,
    "saldo": saldo,
  };
}
