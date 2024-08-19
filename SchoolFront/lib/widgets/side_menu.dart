import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth_api.dart';
import '../api/user_api.dart';
import '../dataclasses/user.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late final Future<User> _userFuture;
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

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
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
                  ],
                ),
              ),
              _buildListTile(
                icon: Icons.home,
                title: 'Home',
                onTap: () => _navigateTo(context, '/account'),
              ),
              _buildListTile(
                icon: Icons.person,
                title: 'Profile',
                onTap: () => _navigateTo(context, '/profile'),
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

  void _logout(BuildContext context) {
    // Implement logout logic, such as clearing JWT and navigating to the login screen
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('jwt');
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}
