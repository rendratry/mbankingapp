
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/helper/alert.dart';
import 'package:mbanking_app/src/pages/verif.dart';
import 'package:mbanking_app/src/widgets/exitalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import 'package:http/http.dart' as http;
import '../model/kirimotp_model.dart';
import 'conecttion.dart';

class LoginNoHp extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const LoginNoHp({super.key, required this.sessionStateStream});
  @override
  State<LoginNoHp> createState() => _LoginNoHpState();
}

class _LoginNoHpState extends State<LoginNoHp> {
  String? status;
  String? NoHp;
  String? errMessage;
  String? session = "0";

  @override
  void initState() {
    super.initState();
  }

  Future<void> loginNoHpNasabah(String hp) async{
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

  TextEditingController noHpcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Exitbaru(sessionStateStream: widget.sessionStateStream).showExitPopup(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 68.0),
              ),
              const SizedBox(height: 40),
              Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_jcikwtux.json',
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(right: 32, left: 32),
                child: Container(
                  height: 66,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Stack(
                    children: [
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                          setState(() => NoHp = number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        //ignoreBlank: false,
                        selectorTextStyle: const TextStyle(color: Colors.black),
                        textFieldController: noHpcontroller,
                        formatInput: false,
                        countries: const ['ID'],
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        inputDecoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Nomor Handphone'),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Theme(
                data:
                    Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: RawMaterialButton(
                  onPressed: () async {
                    var re = RegExp(r'\d{2}');
                    var replaceNo = NoHp?.replaceFirst(re, '0');
                    var fixNo = replaceNo?.replaceAll(RegExp('[^A-Za-z0-9]'), '');
                    // SharedPreferences prefsId =
                    // await SharedPreferences.getInstance();
                    // await prefsId.setString('noHpNasabah', fixNo!);
                    await loginNoHpNasabah(fixNo!);
                    print("Fix NO HP :${fixNo}");
                    print("No HP : $fixNo");
                    print("statuscode: ${status!}");
                      if (NoHp!.length < 11){
                        // await SharedPreferences.getInstance();
                        // await prefsId.setString('noHpNasabah', "085892791204");
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message:
                            "Pastikan Isian Nomor Hp Benar",
                          ),
                        );
                      }else{
                        PleaseWait(context);
                        if(status == "00"){
                          Navigator.pop(context);
                          SharedPreferences prefsId =
                          await SharedPreferences.getInstance();
                          await prefsId.setString('noHpNasabah', fixNo);
                          widget.sessionStateStream.add(SessionState.stopListening);
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Verifikasi(sessionStateStream: widget.sessionStateStream)), );
                        }else {
                          Navigator.pop(context);
                          Alert(context, errMessage!);
                        }
                      }

                  },
                  fillColor: const Color.fromRGBO(10, 109, 237, 1.0),
                  constraints:
                      const BoxConstraints(minHeight: 50, minWidth: 170),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  child: const Text('Lanjutkan'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 32, left: 32),
                child: Center(
                  child: Text(
                    "Dengan Masuk atau Mendaftar, Kamu menyetujui Syarat dan Ketentuan dari Bank Madiun",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 310,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ));
  }
}


