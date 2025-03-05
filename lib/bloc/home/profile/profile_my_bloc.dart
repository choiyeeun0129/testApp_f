import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';
import 'package:gnu_mot_t/model/user.dart';

abstract class ProfileMyEvent {}
class InitProfileMy extends ProfileMyEvent {}

abstract class ProfileMyState {}
class ProfileMyYet extends ProfileMyState {}
class ProfileMyDefault extends ProfileMyState {
  User user;
  ProfileMyDefault(this.user);
}
class ProfileMyFail extends ProfileMyState {
  String message;
  ProfileMyFail(this.message);
}

class ProfileMyBloc extends Bloc<ProfileMyEvent, ProfileMyState> {

  ProfileMyBloc() : super(ProfileMyYet()){
    on<InitProfileMy>(_onInit);
  }

  _onInit(InitProfileMy event, Emitter<ProfileMyState> emit) async {
    try {
      User user = await authService.getMyInfo();
      emit(ProfileMyDefault(user));
    } catch (e) {
      emit(ProfileMyFail(e.toString()));
    }
  }
}