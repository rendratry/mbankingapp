import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mbanking_app/src/widgets/customwidget.dart';

class TransferPage2 extends StatefulWidget {
  const TransferPage2({Key? key}) : super(key: key);

  @override
  State<TransferPage2> createState() => _TransferPage2State();
}

class _TransferPage2State extends State<TransferPage2> {
  String avatarDef =
      'https://resources.premierleague.com/premierleague/photos/players/250x250/p14937.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/svg/arrow_left.svg',
              color: const Color(0xff355070),
              height: 40,
              width: 40,
            )),
        title: const Text(
          "Transfer Antar Member",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color(0xff355070),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 17, left: 27, right: 27),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25),
              height: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x26000000)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(avatarDef),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Cristiano Ronaldo",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: const Color(0xffFFB575),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x26000000))),
                        child: const Text(
                          "274625487",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        "Saldo : 500.000",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Color(0xff757575),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset('assets/svg/transfer_arrow.svg'),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25),
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x26000000)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(avatarDef),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Viorella Sunghaion VK",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "082143090698",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Color(0xff757575)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                CustomWidgets.textField(
                    title: 'Nominal Transfer',
                    cornerRadius: 10.0,
                    isNumber: true,
                    hinttext: "Rp"),
                const SizedBox(
                  height: 10,
                ),
                CustomWidgets.textField(
                  title: 'Keterangan',
                  cornerRadius: 10.0,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 50, left: 50),
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent),
                ),
                child: RawMaterialButton(
                  onPressed: () {},
                  fillColor: const Color(0xff0A6DED),
                  constraints:
                      const BoxConstraints(minHeight: 49, minWidth: 128),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  child: const Text('Transfer'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
