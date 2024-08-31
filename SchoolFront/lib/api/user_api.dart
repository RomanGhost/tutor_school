import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school/api/api_interface.dart';

import '../dataclasses/user.dart';
import '../service/jwt_work.dart';

class UserApi extends Api{
  final String _baseUrl = 'http://localhost:8080/api/user';

  Future<User?> getUser(String email) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/get?email=$email');
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
        logError('Failed to get user', response);
      }
    } catch (e) {
      print('Error occurred while fetching user: $e');
    }
    return null;
  }


  Future<bool> updateUserProfile(User user) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return false;
    }

    final url = Uri.parse('$_baseUrl/update');
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
        logError('Failed to update profile', response);
      }
    } catch (e) {
      print('Error occurred while updating profile: $e');
    }
    return false;
  }
}