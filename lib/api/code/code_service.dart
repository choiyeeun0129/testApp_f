import 'dart:convert';
import 'dart:developer';
import 'package:testApp/api/api_service.dart';
import 'package:testApp/api/code/code_api.dart';
import 'package:testApp/model/code.dart';
import 'package:testApp/model/error.dart';
import 'package:testApp/util/extensions.dart';

final codeService = CodeService();
class CodeService extends APIService implements CodeAPI {
  // Code Related APIs
  @override
  Future<List<Code>> getCodeList({
    required String groupCode,
  }) async {
    var response = await executeWithRetry((headers) => client.get(
      getCodeListUri(groupCode),
      headers: authorizationHeader,
    ));
    if(response.isError) throw APIError(response);
    log("getCodeList/response: [${response.statusCode}]${json.decode(utf8.decode(response.bodyBytes))}");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes)) as List;
      return body.map((e) => Code.fromJson(e)).toList();
    }
    throw APIError(response);
  }

  @override
  Future<List<Code>> getBatchCodes() async {
    log("getBatchCodes");
    var response = await executeWithRetry((headers) => client.get(
      getBatchCodesUri(),
      headers: authorizationHeader,
    ));
    log("getBatchCodes/2");
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes)) as List;
      return body.map((e) => Code.fromJson(e)).toList();
    }
    throw APIError(response);
  }
}

extension on CodeService {
  Uri getCodeListUri(String groupCode) => Uri.parse("$baseUrl/api/code/list/$groupCode");
  Uri getBatchCodesUri() => Uri.parse("$baseUrl/api/code/batchCodes");
}
