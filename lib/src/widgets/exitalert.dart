import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import '../pages/login_screen.dart';

class Exitbaru extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;
  const Exitbaru({super.key, required this.sessionStateStream});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void getOutOfApp() {
    if (Platform.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator
            .pop(); // for IOS, not true this, you can make comment this :)
      }
    } else {
      try {
        SystemNavigator.pop(); // sometimes it cant exit app
      } catch (e) {
        exit(0); // so i am giving crash to app ... sad :(
      }
    }
  }

  Future<bool> exitOnly(context) async {
    Navigator.pop(context);
    SystemNavigator.pop();
    return exit(0);
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Apakah anda yakin untuk keluar?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            SystemNavigator.pop();
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                          child: const Text("Ya"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('no selected');
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Tidak",
                            style: TextStyle(color: Colors.white)),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> showExitToLogin(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Apakah anda yakin untuk keluar?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginDemo(sessionStateStream: sessionStateStream)),
                        );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                          child: const Text("Ya"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('no selected');
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Tidak",
                            style: TextStyle(color: Colors.white)),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }


  Future<bool> showExitPagePopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Yakin akan meninggalkan halaman ini?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginDemo(
                                  sessionStateStream: sessionStateStream,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                          child: const Text("Yes"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('no selected');
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("No",
                            style: TextStyle(color: Colors.white)),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
