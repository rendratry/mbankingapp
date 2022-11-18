import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future NoHpNotFound(context) async {
  return  showDialog(
      context: context,
      builder: (context) =>AlertDialog(
        title: Stack(
          clipBehavior: Clip.none, alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 200, 20, 10),
                  child:  const Text("No Hp Belum Terdaftar Mohon Register Terlebih Dahulu",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(53, 80, 210, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -60,
              child: Lottie.network('https://assets4.lottiefiles.com/packages/lf20_qszkkg7n.json',
                  width: 300,
                  height: 300
              ),
            ),
          ],
        ),
      )

  );
}

TapBounceContainer wrongCodeVerif(context) {
  return TapBounceContainer(
    onTap: () {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:
          "There is some information. You need to do something with that",
        ),
      );
    },
    child: Text("Show info"),
  );
}