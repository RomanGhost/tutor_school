import 'dart:convert';

import '../dataclasses/lesson.dart';
import '../service/jwt_work.dart';
import 'package:http/http.dart' as http;
import 'api_interface.dart';

class LessonApi implements Api{
  final String _baseUrl = 'http://localhost:8080/api/lesson'; // Замените на ваш IP

  Future<List<Lesson>> getLessons() async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final url = Uri.parse('$_baseUrl/get');
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
        // print(result);
        List<Lesson> resultLessons = List.empty(growable: true);
        //
        for (var lessonJson in result){
          Lesson newLesson = Lesson(
              title: lessonJson['subject'],
              time: DateTime.parse(lessonJson['plainDateTime']),
              status: lessonJson['status']
          );
          resultLessons.add(newLesson);
        }
        return resultLessons;
      } else {
        _logError('Failed to get user', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return List<Lesson>.empty();
  }

  void _logError(String message, http.Response response) {
    print('$message: ${response.statusCode} ${response.body}');
  }

}