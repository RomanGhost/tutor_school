import 'package:flutter/material.dart';
import 'package:school/screens/auth/login_screen.dart';
import 'package:school/screens/auth/register_screen.dart';
import 'package:school/screens/person_account/edit_profile_screen.dart';
import 'package:school/screens/person_account/person_account.dart';

import 'screens/main_page/main_page.dart';


void main() {
  runApp(MyApp());
}

/// Основное приложение
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Репетитор английского языка',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => RegisterScreen(),
        '/account':(context) => UserProfileScreen(),
        '/profile':(context) => EditProfileScreen(),
      },
    );
  }
}
