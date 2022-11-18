

import 'dart:convert';
import 'package:crypto/crypto.dart';


Hashing(String link){
  var byte = utf8.encode(link);
  var sha = sha256.convert(byte);
  print("Hasil $sha");
}
