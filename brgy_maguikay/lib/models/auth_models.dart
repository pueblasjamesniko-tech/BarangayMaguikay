/// Matches the C# RegisterRequest usage seen in AuthController.Register:
/// _repo.CreateAccountAsync(AccountRole.User, fullName, email, hash, contactNo)
/// i.e. the API wants FullName, Email, Password, and an optional ContactNo.
///
/// NOTE: the barangay-style fields in the Figma mockup (Purok/Zone, Username,
/// Proof of Residency) are NOT part of this API. Until you confirm the real
/// RegisterRequest DTO, registration only sends what the API actually reads.
class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String? contactNo;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    this.contactNo,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    if (contactNo != null && contactNo!.isNotEmpty) 'contactNo': contactNo,
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

/// Matches AuthResponse from the API: { Role, Id, FullName, Email, Token }
class AuthResponse {
  final String role;
  final int id;
  final String fullName;
  final String email;
  final String token;

  AuthResponse({
    required this.role,
    required this.id,
    required this.fullName,
    required this.email,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // C# JSON serializes PascalCase properties as camelCase by default
    // (System.Text.Json's default policy), so we read camelCase here.
    return AuthResponse(
      role: (json['role'] ?? '').toString(),
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      fullName: (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
    );
  }
}
