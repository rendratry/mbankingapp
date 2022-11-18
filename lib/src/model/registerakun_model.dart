// To parse this JSON data, do
//
//     final registerAkunModel = registerAkunModelFromJson(jsonString);

import 'dart:convert';

RegisterAkunModel registerAkunModelFromJson(String str) => RegisterAkunModel.fromJson(json.decode(str));

String registerAkunModelToJson(RegisterAkunModel data) => json.encode(data.toJson());

class RegisterAkunModel {
  RegisterAkunModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory RegisterAkunModel.fromJson(Map<String, dynamic> json) => RegisterAkunModel(
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
    required this.register,
    required this.noHp,
    required this.cif,
  });

  String register;
  String noHp;
  String cif;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    register: json["register"],
    noHp: json["no_hp"],
    cif: json["cif"],
  );

  Map<String, dynamic> toJson() => {
    "register": register,
    "no_hp": noHp,
    "cif": cif,
  };
}
