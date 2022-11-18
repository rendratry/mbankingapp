import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  const LoadingBar({super.key});
  @override
  State<LoadingBar> createState() => _LoadingBar();
}

class _LoadingBar extends State<LoadingBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/gif/loading-dot-bar.gif',
          width: 100,
          height: 100
      ),);
  }
}

