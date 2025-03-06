import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:testApp/api/api_service.dart';
import 'package:testApp/api/auth/auth_api.dart';
import 'package:testApp/manager/storage_manager.dart';
import 'package:testApp/model/error.dart';
import 'package:testApp/model/user.dart';
import 'package:testApp/util/extensions.dart';


final authService = AuthService();
class AuthService extends APIService implements AuthAPI {
  // Auth Related APIs

  @override
  Future<String> getStatus({
    required String number,
  }) async {
    var response = await client.get(
      getStatusUri(number),
      headers: defaultHeader,
    );
    log("getStatue/request: ${response.request?.url}");
    if(response.isError) throw APIError(response);
    log("getStatus/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return body["status"];
    }
    throw APIError(response);
  }

  @override
  Future<String> postLogin({
    required String id,
    required String password,
  }) async {
    var response = await client.post(
      postLoginUri(),
      headers: defaultHeader,
      body: json.encode({
        "loginId": id,
        "password": password,
      }),
    );
    if(response.isError) throw APIError(response);
    log("postLogin/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var cookieList = response.headers['set-cookie']?.split(',') ?? [];
      var refreshToken = cookieList.firstWhereOrNull((cookie) => cookie.contains("refreshToken"));
      if(refreshToken != null){
        await storageManager.setRefreshToken(refreshToken);
      }
      var body = json.decode(utf8.decode(response.bodyBytes));
      return body['accessToken'];
    }
    throw APIError(response);
  }

  @override
  Future<void> getAuthNumber({
    String? name,
    String? number,
    String? id,
    String? type,
  }) async {
    var query = {
      "name": name,
      "mobile": number,
      "loginId": id,
      "type": type,
    };
    query.removeWhere((key, value) => value == null);
    log("getAuthNumber/request: $query");
    var response = await client.get(
      getAuthNumberUri().replace(queryParameters: query),
      headers: defaultHeader,
    );
    if(response.isError) throw APIError(response);
    log("getAuthNumber/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      return;
    }
    throw APIError(response);
  }

  // @override
  // Future<Map<String, dynamic>> getAuthNumber({
  //   String? name,
  //   String? number,
  //   String? id,
  //   String? type,
  // }) async {
  //   var query = {
  //     "name": name,
  //     "mobile": number,
  //     "loginId": id,
  //     "type": type,
  //   };
  //   query.removeWhere((key, value) => value == null);
  //   log("📨 getAuthNumber/request: $query");
  //
  //   var response = await client.get(
  //     getAuthNumberUri().replace(queryParameters: query),
  //     headers: defaultHeader,
  //   );
  //
  //   if (response.isError) {
  //     throw APIError(response);
  //   }
  //
  //   // ✅ 서버 응답을 JSON으로 변환해서 반환
  //   Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
  //   log("🔁 getAuthNumber/response: [${response.statusCode}] $responseData");
  //
  //   // ✅ 응답이 `{}` (빈 JSON)인 경우, 실패 처리
  //   if (responseData.isEmpty) {
  //     log("❌ 서버 응답이 빈 JSON {} 입니다. 이메일이 전송되지 않았을 가능성이 높음.");
  //     return {"success": false, "message": "서버 응답이 비어 있습니다."};
  //   }
  //
  //   if (response.statusCode == 200) {
  //     return responseData; // ✅ 서버 응답을 반환하도록 변경
  //   }
  //
  //   throw APIError(response);
  // }


  @override
  Future<String> postSnsLogin({
    required String provider,
    required String accessToken,
  }) async {
    log("postSnsLogin/request: $provider/$accessToken");
    var response = await client.post(
      postSnsLoginUri(),
      headers: defaultHeader,
      body: json.encode({
        "provider": provider,
        "accessToken": accessToken,
      }),
    );
    log("postSnsLogin/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if(response.isError) throw APIError(response);
    if (response.statusCode == 200) {
      var cookieList = response.headers['set-cookie']?.split(',') ?? [];
      var refreshToken = cookieList.firstWhereOrNull((cookie) => cookie.contains("refreshToken"));
      if(refreshToken != null){
        await storageManager.setRefreshToken(refreshToken);
      }
      var body = json.decode(utf8.decode(response.bodyBytes));
      return body['accessToken'];
    }
    throw APIError(response);
  }

  @override
  Future<String> getRefreshToken() async {
    var header = await refreshHeader;
    var response = await client.get(
      getRefreshUri().replace(),
      headers: header,
    );
    if(response.isError) throw APIError(response);
    log("getRefreshToken/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var cookieList = response.headers['set-cookie']?.split(',') ?? [];
      var refreshToken = cookieList.firstWhereOrNull((cookie) => cookie.contains("refreshToken"));
      if(refreshToken != null){
        await storageManager.setRefreshToken(refreshToken);
      }
      var body = json.decode(utf8.decode(response.bodyBytes));
      return body['accessToken'];
    }
    throw APIError(response);
  }

  @override
  Future<void> getLogout() async {
    var response = await executeWithRetry((headers) => client.get(
      getLogoutUri(),
      headers: authorizationHeader,
    ));
    if(response.isError) throw APIError(response);
    log("getLogout/response: [${response.statusCode}]");
    if (response.statusCode != 200) {
      throw APIError(response);
    }
  }

  @override
  Future<User> postJoin({
    required String number,
    required String id,
    required String password,
  }) async {
    var response = await client.post(
      postJoinUri(),
      headers: defaultHeader,
      body: json.encode({
        "mobile": number,
        "loginId": id,
        "password": password,
      }),
    );
    if(response.isError) throw APIError(response);
    log("postJoin/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<void> postPassword({
    required String name,
    required String id,
    required String newPassword,
    required String authNumber,
  }) async {
    var response = await client.post(
      postPasswordUri(),
      headers: defaultHeader,
      body: json.encode({
        "name": name,
        "loginId": id,
        "password": newPassword,
        "authNumber": authNumber,
      }),
    );
    if(response.isError) throw APIError(response);
    log("postPassword/response: [${response.statusCode}]");
    if (response.statusCode != 200) {
      throw APIError(response);
    }
  }

  @override
  Future<User> getMyInfo() async {
    var response = await executeWithRetry((headers) => client.get(
      getMyInfoUri(),
      headers: authorizationHeader,
    ));
    if(response.isError) throw APIError(response);
    log("getMyInfo/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<User> postMyInfo({
    required Map<String, dynamic> body
  }) async {
    log("postMyInfo/request: $body");
    var response = await executeWithRetry((headers) => client.post(
      postMyInfoUri(),
      headers: authorizationHeader,
      body: json.encode(body),
    ));
    if(response.isError) throw APIError(response);
    log("postMyInfo/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<User> postPublicSettings({
    required Map<String, dynamic> settings,
  }) async {
    var response = await executeWithRetry((headers) => client.post(
      postPublicUri(),
      headers: authorizationHeader,
      body: json.encode(settings),
    ));
    if(response.isError) throw APIError(response);
    log("postPublicSettings/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(body);
    }
    throw APIError(response);
  }

  @override
  Future<String> getFindId({
    required String name,
    required String mobile,
    required String authNumber,
  }) async {
    var response = await client.get(
      getFindIdUri().replace(queryParameters: {
        "name": name,
        "mobile": mobile,
        "authNumber": authNumber,
      }),
      headers: defaultHeader,
    );
    if(response.isError) throw APIError(response);
    log("getFindId/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      return body['loginId'];
    }
    throw APIError(response);
  }

  @override
  Future<void> getLeave() async {
    var response = await executeWithRetry((headers) => client.get(
      getLeaveUri(),
      headers: authorizationHeader,
    ));
    log("getLeave/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if(response.isError) throw APIError(response);
    if (response.statusCode == 200) {
      return;
    }
    throw APIError(response);
  }

  // 프로필 이미지 등록
  @override
  Future<void> postProfileImage({
    required int id,
  }) async {
    var response = await executeWithRetry((headers) => client.post(
      postProfileImageUri(id),
      headers: authorizationHeader,
    ));
    if(response.isError) throw APIError(response);
    log("postProfileImage/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      return;
    }
    throw APIError(response);
  }

  @override
  Future<void> deleteProfileImage() async {
    var response = await executeWithRetry((headers) => client.delete(
      deleteProfileImageUri(),
      headers: authorizationHeader,
    ));
    if(response.isError) throw APIError(response);
    log("deleteProfileImage/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      return;
    }
    throw APIError(response);
  }
}

extension on AuthService {
  Uri getStatusUri(String number) => Uri.parse("$baseUrl/api/auth/status/$number");
  Uri postLoginUri() => Uri.parse("$baseUrl/api/auth/login");
  Uri getAuthNumberUri() => Uri.parse("$baseUrl/api/auth/authNumber");
  Uri postSnsLoginUri() => Uri.parse("$baseUrl/api/auth/sns/mobile");
  Uri getRefreshUri() => Uri.parse("$baseUrl/api/auth/refresh");
  Uri getLogoutUri() => Uri.parse("$baseUrl/api/auth/logout");
  Uri postJoinUri() => Uri.parse("$baseUrl/api/auth/join");
  Uri postPasswordUri() => Uri.parse("$baseUrl/api/auth/password");
  Uri getMyInfoUri() => Uri.parse("$baseUrl/api/auth/myinfo");
  Uri postMyInfoUri() => Uri.parse("$baseUrl/api/auth/myinfo");
  Uri postPublicUri() => Uri.parse("$baseUrl/api/auth/public");
  Uri getFindIdUri() => Uri.parse("$baseUrl/api/auth/findId");
  Uri postProfileImageUri(int id) => Uri.parse("$baseUrl/api/auth/profileImage/$id");
  Uri deleteProfileImageUri() => Uri.parse("$baseUrl/api/auth/profileImage");
  Uri getLeaveUri() => Uri.parse("$baseUrl/api/auth/leave");
}
