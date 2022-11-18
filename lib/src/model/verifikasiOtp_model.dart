// To parse this JSON data, do
//
//     final verifikasiOtp = verifikasiOtpFromJson(jsonString);

import 'dart:convert';

VerifikasiOtp verifikasiOtpFromJson(String str) => VerifikasiOtp.fromJson(json.decode(str));

String verifikasiOtpToJson(VerifikasiOtp data) => json.encode(data.toJson());

class VerifikasiOtp {
  VerifikasiOtp({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory VerifikasiOtp.fromJson(Map<String, dynamic> json) => VerifikasiOtp(
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
