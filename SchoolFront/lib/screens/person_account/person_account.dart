import 'package:flutter/material.dart';
import 'package:school/api/user_api.dart';
import 'package:school/errors/jwt_errors.dart';
import 'package:school/widgets/side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';
import '../../widgets/next_lesson_widget.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserApi _apiService = UserApi();
  User? _userData;

  @override
  void initState() {
    super.initState();
    try {
      _loadUserData();
    }on JwtIsNull catch(e){
      print(e);
      if (Navigator.canPop(context))
        Navigator.pop(context);
      else
        Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if(jwt == null) {
      throw JwtIsNull("Token is not valid");
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    print(decodedToken);
    String? email = decodedToken['sub'];

    final user = await _apiService.getUser(email!);
    setState(() {
      _userData = user;
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
