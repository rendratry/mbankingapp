// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/helper/exception_handler.dart';
import 'package:mbanking_app/src/pages/conecttion.dart';
import 'package:mbanking_app/src/pages/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/FalseModel_Model.dart';
import 'login_screen.dart';

class Loading extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const Loading({super.key, required this.sessionStateStream});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final sessionStateStream = StreamController<SessionState>();
  String? message;
  String? status;

  @override
  void initState() {
    super.initState();
    loadList();

  }

  Future getStatus() async {
    try {
      SharedPreferences no = await SharedPreferences.getInstance();
      String? noNasabah = no.getString('teleponNasabah');
      var nomorHp;
      if (noNasabah == null) {
        nomorHp = "0";
      } else {
        nomorHp = noNasabah;
      }
      print(noNasabah);
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg =
      jsonEncode({"method": "marstech.valid_telepon", "no_hp": nomorHp});
      var response = await http.post(Uri.parse("http://"+baseUrl!),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      setState(() => status = decodeData.status);
      setState(() => message = decodeData.message);
      if (decodeData.status == "00") {
        widget.sessionStateStream.add(SessionState.stopListening);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginDemo(
              sessionStateStream: widget.sessionStateStream,
            ),
          ),
        );
      } else if (decodeData.status == "03") {
        widget.sessionStateStream.add(SessionState.stopListening);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(
              sessionStateStream: widget.sessionStateStream,
            ),
          ),
        );
      }
    } catch (e) {
      var error =  ExceptionHandlers().getExceptionString(e);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
      );

    }
  }

  Future loadList() async {
   await getStatus();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark// status bar color
    ));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/png/bankmadiun.png",
                  height: 70,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bank Madiun Terdaftar\nDan Diawasi Oleh',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      height: 1),
                ),
                const SizedBox(
                  width: 3,
                ),
                Image.asset('assets/png/OJK_Logo.png', height: 35,)
              ],
            ),
            const SizedBox(
              height: 45,
            )
          ],
        ),
      ),
    );
  }
}
