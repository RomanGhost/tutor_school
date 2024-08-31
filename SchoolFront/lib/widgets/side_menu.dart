import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/user_api.dart';
import '../dataclasses/user.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late Future<User> _userFuture;
  final UserApi _apiService = UserApi();

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();
  }

  Future<User> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      // Handle the case where JWT is missing or expired
      return User.undefined();
    }

    final decodedToken = JwtDecoder.decode(jwt);
    final email = decodedToken['sub'] as String?;

    if (email == null) {
      // Handle missing email in token
      return User.undefined();
    }

    final user = await _apiService.getUser(email);
    if (user != null) {
      final role = decodedToken['role']['authority'] as String;
      user.role = role;
      return user;
    } else {
      // Handle the case where user data couldn't be fetched
      return User.undefined();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          }

          final user = snapshot.data ?? User.undefined();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFF6498E4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName.isNotEmpty ? user.firstName : 'Guest',
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            user.email.isNotEmpty ? user.email : 'No email',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          if (user.role != 'USER')
                            Text(
                              user.role.isNotEmpty ? user.role : 'No role',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      icon: Icons.person,
                      title: 'Home page',
                      onTap: () => _navigateTo(context, '/account'),
                    ),
                    _buildListTile(
                      icon: Icons.person_pin_outlined,
                      title: 'Edit profile',
                      onTap: () => _navigateTo(context, '/profile_edit'),
                    ),
                    _buildListTile(
                      icon: Icons.label,
                      title: 'Lessons',
                      onTap: () => _navigateTo(context, '/user_lesson'),
                    ),
                    if (user.role == 'TEACHER') ...[
                      _buildListTile(
                        icon: Icons.school,
                        title: 'Ученики',
                        onTap: () => _navigateTo(context, '/students'),
                      ),
                      _buildListTile(
                        icon: Icons.book,
                        title: 'Уроки',
                        onTap: () => _navigateTo(context, '/lessons'),
                      ),
                    ],
                  ],
                ),
              ),
              _buildListTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _logout(context),
              ),
            ],
          );
        },
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
