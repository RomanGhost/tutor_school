import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school/dataclasses/teacher_lesson.dart';
import '../dataclasses/lesson.dart';
import '../service/jwt_work.dart';
import 'api_interface.dart';

class LessonApi extends Api {
  final String _baseUrl = 'http://localhost:8080/api/lesson'; // Замените на ваш IP

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

  Future<List<Lesson>> getLessonsForMonth(int year, int month) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final url = Uri.parse('$_baseUrl/get_by_month?year=$year&month=$month');
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
        List<Lesson> resultLessons = List.empty(growable: true);

        for (var lessonJson in result) {
          Lesson newLesson = Lesson(
              id: lessonJson['id'],
              title: lessonJson['subject'],
              time: DateTime.parse(lessonJson['plainDateTime']),
              status: lessonJson['status']);
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

  Future<List<Lesson>> getLessons() async {
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
        List<Lesson> resultLessons = List.empty(growable: true);

        for (var lessonJson in result) {
          DateTime utcTime = DateTime.parse(lessonJson['plainDateTime']).toUtc();
          Lesson newLesson = Lesson(
              id: lessonJson['id'],
              title: lessonJson['subject'],
              time: utcTime,
              status: lessonJson['status']);
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

  Future<Lesson?> getNextLessons() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/get_next');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );
      if (response.statusCode == 200) {
        final lessonJson = json.decode(response.body) as Map<String, dynamic>;
        DateTime utcTime = DateTime.parse(lessonJson['plainDateTime']).toUtc();
        Lesson nextLesson = Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: utcTime,
          status: lessonJson['status'],
        );
        return nextLesson;
      } else {
        logError('Failed to get next lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return null;
  }

  Future<Lesson?> addLessons(Lesson lesson) async {
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
          'subject': lesson.title,
          'status': lesson.status,
          'plainDateTime': lesson.time.toUtc().toIso8601String(), // Отправляем в формате UTC
        }),
      );
      if (response.statusCode == 200) {
        final lessonJson = json.decode(response.body) as Map<String, dynamic>;
        DateTime utcTime = DateTime.parse(lessonJson['plainDateTime']).toUtc();
        Lesson newLesson = Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: utcTime,
          status: lessonJson['status'],
        );
        return newLesson;
      } else {
        logError('Failed to add lesson', response);
      }
    } catch (e) {
      print('Error occurred while adding lesson: $e');
    }
    return null;
  }

  Future<List<TeacherLesson>> getProposedLessonsForTeacher() async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<TeacherLesson>.empty();
    }

    final url = Uri.parse('$_baseUrl/teacher/get');
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
        List<TeacherLesson> proposedLessons = List.empty(growable: true);

        for (var lessonTeacherJson in result) {
          var lessonJson = lessonTeacherJson["lessonData"];
          DateTime utcTime = DateTime.parse(lessonJson['plainDateTime']).toUtc();
          Lesson lesson = Lesson(
            id: lessonJson['id'],
            title: lessonJson['subject'],
            time: utcTime,
            status: lessonJson['status'],
          );
          TeacherLesson teacherLesson = TeacherLesson(
              lesson: lesson,
              firstName: lessonTeacherJson['firstName'],
              lastName: lessonTeacherJson['lastName']
          );
          proposedLessons.add(teacherLesson);
        }
        return proposedLessons;
      } else {
        logError('Failed to get proposed lessons', response);
      }
    } catch (e) {
      print('Error occurred while fetching proposed lessons: $e');
    }
    return List<TeacherLesson>.empty();
  }

  Future<TeacherLesson?> approveLesson(int lessonId) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/teacher/approve?lessonId=$lessonId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;

        var lessonJson = result["lessonData"] as Map<String, dynamic>;
        DateTime utcTime = DateTime.parse(lessonJson['plainDateTime']).toUtc();
        Lesson lesson = Lesson(
          id: lessonJson['id'],
          title: lessonJson['subject'],
          time: utcTime,
          status: lessonJson['status'],
        );
        TeacherLesson teacherLesson = TeacherLesson(
            lesson: lesson,
            firstName: result['firstName'],
            lastName: result['lastName']
        );

        return teacherLesson;
      } else {
        logError('Failed to approve lesson', response);
      }
    } catch (e) {
      print('Error occurred while approving lesson: $e');
    }
    return null;
  }

  Future<List<Lesson>> getTeacherLessonsForMonth(int year, int month) async {
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Lesson>.empty();
    }

    final url = Uri.parse('$_baseUrl/teacher/get_all_lessons_by_month?year=$year&month=$month');
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
        List<Lesson> resultLessons = List.empty(growable: true);

        for (var lessonJson in result) {
          Lesson newLesson = Lesson(
              id: lessonJson['id'],
              title: lessonJson['subject'],
              time: DateTime.parse(lessonJson['plainDateTime']),
              status: lessonJson['status']);
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

}
