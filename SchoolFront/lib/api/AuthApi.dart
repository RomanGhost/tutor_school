import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/auth'; // Замените на ваш IP
  String? _jwt;

  Future<String?> authenticateUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _jwt = responseData['jwt'];
      return _jwt;
    } else {
      print('Failed to login: ${response.statusCode} ${response.body}');
      return null;
    }
  }

  Future<String?> registerUser(String firstName, String lastName, String surname, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'surname': surname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('User registered successfully');
      final Map<String, dynamic> responseData = json.decode(response.body);
      _jwt = responseData['jwt'];
      return _jwt;
    } else {
      print('Failed to register: ${response.statusCode} ${response.body}');
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final url = Uri.parse('$baseUrl/user?email=$email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_jwt',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to get user: ${response.statusCode} ${response.body}');
      return null;
    }
  }

  void logout() {
    _jwt = null; // Очистка токена при выходе
  }
}
