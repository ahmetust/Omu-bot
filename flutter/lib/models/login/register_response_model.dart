class RegisterResponse {
  final int id;

  RegisterResponse({required this.id});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'],
    );
  }
}
