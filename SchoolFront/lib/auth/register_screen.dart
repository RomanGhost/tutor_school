import 'package:flutter/material.dart';
import 'package:school/main_page/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/AuthApi.dart';
import '../dataclasses/User.dart';
import '../errors/UserErrors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  User newUser = User.undefined();

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        String? jwt = await _apiService.registerUser(newUser);
        if (jwt != null) {
          // Сохранение JWT в локальное хранилище
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', jwt);
          // Перенаправление на домашнюю страницу
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
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

  @override
  Widget build(BuildContext context) {
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
                      TextFormField(
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newUser.setFirstName(value!);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newUser.setLastName(value!);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Surname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your surname';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newUser.setSurname(value!);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          newUser.setEmail(value!);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          try{
                            if (value != null && value.isNotEmpty) {
                              newUser.setPassword(value);
                            }
                          }on PasswordError catch(e){
                            return e.toString();
                          }

                          return null;
                        },
                        onSaved: (value) {
                          newUser.setPassword(value!);
                        },
                      ),
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
