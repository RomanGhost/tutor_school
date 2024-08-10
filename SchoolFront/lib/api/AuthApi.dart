import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/auth'; // Замените на ваш IP
  String? _jwt;

  Future<void> _saveJwt(String jwt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', jwt);
  }

  Future<String?> _getJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<void> _clearJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

  Future<String?> authenticateUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _jwt = responseData['jwt'];
        await _saveJwt(_jwt!);
        return _jwt;
      } else {
        print('Failed to login: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while logging in: $e');
      return null;
    }
  }

  Future<String?> registerUser(String firstName, String lastName, String surname, String email, String password) async {
    try {
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
        await _saveJwt(_jwt!);
        return _jwt;
      } else {
        print('Failed to register: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while registering: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    try {
      final jwt = await _getJwt();
      if (jwt == null) {
        print('No JWT found, user may not be authenticated.');
        return null;
      }

      final url = Uri.parse('$baseUrl/user?email=$email');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get user: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching user: $e');
      return null;
    }
  }

  void logout() async {
    await _clearJwt(); // Очистка токена при выходе
    _jwt = null;
  }
}
