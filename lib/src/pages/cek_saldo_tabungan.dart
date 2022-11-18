import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/helper/loading_bar.dart';
import 'package:mbanking_app/src/pages/conecttion.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';
import 'package:mbanking_app/src/widgets/bottom_sheet_saldo_tabungan.dart';
import 'package:mbanking_app/src/widgets/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helper/exception_handler.dart';
import '../model/mutasi_model.dart';

class CekSaldoTabungan extends StatefulWidget {
  const CekSaldoTabungan({super.key});

  @override
  State<CekSaldoTabungan> createState() => _CekSaldoTabunganState();
}

class _CekSaldoTabunganState extends State<CekSaldoTabungan> {
  List<RekTabunganModel> listTabungan = [];
  final sessionStateStream = StreamController<SessionState>();
  String? rekDefault;
  String? err;
  bool haveRekening = true;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    listTabungan = await getRekTabungan();
    print("ini list mutasi : " + listTabungan.toString());
    setState(() => listTabungan = listTabungan);
    SharedPreferences server = await SharedPreferences.getInstance();
    String? NoRekDefault = server.getString('rekDefault');

    setState(() => rekDefault = NoRekDefault);
  }

  Future getRekTabungan() async {
    try {
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

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body)["rekening_tabungan"];
        if (it.toString() == "[{rekening: KOSONG}]") {
          setState(() => haveRekening = false);
        } else {
          List<RekTabunganModel> tabungan =
              it.map((e) => RekTabunganModel.fromJson(e)).toList();
          print("ini transaksi mutasi :" + tabungan.toString());
          setState(() => haveRekening = true);
          return tabungan;
        }
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
      setState(() => err = error);
    }
  }

  late String _rekeningUtama = rekDefault!;

  void _update(String rekeningUtama) {
    setState(() => _rekeningUtama = rekeningUtama);
  }

  @override
  Widget build(BuildContext context) {
    List displayTabungan = List.from(listTabungan);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                NavigationPage(sessionStateStream: sessionStateStream)),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      NavigationPage(sessionStateStream: sessionStateStream)),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          title: const Text(
            'Info Saldo',
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: listTabungan == []
            ? const LoadingBar()
            : haveRekening == false
                ? Center(
                    child: Lottie.network(
                        'https://assets3.lottiefiles.com/packages/lf20_mxuufmel.json',
                        width: 300,
                        height: 300),
                  )
                : err != null
                    ? ConnectionPage(
                        error: err!,
                        button: false,
                      )
                    :
                    // Container(
                    //   color: Colors.white,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 120),
                    //     child: Column(
                    //       // mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Image.asset('assets/gif/no-connection.gif'),
                    //           const SizedBox(
                    //             height: 20,
                    //           ),
                    //           Text(
                    //             "Oops.. ${err!}",
                    //             style: TextStyle(
                    //               fontFamily: 'Poppins',
                    //               color: Color.fromRGBO(58, 57, 57, 1.0),
                    //               decoration: TextDecoration.none,
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //           const Text(
                    //             "Mohon Periksa Jaringan Anda dan Coba Lagi",
                    //             style: TextStyle(
                    //               fontFamily: 'Poppins',
                    //               decoration: TextDecoration.none,
                    //               color: Color.fromRGBO(58, 57, 57, 1.0),
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //         ]),
                    //   ),
                    // ):
                    Container(
                        padding: const EdgeInsets.only(top: 21),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pilih Nomer Rekening',
                              style: MbankingTypography.header4,
                            ),
                            const SizedBox(
                              height: 21,
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: displayTabungan.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 17,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0x26000000),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'assets/png/logo_bank_madiun.png'),
                                            const SizedBox(
                                              width: 19,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${displayTabungan[index].rekening}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  displayTabungan[index].nama,
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return BottomSheetSaldoTabungan(
                                              displayTabungan:
                                                  displayTabungan[index],
                                              rekeningUtama: _rekeningUtama,
                                              update: _update,
                                            );
                                          },
                                        );
                                        SharedPreferences noNasabah =
                                            await SharedPreferences
                                                .getInstance();
                                        await noNasabah.setString(
                                          'rekUtama',
                                          _rekeningUtama.toString(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
      ),
    );
  }
}
