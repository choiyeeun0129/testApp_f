import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final String? lottie;

  const IndicatorWidget({super.key, this.width, this.height, this.color, this.lottie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height,
      color: color,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}