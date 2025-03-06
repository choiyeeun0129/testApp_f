import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/code/code_service.dart';
import 'package:testApp/model/code.dart';

abstract class MotEvent {}
class InitMot extends MotEvent {}

abstract class MotState {}
class MotYet extends MotState {}
class MotDefault extends MotState {
  List<Code> motList;
  MotDefault(this.motList);
}
class MotFail extends MotState {
  String message;
  MotFail(this.message);
}
class MotBloc extends Bloc<MotEvent, MotState> {

  MotBloc() : super(MotYet()){
    on<InitMot>(_onInit);
  }

  _onInit(InitMot event, Emitter<MotState> emit) async {
    try {
      var motList = await codeService.getBatchCodes();
      emit(MotDefault(motList));
    } catch (e) {
      emit(MotFail(e.toString()));
    }
  }
}