import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/code/code_service.dart';
import 'package:testApp/model/code.dart';
import 'package:testApp/model/user.dart';

abstract class SearchEvent {}
class InitSearch extends SearchEvent {}

class SearchState {
  List<Code> batchList;
  String? message;
  SearchState({required this.batchList, this.message});

  SearchState copyWith({List<Code>? batchList, List<Code>? courseList, String? message}){
    return SearchState(
      batchList: batchList ?? this.batchList,
      message: message,
    );
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  SearchBloc() : super(SearchState(batchList: [])){
    on<InitSearch>(_onInit);
  }

  List<User> userList = [];
  _onInit(InitSearch event, Emitter<SearchState> emit) async {
    try {
      log("_onInit");
      var batchList = await codeService.getBatchCodes();
      log("_onInit/2");
      emit(state.copyWith(batchList: batchList));
    } catch (e) {
      log("_onInit/3: $e");
      emit(state.copyWith(message: e.toString()));
    }
  }
}