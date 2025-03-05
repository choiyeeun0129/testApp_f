import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';
import 'package:gnu_mot_t/manager/storage_manager.dart';

abstract class IdentificationEvent {}
class DoIdentification extends IdentificationEvent {
  String number;
  DoIdentification(this.number);
}

abstract class IdentificationState {}
class IdentificationDefault extends IdentificationState {
  String? message;
  IdentificationDefault({this.message});
}
class IdentificationLoading extends IdentificationState {}
class IdentificationNotEnrolled extends IdentificationState {}
class IdentificationActive extends IdentificationState {}

class IdentificationBloc extends Bloc<IdentificationEvent, IdentificationState> {

  IdentificationBloc() : super(IdentificationDefault()) {
    on<DoIdentification>(_onDo);
  }

  _onDo(DoIdentification event, Emitter<IdentificationState> emit) async {
    try {
      emit(IdentificationLoading());
      String status = await authService.getStatus(number: event.number);
      if(status == "Unregistered"){
        emit(IdentificationDefault(message: "미등록된 사용자입니다."));
      }else if(status == "NotEnrolled"){
        await storageManager.setIdentifyMobile(event.number);
        emit(IdentificationNotEnrolled());
      }else if(status == "Active"){
        await storageManager.setIdentifyMobile(event.number);
        emit(IdentificationActive());
      }
    } catch (e) {
      emit(IdentificationDefault(message: e.toString()));
    }
  }
}