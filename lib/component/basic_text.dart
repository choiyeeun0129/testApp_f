import 'package:flutter/material.dart';

class BasicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign? textAlign;


  const BasicText(this.text, this.fontSize, this.lineHeight, this.fontWeight, {super.key,
    this.textColor = const Color(0xff000000),
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: textColor, height: lineHeight/fontSize), textAlign: textAlign);
  }
}