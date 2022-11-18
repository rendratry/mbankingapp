import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/pages/transfer_page.dart';
import 'package:mbanking_app/src/widgets/scanner_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../pages/transfer_page2.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  bool isVisibleTwo = false;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AnimationController _animationController;
  late Animation<double> animation;

  void showToast() {
    setState(() {
      isVisible = !isVisible;
      isVisibleTwo = !isVisibleTwo;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(top: 40, child: buildAppbar()),
          Positioned(bottom: 0, child: buildBottombar(context)),
          ScannerAnimation(
            false,
            MediaQuery.of(context).size.width,
            animation: _animationController,
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: Container(
          //       color: Colors.white,
          //       child: (result != null)
          //           ? Text(
          //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //           : const Text('Scan a code'),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      );

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
        // if (result != null) {
        //   startTime();
        // }
        controller.resumeCamera();
      });
    });
  }

  startTime() {
    var duration = const Duration(seconds: 1);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    controller!.pauseCamera();
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: ((context) => TransferPage2()),
      ),
    );
    controller!.resumeCamera();
  }

  Widget buildAppbar() => Row(
        children: [
          IconButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller!.pauseCamera();
              },
              icon: SvgPicture.asset(
                'assets/svg/arrow_left.svg',
                color: Colors.white,
                height: 40,
                width: 40,
              )),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, right: 10),
            child: Text(
              "Scan Barcode Untuk Transfer",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await controller?.toggleFlash();
              showToast();
              setState(() {});
            },
            icon: Row(
              children: [
                Visibility(
                  visible: isVisible,
                  child: const Icon(Icons.flash_off),
                ),
                Visibility(
                  visible: isVisibleTwo,
                  child: const Icon(Icons.flash_on),
                )
              ],
            ),
            color: Colors.white,
          )
        ],
      );

  Widget buildBottombar(BuildContext context) => Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Scan Barcode Bermasalah?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Coba transfer manual dengan\nklik tombol di samping",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: (() async {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => const TransferPage(),
                  ),
                );
                await controller!.stopCamera();
              }),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/Trransfer2.svg',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Transfer\nSesama",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff68BDAE),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
