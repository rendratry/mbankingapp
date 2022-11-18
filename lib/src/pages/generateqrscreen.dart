import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateQr extends StatefulWidget {
  const GenerateQr({Key? key}) : super(key: key);

  @override
  State<GenerateQr> createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  String? qrimage;
  String? rekTab;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? rekTab = server.getString('rekTabungan');
    setState(() => this.rekTab = rekTab);
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Flogo-bank-madiun.png?alt=media&token=1620b016-da77-4856-911b-aeb30376e148',
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/svg/arrow_left.svg',
              color: const Color(0xff292d32),
              height: 40,
              width: 40,
            )),
        title:
         const Text(
            "Kode Qr Kamu",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff292d32),
            ),
          ),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 150)),
          Center(
            child: QrImage(
              data:
                  rekTab!,
              size: 250,
              // embeddedImage: image.image,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(70, 80),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Scan Kode Qr untuk menerima transfer \nuang dari sesama",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Color(0xff292d32),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
