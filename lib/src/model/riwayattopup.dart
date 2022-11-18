class ModelTopup {
  String logo;
  String nama;
  int nomer;
  String tamggal;

  ModelTopup(
      {required this.logo,
      required this.nama,
      required this.nomer,
      required this.tamggal});
}

List topuplist = [
  ModelTopup(
    logo: 'assets/svg/dana.svg',
    nama: 'Rendra Tri Kusuma',
    nomer: 089574635246,
    tamggal: '28 Agustus 2022',
  ),
  ModelTopup(
    logo: 'assets/svg/shopeepay.svg',
    nama: 'Ridho Walidhayin Rifai',
    nomer: 08986725467,
    tamggal: '28 Agustus 2022',
  ),
  ModelTopup(
    logo: 'assets/svg/linkaja.svg',
    nama: 'Pandu Dwi Saputra',
    nomer: 089465273845,
    tamggal: '28 Agustus 2022',
  ),
  ModelTopup(
    logo: 'assets/svg/gopay.svg',
    nama: 'Untuk Kamu',
    nomer: 089374625748,
    tamggal: '28 Agustus 2022',
  ),
  ModelTopup(
    logo: 'assets/svg/ovo.svg',
    nama: 'Dari dia',
    nomer: 081983746567,
    tamggal: '28 Agustus 2022',
  ),
  
];
