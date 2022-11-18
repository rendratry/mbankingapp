// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/helper/alert.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../model/ava_model.dart';
import '../pages/conecttion.dart';
import '../widgets/customwidget.dart';
import '../widgets/exitalert.dart';
import 'login_screen.dart';

class PasswordUpdate extends StatefulWidget {
  const PasswordUpdate({Key? key}) : super(key: key);

  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  final sessionStateStream = StreamController<SessionState>();
  TextEditingController pw1Controller = TextEditingController();
  TextEditingController pw2Controller = TextEditingController();
  bool isChecked = false;

  final _formKey = GlobalKey<FormFieldState>();
  RegExp passvalid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double passwordstrength = 0;

  bool validatePassword(String pass) {
    String password = pass.trim();
    if (password.isEmpty) {
      setState(() {
        passwordstrength = 0;
      });
    } else if (password.length < 4) {
      setState(() {
        passwordstrength = 1 / 4;
      });
    } else if (password.length < 6) {
      setState(() {
        passwordstrength = 2 / 4;
      });
    } else {
      if (passvalid.hasMatch(password)) {
        setState(() {
          passwordstrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordstrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  String? NoHp;
  String? cif;
  String? status;
  String? ketPassword;
  String? errMessage;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences hp = await SharedPreferences.getInstance();
    String? NoHp = hp.getString('noHpNasabah');
    SharedPreferences cifnasabah = await SharedPreferences.getInstance();
    String? cif = cifnasabah.getString('cif');
    SharedPreferences msg = await SharedPreferences.getInstance();
    String? errmsg = msg.getString('errMessage');

    setState(() => this.NoHp = NoHp);
    setState(() => this.cif = cif);
    setState(() => errMessage = errmsg);
  }

  Future updatePassword(
      String noHp, String cif, String pw) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode({
        "method": "marstech.update_lupa_password",
        "cif": cif,
        "no_hp": noHp,
        "password": pw
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => status = decodeData.status);
      SharedPreferences prefsId = await SharedPreferences.getInstance();
      await prefsId.setString('errMessage', decodeData.message);
      if (status == "00") {
        var dataDecode = AvaModel.fromJson(jsonDecode(response.body));
        setState(() => ketPassword = dataDecode.data[0].ket);
      }
      return statuscode;
    } catch (e) {
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
        statusBarIconBrightness: Brightness.light // status bar color
        ));
    return WillPopScope(
      onWillPop: () => Exitbaru(sessionStateStream: sessionStateStream)
          .showExitPagePopup(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 50,
          width: 294,
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: FloatingActionButton(
              backgroundColor: const Color(0xff0A6DED),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () async {
                PleaseWait(context);
                  if (pw1Controller.text == pw2Controller.text) {
                    Navigator.pop(context);
                    if(passwordstrength == 4 / 4){
                      await updatePassword(NoHp!, cif!, pw1Controller.text);
                      if (status == "00") {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message: ketPassword!,
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginDemo(sessionStateStream: sessionStateStream,),
                          ),
                        );
                      } else {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message: errMessage!,
                          ),
                        );
                      }
                    }else{
                      showTopSnackBar(
                        context,
                        const CustomSnackBar.error(
                          message: "Password belum memenuhi syarat",
                        ),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message: "Mohon isi password dengan benar",
                      ),
                    );
                  }
              },
              child: const Text(
                "Lanjutkan",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      "Silakan buat password baru",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                CustomPassword.textField(
                  autofocus: true,
                  key: _formKey,
                  onchanged: (value) => _formKey.currentState!.validate(),
                  hinttext: "Password",
                  //length: 6,
                  textController: pw1Controller,
                  prefixIcon: SvgPicture.asset(
                    "assets/svg/lock.svg",
                    fit: BoxFit.scaleDown,
                  ),
                  suffixicon: IconButton(
                    icon: Icon(
                      _isObscure1 ? Icons.visibility : Icons.visibility_off, color: MbankingColor.biru4,),
                    onPressed: () {
                      setState(() {
                        _isObscure1 = !_isObscure1;
                      });
                    }, padding: const EdgeInsets.only(right: 10),),
                  cornerRadius: 30.0,
                  secure: _isObscure1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter password";
                    } else {
                      //call function to check password
                      bool result = validatePassword(value);
                      if (result) {
                        // create account event
                        return null;
                      } else {
                        return "Sandi harus ada huruf kapital, kecil, angka dan karakter spesial";
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
                  child: LinearProgressIndicator(
                    value: passwordstrength,
                    backgroundColor: Colors.grey[300],
                    minHeight: 5,
                    color: passwordstrength <= 1 / 4
                        ? Colors.red
                        : passwordstrength == 2 / 4
                            ? Colors.yellow
                            : passwordstrength == 3 / 4
                                ? Colors.blue
                                : Colors.green,
                  ),
                ),
                CustomPassword.textField(
                  hinttext: "Konfirmasi Password",
                  textController: pw2Controller,
                  prefixIcon: SvgPicture.asset(
                    "assets/svg/lock.svg",
                    fit: BoxFit.scaleDown,
                  ),
                  suffixicon: IconButton(
                    icon: Icon(
                      _isObscure2 ? Icons.visibility : Icons.visibility_off, color: MbankingColor.biru4,),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    }, padding: const EdgeInsets.only(right: 10),),
                  cornerRadius: 30.0,
                  secure: _isObscure2,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
