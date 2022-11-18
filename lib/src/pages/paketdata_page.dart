import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/paketdata.dart';

class Paketdata extends StatefulWidget {
  const Paketdata({Key? key}) : super(key: key);

  @override
  State<Paketdata> createState() => _PaketdataState();
}

class _PaketdataState extends State<Paketdata> {
  List<PaketData> paketdatacategory = Paket.getPaketDataCategory();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: paketdatacategory.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0x26000000)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Continueewallet()),
                // );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paketdatacategory[index].providerdata,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "HARGA",
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        NumberFormat.currency(
                                locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                            .format(paketdatacategory[index].hargadata),
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
