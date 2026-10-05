import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import 'session_service.dart';

/// Thrown whenever the API returns a non-2xx response. [message] is pulled
/// from the API's own JSON body (`{ "message": "..." }`) when possible, so
/// you can show it straight in a SnackBar.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

/// Thin wrapper around http.* that:
/// - prefixes every path with ApiConfig.baseUrl
/// - sends/receives JSON
/// - attaches "Authorization: Bearer <token>" automatically when a session
///   token is stored (pass [auth] = false for the two endpoints that don't
///   need it: /api/auth/login and /api/auth/register)
/// - turns non-2xx responses into an ApiException with the API's message
class ApiClient {
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await SessionService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  static dynamic _decode(http.Response res) {
    final body = res.body.isEmpty ? null : jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }

    String message = 'Something went wrong (${res.statusCode}).';
    if (body is Map && body['message'] != null) {
      message = body['message'].toString();
    } else if (res.statusCode == 401) {
      message = 'Your session expired. Please log in again.';
    } else if (res.statusCode == 403) {
      message = 'Your account is disabled, or you don\'t have access.';
    }
    throw ApiException(res.statusCode, message);
  }

  static Future<dynamic> get(String path, {bool auth = true}) async {
    final res = await http.get(_uri(path), headers: await _headers(auth: auth));
    return _decode(res);
  }

  static Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final res = await http.post(
      _uri(path),
      headers: await _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }

  static Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final res = await http.put(
      _uri(path),
      headers: await _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }

  static Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final res = await http.patch(
      _uri(path),
      headers: await _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }
}
