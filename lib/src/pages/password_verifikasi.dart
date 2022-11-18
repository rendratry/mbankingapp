import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/pages/login_hp.dart';

class PasswordVerifikasiPage extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;

  const PasswordVerifikasiPage({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginNoHp(
                            sessionStateStream: sessionStateStream,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Color(0xFF0A6DED),
                      ),
                    ),
                  ),
                  CircleAvatar(
                      backgroundColor: const Color(0xFF0A6DED),
                      radius: 16,
                      child: InkWell(
                        onTap: () async  {
                          sessionStateStream.add(SessionState.stopListening);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginNoHp(
                                sessionStateStream: sessionStateStream,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset('assets/svg/arrow_forward.svg'),
                      )),
                ],
              ),
              const SizedBox(
                height: 89,
              )
            ],
          ),
        ),
      ),
    );
  }
}
