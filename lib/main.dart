import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gnu_mot_t/app.dart';
import 'package:flutter/material.dart';
import 'package:gnu_mot_t/util/my_http_overrides.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:package_info_plus/package_info_plus.dart';


// 최종수정본 릴리즈제발

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initConfiguration();
}

Future<void> initConfiguration() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // // 전체 화면 모드 설정
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

// 상태 바 색상 설정 (스플래시 배경과 동일한 색상으로 설정)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffffffff),  // ✅ 상태 바 색상을 스플래시 배경과 동일하게 설정
    // statusBarIconBrightness: Brightness.dark, // ✅ 상태 바 아이콘 색상 (어두운 배경이면 Light 설정)
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 기본 세로 모드
  ]);

  try {
    // 카카오 SDK 초기화
    KakaoSdk.init(
      nativeAppKey: "1a9ab80ceb1bd6387d29fb2167c0fef1",
      javaScriptAppKey: "5afb45818a2adc5e9bb6139738985ea9",
    );

    // 현재 사용 중인 키 해시 출력
    await printKeyHashes();

    log("카카오 SDK 초기화 성공");
  } catch (e) {
    log("카카오 SDK 초기화 실패: $e");
  }

  runApp(const App());
}

Future<void> printKeyHashes() async {
  try {
    // 디버그 키 해시 가져오기
    final debugKeyHash = await KakaoSdk.origin;
    log("디버그 키 해시: $debugKeyHash");

    // 패키지 정보 출력
    final packageInfo = await PackageInfo.fromPlatform();
    log("앱 패키지명: ${packageInfo.packageName}");
    log("앱 버전: ${packageInfo.version}");
    log("빌드 번호: ${packageInfo.buildNumber}");

    // 카카오 로그인 상태 확인
    if (await isKakaoTalkInstalled()) {
      log("카카오톡 설치됨");
    } else {
      log("카카오톡 미설치");
    }
  } catch (e) {
    log("키 해시 확인 중 오류: $e");
  }
}