class Token {
  final String accessToken;

  Token({
    required this.accessToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json["accessToken"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
    };
  }
}