// ignore_for_file: unnecessary_this

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/banner_model.dart';


class SliderDashboard extends StatefulWidget {
  const SliderDashboard({Key? key}) : super(key: key);

  @override
  State<SliderDashboard> createState() => _SliderDashboardState();
}

class _SliderDashboardState extends State<SliderDashboard> {
  int _current = 0;
  String bannerDefault = "https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fbanner-loading.gif?alt=media&token=cbbd373c-2921-4e84-9ad6-89786513bc51";
  String? banner1;
  String? banner2;
  String? banner3;
  final CarouselController _controller = CarouselController();
  List<GetBannerModel> listBanner = [];

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future getBanner() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? baseUrl = server.getString('server');
    try {
      final msg = jsonEncode(
        {
          "method": "marstech.banner",
        },
      );
      var response = await http.post(
          Uri.parse(
              "http://"+baseUrl!),
          headers: {},
          body: msg);

      if (response.statusCode == 200) {
        print("ini respons" + response.body);
        Iterable it = jsonDecode(response.body)["data"];
        List<GetBannerModel> transaksi =
            it.map((e) => GetBannerModel.fromJson(e)).toList();
        return transaksi;
      }
    } catch (e) {
      print("Print" + e.toString());
    }
  }

  Future loadList() async {
    var Listbanner = await getBanner();
    setState(() => listBanner = Listbanner);
    SharedPreferences server = await SharedPreferences.getInstance();
    String? banner1 = server.getString('banner1');
    String? banner2 = server.getString('banner2');
    String? banner3 = server.getString('banner3');
    setState(() => this.banner1 = banner1);
    setState(() => this.banner2 = banner2);
    setState(() => this.banner3 = banner3);

  }



  @override
  Widget build(BuildContext context) {
    var bannerDef = "https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fbanner-loading.gif?alt=media&token=cbbd373c-2921-4e84-9ad6-89786513bc51";
    var banner1Display = bannerDef;
    if(banner1 != null) {
      banner1Display = banner1!;
    }
    var banner2Display = bannerDef;
    if(banner2 != null){
      banner2Display = banner2!;
    }
    var banner3Display = bannerDef;
    if(banner3 != null){
      banner3Display = banner3!;
    }
      final List<String> imgList = [
        banner1Display,
        banner2Display,
        banner3Display
      ];
    return Column(children: [
      // banner1 == null?  Center(
      //   child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_no6msz4f.json',
      //       width: 100,
      //       height: 100
      //   ),):
      CarouselSlider(
        items: listBanner
            .map((item) => ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item.url_banner, fit: BoxFit.cover, width: 1000.0),
                  ],
                )))
            .toList(),
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 298 / 110,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: listBanner.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: (_current == entry.key ? 20.0 : 11.0),
              height: 11.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (_current == entry.key
                      ? MbankingColor.biru3
                      : MbankingColor.grey)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
