import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';

abstract class FindPwEvent {}
class DoFindPw extends FindPwEvent {
  String name;
  String id;
  bool isEmail;
  DoFindPw(this.name, this.id, this.isEmail);
}
abstract class FindPwState {}
class FindPwDefault extends FindPwState {
  String? message;
  FindPwDefault({this.message});
}
class FindPwLoading extends FindPwState {}
class FindPwDone extends FindPwState {
  String name;
  String id;
  String type;
  FindPwDone(this.name, this.id, this.type);
}

class FindPwBloc extends Bloc<FindPwEvent, FindPwState> {

  FindPwBloc() : super(FindPwDefault()) {
    on<DoFindPw>(_onDo);
  }

  _onDo(DoFindPw event, Emitter<FindPwState> emit) async {
    try {
      emit(FindPwLoading());
      String type = event.isEmail ? "email" : "sms";
      await authService.getAuthNumber(name: event.name, id: event.id, type: type);
      emit(FindPwDone(event.name, event.id, type));
    } catch (e) {
      emit(FindPwDefault(message: "사용자를 찾을 수 없습니다."));
    }
  }

  // _onDo(DoFindPw event, Emitter<FindPwState> emit) async {
  //   try {
  //     emit(FindPwLoading());
  //
  //     // ✅ 요청 시작 로그
  //     log("🔍 비밀번호 찾기 요청 시작: name=${event.name}, id=${event.id}, isEmail=${event.isEmail}");
  //
  //     String type = event.isEmail ? "email" : "sms";
  //
  //     // ✅ 서버 요청 전 로그
  //     log("📨 서버에 인증번호 요청: {name: ${event.name}, id: ${event.id}, type: $type}");
  //
  //     // ✅ 실제 요청 (authService.getAuthNumber() 호출)
  //     final response = await authService.getAuthNumber(name: event.name, id: event.id, type: type);
  //
  //     // ✅ 서버 응답 로그
  //     log("🔁 서버 응답: ${response}");
  //
  //     emit(FindPwDone(event.name, event.id, type));
  //
  //   } catch (e) {
  //     // ❌ 오류 발생 로그
  //     log("🚨 비밀번호 찾기 오류 발생: $e");
  //
  //     emit(FindPwDefault(message: "서버 요청 실패"));
  //   }
  // }

}