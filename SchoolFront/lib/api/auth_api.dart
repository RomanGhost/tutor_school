import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school/service/jwt_work.dart';

import '../dataclasses/config.dart';
import '../dataclasses/user.dart';
import 'api_interface.dart';

class AuthApi extends Api{
  final String _baseUrl = '${Config.baseUrl}/api/auth'; // Замените на ваш IP
  String? _jwt;

  Future<String?> authenticateUser(User user) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': user.email,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final jwt = responseData['jwt'] as String?;
        if (jwt != null) {
          _jwt = jwt;
          await JwtWork().saveJwt(jwt);
          return jwt;
        }
      } else {
        _logError('Failed to login', response);
      }
    } catch (e) {
      print('Error occurred while logging in: $e');
    }
    return null;
  }

  Future<String?> registerUser(User newUser) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': newUser.firstName,
          'lastName': newUser.lastName,
          'surname': newUser.surname,
          'email': newUser.email,
          'password': newUser.password,
        }),
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final jwt = responseData['jwt'] as String?;
        if (jwt != null) {
          _jwt = jwt;
          await JwtWork().saveJwt(jwt);
          return jwt;
        }
      } else {
        _logError('Failed to register', response);
      }
    } catch (e) {
      print('Error occurred while registering: $e');
    }
    return null;
  }

  void logout() async {

    await JwtWork().clearJwt();
    _jwt = null;
  }

  void _logError(String message, http.Response response) {
    print('$message: ${response.statusCode} ${response.body}');
  }
}
