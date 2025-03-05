import 'dart:io';

abstract class FileAPI {
  // 즐겨찾기 관련 API
  Future<int> postUpload({
    required File file
  });

}
