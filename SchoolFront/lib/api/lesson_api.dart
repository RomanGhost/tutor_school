import 'dart:convert';

import 'package:flutter/services.dart';

import '../dataclasses/lesson.dart';
import '../service/jwt_work.dart';
import 'package:http/http.dart' as http;
import 'api_interface.dart';

class LessonApi extends Api{
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
              id: lessonJson['id'],
              title: lessonJson['subject'],
              time: DateTime.parse(lessonJson['plainDateTime']),
              status: lessonJson['status']
          );
          resultLessons.add(newLesson);
        }
        return resultLessons;
      } else {
        logError('Failed to get lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return List<Lesson>.empty();
  }

  Future<Lesson?> addLessons(Lesson lesson) async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/add');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({
          'subject':lesson.title,
          'status':lesson.status,
          'plainDateTime':lesson.time.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> lessonJson = json.decode(response.body) as Map<String, dynamic>;
        Lesson lesson = Lesson(
            id: lessonJson['id'],
            title: lessonJson['subject'],
            time: DateTime.parse(lessonJson['plainDateTime']),
            status: lessonJson['status']
        );
        print('lesson saved successfully');
        return lesson;
      } else {
        logError('Failed to save lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return null;
  }

  Future<bool> deleteLesson(int lessonId) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return false;
    }
    final url = Uri.parse('$_baseUrl/remove?lessonId=$lessonId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        print('Lesson deleted successfully');
        return true;
      } else {
        logError('Failed to delete lesson', response);
      }
    } catch (e) {
      print('Error occurred while deleting lesson: $e');
    }
    return false;
  }
}