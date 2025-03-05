class Code {
  final String code;
  final String grpCode;
  final String name;
  final String? value;
  final String? memo;
  final int orderSn;
  final bool enabled;
  final String createdAt;
  final String? updatedAt;
  final CodeGroup? codeGroup;

  Code({
    required this.code,
    required this.grpCode,
    required this.name,
    this.value,
    this.memo,
    required this.orderSn,
    required this.enabled,
    required this.createdAt,
    this.updatedAt,
    this.codeGroup,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      code: json["code"],
      grpCode: json["grpCode"],
      name: json["name"],
      value: json["value"],
      memo: json["memo"],
      orderSn: json["orderSn"],
      enabled: json["enabled"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      codeGroup: json["codeGroup"] != null ? CodeGroup.fromJson(json["codeGroup"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "grpCode": grpCode,
      "name": name,
      "value": value,
      "memo": memo,
      "orderSn": orderSn,
      "enabled": enabled,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "codeGroup": codeGroup?.toJson(),
    };
  }
}

class CodeGroup {
  final String name;

  CodeGroup({
    required this.name,
  });

  factory CodeGroup.fromJson(Map<String, dynamic> json) {
    return CodeGroup(
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}