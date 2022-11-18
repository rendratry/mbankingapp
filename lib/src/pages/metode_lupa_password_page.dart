import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbanking_app/src/helper/alert.dart';
import 'package:mbanking_app/src/pages/verif_lupa_password_page.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/widgets/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../model/kirimotp_model.dart';
import '../widgets/db_provider.dart';
import 'conecttion.dart';

class MetodeUpdatePage extends StatefulWidget {
  const MetodeUpdatePage({Key? key})
      : super(key: key);

  @override
  State<MetodeUpdatePage> createState() => _MetodeUpdatePageState();
}


class _MetodeUpdatePageState extends State<MetodeUpdatePage> {

  String? status;
  String? errMessage;
  bool secured = false;

  Future<void> OtpRequest(String hp) async{
    try{
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode(
          {
            "method": "marstech.request_otp",
            "no_hp": hp
          }
      );
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {
          },
          body:
          msg
      );
      print(response.body);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => status = decodeData.status);
      setState(() => errMessage = decodeData.message);
      if(status=="00"){
        var dataDecode = KirimOtpModel.fromJson(jsonDecode(response.body));
        setState(() => status = dataDecode.status);
      }
      return statuscode;
    }catch(e){
      var error = ExceptionHandlers().getExceptionString(e);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: MbankingColor.biru3,
        statusBarIconBrightness: Brightness.light// status bar color
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body : Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Metode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            const SizedBox(height: 20,),
            InkWell(
              onTap: () async {
                PleaseWait(context);
                DbProvider().getAuthState().then((value) async {
                  if (value == false) {
                    SharedPreferences no = await SharedPreferences.getInstance();
                    String? noNasabah = no.getString('teleponNasabah');
                    await OtpRequest(noNasabah!);
                    if(status == "00"){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VerifikasiLupaPassword()),
                      );

                    }else{
                      Navigator.pop(context);
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: errMessage!,
                        ),
                      );
                    }
                    return null;
                  }else{
                    Navigator.pop(context);
                    bool isAuthenticated =
                    await AuthService.authenticateUser(secured);

                    if (isAuthenticated) {
                      SharedPreferences no = await SharedPreferences.getInstance();
                      String? noNasabah = no.getString('teleponNasabah');
                      await OtpRequest(noNasabah!);
                      if(status == "00"){
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VerifikasiLupaPassword()),
                          );

                      }else{
                          Navigator.pop(context);
                          showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                          message: errMessage!,
                          ),);
                    }
                    } else {}

                  }
                  }
                );},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/png/otp-icon.png',
                      height: 26, width: 26),
                  const SizedBox(
                    width: 21,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kirim SMS OTP",
                        style: TextStyle(
                            fontFamily: 'OpenSans', fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Text("Pulihkan dengan nomor HP \nyang sudah terdaftar di aplikasi", style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/svg/arrow_right.svg', color: MbankingColor.biru3,),
                ],
              ),
            ),
            const Divider(
              color: Color(0xffE3E3FE),
              height: 14,
              thickness: 1,
              indent: 44,
            ),
          ],
        ),
      ),
    );
  }
}