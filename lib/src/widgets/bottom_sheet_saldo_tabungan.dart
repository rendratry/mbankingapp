// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';
import 'package:mbanking_app/src/widgets/saldo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../model/mutasi_model.dart';

class BottomSheetSaldoTabungan extends StatefulWidget {
  final RekTabunganModel displayTabungan;
  final ValueChanged<String> update;
  final String rekeningUtama;
  const BottomSheetSaldoTabungan(
      {super.key,
        required this.displayTabungan,
        required this.update,
        required this.rekeningUtama});

  @override
  State<BottomSheetSaldoTabungan> createState() => _BottomSheetSaldoTabunganState();
}

class _BottomSheetSaldoTabunganState extends State<BottomSheetSaldoTabungan> {
  int? rekDefault;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? NoRekDefault = server.getString('rekDefault');

    setState(() => rekDefault = int.parse(NoRekDefault!));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            'Detail Rekening',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            'Saldo',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            NumberFormat.currency(
              locale: 'id',
              decimalDigits: 0,
              symbol: 'Rp ',
            ).format(int.parse(widget.displayTabungan.saldo)),
            style: const TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0x26000000),
              ),
            ),
            child: Row(
              children: [
                Image.asset('assets/png/logo_bank_madiun.png'),
                const SizedBox(
                  width: 19,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.displayTabungan.rekening}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.displayTabungan.nama,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                  onPressed: widget.rekeningUtama != widget.displayTabungan.rekening
                      ? () async {
                    SharedPreferences noNasabah = await SharedPreferences.getInstance();
                    await noNasabah.setString('rekUtama', widget.displayTabungan.rekening);
                    widget.update(widget.displayTabungan.rekening);

                    showTopSnackBar(
                      context,
                      CustomSnackBar.success(
                        message: "Berhasil Mengganti Rekening Utama",
                      ),
                    );
                    LoadListCardSaldo();
                    Navigator.of(context).pop();
                  }
                      : null,
                  style: widget.rekeningUtama != widget.displayTabungan.rekening
                      ? ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(MbankingColor.biru3),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  )
                      : ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(MbankingColor.grey),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 23,
                    ),
                    child: Text(
                      'Jadikan Rekening Utama',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
