import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyaratDanKetentuan extends StatefulWidget {
  const SyaratDanKetentuan({super.key});

  @override
  State<SyaratDanKetentuan> createState() => _SyaratDanKetentuanState();
}

class _SyaratDanKetentuanState extends State<SyaratDanKetentuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text(
            "Syarat dan Ketentuan",
            style: TextStyle(fontSize: 20, color: Colors.black),
          )
        ],
      ),
    );
  }
}
