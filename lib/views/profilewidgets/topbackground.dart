import 'package:flutter/material.dart';

class TopBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
        width: _width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/images/mount.png', fit: BoxFit.cover));
  }
}
