import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testApp/api/auth/auth_service.dart';
import 'package:testApp/api/file/file_service.dart';

abstract class ProfileEditEvent {}
class DoProfileEdit extends ProfileEditEvent {
  Map<String, dynamic> body;
  File? file;
  DoProfileEdit(this.body, this.file);
}
class DeleteImageProfileEdit extends ProfileEditEvent {}

abstract class ProfileEditState {}
class ProfileEditDefault extends ProfileEditState {
  String? message;
  ProfileEditDefault({this.message});
} 
class ProfileEditDone extends ProfileEditState {
  String message;
  ProfileEditDone(this.message);
}

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {

  ProfileEditBloc() : super(ProfileEditDefault()){
    on<DoProfileEdit>(_onDo);
    on<DeleteImageProfileEdit>(_onDeleteImage);
  }

  _onDo(DoProfileEdit event, Emitter<ProfileEditState> emit) async {
    try {
      if(event.file != null){
        File file = event.file!;
        int id = await fileService.postUpload(file: file);
        await authService.postProfileImage(id: id);
      }

      await authService.postMyInfo(body: event.body);
      emit(ProfileEditDone("프로필이 수정되었습니다."));
    } catch (e) {
      emit(ProfileEditDefault(message: e.toString()));
    }
  }

  _onDeleteImage(DeleteImageProfileEdit event, Emitter<ProfileEditState> emit) async {
    try {
      await authService.deleteProfileImage();
      // emit(ProfileEditDone("프로필 사진이 삭제되었습니다."));
      emit(ProfileEditDefault(message: "deleted"));
      emit(ProfileEditDefault());
    } catch (e) {
      emit(ProfileEditDefault(message: e.toString()));
    }
  }
}