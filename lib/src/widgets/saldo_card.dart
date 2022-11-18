import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';
import 'package:mbanking_app/src/widgets/bottom_sheet_qrcode.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/FalseModel_Model.dart';
import '../model/saldo_model.dart';

class SaldoCard extends StatefulWidget {
  final bool reload;
  final String? title;
  const SaldoCard({Key? key, required this.reload, this.title}) : super(key: key);

  @override
  State<SaldoCard> createState() => _SaldoCardState();


}

class LoadListCardSaldo{

}

class _SaldoCardState extends State<SaldoCard> {


  @override
  void initState() {
    super.initState();

    loadListSaldo();
    if(widget.reload == true){
      loadListSaldo();
      _getData();
    }
  }
  
  _getData() {
    SecureSharedPref.getInstance().then((value) {
      value.getString("RegisterEncrypted",isEncrypted: true).then((value) {
        setState(() {
          register = value.toString();
        });
      });
    });
  }

  Future loadListSaldo() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? NoRekUtama = server.getString('rekUtama');
    String? NoRek = server.getString('rekTabungan');
    SharedPreferences user = await SharedPreferences.getInstance();
    String? userName = user.getString('register');
    SharedPreferences p = await SharedPreferences.getInstance();
    String? pw = p.getString('pw');
    // await SecureSharedPref.getInstance().then((value) {
    //   value.getString('RegisterEncrypted',isEncrypted: true).then((value) {
    //     setState(() {
    //       register = value.toString();
    //     });
    //   });
    // });
    // await SecureSharedPref.getInstance().then((value) {
    //   value.getString('PwEncrypted',isEncrypted: true).then((value) {
    //     setState(() {
    //       passw = value.toString();
    //     });
    //   });
    // });
    print(register);
    print(passw);


    var norekDefault;
    if (NoRekUtama==null){
      norekDefault = NoRek;
    }else{
      norekDefault = NoRekUtama;
    }

    SharedPreferences def = await SharedPreferences.getInstance();
    await def.setString('rekDefault', norekDefault);

    if(norekDefault == null){
      norekDefault = NoRek!;
    }else{}

    setState(() => noRekening = norekDefault);

    await saldoCek(userName!, pw!, noRekening!.toString());
  }

  Future<void> saldoCek(String user, String pw, String rek) async{
    SharedPreferences server = await SharedPreferences.getInstance();
    String? baseUrl = server.getString('server');
    final msg = jsonEncode(
        {
          "method": "marstech.get_saldo_tabungan",
          "username":user,
          "password":pw,
          "rekening_tab":rek
        }
    );
    var response = await http.post(Uri.parse("http://${baseUrl!}"),
        headers: {
        },
        body:
        msg
    );
    var decodeData = FalseModel.fromJson(jsonDecode(response.body));
    var statuscode = setState(() => status = decodeData.status);
    if(status=="00"){
      var dataDecode = SaldoModel.fromJson(jsonDecode(response.body));
      setState(() => saldo = double.parse(dataDecode.data[0].saldo));
      SharedPreferences prefsId =
      await SharedPreferences.getInstance();
      await prefsId.setString('saldo', dataDecode.data[0].saldo);
    }
    return statuscode;
  }


  String? noRekening;
  double? saldo;
  String? status;
  String register = '';
  String passw = '';


  bool _isVisible = false;
  bool _isVisibleTwo = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
      _isVisibleTwo = !_isVisibleTwo;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var noRekeningToDisplay;
    if (noRekening == null) {
      noRekeningToDisplay = '-';
    } else {
      noRekeningToDisplay = noRekening.toString();
    }
    // ignore: prefer_typing_uninitialized_variables
    // if (saldo==null){
    //   saldo =0;
    // }else if (saldo! < 0){
    //   saldo= 0;
    // }else{
    //   saldo=saldo;
    // }
    var saldoToDisplay = saldo;

    return Container(
        padding: const EdgeInsets.only(top: 15, left: 24, right: 24),
        width: MediaQuery.of(context).size.width,
        height: 155,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0x26000000))),
        child: saldo == null?  Center(
          child: Lottie.network("https://assets7.lottiefiles.com/packages/lf20_no6msz4f.json"
              ,
              fit: BoxFit.cover
          ),):Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rekening',
                  style: MbankingTypography.fiturText2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      height: 23,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MbankingColor.biru2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            noRekeningToDisplay,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Saldo Kamu',
                  style: MbankingTypography.fiturText2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Visibility(
                      visible: _isVisible,
                      child: Text(
                        NumberFormat.currency(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                            .format(saldoToDisplay),
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 25),
                      ),
                    ),
                    Visibility(
                      visible: _isVisibleTwo,
                      child: Row(
                        children: const [
                          Text(
                            'Rp ',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                          Text(
                            '. . . . .',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: InkWell(
                            onTap: showToast,
                            child:
                            _isVisible? SvgPicture.asset('assets/svg/Eye_slash.svg'): const Icon(Icons.remove_red_eye, color: MbankingColor.biru4,)))
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) {
                                  return const BottomSheetQrCode();
                                });
                          },
                          child: SvgPicture.asset('assets/svg/QrCode.svg'))),
                ],
              ),
            ),
          ],
        ));
  }
}
