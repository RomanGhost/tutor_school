import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';
import '../../errors/user_errors.dart';
import '../../widgets/user_forms.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthApi _apiService = AuthApi();
  final UserForms userForms = UserForms.undefined();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        final newUser;
        try {
          newUser = userForms.getUser(checkPassword: true);
        }on PasswordError{
          _showErrorSnackbar('Слишком легкий пароль');
          return;
        }
        try {
          String? jwt = await _apiService.registerUser(newUser);
          if (jwt != null) {
            // Сохранение JWT в локальное хранилище
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt', jwt);

            final routeName = ModalRoute.of(context)?.settings.arguments;
            if (routeName == '/enroll_subject') {
              Navigator.pushNamed(context, '/enroll_subject');
            } else {
              Navigator.pushNamed(context, '/account');
            }
          } else {
            // Показ ошибки
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Не смогли зарегистрировать')),
            );
          }
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Регистрация с ошибкой: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            constraints: BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      userForms.buildFirstNameField(),
                      SizedBox(height: 20),
                      userForms.buildLastNameField(),
                      SizedBox(height: 20),
                      userForms.buildSurnameField(),
                      SizedBox(height: 20),
                      userForms.buildEmailNameField(),
                      SizedBox(height: 20),
                      userForms.buildPasswordField(),
                      SizedBox(height: 20),
                      userForms.buildConfirmPasswordField(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6498E4)
                        ),
                        child: const Text(
                            'Зарегистрироваться',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
