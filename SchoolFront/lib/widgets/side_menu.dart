import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/AuthApi.dart';
import '../dataclasses/User.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenu createState() => _SideMenu();
}

class _SideMenu extends State<SideMenu> {
  User _user = User.undefined();
  final ApiService _apiService = ApiService();

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
    final data = await _apiService.getUser(email!);
    setState(() {
      _user.setEmail(data?['email']);
      _user.setFirstName(data?['firstName']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.getFirstName(),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  _user.getEmail(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Schedule'),
            onTap: () {
              Navigator.pushNamed(context, '/schedule');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
// Logout logic here
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}