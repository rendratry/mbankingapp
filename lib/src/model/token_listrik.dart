class TokenListrik {
  String nama;
  int harga;

  TokenListrik({
    required this.nama,
    required this.harga,
  });
}

List<TokenListrik> listTokenListrik = [
  TokenListrik(nama: 'Token PLN 20.000', harga: 21000),
  TokenListrik(nama: 'Token PLN 50.000', harga: 50500),
  TokenListrik(nama: 'Token PLN 70.000', harga: 70500),
  TokenListrik(nama: 'Token PLN 100.000', harga: 100500),
  TokenListrik(nama: 'Token PLN 150.000', harga: 150500),
];
