import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';
import 'package:gnu_mot_t/manager/info_manager.dart';
import 'package:gnu_mot_t/model/user.dart';

abstract class HomeEvent {}
class InitHome extends HomeEvent {}
class LogoutHome extends HomeEvent {}

abstract class HomeState {}
class HomeYet extends HomeState {}
class HomeDefault extends HomeState {
  User user;
  HomeDefault(this.user);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeYet()){
    on<InitHome>(_onInit);
    on<LogoutHome>(_onLogout);
  }

  _onInit(InitHome event, Emitter<HomeState> emit) async {
    try {
      User user = await authService.getMyInfo();
      emit(HomeDefault(user));
    } catch (e) {
      log("_onInit: $e");
    }
  }

  _onLogout(LogoutHome event, Emitter<HomeState> emit) async {
    try {
      await authService.getLogout();
      await infoManager.logOut("LOGOUT API");
    } catch (e) {
      log("_onLogout: $e");
    }
  }
}