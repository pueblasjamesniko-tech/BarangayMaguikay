import 'package:shared_preferences/shared_preferences.dart';

/// Stores what we get back from /api/auth/login (or /register) so the user
/// stays logged in between app launches, and so ApiClient can attach the
/// JWT token to every request after this.
class SessionService {
  static const _kToken = 'session_token';
  static const _kRole = 'session_role';
  static const _kId = 'session_id';
  static const _kFullName = 'session_full_name';
  static const _kEmail = 'session_email';

  /// Call this right after a successful login/register response.
  static Future<void> save({
    required String token,
    required String role,
    required int id,
    required String fullName,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
    await prefs.setString(_kRole, role);
    await prefs.setInt(_kId, id);
    await prefs.setString(_kFullName, fullName);
    await prefs.setString(_kEmail, email);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole);
  }

  static Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kId);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kFullName);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail);
  }

  /// True once a token is stored, so the app can skip straight past login.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRole);
    await prefs.remove(_kId);
    await prefs.remove(_kFullName);
    await prefs.remove(_kEmail);
  }
}
