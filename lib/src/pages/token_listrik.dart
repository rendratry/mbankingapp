import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbanking_app/src/model/token_listrik.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';

class TokenListrik extends StatefulWidget {
  const TokenListrik({Key? key}) : super(key: key);

  @override
  State<TokenListrik> createState() => _TokenListrikState();
}

class _TokenListrikState extends State<TokenListrik> {
  String resultNamaToken = listTokenListrik[0].nama;
  int resultHargaToken = listTokenListrik[0].harga;
  bool isVisible = false;
  TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Token Listrik',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 33,
          left: 33,
          top: 33,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFDAE9FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 151),
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFEBEBEB),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 31,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 33),
                                child: Text(
                                  'Pilih Nominal',
                                  style: MbankingTypography.header3,
                                ),
                              ),
                              const SizedBox(
                                height: 49,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: listTokenListrik.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              resultNamaToken =
                                                  listTokenListrik[index].nama;
                                              resultHargaToken =
                                                  listTokenListrik[index].harga;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 33, vertical: 3),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: MbankingColor.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  listTokenListrik[index].nama,
                                                  style: const TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Harga',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 9),
                                                    ),
                                                    const SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      NumberFormat.currency(
                                                              locale: 'id',
                                                              decimalDigits: 0,
                                                              symbol: 'Rp ')
                                                          .format(
                                                              listTokenListrik[
                                                                      index]
                                                                  .harga),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$resultNamaToken(${NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp ').format(resultHargaToken)})",
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Transform.rotate(
                            angle: -90 * pi / 180,
                            child: const Icon(
                              Icons.arrow_back_ios,
                            )),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Masukkan Nomor ID Pelanggan',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: tokenController,
              maxLength: 12,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: MbankingColor.grey,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: MbankingColor.grey,
                  ),
                ),
                contentPadding: const EdgeInsets.all(17),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'No ID Pelanggan berjumlah 11 atau 12 digit',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 12,
                          color: Colors.redAccent),
                    ),
                    Icon(
                      Icons.warning,
                      size: 15,
                      color: Colors.redAccent,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (tokenController.text.length >= 11) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: 294,
                            margin: const EdgeInsets.only(
                              top: 37,
                              left: 48,
                              right: 48,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'No Pelanggan',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  tokenController.text,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'No Rekening',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  '55748759438390',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                const Text(
                                  'Nama',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  'Rendra Tri Kusuma',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'Tarif Daya',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  'R1 / 000000450',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                Expanded(
                                  child: Center(
                                      child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                MbankingColor.biru3),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        )),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        'Lanjut Beli Token',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          );
                        });
                    setState(() {
                      isVisible = false;
                    });
                  } else {
                    setState(() {
                      isVisible = true;
                    });
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(MbankingColor.biru3),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    )),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  child: Text(
                    'Cek ID Pelanggan',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
