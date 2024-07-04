import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omu_bot/models/login/login_request_model.dart';
import 'package:omu_bot/models/login/login_response_model.dart';
import 'package:omu_bot/models/login/register_request_model.dart';
import 'package:omu_bot/models/login/register_response_model.dart';

class AuthService {
  final String baseUrl = 'http://34.89.5.66:5000';


  Future<LoginResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(LoginRequest(email: email, password: password).toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Oturum açma işlemi başarısız');
    }
  }

  Future<RegisterResponse?> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(RegisterRequest(email: email, password: password).toJson()),
    );

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Kayıt olma işlemi başarısız');
    }
  }
}
