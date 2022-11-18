import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/widgets/scann_qr.dart';
import '/src/theme/mbanking_typography.dart';
import '/src/theme/mbanking_color.dart';
import '/src/pages/akun_page.dart';
import '/src/pages/dashboard_page.dart';
import '/src/pages/help_page.dart';
import '/src/pages/transaksi_page.dart';
import 'exitalert.dart';

class NavigationPage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  const NavigationPage({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentTab = 0;

  // final List<Widget> screen = [
  //   const DashboardPage(),
  //   const HelpPage(),
  //   const TransaksiPage(),
  //   AkunPage(sessionStateStream: sessionStateStream,)
  // ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const DashboardPage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Exitbaru(sessionStateStream: widget.sessionStateStream)
          .showExitToLogin(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 65,
              width: 65,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: MbankingColor.biru1,
                onPressed: () async {
                  widget.sessionStateStream.add(SessionState.stopListening);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrScanner(),
                    ),
                  );
                  widget.sessionStateStream.add(SessionState.startListening);
                },
                child: SvgPicture.asset(
                  'assets/svg/icon_transfer.svg',
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'mPay',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: MbankingColor.biru1),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const DashboardPage();
                        currentTab = 0;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          currentTab == 0
                              ? 'assets/svg/Dashboard-active.svg'
                              : 'assets/svg/Dashboard.svg',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Home',
                          style: MbankingTypography.navbarText,
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const HelpPage();
                        currentTab = 1;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          currentTab == 1
                              ? 'assets/svg/Help-active.svg'
                              : 'assets/svg/Help.svg',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text('Help',
                            style: MbankingTypography.navbarText),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 65,
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = TransaksiPage(
                          sessionStateStream: widget.sessionStateStream,
                        );
                        currentTab = 2;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          currentTab == 2
                              ? 'assets/svg/Transaksi-active.svg'
                              : 'assets/svg/Transaksi.svg',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text('Transaksi',
                            style: MbankingTypography.navbarText),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = AkunPage(
                          sessionStateStream: widget.sessionStateStream,
                        );
                        currentTab = 3;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          currentTab == 3
                              ? 'assets/svg/Profile-active.svg'
                              : 'assets/svg/Profile.svg',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text('Akun',
                            style: MbankingTypography.navbarText),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
