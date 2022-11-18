import 'package:flutter/material.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetQrCode extends StatefulWidget {
  const BottomSheetQrCode({Key? key}) : super(key: key);

  @override
  State<BottomSheetQrCode> createState() => _BottomSheetQrCodeState();
}

class _BottomSheetQrCodeState extends State<BottomSheetQrCode> {
  String? rekTab;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? rekTabu = server.getString('rekTabungan');
    setState(() => rekTab = rekTabu);
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Flogo-bank-madiun.png?alt=media&token=1620b016-da77-4856-911b-aeb30376e148',
    );
    return SizedBox(
      height: 326,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 151),
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFEBEBEB)),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35, top: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'QR Code',
                            style: MbankingTypography.header3,
                          ),
                          Text(
                            'Scan kode ini untuk transfer sesama bank',
                            style: TextStyle(
                                fontFamily: 'Open Sans', fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 29),
                  child: Center(
                    child: QrImage(
                      data: rekTab!,
                      size: 180,
                      embeddedImage: image.image,
                      embeddedImageStyle:
                          QrEmbeddedImageStyle(size: const Size(50, 60)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
