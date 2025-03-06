import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/auth/auth_service.dart';

abstract class SettingEvent {}
class WithdrawSetting extends SettingEvent {}

abstract class SettingState {}
class SettingDefault extends SettingState {
  String? message;
  SettingDefault({this.message});
}
class SettingLogout extends SettingState {}

class SettingBloc extends Bloc<SettingEvent, SettingState> {

  SettingBloc() : super(SettingDefault()){
    on<WithdrawSetting>(_onWithdraw);
  }

  _onWithdraw(WithdrawSetting event, Emitter<SettingState> emit) async {
    try{
      log("_onWithdraw/1");
      await authService.getLeave();
      log("_onWithdraw/2");
      emit(SettingDefault(message: "탈퇴 신청이 완료되었습니다."));
      log("_onWithdraw/3");
    }catch (e){
      log("_onWithdraw/e: $e");
      emit(SettingDefault(message: e.toString()));
    }
  }
}