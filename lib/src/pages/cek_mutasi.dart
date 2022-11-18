import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbanking_app/src/model/mutasi_model.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/exception_handler.dart';
import 'conecttion.dart';

class CekMutasi extends StatefulWidget {
  const CekMutasi({super.key});

  @override
  State<CekMutasi> createState() => _CekMutasiState();
}

class _CekMutasiState extends State<CekMutasi> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  List<MutasiModel> listMutasi = [];
  List<RekTabunganModel> listTabungan = [];
  MutasiRepository mutasiRepository = MutasiRepository();

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future getRekTabungan(String username, String password) async {
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
        Iterable it = jsonDecode(response.body)["rekening_tabungan"];
        List<RekTabunganModel> tabungan =
        it.map((e) => RekTabunganModel.fromJson(e)).toList();
        print("ini transaksi mutasi :" + tabungan.toString());
        return tabungan;
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

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? username = server.getString('register');
    String? noRek = server.getString('rekTabungan');
    String? pw = server.getString('pw');
    listTabungan = await getRekTabungan(username!, pw!);
    print("ini list mutasi : " + listTabungan.toString());
    setState(() => listTabungan = listTabungan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Mutasi',
          style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: MbankingColor.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Cari Mutasi',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Image.asset(
                        'assets/png/bank-cards.png',
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Expanded(
                        child: Text(
                          'Pilih Reekening',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: listTabungan
                      .map((item) => DropdownMenuItem<String>(
                    value: item.rekening,
                    child: Text(
                      item.rekening,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 60,
                  buttonWidth: MediaQuery.of(context).size.width,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  itemHeight: 40,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(0, 0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences server = await SharedPreferences.getInstance();
                    String? username = server.getString('register');
                    String? noRek = selectedValue;
                    String? pw = server.getString('pw');
                    listMutasi = await mutasiRepository.getData(username!, pw!, noRek!);
                    setState(() => listMutasi = listMutasi);
                    print("ini list mutasi : " + listMutasi.toString());
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(MbankingColor.biru3),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    child: Text(
                      'Cari Data',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                ),
              )
            ]),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listMutasi.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${listMutasi[index].keterangan} [${listMutasi[index].id}]',
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '(${listMutasi[index].dk}) ${NumberFormat.currency(
                                    locale: 'id',
                                    decimalDigits: 0,
                                    symbol: 'Rp ',
                                  ).format(int.parse(listMutasi[index].jumlah))}',
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              '(${listMutasi[index].kodeTransaksi})',
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listMutasi[index].tgl,
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 11,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                      symbol: 'Rp ',
                                    ).format(
                                        int.parse(listMutasi[index].saldo)),
                                    style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                    ),
                    const Divider(
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
