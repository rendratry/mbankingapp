import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/FalseModel_Model.dart';


Future<bool?> loginHpNasabah(String hp) async{
  String? status;
  SharedPreferences server = await SharedPreferences.getInstance();
  String? baseUrl = server.getString('server');
  final msg = jsonEncode(
      {
        "method": "marstech.valid_telepon",
        "no_hp": hp
      }
      );

  var response = await http.post(Uri.parse("http://"+baseUrl!),
      headers: {
        //'Content-Type': "application/json",
      },
      body:
      msg
  );
  var data = response.body;
  print(data);

  if(response.statusCode == 200){
    var decodeData = FalseModel.fromJson(jsonDecode(data));
    print("API : " + decodeData.status);
    return true;
  } else {
    return false;
  }
}
