import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mbanking_app/src/helper/loading_bar.dart';
import 'package:mbanking_app/src/model/baki_debet_model.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';
import 'package:mbanking_app/src/widgets/bottom_sheet_baki_debet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mbanking_app/src/model/mutasi_model.dart';

import '../helper/exception_handler.dart';
import '../theme/mbanking_color.dart';
import 'conecttion.dart';

class CekBakiDebet extends StatefulWidget {
  const CekBakiDebet({super.key});

  @override
  State<CekBakiDebet> createState() => _CekBakiDebetState();
}

class _CekBakiDebetState extends State<CekBakiDebet> {

  List<BakiDebetModel> listBakiDebet = [];
  int? noRek = 0;
  String? namaNasabah = "0";
  int? saldo = 0;
  String? err;
  bool haveRekening = true;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    listBakiDebet = await getBakiDebet();
    print("ini list mutasi : " + listBakiDebet.toString());
    setState(() => listBakiDebet = listBakiDebet);
  }

  Future getBakiDebet() async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      String? userName = server.getString('register');
      String? pw = server.getString('pw');
      final msg = jsonEncode(
          {
            "method": "marstech.get_register",
            "username":userName,
            "password":pw
          }
      );
      var response = await http.post(
          Uri.parse(
              "http://"+baseUrl!),
          headers: {},
          body: msg);

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body)["rekening_kredit"];
        print("ini coba : $it");
        if(it.toString() == "[{rekening: KOSONG}]"){
          setState(() => haveRekening = false);
        }else{
          setState(() => haveRekening = true);
          List<BakiDebetModel> deposito =
          it.map((e) => BakiDebetModel.fromJson(e)).toList();
          print("ini transaksi mutasi :" + deposito.toString());
          return deposito;
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


  @override
  Widget build(BuildContext context) {


    List displayBakiDebet = List.from(listBakiDebet);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Baki Debet',
          style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: listBakiDebet == [] ?  LoadingBar():
      haveRekening == false ?  Center(
        child: Lottie.network('https://assets3.lottiefiles.com/packages/lf20_mxuufmel.json',
            width: 300,
            height: 300
        ),):
      err != null ?
      ConnectionPage(
        error: err!,
        button: false,
      ):
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
                itemCount: displayBakiDebet.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(
                            20
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0x26000000),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/png/bankmadiun.png', height: 35,),
                                const Spacer(),
                                displayBakiDebet[index].status == "aktif" ? Container(
                                  decoration: BoxDecoration(
                                      color: MbankingColor.bggreen,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child:  Row(
                                    children: [
                                      Text(displayBakiDebet[index].status, style: TextStyle(color: MbankingColor.contentgreen, fontSize: 12),),
                                      SizedBox(width: 5,),
                                      Icon(Icons.check_circle, color: MbankingColor.contentgreen, size: 12)
                                    ],
                                  ),
                                ) :
                                Container(
                                  decoration: BoxDecoration(
                                      color: MbankingColor.bggred,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  padding: EdgeInsets.all(5),

                                  child:  Row(
                                    children: [
                                      Text(displayBakiDebet[index].status, style: TextStyle(color: MbankingColor.contentred, fontSize: 12),),
                                      SizedBox(width: 5,),
                                      Icon(Icons.close_rounded, color: MbankingColor.contentred, size: 12,)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${displayBakiDebet[index].rekening}',
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  displayBakiDebet[index].nama,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return BottomSheetBakiDebet(
                                displayBakiDebet: displayBakiDebet[index]);
                          },
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
    );
  }
}
