// To parse this JSON data, do
//
//     final cekRegister = cekRegisterFromJson(jsonString);

import 'dart:convert';

CekRegister cekRegisterFromJson(String str) => CekRegister.fromJson(json.decode(str));

String cekRegisterToJson(CekRegister data) => json.encode(data.toJson());

class CekRegister {
  CekRegister({
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
  List<PinPpob> pinPpob;
  List<RekeningTabungan> rekeningTabungan;
  List<RekeningKredit> rekeningKredit;
  List<RekeningDeposito> rekeningDeposito;

  factory CekRegister.fromJson(Map<String, dynamic> json) => CekRegister(
    status: json["status"],
    message: json["message"],
    foto: json["foto"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pinPpob: List<PinPpob>.from(json["pin_ppob"].map((x) => PinPpob.fromJson(x))),
    rekeningTabungan: List<RekeningTabungan>.from(json["rekening_tabungan"].map((x) => RekeningTabungan.fromJson(x))),
    rekeningKredit: List<RekeningKredit>.from(json["rekening_kredit"].map((x) => RekeningKredit.fromJson(x))),
    rekeningDeposito: List<RekeningDeposito>.from(json["rekening_deposito"].map((x) => RekeningDeposito.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "foto": foto,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pin_ppob": List<dynamic>.from(pinPpob.map((x) => x.toJson())),
    "rekening_tabungan": List<dynamic>.from(rekeningTabungan.map((x) => x.toJson())),
    "rekening_kredit": List<dynamic>.from(rekeningKredit.map((x) => x.toJson())),
    "rekening_deposito": List<dynamic>.from(rekeningDeposito.map((x) => x.toJson())),
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

class PinPpob {
  PinPpob({
    required this.pin,
  });

  String pin;

  factory PinPpob.fromJson(Map<String, dynamic> json) => PinPpob(
    pin: json["pin"],
  );

  Map<String, dynamic> toJson() => {
    "pin": pin,
  };
}

class RekeningDeposito {
  RekeningDeposito({
    required this.nama,
    required this.rekening,
    required this.nominal,
  });

  String nama;
  String rekening;
  String nominal;

  factory RekeningDeposito.fromJson(Map<String, dynamic> json) => RekeningDeposito(
    nama: json["nama"],
    rekening: json["rekening"],
    nominal: json["nominal"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "rekening": rekening,
    "nominal": nominal,
  };
}

class RekeningKredit {
  RekeningKredit({
    required this.nama,
    required this.rekening,
    required this.bakiDebet,
  });

  String nama;
  String rekening;
  String bakiDebet;

  factory RekeningKredit.fromJson(Map<String, dynamic> json) => RekeningKredit(
    nama: json["nama"],
    rekening: json["rekening"],
    bakiDebet: json["baki_debet"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "rekening": rekening,
    "baki_debet": bakiDebet,
  };
}

class RekeningTabungan {
  RekeningTabungan({
    required this.nama,
    required this.rekening,
    required this.saldo,
  });

  String nama;
  String rekening;
  String saldo;

  factory RekeningTabungan.fromJson(Map<String, dynamic> json) => RekeningTabungan(
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
