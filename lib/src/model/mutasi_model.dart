// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MutasiModel {
  String tgl;
  String keterangan;
  String kodeTransaksi;
  String dk;
  String jumlah;
  String saldo;
  String id;

  MutasiModel({
    required this.tgl,
    required this.keterangan,
    required this.kodeTransaksi,
    required this.dk,
    required this.jumlah,
    required this.saldo,
    required this.id,
  });

  factory MutasiModel.fromJson(Map<String, dynamic> json) {
    return MutasiModel(
      tgl: json['tgl'],
      keterangan: json['keterangan'],
      kodeTransaksi: json['kodetransaksi'],
      dk: json['DK'],
      jumlah: json['jumlah'],
      saldo: json['saldo'],
      id: json['ID'],
    );
  }
}

class RekTabunganModel {
  String nama;
  String rekening;
  String saldo;


  RekTabunganModel({
    required this.nama,
    required this.rekening,
    required this.saldo,

  });

  factory RekTabunganModel.fromJson(Map<String, dynamic> json) {
    return RekTabunganModel(
      nama: json['nama'],
      rekening: json['rekening'],
      saldo: json['saldo'],
    );
  }
}

class RekDepositoModel {
  String nama;
  String rekening;
  String nominal;
  String status;


  RekDepositoModel({
    required this.nama,
    required this.rekening,
    required this.nominal,
    required this.status

  });

  factory RekDepositoModel.fromJson(Map<String, dynamic> json) {
    return RekDepositoModel(
      nama: json['nama'],
      rekening: json['rekening'],
      nominal: json['nominal'],
      status: json['status'],
    );
  }
}

class BakiDebetModel {
  String nama;
  String rekening;
  String nominal;
  String status;


  BakiDebetModel({
    required this.nama,
    required this.rekening,
    required this.nominal,
    required this.status

  });

  factory BakiDebetModel.fromJson(Map<String, dynamic> json) {
    return BakiDebetModel(
      nama: json['nama'],
      rekening: json['rekening'],
      nominal: json['baki_debet'],
      status: json['status']
    );
  }
}

class MutasiRepository {
  Future getData(String username, String password, String rekeningTab) async {
    SharedPreferences n = await SharedPreferences.getInstance();
    String? baseUrl = n.getString('server');
    try {
      final msg = jsonEncode(
        {
          "method": "marstech.get_mutasi_tabungan",
          "username": username,
          "password": password,
          "rekening_tab": rekeningTab,
        },
      );
      var response = await http.post(
          Uri.parse(
              "http://$baseUrl"),
          headers: {},
          body: msg);

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body)["data"];
        List<MutasiModel> transaksi =
        it.map((e) => MutasiModel.fromJson(e)).toList();
        print("ini transaksi mutasi :" + transaksi.toString());
        return transaksi;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
