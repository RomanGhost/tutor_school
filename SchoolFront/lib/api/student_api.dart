import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school/dataclasses/student.dart';

import '../dataclasses/config.dart';
import '../service/jwt_work.dart';
import 'api_interface.dart';

class StudentApi extends Api {
  final String _baseUrl = '${Config.baseUrl}/api/student/teacher';

  Future<List<Student>> getStudents() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return [];
    }

    final url = Uri.parse('$_baseUrl/get_all');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as List<dynamic>;
        final List<Student> resultList = [];
        for(Map<String, dynamic> studentJson in result){
          Student newStudent = Student(
              id: studentJson['id'],
              firstName: studentJson['firstName'],
              lastName: studentJson['lastName'],
              email: studentJson['email'],
              subject: studentJson['subject'],
          );
          resultList.add(newStudent);
          return resultList;
        }
      } else {
        logError('Failed to get student', response);
      }
    } catch (e) {
      print('Error occurred while fetching student: $e');
    }
    return [];
  }
}