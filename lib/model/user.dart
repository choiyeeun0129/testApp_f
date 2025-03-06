import 'package:testApp/model/code.dart';

class User {
  final int id;
  final String loginId;
  final String name;
  final String? profileImage;
  final int? birthYear;
  final String? mobileNumber;
  final String? email;
  final String? website;
  final String? roleCode;
  final String? batchCode;
  final String? memo;
  final String? companyName;
  final String? officeAddress;
  final String? officePhone;
  final String? level;
  final String? job;
  final String? major;
  final String? degreeCode;
  final String? courseCode;
  final String? advisor;
  final bool graduated;
  final bool retirement;
  final bool isPublic;
  final bool isPublicMobile;
  final bool isPublicOffice;
  final bool isPublicEmail;
  final bool isPublicDepartment;
  final bool isPublicBirth;
  final bool enabled;
  final String? lastLoginDt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Code? role;
  final Code? batch;
  final Code? degree;
  final Code? course;

  User({
    required this.id,
    required this.loginId,
    required this.name,
    this.profileImage,
    this.birthYear,
    this.mobileNumber,
    this.email,
    this.website,
    this.roleCode,
    this.batchCode,
    this.memo,
    this.companyName,
    this.officeAddress,
    this.officePhone,
    this.level,
    this.job,
    this.major,
    this.degreeCode,
    this.courseCode,
    this.advisor,
    required this.graduated,
    required this.retirement,
    required this.isPublic,
    required this.isPublicMobile,
    required this.isPublicOffice,
    required this.isPublicEmail,
    required this.isPublicDepartment,
    required this.isPublicBirth,
    required this.enabled,
    this.lastLoginDt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.role,
    this.batch,
    this.degree,
    this.course,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String? profileImage;
    if(json["imageFile"] != null){
      if(json["imageFile"]["fileName"] != null){
        profileImage = "https://pbnt.kr/upload/${json["imageFile"]["fileName"]}";
      }
    }
    return User(
      id: json["id"],
      loginId: json["loginId"],
      name: json["name"],
      profileImage: profileImage,
      birthYear: json["birthYear"],
      mobileNumber: json["mobileNumber"],
      email: json["email"],
      website: json["website"],
      roleCode: json["roleCode"],
      batchCode: json["batchCode"],
      memo: json["memo"],
      companyName: json["companyName"],
      officeAddress: json["officeAddress"],
      officePhone: json["officePhone"],
      level: json["level"],
      job: json["job"],
      major: json["major"],
      degreeCode: json["degreeCode"],
      courseCode: json["courseCode"],
      advisor: json["advisor"],
      graduated: json["graduated"],
      retirement: json["retirement"],
      isPublic: json["isPublic"],
      isPublicMobile: json["isPublicMobile"],
      isPublicOffice: json["isPublicOffice"],
      isPublicEmail: json["isPublicEmail"],
      isPublicDepartment: json["isPublicDepartment"],
      isPublicBirth: json["isPublicBirth"],
      enabled: json["enabled"],
      lastLoginDt: json["lastLoginDt"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      deletedAt: json["deletedAt"],
      role: json["role"] != null ? Code.fromJson(json["role"]) : null,
      batch: json["batch"] != null ? Code.fromJson(json["batch"]) : null,
      degree: json["degree"] != null ? Code.fromJson(json["degree"]) : null,
      course: json["course"] != null ? Code.fromJson(json["course"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "loginId": loginId,
      "name": name,
      "profileImage": profileImage,
      "birthYear": birthYear,
      "mobileNumber": mobileNumber,
      "email": email,
      "website": website,
      "roleCode": roleCode,
      "batchCode": batchCode,
      "memo": memo,
      "companyName": companyName,
      "officeAddress": officeAddress,
      "officePhone": officePhone,
      "level": level,
      "job": job,
      "major": major,
      "degreeCode": degreeCode,
      "courseCode": courseCode,
      "advisor": advisor,
      "graduated": graduated,
      "retirement": retirement,
      "isPublic": isPublic,
      "isPublicMobile": isPublicMobile,
      "isPublicOffice": isPublicOffice,
      "isPublicEmail": isPublicEmail,
      "isPublicDepartment": isPublicDepartment,
      "isPublicBirth": isPublicBirth,
      "enabled": enabled,
      "lastLoginDt": lastLoginDt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "deletedAt": deletedAt,
      "role": role?.toJson(),
      "batch": batch?.toJson(),
      "degree": degree?.toJson(),
      "course": course?.toJson(),
    };
  }

  factory User.dummy() {
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

  bool get isProfessor {
    return roleCode == "ROLE_1";
  }

  bool get isEmployee {
    return roleCode == "ROLE_2";
  }

  bool get isStudent {
    return roleCode == "ROLE_3";
  }

  String get retirementText {
    return retirement ? "[퇴직]" : "[현직]";
  }
  String get pageTitle {
    if(roleCode == "ROLE_3") return batch?.name ?? "MOT 학생";
    return major ?? "";
  }

  String get infoTitle {
    if(roleCode == "ROLE_1") return "전공";
    if(roleCode == "ROLE_2") return "담당";
    if(roleCode == "ROLE_3") return graduated == true ? "졸업" : "재학";
    return "";
  }

  String get infoDescription {
    if(roleCode == "ROLE_1") return major ?? "";
    if(roleCode == "ROLE_2") return major ?? "";
    if(roleCode == "ROLE_3") return "$batchName / $courseName";
    return major ?? "";
  }

  String get batchName {
    if(batchCode == "BATCH_1") return "MOT 1기";
    else if(batchCode == "BATCH_2") return "MOT 2기";
    else if(batchCode == "BATCH_3") return "MOT 3기";
    else if(batchCode == "BATCH_4") return "MOT 4기";
    else if(batchCode == "BATCH_5") return "MOT 5기";
    else return "";
  }

  String get courseName {
    if(courseCode == "COURSE_1") return "석사과정";
    else if(courseCode == "COURSE_2") return "석박사통합";
    else if(courseCode == "COURSE_3") return "박사과정";
    else return "";
  }
}