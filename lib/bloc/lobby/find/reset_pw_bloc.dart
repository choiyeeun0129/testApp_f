import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/auth/auth_service.dart';
import 'package:testApp/manager/storage_manager.dart';

abstract class ResetPwEvent {}
class ReResetPw extends ResetPwEvent {
  String name;
  String id;
  String type;
  ReResetPw(this.name, this.id, this.type);
}
class DoResetPw extends ResetPwEvent {
  String name;
  String id;
  String code;
  String pw;
  DoResetPw(this.name, this.id, this.code, this.pw);
}
abstract class ResetPwState {}
class ResetPwDefault extends ResetPwState {
  String? message;
  ResetPwDefault({this.message});
}
class ResetPwLoading extends ResetPwState {}
class ResetPwDone extends ResetPwState {}

class ResetPwBloc extends Bloc<ResetPwEvent, ResetPwState> {

  ResetPwBloc() : super(ResetPwDefault()) {
    on<ReResetPw>(_onRe);
    on<DoResetPw>(_onDo);
  }

  _onRe(ReResetPw event, Emitter<ResetPwState> emit) async {
    try {
      await authService.getAuthNumber(name: event.name, id: event.id, type: event.type);
    } catch (e) {
      emit(ResetPwDefault(message: e.toString()));
    }
  }

  _onDo(DoResetPw event, Emitter<ResetPwState> emit) async {
    try {
      emit(ResetPwLoading());
      await authService.postPassword(name: event.name, id: event.id, newPassword: event.pw, authNumber: event.code);
      emit(ResetPwDone());
    } catch (e) {
      emit(ResetPwDefault(message: "인증번호가 일치하지 않습니다."));
    }
  }
}