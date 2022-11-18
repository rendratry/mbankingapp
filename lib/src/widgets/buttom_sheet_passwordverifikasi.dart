import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mbanking_app/src/widgets/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BottomSheetPassword extends StatelessWidget {
  final bool secured;
  const BottomSheetPassword({super.key, required this.secured});

  @override
  Widget build(BuildContext context) {
    TextEditingController pwController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 151),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEBEBEB),
              ),
            ),
          ),
          const SizedBox(
            height: 19,
          ),
          const Text(
            'Masukkan Password',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          TextFormField(
            controller: pwController,
            obscureText: true,
            obscuringCharacter: '*',
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: const TextStyle(
                  color: Color(0xff909091),
                  fontWeight: FontWeight.normal),
              prefixIcon: SvgPicture.asset(
                "assets/svg/lock.svg",
                fit: BoxFit.scaleDown,
              ),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: Colors.transparent),
              child: RawMaterialButton(
                onPressed: () async {
                  SharedPreferences server = await SharedPreferences.getInstance();
                  String? pw = server.getString('pw');
                  if(pwController.text != ""){
                    if(pwController.text == pw){
                      Navigator.pop(context);
                      AuthService.authenticateUser(secured);
                    }else if(pwController.text != pw){
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: "Password Salah",
                        ),
                      );
                    }else{
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: "Error tidak diketahui",
                        ),
                      );
                    }
                  }else{
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message: "Masukkan Password Untuk Melanjutkan",
                      ),
                    );
                  }
                  // AuthService.authenticateUser(secured);
                },
                fillColor: const Color(0xff0A6DED),
                constraints:
                const BoxConstraints(minHeight: 49, minWidth: 150),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                child: const Text('Konfirmasi'),
              )),
        ],
      ),
    );
  }
}
