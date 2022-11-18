import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/widgets/navigation.dart';

class VerPinPage extends StatefulWidget {
  const VerPinPage({Key? key}) : super(key: key);

  @override
  State<VerPinPage> createState() => _VerPinPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const VerPinPage());
  }
}

class _VerPinPageState extends State<VerPinPage> {
  TextEditingController pinController = TextEditingController();
  List<String> currentPin = ["", "", "", "", "", ""];
  TextEditingController firstPinController = TextEditingController();
  TextEditingController secondPinController = TextEditingController();
  TextEditingController thirdPinController = TextEditingController();
  TextEditingController fourthPinController = TextEditingController();
  TextEditingController fifthPinController = TextEditingController();
  TextEditingController sixthPinController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  int pinIndex = 0;

  pinIndexSetup(String text) {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 6) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    if (pinIndex == 6) {
      validatePin();
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        firstPinController.text = text;
        break;
      case 2:
        secondPinController.text = text;
        break;
      case 3:
        thirdPinController.text = text;
        break;
      case 4:
        fourthPinController.text = text;
        break;
      case 5:
        fifthPinController.text = text;
        break;
      case 6:
        sixthPinController.text = text;
        break;
    }
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 6) {
      setPin(pinIndex, '');
      currentPin[pinIndex - 1] = '';
      pinIndex--;
    } else {
      setPin(pinIndex, '');
      currentPin[pinIndex - 1] = '';
      pinIndex--;
    }
  }

  clearAllPin() {
    pinIndex = 0;
    firstPinController.text = '';
    secondPinController.text = '';
    thirdPinController.text = '';
    fourthPinController.text = '';
    fifthPinController.text = '';
    sixthPinController.text = '';
    currentPin = ["", "", "", "", "", ""];
  }

  validatePin() {
    String pin = currentPin.join();
    if (pin.length == 6) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavigationPage(sessionStateStream: null!,)));
    } else {
      clearAllPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/svg/arrow_left.svg',
            width: 30,
            height: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Buat PIN Transaksi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: const Alignment(0, 0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 85),
                      buildSecurityText(),
                      const SizedBox(height: 85),
                      const Text(
                        'Konfirmasi PIN',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildPinRow(),
                    ],
                  ),
                ),
              ),
              buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  buildSecurityText() {
    return const Text(
      "Ketikkan sekali lagi pin yang kamu masukkan\n",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontSize: 13,
      ),
    );
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: firstPinController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: secondPinController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: thirdPinController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: fourthPinController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: fifthPinController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: sixthPinController,
        ),
      ],
    );
  }

  buildNumberPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup('1');
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup('2');
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup('3');
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup('4');
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup('5');
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup('6');
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup('7');
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup('8');
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup('9');
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 60),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup('0');
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        clearPin();
                      },
                      icon: const Icon(
                        Icons.backspace_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  const PinNumber({
    Key? key,
    required this.textEditingController,
    required this.outlineInputBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(13),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
        ),
        style: const TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;

  const KeyboardNumber({
    Key? key,
    required this.n,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: const EdgeInsets.all(8),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        height: 90,
        child: Text(
          n.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            fontFamily: 'poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
