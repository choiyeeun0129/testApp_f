import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/api/auth/auth_service.dart';
import 'package:gnu_mot_t/manager/storage_manager.dart';

abstract class RegisterEvent {}
class DoRegister extends RegisterEvent {
  String id;
  String pw;
  String pwAgain;
  DoRegister(this.id, this.pw, this.pwAgain);
}

abstract class RegisterState {}
class RegisterDefault extends RegisterState {
  String? message;
  RegisterDefault({this.message});
}
class RegisterLoading extends RegisterState {}
class RegisterDone extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  RegisterBloc() : super(RegisterDefault()) {
    on<DoRegister>(_onDo);
  }

  _onDo(DoRegister event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterLoading());

      if (event.pw.length < 8) {
        emit(RegisterDefault(message: "비밀번호는 8자 이상 입력해주세요."));
        return;
      }

      if(event.pw == event.pwAgain){
        String? number = await storageManager.getIdentifyMobile();
        if(number != null){
          await authService.postJoin(number: number, id: event.id, password: event.pw);
          emit(RegisterDone());
        }else{
          emit(RegisterDefault(message: "데이터가 유실되었습니다."));}
      }else{
        emit(RegisterDefault(message: "재입력된 비밀번호가 다릅니다."));
      }
    } catch (e) {
      emit(RegisterDefault(message: e.toString()));
    }
  }
}