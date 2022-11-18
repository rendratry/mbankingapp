import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'currency_formatter.dart';

// KeyPad widget
// This widget is reusable and its buttons are customizable (color, size)
class NumPadNominal extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final TextInputFormatter currency;
  final Function delete;

  const NumPadNominal({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.iconColor = Colors.amber,
    required this.delete,
    required this.controller, required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right:0,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // implement the number keys (from 0 to 9) with the NumberButton widget
              // the NumberButton widget is defined in the bottom of this file
              children: [
                NumberButton(
                  number: 1,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 2,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 3,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberButton(
                  number: 4,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 5,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 6,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberButton(
                  number: 7,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 8,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 9,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // this button is used to delete the last number
                NumberButton(
                  number: 0,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                NumberButton(
                  number: 0,
                  size: buttonSize,
                  currency: CurrencyPtBrInputFormatter(),
                  controller: controller,
                ),
                // this button is used to submit the entered value
                IconButton(
                    onPressed: () => delete(),
                    icon: Icon(
                      Icons.backspace,
                      color: iconColor,
                      size: 30,
                    ),
                    iconSize: buttonSize
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// define NumberButton widget
// its shape is round
class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final TextEditingController controller;
  final TextInputFormatter currency;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.controller, required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: MaterialButton(

        onPressed: () {
          controller.text += number.toString();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26),
          ),
        ),
      ),
    );
  }
}
