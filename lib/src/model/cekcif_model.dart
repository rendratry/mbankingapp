// To parse this JSON data, do
//
//     final cekCifModel = cekCifModelFromJson(jsonString);

import 'dart:convert';

CekCifModel cekCifModelFromJson(String str) => CekCifModel.fromJson(json.decode(str));

String cekCifModelToJson(CekCifModel data) => json.encode(data.toJson());

class CekCifModel {
  CekCifModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory CekCifModel.fromJson(Map<String, dynamic> json) => CekCifModel(
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
    required this.kode,
    required this.nama,
  });

  String kode;
  String nama;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    kode: json["kode"],
    nama: json["nama"],
  );

  Map<String, dynamic> toJson() => {
    "kode": kode,
    "nama": nama,
  };
}
