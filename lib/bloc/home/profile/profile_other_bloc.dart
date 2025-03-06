import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/user/user_service.dart';
import 'package:testApp/model/user.dart';

abstract class ProfileOtherEvent {}
class InitProfileOther extends ProfileOtherEvent {
  int id;
  InitProfileOther(this.id);
}
class SaveProfileOther extends ProfileOtherEvent {}

abstract class ProfileOtherState {}
class ProfileOtherYet extends ProfileOtherState {}
class ProfileOtherDefault extends ProfileOtherState {
  User user;
  ProfileOtherDefault(this.user);
}
class ProfileOtherFail extends ProfileOtherState {
  String message;
  ProfileOtherFail(this.message);
}

class ProfileOtherBloc extends Bloc<ProfileOtherEvent, ProfileOtherState> {

  ProfileOtherBloc() : super(ProfileOtherYet()){
    on<InitProfileOther>(_onInit);
    on<SaveProfileOther>(_onSave);
  }

  _onInit(InitProfileOther event, Emitter<ProfileOtherState> emit) async {
    try {
      User user = await userService.getUserById(id: event.id);
      emit(ProfileOtherDefault(user));
    } catch (e) {
      emit(ProfileOtherFail(e.toString()));
    }
  }

  _onSave(SaveProfileOther event, Emitter<ProfileOtherState> emit) async {
    try {
    } catch (e) {
    }
  }
}