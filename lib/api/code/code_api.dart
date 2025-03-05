import 'package:gnu_mot_t/model/code.dart';

abstract class CodeAPI {
  // 코드 관련 API
  Future<List<Code>> getCodeList({
    required String groupCode,
  });

  Future<List<Code>> getBatchCodes();
}
