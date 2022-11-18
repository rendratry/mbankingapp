import 'dart:convert';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class InputPin extends StatefulWidget {
  @override
  State<InputPin> createState() => _InputPinState();
}


class _InputPinState extends State<InputPin> {
  List<String> currentPin = ["", "", "", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  TextEditingController pinFiveController = TextEditingController();
  TextEditingController pinSixController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.blue),
  );

  int pinIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 69.0)),
        Expanded(
          child: Container(
            alignment: const Alignment(0, 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildSecurityText(),
                const SizedBox(height: 40.0),
                buildPinRow(),
                const SizedBox(height: 40.0),
                buildButton(),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildSecurityText() {
    return const Text("Masukan PIN Kamu",
        style: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
          fontWeight: FontWeight.bold,
        ));
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinOneController,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinTwoController,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinThreeController,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinFourController,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinFiveController,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinSixController,
        ),
      ],
    );
  }

  buildButton() {
    var pin1 = pinOneController.text;
    var pin2 = pinTwoController.text;
    var pin3 = pinThreeController.text;
    var pin4 = pinFourController.text;
    var pin5 = pinFiveController.text;
    var pin6 = pinSixController.text;
    var pinString = pin1.toString()+pin2.toString()+pin3.toString()+pin4.toString()+pin5.toString()+pin6.toString();
    return RawMaterialButton(
      onPressed: () async {
      },
      fillColor: const Color.fromRGBO(53, 80, 112, 1),
      constraints: const BoxConstraints(minHeight: 49, minWidth: 128),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      child: const Text('Masuk'),
    );
  }
}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  // ignore: use_key_in_widget_constructors
  const PINNumber(
      {required this.textEditingController, required this.outlineInputBorder});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50.0,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            controller: textEditingController,
            obscureText: true,
            textAlign: TextAlign.center,
            showCursor: false,
            maxLength: 1,
            decoration: InputDecoration(
              counter: const Offstage(),
              contentPadding: const EdgeInsets.all(16.0),
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              filled: true,
              fillColor: Colors.white30,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21.0,
              color: Colors.black,
            ),
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
                debugPrint(value);
              }
              if (value.isEmpty) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ));
  }
}
