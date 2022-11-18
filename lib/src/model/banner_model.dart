// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
    required this.judul,
    required this.pesan,
    required this.urlBanner,
  });

  String judul;
  String pesan;
  String urlBanner;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    judul: json["judul"],
    pesan: json["pesan"],
    urlBanner: json["url_banner"],
  );

  Map<String, dynamic> toJson() => {
    "judul": judul,
    "pesan": pesan,
    "url_banner": urlBanner,
  };
}

class GetBannerModel {
  String judul;
  String pesan;
  String url_banner;

  GetBannerModel({
    required this.judul,
    required this.pesan,
    required this.url_banner,

  });

  factory GetBannerModel.fromJson(Map<String, dynamic> json) {
    return GetBannerModel(
      judul: json['judul'],
      pesan: json['pesan'],
      url_banner: json['url_banner'],
    );
  }
}
