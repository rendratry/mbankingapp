import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbanking_app/src/model/riwayattopup.dart';
import 'package:mbanking_app/src/widgets/custom_page_route.dart';
import 'package:mbanking_app/src/widgets/modal_trigger.dart';
import 'package:mbanking_app/src/widgets/transaction_page_ewallet.dart';
import 'package:page_transition/page_transition.dart';

// ignore: use_key_in_widget_constructors
class TopUp extends StatefulWidget {
  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  TextEditingController emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            'Uang Elektronik',
            style: TextStyle(
              color: Color.fromRGBO(41, 45, 50, 1.0),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: SvgPicture.asset('assets/svg/ewallet_illustration.svg')),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
            child: TextField(
              showCursor: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Cari Riwayat',
                suffixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.search,
                  ),
                ),
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
              "Riwayat",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: topuplist.length,
              itemBuilder: (BuildContext context, int index) {
                final ModelTopup modelTopup = topuplist[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 32.0,
                      right: 32.0,
                    ),
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: EwalletTransaction(
                                  modelTopup: modelTopup,
                                ),
                                type: PageTransitionType.bottomToTop,
                                duration: const Duration(milliseconds: 400),
                                reverseDuration:
                                    const Duration(milliseconds: 400),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                modelTopup.logo,
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      modelTopup.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      '${modelTopup.nomer}',
                                    ),
                                    Text(
                                      modelTopup.tamggal,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            "assets/svg/recyclebin.svg",
                            height: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: const ModalTrigger(),
      ),
    );
  }
}
