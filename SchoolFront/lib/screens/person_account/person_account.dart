import 'package:flutter/material.dart';
import 'package:school/widgets/side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../api/AuthApi.dart';
import '../../widgets/next_lesson_widget.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    String? email = decodedToken['sub'];
    print("Email: $email");

    final data = await _apiService.getUser(email!);
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      drawer: SideMenu(), // Добавление боковой панели
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NextLessonWidget(),
            Text('First Name: ${_userData!['firstName']}', style: TextStyle(fontSize: 18)),
            Text('Last Name: ${_userData!['lastName']}', style: TextStyle(fontSize: 18)),
            Text('Email: ${_userData!['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Welcome to your dashboard!',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
