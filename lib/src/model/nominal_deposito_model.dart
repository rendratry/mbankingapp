// ignore_for_file: non_constant_identifier_names

class NominalDepositoModel {
  int rekening;
  String nama;
  int nominal;

  NominalDepositoModel(
      {required this.rekening, required this.nama, required this.nominal});
}

List<NominalDepositoModel> rekening_deposito = [
  NominalDepositoModel(
      rekening: 1237485748, nama: 'Pandu Dwi Subandono', nominal: 9000000),
  NominalDepositoModel(
      rekening: 1237485740, nama: 'Pandu Dwi Subandono', nominal: 8000000),
  NominalDepositoModel(
      rekening: 1237485741, nama: 'Pandu Dwi Subandono', nominal: 7000000),
  NominalDepositoModel(
      rekening: 1237485743, nama: 'Pandu Dwi Subandono', nominal: 6000000),
  NominalDepositoModel(
      rekening: 1237485745, nama: 'Pandu Dwi Subandono', nominal: 5000000),
];
