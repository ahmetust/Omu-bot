class LoginResponse {
  final int id;
  final String role;

  LoginResponse({required this.id, required this.role});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['user_id'],
      role: json['role'],
    );
  }
}
