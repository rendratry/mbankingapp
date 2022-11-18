import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mbanking_app/src/model/transaksi.dart';
import 'package:mbanking_app/src/theme/mbanking_color.dart';

class DetailTransaksiPage extends StatelessWidget {
  final ModelTransaksi displayListTransaksi;
  const DetailTransaksiPage({super.key, required this.displayListTransaksi});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.height;
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          )),
      title: const Text(
        'Detail Transaksi',
        style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black),
      ),
    );
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: mediaQueryWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 29,
                    ),
                    SizedBox(
                      child: displayListTransaksi.status == 'SUCCESS'
                          ? SvgPicture.asset(
                              'assets/svg/icon_berhasil.svg',
                            )
                          : null,
                    ),
                    Text(
                      displayListTransaksi.status == 'SUCCESS'
                          ? 'Berhasil'
                          : 'Gagal',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: displayListTransaksi.status == 'SUCCESS'
                              ? MbankingColor.green
                              : Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 58,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Transaki',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.jenisTransaksi,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Faktur',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.faktur,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Dari',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.dariUser,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Tujuan',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.tujuanUser,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Nominal',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                          .format(displayListTransaksi.nominal),
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Keterangan',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.keterangan,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Status',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          color: displayListTransaksi.status == 'SUCCESS'
                              ? MbankingColor.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        displayListTransaksi.status,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Tanggal',
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 11,
                          color: MbankingColor.grey2),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      displayListTransaksi.tanggalTransaksi,
                      style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: displayListTransaksi.status == 'SUCCESS'
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    backgroundColor: MaterialStateProperty.all(
                                        MbankingColor.biru3)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  child: Text(
                                    'Download Bukti',
                                    style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
