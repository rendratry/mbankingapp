import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'paketdata_page.dart';
import 'pulsa_page.dart';

class PulsaPaketData extends StatefulWidget {
  const PulsaPaketData({Key? key}) : super(key: key);

  @override
  State<PulsaPaketData> createState() => _PulsaPaketDataState();
}

class _PulsaPaketDataState extends State<PulsaPaketData> {
  TextEditingController nominalcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Pulsa dan Paket Data',
            style: TextStyle(
              color: Color.fromRGBO(41, 45, 50, 1.0),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(right: 32, left: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Masukkan Nomor Handphone",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                showCursor: true,
                keyboardType: TextInputType.number,
                controller: nominalcontroller,
                maxLength: 13,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: '081554595532',
                  icon: SvgPicture.asset(
                    'assets/svg/contact.svg',
                    height: 45,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Masukan nomer tujuan terlebih dahulu, maka \nnominal akan muncul setelahnya',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const TabBar(
                labelColor: Color(0xff0a6ded),
                unselectedLabelColor: Color(0xff292d32),
                indicatorColor: Color(0xff0a6ded),
                tabs: [
                  Tab(
                      child: Text("Pulsa",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ))),
                  Tab(
                      child: Text("Paket Data",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          )))
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Pulsapage(),
                    Paketdata(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
