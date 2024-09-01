import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school/api/api_interface.dart';
import 'package:school/dataclasses/review.dart';

import '../dataclasses/config.dart';
import '../service/jwt_work.dart';

class ReviewApi extends Api{
  final String _baseUrl = '${Config.baseUrl}/api/review';

  Future<List<Review>> getAllReview() async{
    final url = Uri.parse('$_baseUrl/get_all');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as List<dynamic>;
        // print(result);
        List<Review> resultReview = List.empty(growable: true);
        //
        for (var reviewJson in result){
          Review newReview = Review(
            rate: reviewJson['rate'],
            text: reviewJson['text'],
            source: reviewJson['source'],
            userData: reviewJson['userData'],
          );
          resultReview.add(newReview);
        }
        return resultReview;
      } else {
        logError('Failed to get lesson', response);
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching lesson: $e');
      return [];
    }
  }

  Future<void> addNewReview(Review review) async{
    final jwt = await JwtWork().getJwt();
    if (jwt == null) {
      print('No JWT found, user may not be authenticated.');
      return;
    }

    final url = Uri.parse('$_baseUrl/add');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode(review.getJson()),
      );
      if (response.statusCode != 200) {
        logError('Failed to send review', response);
      }
    } catch (e) {
      print('Error occurred while fetching review: $e');
    }
  }
}