import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:testApp/api/auth/auth_service.dart';
import 'package:testApp/manager/info_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class LoginEvent {}
class DoLogin extends LoginEvent {
  String id;
  String pw;
  bool enableAutoLogin;
  DoLogin(this.id, this.pw, this.enableAutoLogin);
}
class KakaoLogin extends LoginEvent {
  bool enableAutoLogin;
  KakaoLogin(this.enableAutoLogin);
}
// class NaverLogin extends LoginEvent {
//   bool enableAutoLogin;
//   NaverLogin(this.enableAutoLogin);
// }

abstract class LoginState {}
class LoginDefault extends LoginState {
  String? message;
  LoginDefault({this.message});
}
class LoginLoading extends LoginState {}
class LoginDone extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc() : super(LoginDefault()) {
    on<DoLogin>(_onDo);
    on<KakaoLogin>(_onKakao);
    // on<NaverLogin>(_onNaver);
  }

  _onDo(DoLogin event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoading());
      var token = await authService.postLogin(id: event.id, password: event.pw);
      await infoManager.logIn(token, event.enableAutoLogin);
      emit(LoginDone());
    } catch (e) {
      emit(LoginDefault(message: e.toString()));
    }
  }

  _onKakao(KakaoLogin event, Emitter<LoginState> emit) async {
    OAuthToken? oAuthToken;
    log("시작됏다");
    try {
      emit(LoginLoading());
      bool isInstalled = await isKakaoTalkInstalled();
      log("설치됨");
      if (isInstalled) {
        try {
          oAuthToken = await UserApi.instance.loginWithKakaoTalk();
          log("조아조아");
        } catch (error) {

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            log("로그인취소함");
            return;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            log("카카오계정없어서 여기로홈");
            oAuthToken = await UserApi.instance.loginWithKakaoAccount();
          } catch (error) {
            log("error");
            emit(LoginDefault(message: '카카오계정으로 로그인 실패 $error'));
          }
        }
      } else {try {
        log("이것도아님");
          oAuthToken = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          emit(LoginDefault(message: '카카오계정으로 로그인 실패 $error'));
        }
      }
      if(oAuthToken != null){
        log("여기로?");
        var token = await authService.postSnsLogin(provider: "kakao", accessToken: oAuthToken.accessToken);
        log("넣음");
        await infoManager.logIn(token, event.enableAutoLogin);
        log("휴");
        emit(LoginDone());
      }
    } catch (e) {
      if(oAuthToken != null){
        await UserApi.instance.logout();
      }
      emit(LoginDefault(message: e.toString()));
    }
  }

  // _onNaver(NaverLogin event, Emitter<LoginState> emit) async {
  //   try {
  //     emit(LoginLoading());
  //     final result = await FlutterNaverLogin.logIn();
  //     if(result.status == NaverLoginStatus.loggedIn){
  //       log("naver: $result");
  //       var token = await authService.postSnsLogin(provider: "naver", accessToken: result.account.id);
  //       await infoManager.logIn(token, event.enableAutoLogin);
  //       emit(LoginDone());
  //     }else if(result.status == NaverLoginStatus.error){
  //       if(!result.errorMessage.contains("user_cancel")){
  //         emit(LoginDefault(message: '네이버 간편 로그인 실패 ${result.errorMessage}'));
  //       }
  //     }
  //   } catch (e) {
  //     await FlutterNaverLogin.logOutAndDeleteToken();
  //     emit(LoginDefault(message: e.toString()));
  //   }
  // }
}