import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/auth/auth_service.dart';

abstract class FindIdEvent {}
class DoFindId extends FindIdEvent {
  String name;
  String number;
  DoFindId(this.name, this.number);
}
class ReFindId extends FindIdEvent {}
class CodeFindId extends FindIdEvent {
  String code;
  CodeFindId(this.code);
}
abstract class FindIdState {}
class FindIdDefault extends FindIdState {
  String? message;
  FindIdDefault({this.message});
}
class FindIdCode extends FindIdState {
  String? message;
  final bool isResent;
  final bool isSuccess;
  FindIdCode({this.message, this.isResent = false,required this.isSuccess});
}
class FindIdDone extends FindIdState {
  String id;
  FindIdDone(this.id);
}

class FindIdBloc extends Bloc<FindIdEvent, FindIdState> {

  FindIdBloc() : super(FindIdDefault()) {
    on<DoFindId>(_onDo);
    on<ReFindId>(_onRe);
    on<CodeFindId>(_onCode);
  }

  String name = "";
  String number = "";
  _onDo(DoFindId event, Emitter<FindIdState> emit) async {
    try {
      await authService.getAuthNumber(name: event.name, number: event.number);
      name = event.name;
      number = event.number;
      emit(FindIdCode(isSuccess: true));
    } catch (e) {
      log("_onDo/e: $e");
      emit(FindIdDefault(message: "사용자를 찾을 수 없습니다."));
    }
  }

  _onRe(ReFindId event, Emitter<FindIdState> emit) async {
    try {
      await authService.getAuthNumber(name: name, number: number);
      emit(FindIdCode(message: "인증번호가 재전송 되었습니다.", isResent: true, isSuccess: true));
    } catch (e) {
      emit(FindIdCode(message: "인증번호 전송 실패: $e", isResent: true, isSuccess: false));
    }
  }

  _onCode(CodeFindId event, Emitter<FindIdState> emit) async {
    try {
      log("_onCode: ${event.code}");
      String id = await authService.getFindId(name: name, mobile: number, authNumber: event.code);
      emit(FindIdDone(id));
    } catch (e) {
      log("실패");
      emit(FindIdCode(message: "인증번호가 일치하지 않습니다.", isResent: false, isSuccess: false));
    }
  }
}