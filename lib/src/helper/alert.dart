import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import '../pages/login_screen.dart';

Future Logout(context) async {
  final sessionStateStream = StreamController<SessionState>();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      width: 220,
                      height: 215,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 175, 20, 10),
                      child: const Text(
                        "Yakin akan keluar?",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff3a3939)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (kDebugMode) {
                              print('yes selected');
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginDemo(
                                      sessionStateStream: sessionStateStream)),
                            );
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: const Text("OK"),
                        ),
                      ),
                    ]),
                  ],
                ),
                Positioned(
                  top: -10,
                  child: Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_vvx2gjpt.json',
                      width: 190,
                      height: 187),
                ),
              ],
            ),
          ));
}

Future UnderDevelopment(context) async {
  final sessionStateStream = StreamController<SessionState>();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      width: 250,
                      height: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 175, 20, 10),
                      child: const Text(
                        "Fitur Dalam Pengembangan",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff3a3939)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (kDebugMode) {
                              print('yes selected');
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MbankingColor.biru3),
                          child: const Text("OK"),
                        ),
                      ),
                    ]),
                  ],
                ),
                Positioned(
                  top: -10,
                  child: Image.asset('assets/gif/under-development.gif',
                      width: 190, height: 187),
                ),
              ],
            ),
          ));
}

Future Alert(context, String text) async {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.network(
                        "https://assets10.lottiefiles.com/private_files/lf30_yABbl9.json",
                        height: 70),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (kDebugMode) {
                              print('yes selected');
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MbankingColor.biru3),
                          child: const Text("OK"),
                        ),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ));
}

PleaseWait(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Mohon Menunggu")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: alert);
    },
  );
}
