import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/AuthApi.dart';

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
    // Получение email из декодированного токена
    String? email = decodedToken['sub']; // 'sub' обычно используется для хранения идентификатора пользователя или email
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _apiService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${_userData!['firstName']}', style: TextStyle(fontSize: 18)),
            Text('Last Name: ${_userData!['lastName']}', style: TextStyle(fontSize: 18)),
            Text('Email: ${_userData!['email']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
