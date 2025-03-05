import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String message) {
  if (Platform.isAndroid) {
    // 안드로이드에서는 showToastAt()을 사용해 위치 수동 설정
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP, // 기본적으로 TOP 적용
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    // iOS는 기본적으로 TOP에서 정상적으로 표시됨
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
