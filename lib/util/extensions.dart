import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gnu_mot_t/model/code.dart';
import 'package:gnu_mot_t/model/user.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

extension PaddingExtension on BuildContext {
  double get bottomPadding {
    var viewPadding = MediaQuery.of(this).viewPadding;

    return viewPadding.bottom;
  }

  double get topPadding {
    var viewPadding = MediaQuery.of(this).viewPadding;

    return viewPadding.top;
  }
}

extension ResponseExtension on Response {
  bool get isError {
    try {
      var body = json.decode(utf8.decode(bodyBytes));

      // body가 Map이 아닐 경우를 처리
      if (body is! Map) {
        return false;  // 또는 상황에 맞는 기본값 반환
      }

      return (body["success"] != null && body["success"] == false);
    } catch (e) {
      // JSON 디코딩 중 오류가 발생한 경우
      return false;  // 또는 상황에 맞는 기본값 반환
    }
  }
}

extension IntTimerParsing on int {
  String parseTimer() {
    int minute = (this / 60).floor();
    int second = (this % 60);
    String minuteString = minute == 0 ? "" : "$minute분 ";
    String secondString = "$second초";
    return minuteString + secondString;
  }

  String parseHour() {
    if (this < 10) {
      return "0$this";
    } else {
      return "$this";
    }
  }

  String get timerText {
    int sec = this % 60;
    int min = (this / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }
}

extension DoubleMoneyParsing on double {
  String parseMoney() {
    return NumberFormat("#,##0").format(this);
  }
}

extension TypoExtension on TextStyle {
  TextStyle colored(Color color) {
    return copyWith(color: color);
  }
}

extension FormattedDateTime on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }
}

extension ColorFromString on String {
  Color toColor() {
    if (isEmpty) {
      return Colors.white;
    } else {
      var hexColor = replaceAll("#", "");
      if (hexColor.length == 3) {
        hexColor = "FF${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}";
      }

      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      }
    }
    return Colors.white;
  }
}

extension StringToDateTime on String {
  DateTime get dateTime {
    return DateFormat("hh:mm:ss").parse(this);
  }
}

extension SuperString on String? {
  bool get isNullOrEmpty {
    if(this != null){
      return this!.isEmpty;
    }else{
      return true;
    }
  }

  bool get isExist {
    return this != null && this!.isNotEmpty;
  }

  bool get isPhoneNumber {
    if(isExist) {
      return RegExp(r'^[0-9-]+$').hasMatch(this!);
    } else {
      return false;
    }
  }
}

extension LastString on String {
  String lastChars(int n) => substring(length - n);
}

String get currentDay {
  return DateTime.now().format("yyyy-MM-dd");
}

String get currentDayBeforeWeek {
  return DateTime.now().add(const Duration(days: -6)).format("yyyyMMdd");
}

String get currentDayBeforeMonth {
  return DateTime.now().add(const Duration(days: -30)).format("yyyyMMdd");
}

String get currentDate {
  return DateTime.now().format("yyyyMMddHHmmss");
}

String get currentDateMinute {
  return DateTime.now().format("yyyyMMddHHmm");
}

String get currentTime {
  return DateFormat('HH:mm').format(DateTime.now());
}

String get today {
  return DateTime.now().format("yyyyMMdd");
}

String get todayString {
  return DateTime.now().format("yyyy년 MM월 dd일");
}

String get todayPrinterString {
  return DateTime.now().format("yyyy년 MM월 dd일 HH:mm:ss");
}

extension BoolFromDateTime on DateTime {
  bool get isToday {
    String date = format("yyyyMMdd");
    String today = DateTime.now().format("yyyyMMdd");
    return date == today;
  }
}

extension CodeString on String {
  String get name {
    var mName = this;
    switch(this){
      case "ROLE_ADMIN": mName = "관리자";
      case "ROLE_1": mName = "교수진";
      case "ROLE_2": mName = "교직원";
      case "ROLE_3": mName = "학생";
      case "COURSE_1": mName = "석사과정";
      case "COURSE_2": mName = "석박사통합";
      case "COURSE_3": mName = "박사과정";
      case "DEGREE_1": mName = "석사";
      case "DEGREE_2": mName = "박사";
      case "DOC_HELP": mName = "도움말";
      case "DOC_NOTICE": mName = "공지사항";
      case "DOC_POLICY": mName = "이용약관 및 정책";
      case "BATCH_1": mName = "MOT 1기";
      case "BATCH_2": mName = "MOT 2기";
      case "BATCH_3": mName = "MOT 3기";
      case "BATCH_4": mName = "MOT 4기";
      case "BATCH_5": mName = "MOT 5기";
    }
    return mName;
  }
}
extension DummyUser on User {
  static User dummy() {
    return User(
      id: 1,
      loginId: "dummy_user",
      name: "홍길동",
      profileImage: "https://example.com/profile.jpg",
      birthYear: 1990,
      mobileNumber: "010-1234-5678",
      email: "dummy@example.com",
      website: "https://example.com",
      roleCode: "ROLE_STUDENT",
      batchCode: "BATCH_2024",
      memo: "더미 사용자 데이터입니다.",
      companyName: "더미 주식회사",
      officeAddress: "서울시 강남구 테헤란로 123",
      officePhone: "02-123-4567",
      level: "4",
      job: "개발자",
      major: "컴퓨터공학",
      degreeCode: "DEGREE_BACHELOR",
      courseCode: "COURSE_CS",
      advisor: "김교수",
      graduated: false,
      retirement: false,
      isPublic: true,
      isPublicMobile: false,
      isPublicOffice: true,
      isPublicEmail: true,
      isPublicDepartment: true,
      isPublicBirth: false,
      enabled: true,
      lastLoginDt: "2024-12-20T12:00:00",
      createdAt: "2024-01-01T00:00:00",
      updatedAt: "2024-12-20T12:00:00",
      deletedAt: null,
      role: Code(
          code: "ROLE_STUDENT",
          grpCode: "ROLE",
          name: "학생",
          value: "STUDENT",
          memo: "학생 역할",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "역할")
      ),
      batch: Code(
          code: "BATCH_2024",
          grpCode: "BATCH",
          name: "2024학년도",
          value: "2024",
          memo: "2024학년도 입학",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "학년도")
      ),
      degree: Code(
          code: "DEGREE_BACHELOR",
          grpCode: "DEGREE",
          name: "학사",
          value: "BACHELOR",
          memo: "학사과정",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "학위")
      ),
      course: Code(
          code: "COURSE_CS",
          grpCode: "COURSE",
          name: "컴퓨터공학",
          value: "CS",
          memo: "컴퓨터공학과정",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "과정")
      ),
    );
  }

  static List<User> dummyList(int count) {
    return List.generate(count, (index) => User(
      id: index + 1,
      loginId: "dummy_user_${index + 1}",
      name: "홍길동${index + 1}",
      profileImage: "https://example.com/profile_${index + 1}.jpg",
      birthYear: 1990 + (index % 10),
      mobileNumber: "010-1234-${(5678 + index).toString().padLeft(4, '0')}",
      email: "dummy${index + 1}@example.com",
      website: "https://example.com/user${index + 1}",
      roleCode: "ROLE_STUDENT",
      batchCode: "BATCH_2024",
      memo: "더미 사용자 데이터 ${index + 1}입니다.",
      companyName: "더미 주식회사 ${index + 1}",
      officeAddress: "서울시 강남구 테헤란로 ${123 + index}",
      officePhone: "02-123-${(4567 + index).toString().padLeft(4, '0')}",
      level: "${4 + (index % 3)}",
      job: "개발자",
      major: "컴퓨터공학",
      degreeCode: "DEGREE_BACHELOR",
      courseCode: "COURSE_CS",
      advisor: "김교수",
      graduated: index % 2 == 0,
      retirement: index % 2 == 0,
      isPublic: true,
      isPublicMobile: index % 2 == 0,
      isPublicOffice: true,
      isPublicEmail: true,
      isPublicDepartment: true,
      isPublicBirth: index % 2 == 0,
      enabled: true,
      lastLoginDt: "2024-12-20T12:00:00",
      createdAt: "2024-01-01T00:00:00",
      updatedAt: "2024-12-20T12:00:00",
      deletedAt: null,
      role: Code(
          code: "ROLE_STUDENT",
          grpCode: "ROLE",
          name: "학생",
          value: "STUDENT",
          memo: "학생 역할",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "역할")
      ),
      batch: Code(
          code: "BATCH_2024",
          grpCode: "BATCH",
          name: "2024학년도",
          value: "2024",
          memo: "2024학년도 입학",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "학년도")
      ),
      degree: Code(
          code: "DEGREE_BACHELOR",
          grpCode: "DEGREE",
          name: "학사",
          value: "BACHELOR",
          memo: "학사과정",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "학위")
      ),
      course: Code(
          code: "COURSE_CS",
          grpCode: "COURSE",
          name: "컴퓨터공학",
          value: "CS",
          memo: "컴퓨터공학과정",
          orderSn: 1,
          enabled: true,
          createdAt: "2024-01-01T00:00:00",
          updatedAt: "2024-12-20T12:00:00",
          codeGroup: CodeGroup(name: "과정")
      ),
    ));
  }
}

MethodChannel get channel => const MethodChannel('kr.puze.aqual');