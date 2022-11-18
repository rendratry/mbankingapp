import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mbanking_app/src/helper/alert.dart';
import 'package:mbanking_app/src/model/transaksi.dart';
import 'package:mbanking_app/src/pages/conecttion.dart';
import 'package:mbanking_app/src/pages/detail_transaksi_page.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TransaksiPage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const TransaksiPage({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  List searchList = List.from(listTransaksi);
  bool dev = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark// status bar color
    ));
    var dateTime = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Transaksi',
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.black),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0x33000000))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Tanggal Mulai',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w700,
                                    color: MbankingColor.biru3,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 50,
                                height: 50),
                            child: TextField(
                              controller: startDateController,
                              readOnly: true,
                              onTap: pickDateRange,
                              decoration: InputDecoration(
                                hintText:
                                    '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                contentPadding: const EdgeInsets.only(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                ),
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
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sampai Tanggal',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w700,
                                    color: MbankingColor.biru3,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 50,
                                height: 50),
                            child: TextField(
                              controller: endDateController,
                              readOnly: true,
                              onTap: pickDateRange,
                              decoration: InputDecoration(
                                hintText:
                                    '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                contentPadding: const EdgeInsets.only(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                ),
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
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        UnderDevelopment(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MbankingColor.biru3),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        child: Text(
                          'Cari Data',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            dev == true? Container():Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: searchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: DetailTransaksiPage(
                                  displayListTransaksi: searchList[index]),
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 400),
                              reverseDuration:
                                  const Duration(milliseconds: 400),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        padding:
                            const EdgeInsets.only(top: 17, left: 22, right: 22),
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0x33000000))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchList[index].faktur,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                                Text(
                                  'Rekening : ${searchList[index].noRekening}',
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans', fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                const Text(
                                  'Transfer',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: MbankingColor.biru3),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  searchList[index].tanggalTransaksi,
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans', fontSize: 9),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          decimalDigits: 0,
                                          symbol: 'Rp ')
                                      .format(searchList[index].nominal),
                                  style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      color:
                                          searchList[index].status == 'SUCCESS'
                                              ? MbankingColor.green
                                              : Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    searchList[index].status,
                                    style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
      startDateController.text =
          DateFormat('yyyy-MM-dd').format(newDateRange.start);
      endDateController.text =
          DateFormat('yyyy-MM-dd').format(newDateRange.end);
    });
  }
}
