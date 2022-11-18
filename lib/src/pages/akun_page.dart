import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/model/simple_register_model.dart';
import 'package:mbanking_app/src/pages/account.dart';
import 'package:mbanking_app/src/pages/generateqrscreen.dart';
import 'package:mbanking_app/src/pages/login_screen.dart';
import 'package:mbanking_app/src/pages/syaratdanketentuan.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../helper/alert.dart';
import '../helper/exception_handler.dart';
import '../helper/loading_bar.dart';
import '../model/FalseModel_Model.dart';
import '../model/ava_model.dart';
import '../model/cekregister_model.dart';
import 'conecttion.dart';

class AkunPage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const AkunPage({Key? key, required this.sessionStateStream})
      : super(key: key);

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  String? nama;
  String? ava ;
  String? noNasabah;
  final picker = ImagePicker();
  File? _profile;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    loadList();
  }

  Future cekRegister() async {
    try{
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      String? userName = server.getString('register');
      String? pw = server.getString('pw');
      final msg = jsonEncode({
        "method": "marstech.get_register",
        "username": userName,
        "password": pw
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      print(response.body);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      if (decodeData.status == "00") {
        var dataDecode = SimpleModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefsId = await SharedPreferences.getInstance();
        await prefsId.setString('ava', dataDecode.foto);
        setState(() => ava = dataDecode.foto);
      }
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


  Future loadList() async {
    await cekRegister();
    SharedPreferences n = await SharedPreferences.getInstance();
    String? namaNasabah = n.getString('namaNasabah');
    SharedPreferences no = await SharedPreferences.getInstance();
    String? noNasabah = no.getString('noNasabah');

    setState(() => this.noNasabah = noNasabah);
    setState(() => nama = namaNasabah);
  }

  Future getImageSource(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _profile = File(pickedFile.path);
      });
      _cropImage();
    }
    if (pickedFile == null) return;
  }

  Future<void> _cropImage() async {
    if (_profile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _profile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: MbankingColor.biru3,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
      if(croppedFile == null) return;
      final bytes = File(croppedFile.path).readAsBytesSync();
      String base64Image = "data:image/png;base64,${base64Encode(bytes)}";

      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode({
        "method": "marstech.update_foto_register",
        "no_hp": noNasabah,
        "file": base64Encode(bytes)
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      print(response.body);
      var dataDecode = AvaModel.fromJson(jsonDecode(response.body));

      if(dataDecode.status == "00"){
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: dataDecode.data[0].ket,
          ),
        );
       return loadList();
      }
      print("img_pan : $base64Image");
    }
  }

  void _showPicker(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImageSource(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageSource(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    String avatarDefault =
        'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fuser.png?alt=media&token=8026a04d-d074-41fe-8cb8-37f1989e5fd5';
    String resultAvatar;
    if (ava == null) {
      resultAvatar = avatarDefault;
    } else if(ava == "-"){
      resultAvatar = avatarDefault;
    }else{
      resultAvatar = ava!;
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark// status bar color
    ));
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 17, left: 27, right: 27),
        color: Colors.white,
        child: nama == null
            ? const LoadingBar()
            : ListView(
                children: [
                  //Judul halaman
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff292d32),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //Box data user
                  Container(
                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 20),
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x26000000)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(resultAvatar),
                            ),
                            Positioned(
                                bottom: -15,
                                left: 15,
                                child: RawMaterialButton(
                                  onPressed: () async {
                                    widget.sessionStateStream.add(SessionState.stopListening);
                                    _showPicker(context);
                                    widget.sessionStateStream.add(SessionState.startListening);
                                  },
                                  elevation: 0.0,
                                  fillColor: const Color(0xFFF5F6F9),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.blue,
                                  ),
                                )),
                          ],
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
                                "Akun Nasabah",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Color(0xff757575)),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                nama!,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                noNasabah!,
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Color(0xff757575)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Form Data Pribadi
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Akun",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     // Navigator.push(
                        //     //   context,
                        //     //   CupertinoPageRoute(
                        //     //       builder: ((context) => const Ubahprofil())),
                        //     // );
                        //   },
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           SvgPicture.asset('assets/svg/document2.svg',
                        //               height: 26, width: 26),
                        //           const SizedBox(
                        //             width: 21,
                        //           ),
                        //           const Text(
                        //             "Ubah Profil",
                        //             style: TextStyle(
                        //                 fontFamily: 'OpenSans', fontSize: 15),
                        //           ),
                        //           const Spacer(),
                        //           SvgPicture.asset(
                        //               'assets/svg/arrow_right.svg'),
                        //         ],
                        //       ),
                        //       const Divider(
                        //         color: Color(0xffE3E3FE),
                        //         height: 14,
                        //         thickness: 1,
                        //         indent: 44,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ]),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  //kode Qr
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const GenerateQr())),
                      );
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 25),
                      height: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0x26000000)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/qr_code_scan.svg',
                              height: 40, width: 40),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text(
                            "Tampilkan \nKode Qr ",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  //Akun & Keamanan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Akun & Keamanan",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ()),
                          // );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/document2.svg',
                                    height: 26, width: 26),
                                const SizedBox(
                                  width: 21,
                                ),
                                const Text(
                                  "Ajukan Perubahan Data",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans', fontSize: 15),
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/svg/arrow_right.svg'),
                              ],
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
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => PinLamascreen()),
                          // );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("assets/svg/keyprofile.svg",
                                    height: 26, width: 26),
                                const SizedBox(
                                  width: 21,
                                ),
                                const Text(
                                  "Ubah PIN",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans', fontSize: 15),
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/svg/arrow_right.svg'),
                              ],
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
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          if (_supportState == _SupportState.supported) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: ((context) => const Account())));
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => const AlertDialog(
                                title: Text(
                                    "Your device is not supported biometric"),
                              ),
                            );
                            return;
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/fingerprint.svg',
                                    height: 26, width: 26),
                                const SizedBox(
                                  width: 21,
                                ),
                                const Text(
                                  "Login Dengan Biometric",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans', fontSize: 15),
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/svg/arrow_right.svg'),
                              ],
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
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),

                  //Info Lainnya
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Info Lainnya",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/svg/medal_star.svg',
                                  height: 26, width: 26),
                              const SizedBox(
                                width: 21,
                              ),
                              const Text(
                                "Beri Rating",
                                style: TextStyle(
                                    fontFamily: 'OpenSans', fontSize: 15),
                              ),
                              const Spacer(),
                              SvgPicture.asset('assets/svg/arrow_right.svg'),
                            ],
                          ),
                          const Divider(
                            color: Color(0xffE3E3FE),
                            height: 14,
                            thickness: 1,
                            indent: 44,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: ((context) =>
                                  const SyaratDanKetentuan()),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/document.svg',
                                    height: 26, width: 26),
                                const SizedBox(
                                  width: 21,
                                ),
                                const Text(
                                  "Syarat dan Ketentuan",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans', fontSize: 15),
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/svg/arrow_right.svg'),
                              ],
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
                      const SizedBox(
                        height: 4,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/svg/shield.svg',
                                  height: 26, width: 26),
                              const SizedBox(
                                width: 21,
                              ),
                              const Text(
                                "Kebijakan Privasi",
                                style: TextStyle(
                                    fontFamily: 'OpenSans', fontSize: 15),
                              ),
                              const Spacer(),
                              SvgPicture.asset('assets/svg/arrow_right.svg'),
                            ],
                          ),
                          const Divider(
                            color: Color(0xffE3E3FE),
                            height: 14,
                            thickness: 1,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Logout(context);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => LoginDemo(
                          //             sessionStateStream:
                          //                 widget.sessionStateStream,
                          //           )),
                          // );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/upload.svg',
                                  height: 26,
                                  width: 26,
                                ),
                                const SizedBox(
                                  width: 21,
                                ),
                                const Text(
                                  "Keluar",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffE03A45)),
                                )
                              ],
                            ),
                            const Divider(
                              color: Color(0xffE3E3FE),
                              height: 14,
                              thickness: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
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
