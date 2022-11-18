import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/model/help_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../helper/loading_bar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<HelpModel> listHelp = [];
  HelpRepository helpRepository = HelpRepository();
  final sessionStateStream = StreamController<SessionState>();


  void openWhatsapp(
      {required BuildContext context,
        required String text,
        required String number}) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }

  void launchTelegram() async {
    String url = "https://telegram.me/zulfimasyitaaa";
    print("launchingUrl: $url");
    if (Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    listHelp = await helpRepository.getData();
    setState(() => listHelp = listHelp);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark // status bar color
        ));
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: SizedBox(
          height: 40,
          width: 101,
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: Row(
              children: [
                FloatingActionButton.small(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () async {
                    sessionStateStream.add(SessionState.stopListening);
                    openWhatsapp(
                      context: context,
                      number: '+6283857667881',
                      text: 'hallo',
                    );
                    sessionStateStream.add(SessionState.startListening);
                  },
                  heroTag: null,
                  child: SvgPicture.asset('assets/svg/whatsappIcon.svg'),
                ),
                const SizedBox(
                  width: 5,
                ),
                FloatingActionButton.small(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    launchTelegram();
                  },
                  heroTag: null,
                  child: SvgPicture.asset('assets/svg/telegramLogo.svg'),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Pusat Bantuan',
            style: TextStyle(
                color: Color.fromRGBO(41, 45, 50, 1.0),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700),
          ),
        ),
        body: listHelp == []
            ? LoadingBar()
            : Column(children: [
          const SizedBox(height: 29),
          Padding(
            padding: const EdgeInsets.only(right: 62, left: 31),
            child: SvgPicture.asset(
              "assets/svg/help2.svg",
              width: 162,
              height: 158,
            ),
          ),
          const SizedBox(height: 47),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: Text(listHelp[index].judul,
                      style: const TextStyle(
                          color: Color(0xff292D32),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'WorkSans')),
                  children: <Widget>[
                    ListTile(
                        title: Text(listHelp[index].konten,
                            style: const TextStyle(
                                color: Color(0xff292D32),
                                fontSize: 15,
                                fontFamily: 'WorkSans'))),
                  ],
                );
              },
              itemCount: listHelp.length,
            ),
          )
        ]),
      ),
    );
  }
}
