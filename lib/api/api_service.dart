import 'dart:developer';

import 'package:gnu_mot_t/api/api_client.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';
import 'package:gnu_mot_t/manager/info_manager.dart';
import 'package:gnu_mot_t/manager/storage_manager.dart';
import 'package:http/http.dart' as http;

abstract class APIService {
  Map<String, String> get commonHeader => {
    'Content-Type': 'application/json',
    "Accept": "application/json",
  };

  Map<String, String> get defaultHeader => {
    'Content-Type': 'application/json; charset=utf-8',
    "Accept": "application/json; charset=utf-8",
  };

  Map<String, String> get authorizationHeader {
    var accessToken = infoManager.accessToken;
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      "Accept": "application/json",
    };
  }

  Future<Map<String, String>> get refreshHeader async {
    var accessToken = infoManager.accessToken;
    String refreshToken = await storageManager.getRefreshToken() ?? "";
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Cookie": refreshToken,
    };
  }

  // String get baseUrl => "https://pbnt.kr/gnumot";
  String get baseUrl => "http://10.0.2.2:16001";

  ApiClient get client => ApiClient();

  Future<http.Response> executeWithRetry(Future<http.Response> Function(Map<String, String> headers) apiCall) async {
    // 첫 번째 시도
    var response = await apiCall(authorizationHeader);

    // 토큰 만료 체크 (401 에러)
    if (response.statusCode == 401) {
      // 토큰 갱신 시도
      try {
        String accessToken = await authService.getRefreshToken();
        await infoManager.setAccessToken(accessToken);
        response = await apiCall(authorizationHeader);

      } catch (e) {
        log("executeWithRetry/e: $e");
        infoManager.logOut("Token Expired");
        rethrow;
      }
    }
    return response;
  }

  // static const String _cookieKey = 'refresh_token_cookie';
  // void _saveCookie(List<String>? cookies) {
  //   if (cookies != null && cookies.isNotEmpty) {
  //     for (String cookie in cookies) {
  //       if (cookie.contains('refresh_token')) {
  //         prefs.setString(_cookieKey, cookie);
  //         break;
  //       }
  //     }
  //   }
  // }
}
