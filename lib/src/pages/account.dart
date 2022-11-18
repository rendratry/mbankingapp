import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/widgets/buttom_sheet_passwordverifikasi.dart';
import 'package:mbanking_app/src/widgets/db_provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _secured = false;

  @override
  void initState() {
    super.initState();

    DbProvider().getAuthState().then((value) {
      setState(() {
        _secured = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: MbankingColor.biru3,
        statusBarIconBrightness: Brightness.dark// status bar color
    ));
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
              color: const Color(0xff3a3939),
              height: 30,
              width: 30,
            )),
        title: const Text(
          "Keamanan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff3a3939),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            ListTile(
              title: const Text("Keamanan Akun"),
              subtitle: const Text("Aktifkan login dengan biometric"),
              trailing: Switch(
                value: _secured,
                onChanged: ((value) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: SizedBox(
                          height: 300,
                          child: BottomSheetPassword(
                            secured: value,
                          ),
                        ),
                      );
                    },
                  );
                  setState(() {
                    _secured = value;
                  });
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
