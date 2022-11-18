// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../model/registerakun_model.dart';
import '../pages/conecttion.dart';
import '../pages/login_screen.dart';
import '../theme/mbanking_color.dart';
import '../widgets/customwidget.dart';

class PasswordCreate extends StatefulWidget {
  const PasswordCreate({Key? key}) : super(key: key);

  @override
  State<PasswordCreate> createState() => _PasswordCreateState();
}

class _PasswordCreateState extends State<PasswordCreate> {
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
  String? namaNasabah;
  String? cif;
  String? status;
  String? errMessage;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences hp = await SharedPreferences.getInstance();
    String? NoHp = hp.getString('noHpNasabah');
    SharedPreferences noNasabah = await SharedPreferences.getInstance();
    await noNasabah.setString('teleponNasabah', NoHp!);
    SharedPreferences cifnasabah = await SharedPreferences.getInstance();
    String? cif = cifnasabah.getString('cif');
    SharedPreferences nama = await SharedPreferences.getInstance();
    String? namaNasabah = nama.getString('namaNasabah');
    SharedPreferences msg = await SharedPreferences.getInstance();
    String? errmsg = msg.getString('errMessage');

    setState(() => this.NoHp = NoHp);
    setState(() => this.cif = cif);
    setState(() => this.namaNasabah = namaNasabah);
    setState(() => errMessage = errmsg);
  }

  Future<void> registerNasabah(String noHp, String cif, String nama, String pw) async {
    try{
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode({
        "method": "marstech.new_register_mobile",
        "no_hp": noHp,
        "cif": cif,
        "nama": nama,
        "password": pw
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => status = decodeData.status);
      SharedPreferences prefsId = await SharedPreferences.getInstance();
      await prefsId.setString('errMessage', decodeData.message);
      if (status == "00") {
        var dataDecode = RegisterAkunModel.fromJson(jsonDecode(response.body));
        print(dataDecode.data[0].noHp);
      }
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: MbankingColor.biru3,
        statusBarIconBrightness: Brightness.light// status bar color
    ));
    var namaToDisplay = namaNasabah.toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
          'Buat Password Akun',
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
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25),
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x26000000)),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image.asset('assets/png/user.png'),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Nama Lengkap :",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Color(0xff757575)),
                          ),
                          Text(
                            namaToDisplay,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 19,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Lottie.network(
                      "https://assets10.lottiefiles.com/private_files/lf30_yABbl9.json",
                      height: 50),
                  const Flexible(
                    child:  Text(
                      "Username anda akan dibuat secara otomatis oleh sistem dan akan dikirimkan melalui sms ke nomor telephone anda",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
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
                cornerRadius: 30.0,
                secure: true,
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
                padding: const EdgeInsets.only(top: 12,right: 12,left: 12),
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
                cornerRadius: 30.0,
                secure: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  "Dengan Mendaftar Saya Menyetujui Syarat dan Ketentuan yang berlaku",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
                ),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              RawMaterialButton(
                onPressed: () async {
                  if (pw1Controller.text == pw2Controller.text) {
                    if(isChecked == true){
                      if(passwordstrength == 4 / 4){
                        await registerNasabah(
                            NoHp!, cif!, namaNasabah!, pw1Controller.text);
                        if (status == "00") {
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
                    }else{
                      showTopSnackBar(
                        context,
                        const CustomSnackBar.error(
                          message: "Centang untuk menyetujui syarat dan ketentuan",
                        ),
                      );
                    }
                  } else {
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.error(
                        message: "Konfirmasi Password Tidak Sama",
                      ),
                    );
                  }
                },
                fillColor: const Color(0xff0A6DED),
                constraints: const BoxConstraints(minHeight: 49, minWidth: 128),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}