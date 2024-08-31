import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthApi _apiService = AuthApi();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = User.undefined();
      user.email = _emailController.text.trim();
      user.password = _passwordController.text.trim();

      final jwt = await _apiService.authenticateUser(user);

      if (jwt != null) {
        await _storeJwt(jwt);
        _navigateToUserProfile();
      } else {
        _showErrorSnackbar('Failed to login');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred during login');
    }
  }

  Future<void> _storeJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', jwt);
  }

  void _navigateToUserProfile() {
    final routeName = ModalRoute.of(context)?.settings.arguments;
    if (routeName == '/write_review') {
      Navigator.pushNamed(context, '/write_review');
    } else {
      Navigator.pushNamed(context, '/account');
    }
  }


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Перенаправление на главную страницу
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false; // Предотвращаем стандартное поведение "Назад"
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildEmailField(),
                        SizedBox(height: 16),
                        _buildPasswordField(),
                        SizedBox(height: 24),
                        _buildLoginButton(),
                        SizedBox(height: 8),
                        _buildRegisterButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }


  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6498E4)
      ),
      onPressed: _login,
      child: const Text(
        'Войти',
        style: TextStyle(
          color: Colors.white
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: Text('Don\'t have an account? Register'),
    );
  }
}
