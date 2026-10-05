import '../models/auth_models.dart';
import 'api_client.dart';
import 'session_service.dart';

/// Wraps the three auth endpoints from AuthController.cs.
/// Mobile only ever needs register() and login() — webLogin() is here for
/// completeness/reference since that endpoint is for the PHP web side.
class AuthService {
  /// POST /api/auth/register
  /// Always creates a "user" (mobile) account on the API.
  static Future<AuthResponse> register(RegisterRequest req) async {
    final json = await ApiClient.post(
      '/api/auth/register',
      body: req.toJson(),
      auth: false,
    );
    final auth = AuthResponse.fromJson(json as Map<String, dynamic>);
    await SessionService.save(
      token: auth.token,
      role: auth.role,
      id: auth.id,
      fullName: auth.fullName,
      email: auth.email,
    );
    return auth;
  }

  /// POST /api/auth/login (mobile login — LoginType.Mobile)
  static Future<AuthResponse> login(LoginRequest req) async {
    final json = await ApiClient.post(
      '/api/auth/login',
      body: req.toJson(),
      auth: false,
    );
    final auth = AuthResponse.fromJson(json as Map<String, dynamic>);
    await SessionService.save(
      token: auth.token,
      role: auth.role,
      id: auth.id,
      fullName: auth.fullName,
      email: auth.email,
    );
    return auth;
  }

  /// POST /api/auth/web-login — not used by the mobile app, kept for reference.
  static Future<AuthResponse> webLogin(LoginRequest req) async {
    final json = await ApiClient.post(
      '/api/auth/web-login',
      body: req.toJson(),
      auth: false,
    );
    return AuthResponse.fromJson(json as Map<String, dynamic>);
  }

  static Future<void> logout() => SessionService.clear();
}
