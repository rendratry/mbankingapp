// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/FalseModel_Model.dart';
import '../model/cekregister_model.dart';


class SaldoTabunganModel {
  int rekening;
  String nama;
  int saldo;

  SaldoTabunganModel(
      {required this.rekening, required this.nama, required this.saldo});
}
