import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/model/riwayattopup.dart';

import 'currency_formatter.dart';
import 'num_pad.dart';
import 'numpad_nominal.dart';

class EwalletTransaction extends StatefulWidget {
  final ModelTopup modelTopup;
  const EwalletTransaction({Key? key, required this.modelTopup})
      : super(key: key);

  @override
  State<EwalletTransaction> createState() => _EwalletTransactionState();
}

class _EwalletTransactionState extends State<EwalletTransaction> {
  TextEditingController Nominalcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Top Up Ewallet',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x26000000)),
                ),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      widget.modelTopup.logo,
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.modelTopup.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text('${widget.modelTopup.nomer}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 32.0,
                right: 32.0,
              ),
              child: Text(
                "Masukkan Nominal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
              child: TextFormField(
                  controller: Nominalcontroller,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyPtBrInputFormatter()
                  ],
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Cth : Rp 50.000',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: NumPadNominal(
                buttonSize: 55,
                buttonColor: Colors.black,
                iconColor: Colors.black,
                controller: Nominalcontroller,
                currency: CurrencyPtBrInputFormatter(),
                delete: () {
                  Nominalcontroller.text = Nominalcontroller.text
                      .substring(0, Nominalcontroller.text.length - 1);
                },
                // do something with the input numbers
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RawMaterialButton(
              onPressed: () {},
              fillColor: const Color.fromRGBO(10, 109, 237, 1.0),
              constraints: const BoxConstraints(minHeight: 55, minWidth: 200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              child: const Text('Selesai'),
            )
          ]),
    );
  }
}
