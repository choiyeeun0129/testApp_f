import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final http.Client _client = http.Client();
  final Duration timeout = const Duration(seconds: 60);

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) => _client.get(url, headers: headers).timeout(timeout);
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) => _client.post(url, headers: headers, body: body).timeout(timeout);
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body}) => _client.patch(url, headers: headers, body: body).timeout(timeout);
  Future<http.Response> delete(Uri url, {Map<String, String>? headers}) => _client.delete(url, headers: headers).timeout(timeout);

  void close() => _client.close();
}