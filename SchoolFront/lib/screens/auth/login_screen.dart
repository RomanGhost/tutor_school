import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';
import '../../errors/user_errors.dart';
import '../../widgets/user_forms.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthApi _apiService = AuthApi();
  final UserForms userForms = UserForms.undefined();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (jwt != null) {
      _navigateToUserProfile();
    }
  }

  Future<void> _login() async {
    final user;
    try {
      user = userForms.getUserLogin();
    }on PasswordError{
      _showErrorSnackbar('Слишком легкий пароль');
      return;
    }
    try {
      final jwt = await _apiService.authenticateUser(user);

      if (jwt != null) {
        await _storeJwt(jwt);
        _navigateToUserProfile();
      } else {
        _showErrorSnackbar('Ошибка авторизации');
      }
    } catch (e) {
      _showErrorSnackbar('Произошла ошибка на одном из этапов');
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
        appBar: AppBar(title: const Text('Авторизация')),
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
                    child: Column(
                      children: <Widget>[
                        userForms.buildEmailNameField(),
                        SizedBox(height: 16),
                        userForms.buildPasswordField(),
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
      child: const Text('Зарегистрироваться'),
    );
  }
}
