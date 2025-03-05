import 'package:gnu_mot_t/model/code.dart';

class UserFavorite {
  final int id;
  final String loginId;
  final String name;
  final String? profileImage;
  final int birthYear;
  final String mobileNumber;
  final String email;
  final String? website;
  final String roleCode;
  final String batchCode;
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
  final bool isPublic;
  final bool isPublicMobile;
  final bool isPublicOffice;
  final bool isPublicEmail;
  final bool isPublicDepartment;
  final bool isPublicBirth;
  final bool enabled;
  final String? lastLoginDt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Code? role;
  final Code? batch;
  final Code? degree;
  final Code? course;

  UserFavorite({
    required this.id,
    required this.loginId,
    required this.name,
    this.profileImage,
    required this.birthYear,
    required this.mobileNumber,
    required this.email,
    this.website,
    required this.roleCode,
    required this.batchCode,
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
    required this.isPublic,
    required this.isPublicMobile,
    required this.isPublicOffice,
    required this.isPublicEmail,
    required this.isPublicDepartment,
    required this.isPublicBirth,
    required this.enabled,
    this.lastLoginDt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.role,
    this.batch,
    this.degree,
    this.course,
  });

  factory UserFavorite.fromJson(Map<String, dynamic> json) {
    return UserFavorite(
      id: json["id"],
      loginId: json["loginId"],
      name: json["name"],
      profileImage: json["profileImage"],
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
}