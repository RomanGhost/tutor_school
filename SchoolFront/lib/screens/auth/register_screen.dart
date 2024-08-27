import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth_api.dart';
import '../../dataclasses/user.dart';
import '../forms/user_forms.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthApi _apiService = AuthApi();
  UserForms userForms = UserForms.undefined();

  @override
  Widget build(BuildContext context) {
    // Получаем аргументы из Navigator
    final bool goToSubjectSelection = ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    Future<void> _submit() async {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        User newUser = userForms.getUser();
        try {
          String? jwt = await _apiService.registerUser(newUser);
          if (jwt != null) {
            // Сохранение JWT в локальное хранилище
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt', jwt);

            // Проверка необходимости перехода на экран выбора предмета
            if (goToSubjectSelection) {
              Navigator.pushNamed(context, '/enroll_subject');
            } else {
              Navigator.pushNamed(context, '/account');
            }
          } else {
            // Показ ошибки
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to register')),
            );
          }
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                        child: Text('Register'),
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
}
