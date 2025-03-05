import 'package:shared_preferences/shared_preferences.dart';

const AUTH_TOKEN = "AUTH_TOKEN";

class StorageException implements Exception {
  String msg;

  StorageException({this.msg = "Local Storage Exception!!"});

  @override
  String toString() {
    return msg;
  }
}

LocalStorage localStorage = LocalStorage();
class LocalStorage {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future<bool> clear() async {
    var pref = await _pref;
    return await pref.clear();
  }

  Future<void> setToken(String token) async {
    var pref = await _pref;
    await pref.setString(AUTH_TOKEN, token);
  }

  Future<String?> getToken() async {
    var pref = await _pref;
    var token = pref.getString(AUTH_TOKEN);
    return token;
  }

  Future<void> removeToken() async {
    var pref = await _pref;
    pref.remove(AUTH_TOKEN);
  }
}