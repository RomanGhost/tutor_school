import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dataclasses/User.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:8080/api/auth'; // Замените на ваш IP
  String? _jwt;

  Future<void> _saveJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', jwt);
  }

  Future<String?> _getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<void> _clearJwt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

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
          await _saveJwt(jwt);
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
          await _saveJwt(jwt);
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

  Future<User?> getUser(String email) async {
    final jwt = await _getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/user?email=$email');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        return User(
          email: result['email'],
          firstName: result['firstName'],
          lastName: result['lastName'],
          surname: result['surname'],
        );
      } else {
        _logError('Failed to get user', response);
      }
    } catch (e) {
      print('Error occurred while fetching user: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(User user) async {
    final jwt = await _getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return false;
    }

    final url = Uri.parse('$_baseUrl/user/update');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({
          'firstName': user.firstName,
          'lastName': user.lastName,
          'surname': user.surname,
          'email': user.email,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true;
      } else {
        _logError('Failed to update profile', response);
      }
    } catch (e) {
      print('Error occurred while updating profile: $e');
    }
    return false;
  }

  void logout() async {
    await _clearJwt();
    _jwt = null;
  }

  void _logError(String message, http.Response response) {
    print('$message: ${response.statusCode} ${response.body}');
  }
}
