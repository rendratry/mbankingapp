class Pulsa {
  String provider;
  int harga;

  Pulsa({required this.provider, required this.harga});
}

class Pulsaisi{
  static List<Pulsa> getpulsaCategory(){
    return [
      Pulsa(provider: "ISAT IM3 / MENTARI REGULER 5RB", harga: 7425),
      Pulsa(provider: "ISAT IM3 / MENTARI REGULER 10RB", harga: 12500),
      Pulsa(provider: "ISAT IM3 / MENTARI REGULER 12RB", harga: 13467),
      Pulsa(provider: "ISAT IM3 / MENTARI REGULER 15RB", harga: 16610),
      Pulsa(provider: "ISAT IM3 / MENTARI REGULER 20RB", harga: 21350),
    ];
  }
}
