// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/helper/alert.dart';
import 'package:mbanking_app/src/helper/hash.dart';
import 'package:mbanking_app/src/model/verifikasiOtp_model.dart';
import 'package:mbanking_app/src/pages/login_hp.dart';
import 'package:mbanking_app/src/pages/login_screen.dart';
import 'package:mbanking_app/src/pages/register_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../widgets/exitalert.dart';
import 'conecttion.dart';

class Verifikasi extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const Verifikasi({super.key, required this.sessionStateStream});

  @override
  _VerifikasiState createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool showWidget = false;
  bool timerWidget = true;
  String? status;
  String? statusTelp;
  String? errMessage;
  String? NoHp;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? NoHp = server.getString('noHpNasabah');
    setState(() => this.NoHp = NoHp);
  }

  Future<void> cekNoHp(String hp) async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? baseUrl = server.getString('server');
    final msg = jsonEncode({"method": "marstech.valid_telepon", "no_hp": hp});
    var response = await http.post(Uri.parse("http://${baseUrl!}"),
        headers: {}, body: msg);
    var decodeData = FalseModel.fromJson(jsonDecode(response.body));
    setState(() => this.status = decodeData.status);
    setState(() => this.errMessage = decodeData.message);
    if (decodeData.status == "00") {
      setState(() => this.status = decodeData.status);
    } else {}
  }

  Future<void> verifOTP(String otp) async {
    try{
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode(
          {"method": "marstech.verifikasi_otp", "no_hp": NoHp, "otp": otp});
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      print(response.body);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      setState(() => errMessage = decodeData.message);
      if (decodeData.status == "00") {
        var dataDecode = VerifikasiOtp.fromJson(jsonDecode(response.body));
        setState(() => status = dataDecode.status);
      } else {
        setState(() => status = decodeData.status);
      }
    }catch(e){
      var error =  ExceptionHandlers().getExceptionString(e);
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

  Future<void> cekTelepon(String hp) async {
    try{
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode({"method": "marstech.valid_telepon", "no_hp": hp});
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      print(response.body);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => statusTelp = decodeData.status);
      SharedPreferences prefsId = await SharedPreferences.getInstance();
      await prefsId.setString('registerMessage', decodeData.message);
      return statuscode;
    }catch(e){
      var error =  ExceptionHandlers().getExceptionString(e);
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
    var re = RegExp(r'\d(?!\d{0,2}$)'); // keep last 3 digits
    print('123456789'.replaceAll(re, '-'));
    var nomorToDisplay = NoHp?.replaceAll(re, "*");
    return Scaffold(
      backgroundColor: Colors.white,
      body:WillPopScope(
        onWillPop: () => Exitbaru(sessionStateStream: widget.sessionStateStream).showExitPopup(context),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SvgPicture.asset(
                  "assets/svg/verif2.svg",
                  width: 200,
                  height: 200,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Verifikasi Akun',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color.fromRGBO(41, 45, 50, 1.0),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32, left: 32, top: 10),
                child: Center(
                    child: Text(
                  "Kode Verifikasi telah dikirim ke nomor $nomorToDisplay Cek sms untuk melihatnya",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color(0xff000000),
                    fontSize: 14,
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 42, right: 42, top: 23),
                child: Center(
                  child: PinCodeTextField(
                    length: 4,
                    backgroundColor: Colors.white,
                    keyboardType: const TextInputType.numberWithOptions(),
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 54,
                        fieldWidth: 57,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        inactiveColor: const Color(0x26000000),
                        activeColor: const Color(0x26000000)),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: textEditingController,
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),
              ),
              timerWidget
                  ? TweenAnimationBuilder<Duration>(
                      duration: const Duration(minutes: 3),
                      tween: Tween(
                          begin: const Duration(minutes: 3), end: Duration.zero),
                      onEnd: () {
                        setState(() {
                          showWidget = !showWidget;
                          timerWidget = false;
                        });
                      },
                      builder:
                          (BuildContext context, Duration value, Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text('$minutes:$seconds',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)));
                      })
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              showWidget
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(''),
                        const Text(
                          'Belum menerima kode?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xff000000),
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xff0A6DED), textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          child: const Text("Kirim Ulang Kode"),
                          onPressed: () async {
                            await verifOTP(textEditingController.text);
                            setState(() {
                              showWidget = false;
                              timerWidget = !timerWidget;
                              Hashing("link");
                            });
                          },
                        ),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(''),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(218, 86, 86, 1.0),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    child: const Text("Nomor Hp Salah?"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginNoHp(sessionStateStream: widget.sessionStateStream,)),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              RawMaterialButton(
                onPressed: () async {
                  PleaseWait(context);
                  await verifOTP(textEditingController.text);
                  if (status == "00") {
                    await cekTelepon(NoHp!);
                    if (statusTelp == "00") {
                      Navigator.pop(context);
                      SharedPreferences prefsId =
                      await SharedPreferences.getInstance();
                      await prefsId.setString('teleponNasabah', NoHp!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginDemo(
                                  sessionStateStream: widget.sessionStateStream,
                                )),
                      );
                    } else {
                      Navigator.pop(context);
                      widget.sessionStateStream.add(SessionState.stopListening);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisScreen()),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message: errMessage!,
                      ),
                    );
                  }
                },
                fillColor: const Color(0xff0A6DED),
                constraints: const BoxConstraints(minHeight: 49, minWidth: 140),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                child: const Text('Verifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
