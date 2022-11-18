import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbanking_app/src/model/ewallet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'lis_ewallet.dart';

class Listewallet extends StatefulWidget {
  const Listewallet({Key? key}) : super(key: key);

  @override
  State<Listewallet> createState() => _ListewalletState();
}

class _ListewalletState extends State<Listewallet> {
  bool ischange = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          'Pilih Ewallet',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: ewalletcategory.length,
        itemBuilder: (BuildContext context, int index) {
          final Ewallet ewalletModel = ewalletcategory[index];
          return Container(
            margin: const EdgeInsets.only(top: 15, right: 27, left: 27),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      topRadius: const Radius.circular(20),
                      enableDrag: true,
                      context: context,
                      duration: const Duration(seconds: 1),
                      barrierColor: Colors.transparent,
                      builder: (context) => Container(
                        height: 650,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Continueewallet(modalewallet: ewalletModel,),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x26000000)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ewalletModel.logoE,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          ewalletModel.namaE,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
