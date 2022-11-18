// To parse this JSON data, do
//
//     final simpleModel = simpleModelFromJson(jsonString);

import 'dart:convert';

SimpleModel simpleModelFromJson(String str) => SimpleModel.fromJson(json.decode(str));

String simpleModelToJson(SimpleModel data) => json.encode(data.toJson());

class SimpleModel {
  SimpleModel({
    required this.status,
    required this.message,
    required this.foto,
    required this.data,
    required this.pinPpob,
    required this.rekeningTabungan,
    required this.rekeningKredit,
    required this.rekeningDeposito,
  });

  String status;
  String message;
  String foto;
  List<Datum> data;
  List<dynamic> pinPpob;
  List<dynamic> rekeningTabungan;
  List<dynamic> rekeningKredit;
  List<dynamic> rekeningDeposito;

  factory SimpleModel.fromJson(Map<String, dynamic> json) => SimpleModel(
    status: json["status"],
    message: json["message"],
    foto: json["foto"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pinPpob: List<dynamic>.from(json["pin_ppob"].map((x) => x)),
    rekeningTabungan: List<dynamic>.from(json["rekening_tabungan"].map((x) => x)),
    rekeningKredit: List<dynamic>.from(json["rekening_kredit"].map((x) => x)),
    rekeningDeposito: List<dynamic>.from(json["rekening_deposito"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "foto": foto,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pin_ppob": List<dynamic>.from(pinPpob.map((x) => x)),
    "rekening_tabungan": List<dynamic>.from(rekeningTabungan.map((x) => x)),
    "rekening_kredit": List<dynamic>.from(rekeningKredit.map((x) => x)),
    "rekening_deposito": List<dynamic>.from(rekeningDeposito.map((x) => x)),
  };
}

class Datum {
  Datum({
    required this.cif,
    required this.nama,
    required this.tempatLahir,
    required this.alamat,
    required this.noHp,
  });

  String cif;
  String nama;
  String tempatLahir;
  String alamat;
  String noHp;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cif: json["cif"],
    nama: json["nama"],
    tempatLahir: json["tempat_lahir"],
    alamat: json["alamat"],
    noHp: json["no_hp"],
  );

  Map<String, dynamic> toJson() => {
    "cif": cif,
    "nama": nama,
    "tempat_lahir": tempatLahir,
    "alamat": alamat,
    "no_hp": noHp,
  };
}
