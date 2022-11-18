import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/pages/loading.dart';
import 'package:mbanking_app/src/pages/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final sessionStateStream = StreamController<SessionState>();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark // status bar color
      ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MbankingApp());
  sessionStateStream.add(SessionState.stopListening);
  SharedPreferences server = await SharedPreferences.getInstance();
  await server.setString(
      'server', ":3000");
}

class MbankingApp extends StatelessWidget {
  MbankingApp({
    Key? key,
  }) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  final sessionStateStream = StreamController<SessionState>();

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 3),
      invalidateSessionForUserInactiviity: const Duration(minutes: 10),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        // handle user  inactive timeout
        _navigator.push(MaterialPageRoute(
          builder: (_) => LoginDemo(
            sessionStateStream: sessionStateStream,
            loggedOutReason: "Sesi Habis, Silakan Login Kembali",
          ),
        ));
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user  app lost focus timeout
        _navigator.push(MaterialPageRoute(
          // ignore: unnecessary_new
          builder: (_) => new LoginDemo(
            sessionStateStream: sessionStateStream,
            loggedOutReason: "Sesi Habis, Silakan Login Kembali",
          ),
        ));
      }
    });
    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "Mobile Banking App",
        home: AnimatedSplashScreen(
          splash: const MyWidget(),
          splashIconSize: 900.0,
          nextScreen: Loading(
            sessionStateStream: sessionStateStream,
          ),
          pageTransitionType: PageTransitionType.fade,
          splashTransition: SplashTransition.sizeTransition,
          duration: 2000,
          animationDuration: const Duration(seconds: 1),
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    height: 1,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Image.asset(
                  'assets/png/OJK_Logo.png',
                  height: 35,
                )
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
