// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    required this.noHp,
    required this.register,
    required this.cif,
    required this.rekeningTab,
    required this.nama,
    required this.alamat,
  });

  String noHp;
  String register;
  String cif;
  String rekeningTab;
  String nama;
  String alamat;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    noHp: json["no_hp"],
    register: json["register"],
    cif: json["cif"],
    rekeningTab: json["rekening_tab"],
    nama: json["nama"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "no_hp": noHp,
    "register": register,
    "cif": cif,
    "rekening_tab": rekeningTab,
    "nama": nama,
    "alamat": alamat,
  };
}
