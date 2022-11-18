import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbanking_app/src/model/ewallet.dart';
import 'package:mbanking_app/src/widgets/num_pad.dart';

class Continueewallet extends StatefulWidget {
  final Ewallet modalewallet;
  const Continueewallet({Key? key, required this.modalewallet}) : super(key: key);

  @override
  State<Continueewallet> createState() => _ContinueewalletState();
}

class _ContinueewalletState extends State<Continueewallet> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final TextEditingController _myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
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
            'Masukan Nomor',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1.0),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10, left: 27, right: 27),
          child: Column(
            children: [
              FlipCard(
                flipOnTouch: false,
                direction: FlipDirection.VERTICAL,
                key: cardKey,
                front: Column(
                  children: [
                    Container(
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
                            widget.modalewallet.logoE,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(widget.modalewallet.namaE, style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        autofocus: true,
                        controller: _myController,
                        keyboardType: TextInputType.none,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Masukan Nomor Hp / E-wallet',
                          hintTextDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RawMaterialButton(
                      onPressed: () => cardKey.currentState!.toggleCard(),
                      fillColor: const Color.fromRGBO(10, 109, 237, 1.0),
                      constraints:
                          const BoxConstraints(minHeight: 49, minWidth: 340),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      child: const Text('Masuk'),
                    ),
                    NumPad(
                      buttonSize: 55,
                      buttonColor: Colors.black,
                      iconColor: Colors.black,
                      controller: _myController,
                      delete: () {
                        _myController.text = _myController.text
                            .substring(0, _myController.text.length - 1);
                      },
                      // do something with the input numbers
                    ),
                  ],
                ),
                back: Container(
                  margin: const EdgeInsets.only(bottom: 450),
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 27),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0x26000000)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/dana.svg',
                        height: 50,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Rendra Tri K',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("0896746858", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
