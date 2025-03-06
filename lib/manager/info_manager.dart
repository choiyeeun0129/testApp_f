import 'package:get/get.dart';
import 'package:testApp/manager/storage_manager.dart';
import 'package:testApp/model/user.dart';
import 'package:testApp/router/app_router.dart';
import 'package:testApp/router/app_routes.dart';

InfoService infoManager = InfoManager();
abstract class InfoService {
  bool isLogIn();
  Future<void> logIn(String accessToken, bool enableAutoLogin);
  Future<void> setAccessToken(String accessToken);
  Future<bool> autoLogin();
  String get accessToken;
  User get userInfo;
  Future<void> logOut(String message);
}

class InfoManager extends InfoService {
  String? mAccessToken;
  User? mUserInfo;

  InfoManager({this.mAccessToken, this.mUserInfo});

  @override
  bool isLogIn(){
    return mAccessToken != null;
  }

  @override
  Future<void> logIn(String accessToken, bool enableAutoLogin) async {
    await setAccessToken(accessToken);
    await setEnableAutoLogin(enableAutoLogin);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    mAccessToken = accessToken;
    await storageManager.setAccessToken(accessToken);
  }

  Future<void> setEnableAutoLogin(bool enableAutoLogin) async {
    await storageManager.setEnableAutoLogin(enableAutoLogin);
  }

  void setUserInfo(User userInfo) {
    mUserInfo = userInfo;
  }

  @override
  Future<bool> autoLogin() async {
    bool enableAutoLogin = await storageManager.getEnableAutoLogin();
    if(enableAutoLogin){
      mAccessToken = await storageManager.getAccessToken();
      return mAccessToken != null;
    }else{
      return false;
    }
  }

  @override
  String get accessToken {
    if(mAccessToken != null){
      return mAccessToken!;
    }
    throw Exception("로그인이 필요합니다.");
  }

  @override
  User get userInfo {
    if(mUserInfo != null){
      return mUserInfo!;
    }
    throw Exception("로그인이 필요합니다.");
  }

  @override
  Future<void> logOut(String message) async {
    mAccessToken = null;
    await storageManager.removeToken();
    await storageManager.logOut();
    String routeFrom = MyNavigatorObserver.routeStack.lastOrNull?.settings.name ?? "Unknown";
    Map<String, dynamic> arg = {"message": message, "from": routeFrom};
    Get.offAllNamed(routeLoginPage, arguments: arg);
  }
}