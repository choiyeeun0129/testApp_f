import 'package:testApp/model/code.dart';

abstract class CodeAPI {
  // 코드 관련 API
  Future<List<Code>> getCodeList({
    required String groupCode,
  });

  Future<List<Code>> getBatchCodes();
}
