import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnu_mot_t/manager/info_manager.dart';
import 'package:gnu_mot_t/manager/storage_manager.dart';

abstract class SplashEvent {}
class InitSplash extends SplashEvent {}

abstract class SplashState {}
class SplashInitYet extends SplashState {}
class SplashLoginSuccess extends SplashState {}
class SplashNeedIdentification extends SplashState {}
class SplashNeedLogin extends SplashState {}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitYet()) {
    on<InitSplash>(_onInitSplash);
  }

  _onInitSplash(InitSplash event, Emitter<SplashState> emit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      bool isLogin = await infoManager.autoLogin();
      if(isLogin){
        emit(SplashLoginSuccess());
      }else{
        String? mobile = await storageManager.getIdentifyMobile();
        if(mobile != null){
          emit(SplashNeedLogin());
        }else{
          emit(SplashNeedIdentification());
        }
      }
    } catch (e) {
      emit(SplashNeedIdentification());
    }
  }
}