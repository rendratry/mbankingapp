import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbanking_app/src/widgets/customwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ubahprofil extends StatefulWidget {
  const Ubahprofil({Key? key}) : super(key: key);

  @override
  State<Ubahprofil> createState() => _UbahprofilState();
}

class _UbahprofilState extends State<Ubahprofil> {
  TextEditingController controller = TextEditingController();

  File? _profile;
  final picker = ImagePicker();
  CroppedFile? _croppedFoto;
  String? nama;
  String? ava =
      'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fuser.png?alt=media&token=8026a04d-d074-41fe-8cb8-37f1989e5fd5';
  String? noNasabah;

  Future getImageSource2(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 100,
    );

    setState(() {
      if (pickedFile != null) {
         _profile = File(pickedFile.path);
        _cropFoto();
      }
      if (pickedFile == null) return;
    });
  }

  Future<void> _cropFoto() async {
    if (_profile != null) {
      final croppedFoto = await ImageCropper().cropImage(
        sourcePath: _profile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: const Color(0xff355070),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFoto != null) {
        setState(() {
          _croppedFoto = croppedFoto;
        });
        //uploadImageToFirebase();
      }
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImageSource2(ImageSource.gallery);
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageSource2(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    SharedPreferences n = await SharedPreferences.getInstance();
    String? namaNasabah = n.getString('namaNasabah');
    String? ava = n.getString('ava');
    SharedPreferences no = await SharedPreferences.getInstance();
    String? noNasabah = no.getString('noNasabah');

    setState(() => this.noNasabah = noNasabah);
    setState(() => this.nama = namaNasabah);
    setState(() => this.ava = ava);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/svg/arrow_left.svg',
              color: const Color(0xff292d32),
              height: 40,
              width: 40,
            )),
        title: const Text(
          "Ubah Profil",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff292d32),
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(ava!),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          border: Border.all(color: const Color(0x26000000)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            getImageSource2(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            CupertinoIcons.camera,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          border: Border.all(color: const Color(0x26000000)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            getImageSource2(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.photo_library,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text("Nama Lengkap"),
                          ],
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
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  'nama!',
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
                        CustomWidgets.textField(
                          title: 'Username',
                          cornerRadius: 10.0,
                          ischange: true,
                          textController: controller,
                        ),
                        CustomWidgets.textField(
                          title: 'Password',
                          isNumber: true,
                          length: 10,
                          cornerRadius: 10.0,
                          secure: true,
                          ischange: true,
                        ),
                        CustomWidgets.textField(
                          title: 'Email',
                          cornerRadius: 10.0,
                          ischange: true,
                        ),
                        CustomWidgets.textField(
                          title: 'No Hp',
                          cornerRadius: 10.0,
                          isNumber: true,
                          ischange: false,
                        ),
                        const Text(
                          "! untuk mengubah nomer hp hubungi customer service",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
