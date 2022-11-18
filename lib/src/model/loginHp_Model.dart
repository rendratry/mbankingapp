// To parse this JSON data, do
//
//     final loginHpModel = loginHpModelFromJson(jsonString);

import 'dart:convert';

// LoginHpModel loginHpModelFromJson(String str) => LoginHpModel.fromJson(json.decode(str));
//
// String loginHpModelToJson(LoginHpModel data) => json.encode(data.toJson());

class LoginHpModel {
  LoginHpModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory LoginHpModel.fromJson(Map<String, dynamic> json) => LoginHpModel(
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
    required this.cif,
    required this.noHp,
  });

  String register;
  String cif;
  String noHp;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    register: json["register"],
    cif: json["cif"],
    noHp: json["no_hp"],
  );

  Map<String, dynamic> toJson() => {
    "register": register,
    "cif": cif,
    "no_hp": noHp,
  };
}
