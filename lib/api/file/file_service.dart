import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:testApp/api/auth/auth_service.dart';
import 'package:testApp/manager/info_manager.dart';
import 'package:http/http.dart' as http;
import 'package:testApp/api/api_service.dart';
import 'package:testApp/api/file/file_api.dart';
import 'package:testApp/model/error.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

final fileService = FileService();
class FileService extends APIService implements FileAPI {
  @override
  Future<int> postUpload({required File file}) async {
    try {
      final request = http.MultipartRequest('POST', postFileUri());

      // MIME type 설정
      final mimeType = lookupMimeType(file.path); // 파일 확장자로부터 MIME type 추론
      final contentType = mimeType != null ? MediaType.parse(mimeType) : null;

      // 단일 파일 추가
      log("postUpload/path: ${file.path}");
      final multipartFile = await http.MultipartFile.fromPath(
        'file',  // 서버에서 기대하는 필드명
        file.path,
        contentType: contentType, // MIME type 설정
      );
      request.files.add(multipartFile);

      // 헤더 추가
      request.headers.addAll(authorizationHeader);

      // 요청 전송 및 응답 받기
      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      log("postUpload/statusCode: ${response.statusCode}");
      // 응답 처리
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['success'] == false) {
          throw MultiPartError(streamedResponse);
        }

        return jsonBody['id'];
      }else if(response.statusCode == 401){
        try {
          String accessToken = await authService.getRefreshToken();
          await infoManager.setAccessToken(accessToken);
          int id = await fileService.postUpload(file: file);
          return id;
        } catch (e) {
          rethrow;
        }
      }

      throw MultiPartError(streamedResponse);
    } catch (e) {
      rethrow;
    }
  }
}

extension on FileService {
  Uri postFileUri() => Uri.parse("$baseUrl/api/file/upload");
}
