import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<String> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['streamToken'];
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['streamToken'];
    } else {
      throw Exception('Failed to login');
    }
  }
}