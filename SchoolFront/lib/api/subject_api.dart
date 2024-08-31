import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dataclasses/subject.dart';
import '../service/jwt_work.dart';
import 'api_interface.dart';

class SubjectApi extends Api{
  final String _baseUrl = 'http://localhost:8080/api';

  Future<List<Subject>> getAvailableSubjects() async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Subject>.empty();
    }

    final url = Uri.parse('$_baseUrl/subject/get_access_user');
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
        List<Subject> resultLessons = List.empty(growable: true);
        //
        for (var lessonJson in result){
          Subject newSubject = Subject(
              id: lessonJson['id'],
              name: lessonJson['name'],
              price: lessonJson['price'],
          );
          resultLessons.add(newSubject);
        }
        return resultLessons;
      } else {
        logError('Failed to get lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return List<Subject>.empty();
  }

  Future<void> addSubjectUser(Subject subject) async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    final url = Uri.parse('$_baseUrl/user_subject/add');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({
          'id':subject.id,
          'name':subject.name,
          'price':subject.price,
          'level':subject.level,
        }),
      );
      if (response.statusCode != 200) {
        logError('Failed to get lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
  }

  Future<List<Subject>> getUserSubjects() async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return List<Subject>.empty();
    }

    final url = Uri.parse('$_baseUrl/user_subject/getuserall');
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
        List<Subject> resultSubject = List.empty(growable: true);
        for (var subjectJson in result){
          print(subjectJson);
          Subject newSubject = Subject(
            id: subjectJson['id'],
            name: subjectJson['name'],
            price: subjectJson['price'],
            level:subjectJson['level']
          );
          resultSubject.add(newSubject);
        }
        return resultSubject;
      } else {
        logError('Failed to get lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
    return List<Subject>.empty();
  }

  Future<void> deleteUserSubject(Subject subject) async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    final url = Uri.parse('$_baseUrl/user_subject/delete');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({
          'id':subject.id,
          'name':subject.name,
          'price':subject.price,
          'level':subject.level,
        }),
      );
      if (response.statusCode != 200) {
        logError('Failed to get lesson', response);
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
    }
  }
}