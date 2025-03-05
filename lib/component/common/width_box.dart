import 'package:flutter/material.dart';

class WidthBox extends StatelessWidget {
  final double? width;

  const WidthBox(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}