import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school/dataclasses/review.dart';
import 'package:school/screens/main_page/widgets/home_screen_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/review_api.dart';
import 'home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _profileImageUrl =
      'https://sun9-17.userapi.com/impg/Y6qMi35j6HE6HeZ6uS4HGsRe4pc5BYeXHy-h8g/m71YiHlpWH8.jpg?size=2560x1920&quality=95&sign=f64d0fb93c2676b015ab8d974b347515&type=album';
  List<Review> _reviews = [];
  final ReviewApi _reviewApi = ReviewApi();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<Review> reviews = await _reviewApi.getAllReview();
    setState(() {
      _reviews = reviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: HomeScreenBody(
        profileImageUrl: _profileImageUrl,
        reviews: _reviews,
      ),
    );
  }
}
