import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/user/user_service.dart';
import 'package:gnu_mot_t/model/pagination.dart';
import 'package:gnu_mot_t/model/user.dart';

abstract class GroupEvent {}
class LoadGroup extends GroupEvent {
  String type;
  String code;
  LoadGroup(this.type, this.code);
}
class TextGroup extends GroupEvent {
  List<String> idList;
  TextGroup(this.idList);
}
class MailGroup extends GroupEvent {
  List<String> idList;
  MailGroup(this.idList);
}

class GroupState {
  List<User> userList;
  String? message;
  GroupState({required this.userList, this.message});

  GroupState copyWith({List<User>? userList, String? message}){
    return GroupState(
      userList: userList ?? this.userList,
      message: message,
    );
  }
}

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  int page = 1;
  bool pageLoadable = true;
  List<User> userList = [];
  GroupBloc() : super(GroupState(userList: [])){
    on<LoadGroup>(_onLoad);
    on<TextGroup>(_onText);
    on<MailGroup>(_onMail);
  }

  _onLoad(LoadGroup event, Emitter<GroupState> emit) async {
    if(pageLoadable){
      try {
        Pagination<User>? result;
        if(event.type == "ROLE"){
          result = await userService.getUserListByRole(roleCode: event.code, page: page);
        }else if(event.type == "BATCH"){
          result = await userService.getUserListByBatch(batchCode: event.code, page: page);
        }
        if(result != null){
          userList = [...userList, ...(result.list)];
          pageLoadable = userList.length < result.totalCount;
          page += 1;
          emit(state.copyWith(userList: userList));
        }
      } catch (e) {
        emit(state.copyWith(message: e.toString()));
      }
    }
  }

  _onText(TextGroup event, Emitter<GroupState> emit) async {
    try {
      emit(state.copyWith(message: "단체 문자는 준비중인 기능입니다."));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  _onMail(MailGroup event, Emitter<GroupState> emit) async {
    try {
      emit(state.copyWith(message: "단체 메일은 준비중인 기능입니다."));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}