import 'dart:io';
import 'package:gnu_mot_t/model/pagination.dart';
import 'package:gnu_mot_t/model/user.dart';

abstract class UserAPI {
  // 사용자 관련 API
  Future<Pagination<User>> getUserListByRole({
    required String roleCode,
    required int page,
  });

  Future<Pagination<User>> getUserListByBatch({
    required String batchCode,
    required int page,
  });

  Future<Pagination<User>> getUserList({
    required String? keyword,
    required String? courseCode,
    required String? batchCode,
    required int page,
  });

  Future<User> getUserById({
    required int id,
  });

  Future<User> updateUser({
    required int id,
    required User userData,
  });

  Future<void> uploadProfileImage({
    required String userId,
    required File imageFile,
  });

  Future<void> deleteProfileImage({
    required String userId,
  });
}
