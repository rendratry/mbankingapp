import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/model/simple_register_model.dart';
import 'package:mbanking_app/src/pages/cek_baki_debet.dart';
import 'package:mbanking_app/src/pages/cek_mutasi.dart';
import 'package:mbanking_app/src/pages/cek_nominal_deposito.dart';
import 'package:mbanking_app/src/pages/cek_saldo_tabungan.dart';
import 'package:mbanking_app/src/pages/transfer_page.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';
import 'package:mbanking_app/src/widgets/fitur_mbanking.dart';
import 'package:mbanking_app/src/widgets/refresh_widget.dart';
import 'package:mbanking_app/src/widgets/saldo_card.dart';
import 'package:mbanking_app/src/widgets/slider_dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/alert.dart';
import '../helper/exception_handler.dart';
import '../helper/loading_bar.dart';
import '../model/FalseModel_Model.dart';
import '../model/banner_model.dart';
import '../theme/mbanking_color.dart';
import 'conecttion.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  String? namaNasabah;
  String? ava;
  String? value;
  bool reload = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadList());
  }

  Future Banner() async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode({
        "method": "marstech.banner",
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      if (decodeData.status == "00") {
        var dataDecode = BannerModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefsId = await SharedPreferences.getInstance();
        await prefsId.setString('banner1', dataDecode.data[0].urlBanner);
        await prefsId.setString('banner2', dataDecode.data[1].urlBanner);
        await prefsId.setString('banner3', dataDecode.data[2].urlBanner);
      }
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
      );
    }
  }

  Future cekRegister() async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      String? userName = server.getString('register');
      String? pw = server.getString('pw');
      final msg = jsonEncode({
        "method": "marstech.get_register",
        "username": userName,
        "password": pw
      });
      var response = await http.post(Uri.parse("http://${baseUrl!}"),
          headers: {}, body: msg);
      print(response.body);
      var decodeData = FalseModel.fromJson(jsonDecode(response.body));
      if (decodeData.status == "00") {
        var dataDecode = SimpleModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefsId = await SharedPreferences.getInstance();
        await prefsId.setString('ava', dataDecode.foto);
        setState(() => ava = dataDecode.foto);
      }
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
      );
    }
  }

  Future loadList() async {
    keyRefresh.currentState?.show();
    await Future.delayed(const Duration(milliseconds: 500));
    SharedPreferences n = await SharedPreferences.getInstance();
    String? namaNasabah = n.getString('namaNasabah');
    setState(() => this.namaNasabah = namaNasabah);
    await Banner();
    await cekRegister();
    if (kDebugMode) {
      print("ini value : $value");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: MbankingColor.biru1,
          statusBarIconBrightness: Brightness.light),
    );
    String? nama = namaNasabah;
    String namaDefault = 'User Mbanking';
    String resultNama;

    if (nama == null) {
      resultNama = namaDefault;
    } else {
      resultNama = nama;
    }

    String avatarDefault =
        'https://firebasestorage.googleapis.com/v0/b/myfin-ktp.appspot.com/o/Logo%2Fuser.png?alt=media&token=8026a04d-d074-41fe-8cb8-37f1989e5fd5';
    String resultAvatar;
    if (ava == null) {
      resultAvatar = avatarDefault;
    } else if (ava == "-") {
      resultAvatar = avatarDefault;
    } else {
      resultAvatar = ava!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: resultNama == namaDefault
          ? const LoadingBar()
          : RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: loadList,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: SvgPicture.asset(
                          'assets/svg/Bg_Header.svg',
                          fit: BoxFit.fill,
                          color: MbankingColor.biru1,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, top: 10, right: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Halo,\n$resultNama',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.white),
                                    ),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(resultAvatar),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SaldoCard(
                                  reload: reload,
                                ),
                                const SizedBox(
                                  height: 26,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/saldo_tabungan.svg',
                                      textFitur: 'Saldo\nTabungan',
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const CekSaldoTabungan(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            reverseDuration: const Duration(
                                                milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Mutasi.svg',
                                      textFitur: 'Mutasi',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const CekMutasi(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            reverseDuration: const Duration(
                                                milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Transfer.svg',
                                      textFitur: 'Transfer\nSesama',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const TransferPage(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            reverseDuration: const Duration(
                                                milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Transfer antar bank.svg',
                                      textFitur: 'Transfer\nAntar Bank',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Deposit.svg',
                                      textFitur: 'Deposito',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const CekNominalDeposito(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            reverseDuration: const Duration(
                                                milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Angsuran.svg',
                                      textFitur: 'Angsuran',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Pengajuan.svg',
                                      textFitur: 'Pengajuan',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Kategori.svg',
                                      textFitur: 'Semua',
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (context) {
                                              return SizedBox(
                                                height: 326,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        151),
                                                            child: Container(
                                                              height: 5,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: const Color(
                                                                      0xFFEBEBEB)),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 46,
                                                          ),
                                                          const Text(
                                                            'Pilih Layanan',
                                                            style:
                                                                MbankingTypography
                                                                    .header3,
                                                          ),
                                                          const SizedBox(
                                                            height: 29,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/saldo_tabungan.svg',
                                                                textFitur:
                                                                    'Saldo\nTabungan',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      child:
                                                                          const CekSaldoTabungan(),
                                                                      type: PageTransitionType
                                                                          .bottomToTop,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      reverseDuration:
                                                                          const Duration(
                                                                              milliseconds: 400),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Mutasi.svg',
                                                                textFitur:
                                                                    'Mutasi',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      child:
                                                                          const CekMutasi(),
                                                                      type: PageTransitionType
                                                                          .bottomToTop,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      reverseDuration:
                                                                          const Duration(
                                                                              milliseconds: 400),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Transfer.svg',
                                                                textFitur:
                                                                    'Transfer\nSesama',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const TransferPage()));
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Transfer antar bank.svg',
                                                                textFitur:
                                                                    'Transfer\nAntar Bank',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  UnderDevelopment(
                                                                      context);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Deposit.svg',
                                                                textFitur:
                                                                    'Deposito',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      child:
                                                                          const CekNominalDeposito(),
                                                                      type: PageTransitionType
                                                                          .bottomToTop,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      reverseDuration:
                                                                          const Duration(
                                                                              milliseconds: 400),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Sisa Pokok.svg',
                                                                textFitur:
                                                                    'Sisa\nPokok',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      child:
                                                                          const CekBakiDebet(),
                                                                      type: PageTransitionType
                                                                          .bottomToTop,
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      reverseDuration:
                                                                          const Duration(
                                                                              milliseconds: 400),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Angsuran.svg',
                                                                textFitur:
                                                                    'Angsuran',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  UnderDevelopment(
                                                                      context);
                                                                },
                                                              ),
                                                              FiturMbanking(
                                                                iconFitur:
                                                                    'assets/svg/Pengajuan.svg',
                                                                textFitur:
                                                                    'Pengajuan',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  UnderDevelopment(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const SliderDashboard(),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Pembelian',
                                      style: MbankingTypography.header4,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Pulsa.svg',
                                      textFitur: 'Pulsa',
                                      onTap: () {
                                        UnderDevelopment(context);
                                        // Navigator.push(
                                        //   context,
                                        //   PageTransition(
                                        //     child: const PulsaPaketData(),
                                        //     type: PageTransitionType
                                        //         .bottomToTop,
                                        //     duration: const Duration(
                                        //         milliseconds: 400),
                                        //     reverseDuration: const Duration(
                                        //         milliseconds: 400),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Paket Data.svg',
                                      textFitur: 'Paket Data',
                                      onTap: () {
                                        UnderDevelopment(context);
                                        // Navigator.push(
                                        //   context,
                                        //   PageTransition(
                                        //     child: const PulsaPaketData(),
                                        //     type: PageTransitionType
                                        //         .bottomToTop,
                                        //     duration: const Duration(
                                        //         milliseconds: 400),
                                        //     reverseDuration: const Duration(
                                        //         milliseconds: 400),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Listrik.svg',
                                      textFitur: 'Token\nListrik',
                                      onTap: () {
                                        UnderDevelopment(context);
                                        // Navigator.push(
                                        //   context,
                                        //   PageTransition(
                                        //     child: const TokenListrik(),
                                        //     type: PageTransitionType
                                        //         .bottomToTop,
                                        //     duration: const Duration(
                                        //         milliseconds: 400),
                                        //     reverseDuration: const Duration(
                                        //         milliseconds: 400),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Paket Telpon dan SMS.svg',
                                      textFitur: 'Telepon\ndan SMS',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Topup EWallet.svg',
                                      textFitur: 'Top Up\nE-Wallet',
                                      onTap: () {
                                        UnderDevelopment(context);
                                        // Navigator.push(
                                        //     context,
                                        //     PageTransition(
                                        //       child: TopUp(),
                                        //       type: PageTransitionType
                                        //           .bottomToTop,
                                        //       duration: const Duration(
                                        //           milliseconds: 400),
                                        //       reverseDuration: const Duration(
                                        //           milliseconds: 400),
                                        //     ));
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Voucher game.svg',
                                      textFitur: 'Voucher Game',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/TV Berbayar.svg',
                                      textFitur: 'TV Berbayar',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Pulsa Transfer.svg',
                                      textFitur: 'Pulsa\nTransfer',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                const Divider(
                                  thickness: 3,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Pembayaran',
                                      style: MbankingTypography.header4,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/PDAM.svg',
                                      textFitur: 'PDAM',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Listrik Pascabayar.svg',
                                      textFitur: 'Listrik Non\nTaglist',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Internet.svg',
                                      textFitur: 'Telkom',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Paket Telpon dan SMS.svg',
                                      textFitur: 'BPJS\nKesehatan',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Celuler Pascabayar.svg',
                                      textFitur: 'Seluler',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/PBB.svg',
                                      textFitur: 'PBB',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur:
                                          'assets/svg/Listrik Non taglist.svg',
                                      textFitur: 'Listrik',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    ),
                                    FiturMbanking(
                                      iconFitur: 'assets/svg/Laporan.svg',
                                      textFitur: 'Laporan\nTransaksi',
                                      onTap: () {
                                        UnderDevelopment(context);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
