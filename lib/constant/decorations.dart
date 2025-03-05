import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class Decorations {
  Decorations._();

  static BoxDecoration textBox = BoxDecoration(
    color: const Color(0xffF7F8FA),
    borderRadius: BorderRadius.circular(27),
    boxShadow: [
      BoxShadow(
        color: const Color(0xff251F30).withOpacity(0.05),
        offset: const Offset(0, 13),
        spreadRadius: 0.2,
        blurRadius: 55,
        blurStyle: BlurStyle.outer
      ),
    ],
  );

}
