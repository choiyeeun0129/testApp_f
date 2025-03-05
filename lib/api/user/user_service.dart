import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:gnu_mot_t/api/api_service.dart';
import 'package:gnu_mot_t/api/user/user_api.dart';
import 'package:gnu_mot_t/model/error.dart';
import 'package:gnu_mot_t/model/pagination.dart';
import 'package:gnu_mot_t/model/user.dart';

final userService = UserService();
class UserService extends APIService implements UserAPI {
  // User Related APIs
  @override
  Future<Pagination<User>> getUserListByRole({
    required String roleCode,
    required int page,
  }) async {
    var response = await executeWithRetry((headers) => client.get(
      getUserListByRoleUri(roleCode).replace(queryParameters: {
        "page": page.toString(),
      }),
      headers: authorizationHeader,
    ));
    log("getUserListByRole/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      var results = (body["contents"] as List)
          .map((e) => User.fromJson(e))
          .toList();
      return Pagination.fromJson(body, results);
    }
    throw APIError(response);
  }

  @override
  Future<Pagination<User>> getUserListByBatch({
    required String batchCode,
    required int page,
  }) async {
    var response = await executeWithRetry((headers) => client.get(
      getUserListByBatchUri(batchCode).replace(queryParameters: {
        "page": page.toString(),
      }),
      headers: authorizationHeader,
    ));
    log("getUserListByBatch/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      var results = (body["contents"] as List)
          .map((e) => User.fromJson(e))
          .toList();
      return Pagination.fromJson(body, results);
    }
    throw APIError(response);
  }

  @override
  Future<Pagination<User>> getUserList({
    required String? keyword,
    required String? courseCode,
    required String? batchCode,
    required int page,
  }) async {
    var query = {
      "keyword": keyword,
      "courseCode": courseCode,
      "batchCode": batchCode,
      "page": page.toString(),
    };
    query.removeWhere((key, value) => (value == null || value.isEmpty));
    log("getUserList/request: $query");
    var response = await executeWithRetry((headers) => client.get(
      getUserListUri().replace(queryParameters: query),
      headers: authorizationHeader,
    ));
    log("getUserList/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      var results = (body["contents"] as List)
          .map((e) => User.fromJson(e))
          .toList();
      return Pagination.fromJson(body, results);
    }
    throw APIError(response);
  }

  @override
  Future<User> getUserById({
    required int id,
  }) async {
    var response = await executeWithRetry((headers) => client.get(
      getUserByIdUri(id),
      headers: authorizationHeader,
    ));
    log("getUserById/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<User> updateUser({
    required int id,
    required User userData,
  }) async {
    var response = await executeWithRetry((headers) => client.post(
      updateUserUri(id),
      headers: authorizationHeader,
      body: json.encode(userData.toJson()),
    ));
    log("updateUser/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<void> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    var response = await executeWithRetry((headers) async => client.post(
      uploadProfileImageUri(userId),
      headers: authorizationHeader,
      body: await imageFile.readAsBytes(),
    ));
    log("uploadProfileImage/response: [${response.statusCode}]");
    if (response.statusCode != 200) {
      throw APIError(response);
    }
  }

  @override
  Future<void> deleteProfileImage({
    required String userId,
  }) async {
    var response = await executeWithRetry((headers) => client.delete(
      deleteProfileImageUri(userId),
      headers: authorizationHeader,
    ));
    log("deleteProfileImage/response: [${response.statusCode}]");
    if (response.statusCode != 200) {
      throw APIError(response);
    }
  }
}

extension on UserService {
  Uri getUserListByRoleUri(String groupCode) => Uri.parse("$baseUrl/api/user/list/role/$groupCode");
  Uri getUserListByBatchUri(String batchCode) => Uri.parse("$baseUrl/api/user/list/batch/$batchCode");
  Uri getUserListUri() => Uri.parse("$baseUrl/api/user/list");
  Uri getUserByIdUri(int id) => Uri.parse("$baseUrl/api/user/find/$id");
  Uri updateUserUri(int id) => Uri.parse("$baseUrl/api/user/$id");
  Uri uploadProfileImageUri(String userId) => Uri.parse("$baseUrl/api/user/profileImage/$userId");
  Uri deleteProfileImageUri(String userId) => Uri.parse("$baseUrl/api/user/profileImage/$userId");
}
