import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/model/riwayattransfer.dart';
import 'package:mbanking_app/src/pages/transfer_page2.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/widgets/num_pad.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/alert.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  List<RiwayatTransfer> riwayatTransfer = Riwayat.getRiwayatTransferCategory();

  String? namaNasabah;
  String? saldo;
  String? noRek;
  String? ava;
  String? riwayat;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? nama = server.getString('namaNasabah');
    String? saldo = server.getString('saldo');
    String? noRek = server.getString('rekTabungan');
    String? ava = server.getString('ava');
    setState(() => namaNasabah = nama);
    setState(() => this.saldo = saldo);
    setState(() => this.noRek = noRek);
    setState(() => this.ava = ava);
  }

  String avatarDef =
      'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fuser.png?alt=media&token=8026a04d-d074-41fe-8cb8-37f1989e5fd5';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: 294,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: FloatingActionButton(
            backgroundColor: const Color(0xff0A6DED),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              UnderDevelopment(context);
              // showCupertinoModalPopup(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return Padding(
              //       padding: MediaQuery.of(context).viewInsets,
              //       child: Container(
              //           height: 650,
              //           decoration: const BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(20),
              //               topRight: Radius.circular(20),
              //             ),
              //           ),
              //           child: const Modalsheet()),
              //     );
              //   },
              // );
            },
            child: const Text(
              "Tambah Penerima",
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/svg/arrow_left.svg',
              color: const Color(0xff3a3939),
              height: 40,
              width: 40,
            )),
        title: const Text(
          "Transfer Antar Member",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff3a3939),
          ),
        ),
      ),
      body: namaNasabah == null
          ? Center(
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/packages/lf20_fyye8szy.json',
                  width: 100,
                  height: 100),
            )
          : Container(
              padding: const EdgeInsets.only(top: 17, left: 27, right: 27),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x26000000)),
                    ),
                    child: Row(
                      children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(ava!),
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
                                namaNasabah!,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff292d32)),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: MbankingColor.biru1,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0x26000000),
                                  ),
                                ),
                                child: Text(
                                  noRek!,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Saldo :"+saldo!,
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
                    height: 40,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Riwayat",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  riwayat == null
                      ? Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Lottie.network(
                                'https://assets3.lottiefiles.com/packages/lf20_mxuufmel.json',
                                width: 300,
                                height: 300),
                          ),
                        )
                      : Flexible(
                          child: ListView.builder(
                            itemCount: riwayatTransfer.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const TransferPage2()),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, right: 5, bottom: 0),
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 25),
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0x26000000)),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            riwayatTransfer[index].avaname),
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                riwayatTransfer[index].namaakun,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              riwayatTransfer[index].nohp,
                                              style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  color: Color(0xff757575)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            "assets/svg/recyclebin.svg",
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

class Modalsheet extends StatefulWidget {
  const Modalsheet({super.key});

  @override
  State<Modalsheet> createState() => ModalsheetState();
}

class ModalsheetState extends State<Modalsheet> {
  bool isvisible = false;
  Barcode? result;
  TextEditingController newcontroller = TextEditingController();

  @override
  void dispose() {
    newcontroller.dispose();
    super.dispose();
  }

  var image = Image.network(
    'https://randomuser.me/api/portraits/lego/5.jpg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                const Text(
                  "Masukkan Nomer Rekening Tujuan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: newcontroller,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: '14253746356',
                    ),
                  ),
                ),
                Visibility(
                  visible: isvisible,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: baru(),
                ),
                const SizedBox(
                  height: 50,
                ),
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      isvisible = !isvisible;
                    });
                  },
                  fillColor: const Color(0xff0A6DED),
                  constraints:
                      const BoxConstraints(minHeight: 50, minWidth: 320),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  child: const Text('Cek Nomer'),
                ),
                NumPad(
                  buttonSize: 55,
                  buttonColor: Colors.black,
                  iconColor: Colors.black,
                  controller: newcontroller,
                  delete: () {
                    newcontroller.text = newcontroller.text
                        .substring(0, newcontroller.text.length - 1);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget baru() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 10.0),
      child: Container(
        // margin: const EdgeInsets.only(top: 10, right: 5, bottom: 0),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25),
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x26000000)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: image.image,
            ),
            const SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Text(
                      'Viorela Sunghaiyon VK',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '1234362436472',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Color(0xff757575)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
