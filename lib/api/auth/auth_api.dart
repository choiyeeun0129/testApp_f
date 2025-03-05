import 'package:gnu_mot_t/model/user.dart';

abstract class AuthAPI {
  // 로그인
  Future<String> getStatus({
    required String number,
  });

  // 로그인
  Future<String> postSnsLogin({
    required String provider,
    required String accessToken,
  });

  // 로그인
  Future<void> getAuthNumber({
    String? name,
    String? number,
    String? id,
    String? type,
  });

  // 로그인
  Future<String> postLogin({
    required String id,
    required String password,
  });

  // 인증 재요청
  Future<String> getRefreshToken();

  // 로그아웃
  Future<void> getLogout();

  // 회원가입
  Future<User> postJoin({
    required String number,
    required String id,
    required String password,
  });

  // 비밀번호 재설정
  Future<void> postPassword({
    required String name,
    required String id,
    required String newPassword,
    required String authNumber,
  });

  // 내 프로필 요청
  Future<User> getMyInfo();

  // 내 프로필 수정
  Future<User> postMyInfo({
    required Map<String, dynamic> body,
  });

  // 공개 범위 설정
  Future<User> postPublicSettings({
    required Map<String, dynamic> settings,
  });

  // 아이디 찾기
  Future<String> getFindId({
    required String name,
    required String mobile,
    required String authNumber,
  });

  // 프로필 이미지 등록
  Future<void> postProfileImage({
    required int id,
  });

  // 프로필 이미지 삭제
  Future<void> deleteProfileImage();

  // 회원 탈퇴
  Future<void> getLeave();
}
