import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/auth/auth_service.dart';
import 'package:testApp/model/user.dart';

abstract class SettingPrivacyEvent {}
class InitSettingPrivacy extends SettingPrivacyEvent {}
class MobileSettingPrivacy extends SettingPrivacyEvent {}
class OfficePhoneSettingPrivacy extends SettingPrivacyEvent {}
class EmailSettingPrivacy extends SettingPrivacyEvent {}
class CompanySettingPrivacy extends SettingPrivacyEvent {}
class BirthSettingPrivacy extends SettingPrivacyEvent {}

class SettingPrivacyState {
  bool enableMobile;
  bool enableOfficePhone;
  bool enableEmail;
  bool enableCompany;
  bool enableBirth;
  String? message;
  SettingPrivacyState({required this.enableMobile, required this.enableOfficePhone, required this.enableEmail, required this.enableCompany, required this.enableBirth, this.message});

  SettingPrivacyState copyWith({bool? enableMobile, bool? enableOfficePhone, bool? enableEmail, bool? enableCompany, bool? enableBirth, String? message}){
    return SettingPrivacyState(
      enableMobile: enableMobile ?? this.enableMobile,
      enableOfficePhone: enableOfficePhone ?? this.enableOfficePhone,
      enableEmail: enableEmail ?? this.enableEmail,
      enableCompany: enableCompany ?? this.enableCompany,
      enableBirth: enableBirth ?? this.enableBirth,
      message: message,
    );
  }
}

class SettingPrivacyBloc extends Bloc<SettingPrivacyEvent, SettingPrivacyState> {

  SettingPrivacyBloc() : super(SettingPrivacyState(enableMobile: false, enableOfficePhone: false, enableEmail: false, enableCompany: false, enableBirth: false)){
    on<InitSettingPrivacy>(_onInit);
    on<MobileSettingPrivacy>(_onMobile);
    on<OfficePhoneSettingPrivacy>(_onOfficePhone);
    on<EmailSettingPrivacy>(_onEmail);
    on<CompanySettingPrivacy>(_onCompany);
    on<BirthSettingPrivacy>(_onBirth);
  }

  _onInit(InitSettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    try {
      User user = await authService.getMyInfo();
      emit(state.copyWith(
        enableMobile: user.isPublicMobile,
        enableOfficePhone: user.isPublicOffice,
        enableEmail: user.isPublicEmail,
        enableCompany: user.isPublicDepartment,
        enableBirth: user.isPublicBirth,
      ));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
  _onMobile(MobileSettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    var enable = !state.enableMobile;
    emit(state.copyWith(enableMobile: enable));
    await authService.postPublicSettings(settings: {
      "mobile": state.enableMobile,
      "office": state.enableOfficePhone,
      "email": state.enableEmail,
      "department": state.enableCompany,
      "birth": state.enableBirth,
    });
  }
  _onOfficePhone(OfficePhoneSettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    var enable = !state.enableOfficePhone;
    emit(state.copyWith(enableOfficePhone: enable));
    await authService.postPublicSettings(settings: {
      "mobile": state.enableMobile,
      "office": state.enableOfficePhone,
      "email": state.enableEmail,
      "department": state.enableCompany,
      "birth": state.enableBirth,
    });
  }
  _onEmail(EmailSettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    var enable = !state.enableEmail;
    emit(state.copyWith(enableEmail: enable));
    await authService.postPublicSettings(settings: {
      "mobile": state.enableMobile,
      "office": state.enableOfficePhone,
      "email": state.enableEmail,
      "department": state.enableCompany,
      "birth": state.enableBirth,
    });
  }
  _onCompany(CompanySettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    var enable = !state.enableCompany;
    emit(state.copyWith(enableCompany: enable));
    await authService.postPublicSettings(settings: {
      "mobile": state.enableMobile,
      "office": state.enableOfficePhone,
      "email": state.enableEmail,
      "department": state.enableCompany,
      "birth": state.enableBirth,
    });
  }
  _onBirth(BirthSettingPrivacy event, Emitter<SettingPrivacyState> emit) async {
    var enable = !state.enableBirth;
    emit(state.copyWith(enableBirth: enable));
    await authService.postPublicSettings(settings: {
      "mobile": state.enableMobile,
      "office": state.enableOfficePhone,
      "email": state.enableEmail,
      "department": state.enableCompany,
      "birth": state.enableBirth,
    });
  }
}