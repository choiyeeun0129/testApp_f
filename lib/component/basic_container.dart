import 'package:flutter/material.dart';

class BasicContainer extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final Widget child;
  final BorderRadius? borderRadius;

  const BasicContainer({
    super.key,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15), // 기존 27에서 줄임
        border: Border.all(color: Color(0xff2155A8), width: 1.5), // 테두리 추가
      ),
      child: child,
    );
  }
}
