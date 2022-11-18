import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HelpModel {
  String kode;
  String judul;
  String konten;

  HelpModel({
    required this.kode,
    required this.judul,
    required this.konten,
  });

  factory HelpModel.fromJson(Map<String, dynamic> json) {
    return HelpModel(
      kode: json['kode'],
      judul: json['judul'],
      konten: json['konten'],
    );
  }
}

class HelpRepository {
  Future getData() async {
    SharedPreferences n = await SharedPreferences.getInstance();
    String? baseUrl = n.getString('server');
    try {
      final msg = jsonEncode(
        {
          "method": "marstech.get_help"
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
        List<HelpModel> listHelp =
            it.map((e) => HelpModel.fromJson(e)).toList();
        return listHelp;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
