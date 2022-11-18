class PaketData {
  String providerdata;
  int hargadata;

  PaketData({required this.providerdata, required this.hargadata});
}

class Paket {
  static List<PaketData> getPaketDataCategory() {
    return [
      PaketData(
          providerdata: "FREEDOM INTERNET 5 GB / 3 HARI", hargadata: 14500),
      PaketData(
          providerdata: "FREEDOM INTERNET 2,5 GB / 5 HARI", hargadata: 11000),
      PaketData(
          providerdata: "FREEDOM INTERNET 7 GB / 5 HARI", hargadata: 20193),
      PaketData(
          providerdata: "FREEDOM INTERNET 2 GB / 30 HARI", hargadata: 16500),
      PaketData(
          providerdata: "FREEDOM INTERNET 6 GB / 30 HARI", hargadata: 30535),
    ];
  }
}
