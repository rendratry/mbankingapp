class RiwayatTransfer {
  String namaakun;
  String avaname;
  String nohp;

  RiwayatTransfer({
    required this.avaname,
    required this.namaakun,
    required this.nohp,
  });
}

class Riwayat {
  static List<RiwayatTransfer> getRiwayatTransferCategory() {
    return [
      RiwayatTransfer(
        avaname: 'https://pngimg.com/uploads/ostrich/ostrich_PNG76980.png',
        namaakun: 'sdr. Pandu Dwi Saputra',
        nohp: "082143090698",
      ),
      RiwayatTransfer(
        avaname:
            'https://assets-a1.kompasiana.com/items/album/2017/10/11/fa4eb39b-fcfe-47a2-b60f-d778a1297192-59dda141bde5757bb35671f5.jpeg',
        namaakun: 'Ridho Walidhayin Rifai',
        nohp: "089764782947",
      ),
    ];
  }
}
