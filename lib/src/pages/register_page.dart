import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:mbanking_app/src/model/registerakun_model.dart';
import 'package:mbanking_app/src/widgets/customwidget.dart';
import 'package:mbanking_app/src/widgets/modal_trigger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../helper/exception_handler.dart';
import '../model/FalseModel_Model.dart';
import '../model/cekcif_model.dart';
import 'conecttion.dart';

class RegisScreen extends StatefulWidget {
  const RegisScreen({Key? key}) : super(key: key);

  @override
  State<RegisScreen> createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
  bool isChecked = false;
  bool nasabahChecked = false;
  bool loadinglist = false;
  String? NoHp;
  String? namaNasabah;
  String? status;
  String? regisMsg;
  String? errMessage;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? NoHp = server.getString('noHpNasabah');
    SharedPreferences m = await SharedPreferences.getInstance();
    String? regisMsg = m.getString('registerMessage');
    setState(() => this.NoHp = NoHp);
    setState(() => this.regisMsg = regisMsg);

    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: regisMsg!,
      ),
    );
  }

  Future<void> cekCIF(String cif) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode(
          {"method": "marstech.valid_cif_number", "no_hp": NoHp, "cif": cif});
      var response = await http.post(Uri.parse("http://" + baseUrl!),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      var statuscode = setState(() => this.status = decodeData.status);
      setState(() => this.errMessage = decodeData.message);
      if (status == "00") {
        var dataDecode = CekCifModel.fromJson(jsonDecode(response.body));
        print(dataDecode.data[0].nama);
        SharedPreferences prefsId = await SharedPreferences.getInstance();
        await prefsId.setString('namaNasabah', dataDecode.data[0].nama);
        setState(() => namaNasabah = dataDecode.data[0].nama);
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
    var noHpToDisplay = NoHp.toString();
    var namaToDisplay = namaNasabah.toString();
    TextEditingController cifcontroller = TextEditingController();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 68.0),
                child: Text(
                  'Register Akun',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color.fromRGBO(41, 45, 50, 1.0),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Image.asset(
                'assets/png/regis.png',
                width: 280,
                height: 250,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    CustomWidgets.textField(
                      textController: cifcontroller,
                      isNumber: true,
                      hinttext: "Kode Register / CIF",
                      prefixIcon: SvgPicture.asset(
                        "assets/svg/lock.svg",
                        fit: BoxFit.scaleDown,
                      ),
                      cornerRadius: 30.0,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/mobile.svg",
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text(
                              noHpToDisplay,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF909091),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loadinglist
                        ? Row(
                            children: [
                              Lottie.network(
                                  "https://assets3.lottiefiles.com/packages/lf20_fyye8szy.json",
                                  height: 30),
                              const Text(
                                "Checking",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : Container(),
                    nasabahChecked
                        ? Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 25),
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0x26000000)),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreatePassword()),
                                    );
                                  },
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
                                      Text(
                                        "Nama Lengkap :",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            color: Color(0xff757575)),
                                      ),
                                      Text(
                                        namaToDisplay,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    RawMaterialButton(
                      onPressed: () async {
                        await cekCIF(cifcontroller.text);
                        setState(() {
                          loadinglist = true;
                        });
                        if (status == "03") {
                          setState(() {
                            nasabahChecked = false;
                            loadinglist = false;
                          });
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: errMessage!,
                            ),
                          );
                        } else if (status == "00") {
                          setState(() {
                            nasabahChecked = true;
                          });
                          SharedPreferences prefsId =
                              await SharedPreferences.getInstance();
                          await prefsId.setString('cif', cifcontroller.text);
                          if (nasabahChecked == true) {
                            setState(() {
                              loadinglist = false;
                            });
                          }
                        } else {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "Kode CIF Tidak Terdaftar",
                            ),
                          );
                        }
                        //_showModallBottomSheet(context);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const CreatePinPage(),
                        //   ),
                        // );
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
                      child: const Text('Cek CIF'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //button regis
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     TextButton(
                    //       style: TextButton.styleFrom(
                    //         primary: const Color(0xff0A6DED),
                    //         textStyle: const TextStyle(
                    //             fontWeight: FontWeight.normal, fontSize: 15),
                    //       ),
                    //       child: const Text("Saya Sudah Punya Akun", style: TextStyle(fontWeight: FontWeight.bold),),
                    //       onPressed: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: (context) => const LoginDemo(),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  custombutton() {
    TextButton(
      onPressed: () {},
      child: const Text("Syarat dan Ketetentuan"),
    );
  }
}

_showModallBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: CreatePassword(),
          ),
        );
      });
}
