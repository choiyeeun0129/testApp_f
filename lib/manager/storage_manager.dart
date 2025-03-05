import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const IDENTIFY_MOBILE = "IDENTIFY_MOBILE";
const ENABLE_AUTO_LOGIN = "ENABLE_AUTO_LOGIN";
const ACCESS_TOKEN = "ACCESS_TOKEN";
const REFRESH_TOKEN = "REFRESH_TOKEN";

final storageManager = StorageManager();
class StorageManager {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future<String?> getIdentifyMobile() async {
    var pref = await _pref;
    var mobile = pref.getString(IDENTIFY_MOBILE);
    return mobile;
  }

  Future<void> setIdentifyMobile(String mobile) async {
    var pref = await _pref;
    await pref.setString(IDENTIFY_MOBILE, mobile);
  }

  Future<String?> getAccessToken() async {
    var pref = await _pref;
    return pref.getString(ACCESS_TOKEN);
  }

  Future<void> setAccessToken(String accessToken) async {
    var pref = await _pref;
    await pref.setString(ACCESS_TOKEN, accessToken);
  }

  Future<String?> getRefreshToken() async {
    var pref = await _pref;
    return pref.getString(REFRESH_TOKEN);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    var pref = await _pref;
    await pref.setString(REFRESH_TOKEN, refreshToken);
  }

  Future<void> removeToken() async {
    var pref = await _pref;
    pref.remove(ACCESS_TOKEN);
    pref.remove(REFRESH_TOKEN);
  }

  Future<bool> getEnableAutoLogin() async {
    var pref = await _pref;
    var enableAutoLogin = pref.getBool(ENABLE_AUTO_LOGIN);
    return enableAutoLogin ?? false;
  }

  Future<void> setEnableAutoLogin(bool enableAutoLogin) async {
    var pref = await _pref;
    await pref.setBool(ENABLE_AUTO_LOGIN, enableAutoLogin);
  }

  Future<void> logOut() async {
    var pref = await _pref;
    await pref.remove(ACCESS_TOKEN);
    await pref.remove(ENABLE_AUTO_LOGIN);
    return;
  }
}