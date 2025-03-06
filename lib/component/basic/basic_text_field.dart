import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testApp/constant/colors.dart';

class BasicTextField extends StatefulWidget {
  final String hintText;
  final double fontSize;
  final double height;
  final TextEditingController controller;
  final Color hintColor;
  final String subText;
  final bool enabled;
  final bool autoFocus;
  final bool isObscure;
  final TextInputType keyboardType;
  final double? width;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function? onError;
  final List<TextInputFormatter>? inputFormatterList;

  @override
  _BasicTextFieldState createState() => _BasicTextFieldState();

  const BasicTextField(this.hintText, this.controller, {
    super.key,
    this.fontSize = 14,
    this.height = 18,
    this.hintColor = const Color(0xff818080),
    this.subText = "TEXT",
    this.enabled = true,
    this.autoFocus = false,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.width,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onError,
    this.inputFormatterList,
  });
}

class _BasicTextFieldState extends State<BasicTextField> {
  late bool _isObscure;
  late TextEditingController _textEditingController;
  late InputDecoration _decoration;

  @override
  void initState() {
    _isObscure = widget.isObscure;
    _textEditingController = widget.controller;
    _decoration = const InputDecoration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle typo = TextStyle(fontSize: widget.fontSize, height: widget.fontSize/widget.height, color: AppColors.black, fontWeight: FontWeight.w400);
    _decoration = InputDecoration(
      hintText: widget.hintText,
      contentPadding: const EdgeInsets.all(16),
      filled: true,
      fillColor: Colors.transparent,
      // 테두리도 없애고 싶다면
      border: InputBorder.none,
      hintStyle: typo.copyWith(color: widget.hintColor),
    );

    if(widget.isObscure){
      _decoration = _decoration.copyWith(suffixIcon: _passwordSuffix);
    }

    return Container(
      alignment: Alignment.center,
      height: widget.height,
      child: TextField(
        inputFormatters: widget.inputFormatterList,
        onChanged: (text) {
          widget.onChanged?.call(text);
        },
        cursorColor: AppColors.black,
        textAlignVertical: TextAlignVertical.center,
        enabled: widget.enabled,
        style: typo,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType,
        controller: _textEditingController,
        autofocus: widget.autoFocus,
        textInputAction: widget.textInputAction,
        decoration: _decoration,
      ),
    );
  }

  Widget get _passwordSuffix {
    return SizedBox(
        child: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: (!_isObscure
              ? const Icon(
            Icons.remove_red_eye,
            size: 24,
            color: AppColors.black,
          )
              : const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.remove_circle_outline,
              size: 24,
              color: AppColors.black,
            ),
          )),
        ));
  }
}
