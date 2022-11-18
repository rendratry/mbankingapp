import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mutasi_model.dart';

class BottomSheetSaldoDeposito extends StatelessWidget {
  final RekDepositoModel displayDeposito;
  const BottomSheetSaldoDeposito({super.key, required this.displayDeposito});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.3,
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
            'Deposito',
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
            ).format(int.parse(displayDeposito.nominal)),
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
                      '${displayDeposito.rekening}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      displayDeposito.nama,
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
        ],
      ),
    );
  }
}
