class ModelTransaksi {
  String jenisTransaksi;
  String faktur;
  String dariUser;
  String tujuanUser;
  int noRekening;
  String tanggalTransaksi;
  int nominal;
  String keterangan;
  String status;

  ModelTransaksi(
      {required this.jenisTransaksi,
      required this.faktur,
      required this.dariUser,
      required this.tujuanUser,
      required this.noRekening,
      required this.tanggalTransaksi,
      required this.nominal,
      required this.keterangan,
      required this.status});
}

List listTransaksi = [
  ModelTransaksi(
      jenisTransaksi: 'Transfer Sesama',
      faktur: '#TF101201103160001',
      dariUser: 'Rendra Tri Kusuma (2748899288)',
      tujuanUser: 'Viorella Sunghaiyon VK (2748899280)',
      noRekening: 10110035447,
      tanggalTransaksi: '5 September 2022',
      nominal: 200000,
      keterangan: 'Buat Beli Seblak',
      status: 'SUCCESS'),
  ModelTransaksi(
      jenisTransaksi: 'Transfer Sesama',
      faktur: '#TF101201103160001',
      dariUser: 'Pandu D S (2748899288)',
      tujuanUser: 'Ngab Ridho (2748899280)',
      noRekening: 10110035447,
      tanggalTransaksi: '5 September 2022',
      nominal: 5000,
      keterangan: 'Mencari Info',
      status: 'GAGAL'),
  ModelTransaksi(
      jenisTransaksi: 'Transfer Sesama',
      faktur: '#TF101201103160001',
      dariUser: 'Rendra Tri Kusuma (2748899288)',
      tujuanUser: 'Viorella Sunghaiyon VK (2748899280)',
      noRekening: 10110035447,
      tanggalTransaksi: '5 September 2022',
      nominal: 50000,
      keterangan: 'Buat Beli Seblak',
      status: 'SUCCESS'),
  ModelTransaksi(
      jenisTransaksi: 'Transfer Sesama',
      faktur: '#TF101201103160001',
      dariUser: 'Ngab Ridho (2748899288)',
      tujuanUser: 'Pandu D S (2748899280)',
      noRekening: 10110035447,
      tanggalTransaksi: '5 September 2022',
      nominal: 2500000,
      keterangan: 'Buat Beli Kinderjoy',
      status: 'GAGAL'),
  
];
