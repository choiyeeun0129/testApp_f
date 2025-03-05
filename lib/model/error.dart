import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

class APIError extends Error {
  final Response response;

  APIError(this.response);

  @override
  String toString() {
    log("API Error: \"[${response.request?.method}] [${response.statusCode}] ${response.request?.url.path}\" $error $message");
    return "$message";
  }

  Map<String, dynamic> get body {
    return json.decode(response.body);
  }

  String get bodyString {
    return utf8.decode(response.bodyBytes);
  }

  String get error {
    try {
      return json.decode(bodyString)["error"];
    } catch (error) {
      return "알 수 없는 오류";
    }
  }

  String get message {
    try {
      return json.decode(bodyString)["message"];
    } catch (error) {
      return "알 수 없는 메시지";
    }
  }
}

class MultiPartError extends Error {
  final StreamedResponse response;

  MultiPartError(this.response);

  @override
  String toString() {
    log("API Error: \"[${response.request?.method}] ${response.request?.url.path}\" $message");
    return "$message";
  }

  Future<Map<String, dynamic>> get body async {
    return json.decode(utf8.decode(await response.stream.toBytes()));
  }

  Future<String> get bodyString async {
    return utf8.decode(await response.stream.toBytes());
  }

  Future<String> get error async {
    try {
      return json.decode(await bodyString)["error"];
    } catch (error) {
      return "알 수 없는 오류";
    }
  }

  Future<String> get message async {
    try {
      return json.decode(await bodyString)["message"];
    } catch (error) {
      return "알 수 없는 메시지";
    }
  }
}