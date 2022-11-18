// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/widgets/auth.dart';
import 'package:mbanking_app/src/widgets/db_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mbanking_app/src/widgets/navigation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/alert.dart';
import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../model/login_model.dart';
import '../widgets/exitalert.dart';
import 'conecttion.dart';
import 'metode_lupa_password_page.dart';

// ignore: must_be_immutable
class LoginDemo extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  String loggedOutReason;
  LoginDemo(
      {Key? key, required this.sessionStateStream, this.loggedOutReason = ""})
      : super(key: key);

  @override
  State<LoginDemo> createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  TextEditingController userController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  String? status;
  String? errMessage;
  String? noHp;
  bool _isObscure = true;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    if (widget.loggedOutReason != "") {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: widget.loggedOutReason,
          boxShadow: const [],
        ),
      );
    }
    _initPackageInfo();
  }

  Future<bool?> loginNasabah(String username, String pw) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode(
          {"method": "marstech.login", "username": username, "password": pw});
      var response = await http.post(Uri.parse("http://" + baseUrl!),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => status = decodeData.status);
      setState(() => errMessage = decodeData.message);
      if (status == "00") {
        var dataDecode = LoginModel.fromJson(jsonDecode(response.body));
        setState(() => noHp = dataDecode.data[0].noHp);
        SharedPreferences noNasabah = await SharedPreferences.getInstance();
        await noNasabah.setString('noNasabah', dataDecode.data[0].noHp);
        SharedPreferences cif = await SharedPreferences.getInstance();
        await cif.setString('cif', dataDecode.data[0].cif);
        SharedPreferences nama = await SharedPreferences.getInstance();
        await nama.setString('namaNasabah', dataDecode.data[0].nama);
        SharedPreferences rek = await SharedPreferences.getInstance();
        await rek.setString('rekTabungan', dataDecode.data[0].rekeningTab);
        SharedPreferences alamat = await SharedPreferences.getInstance();
        await alamat.setString('alamat', dataDecode.data[0].alamat);
        //print(response.body);
        return true;
      } else {
        return false;
      }
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

  DateTime datetime = DateTime.now();

  Future<bool> exitbackprees() async {
    var diferenceTime = DateTime.now().difference(datetime);

    var checkDuration = diferenceTime >= const Duration(seconds: 2);

    if (checkDuration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tekan Sekali Lagi Untuk Keluar")),
      );
      datetime = DateTime.now();
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Widget _infoTile(String title) {
  //   return Text(
  //     title,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark // status bar color
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => Exitbaru(sessionStateStream: widget.sessionStateStream)
            .exitOnly(context),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 68.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color.fromRGBO(58, 57, 57, 1.0),
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Image.asset(
                'assets/png/logo-login-bankmadiun.png',
                width: 280,
                height: 200,
              ),
              // if (widget.loggedOutReason != "")
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 10,
              //       horizontal: 15,
              //     ),
              //     child: Text(widget.loggedOutReason),
              //   ),

              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: userController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: const TextStyle(
                            color: Color(0xff909091),
                            fontWeight: FontWeight.normal),
                        prefixIcon: SvgPicture.asset(
                          "assets/svg/user.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fillColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: pwController,
                      obscureText: _isObscure,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off, color: MbankingColor.biru4,),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }, padding: const EdgeInsets.only(right: 10),),
                        hintStyle: const TextStyle(
                            color: Color(0xff909091),
                            fontWeight: FontWeight.normal),
                        prefixIcon: SvgPicture.asset(
                          "assets/svg/lock.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child:
                      //Login button
                      RawMaterialButton(
                    onPressed: () async {
                      SharedPreferences no = await SharedPreferences.getInstance();
                      String? noNasabah = no.getString('noHpNasabah');
                      if (userController.text == "") {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message: "Masukkan Data Login Dengan Benar",
                          ),
                        );
                      } else if (pwController.text == "") {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message: "Masukkan Data Login Dengan Benar",
                          ),
                        );
                      } else {
                        PleaseWait(context);
                        await loginNasabah(userController.text, pwController.text);
                        if (status == "00") {
                          if (
                          noHp == noNasabah
                          ) {
                            Navigator.pop(context);
                            SharedPreferences pw =
                                await SharedPreferences.getInstance();
                            await pw.setString('pw', pwController.text);
                            SharedPreferences register =
                                await SharedPreferences.getInstance();
                            await register.setString(
                                'register', userController.text);
                            widget.sessionStateStream
                                .add(SessionState.startListening);
                            widget.loggedOutReason =
                                await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => NavigationPage(
                                  sessionStateStream: widget.sessionStateStream,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: "Data Login Tidak Dikenali",
                              ),
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
                      }
                    },
                    fillColor: const Color(0xff0A6DED),
                    constraints:
                        const BoxConstraints(minHeight: 49, minWidth: 128),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text('Masuk'),
                  )),
              const SizedBox(
                height: 30,
              ),
              //button regis
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xff0A6DED),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    ),
                    child: const Text("Lupa kata Sandi ?"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MetodeUpdatePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              //Function Biometric
              if (_supportState == _SupportState.unknown)
                const CircularProgressIndicator()
              else if (_supportState == _SupportState.supported)
                Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: IconButton(
                    iconSize: 50,
                    icon: const Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Color(0xff0A6DED),
                    ),
                    onPressed: () async {
                      DbProvider().getAuthState().then((value) async {
                        if (value == false) {
                          showDialog(
                              context: context,
                              builder: (ctx) => const AlertDialog(
                                    title: Text("Biometric Belum Aktif"),
                                  ));
                          return null;
                        } else {
                          bool isAuthenticated =
                              await AuthService.authenticateUser(value);

                          if (isAuthenticated) {
                            widget.sessionStateStream
                                .add(SessionState.startListening);
                            widget.loggedOutReason =
                                await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => NavigationPage(
                                  sessionStateStream: widget.sessionStateStream,
                                ),
                              ),
                            );
                          } else {}
                        }
                      });
                    },
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              Text('App version ${_packageInfo.version}')
              // else
              //   const Text(
              //     'This device is not supported',
              //     style: TextStyle(
              //       color: Colors.white,
              //       height: 1.5,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
