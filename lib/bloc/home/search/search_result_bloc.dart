import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/user/user_service.dart';
import 'package:gnu_mot_t/model/user.dart';

abstract class SearchResultEvent {}
class LoadSearchResult extends SearchResultEvent {
  String? keyword;
  String? batch;
  String? course;
  LoadSearchResult(this.keyword, this.batch, this.course);
}
class DoSearchResult extends SearchResultEvent {
  String keyword;
  DoSearchResult(this.keyword);
}

class SearchResultState {
  List<User> userList;
  String? message;
  SearchResultState({required this.userList, this.message});

  SearchResultState copyWith({List<User>? userList, String? message}){
    return SearchResultState(
      userList: userList ?? this.userList,
      message: message,
    );
  }
}

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  int page = 1;
  bool pageLoadable = true;
  List<User> userList = [];
  SearchResultBloc() : super(SearchResultState(userList: [])){
    on<LoadSearchResult>(_onInit);
    on<DoSearchResult>(_onDo);
  }

  _onInit(LoadSearchResult event, Emitter<SearchResultState> emit) async {
    try {
      var result = await userService.getUserList(keyword: event.keyword, courseCode: event.course, batchCode: event.batch, page: page);
      userList = [...userList, ...(result.list)];
      pageLoadable = userList.length < result.totalCount;
      page += 1;
      emit(state.copyWith(userList: userList));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  _onDo(DoSearchResult event, Emitter<SearchResultState> emit) async {
    try {
      var list = userList.where((user) => user.name.contains(event.keyword)).toList();
      emit(state.copyWith(userList: list));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}