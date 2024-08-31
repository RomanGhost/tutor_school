import 'package:flutter/material.dart';

import '../../dataclasses/user.dart';
import '../../errors/user_errors.dart';

class UserForms{
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String getFirstName() => _firstNameController.text;
  String getLastName() => _lastNameController.text;
  String getSurname() => _surnameController.text;
  String getEmail() => _emailController.text;
  String getPasswordController() => _passwordController.text;
  String getConfirmPasswordController() => _confirmPasswordController.text;


  void dispose(){
    _firstNameController.dispose();
    _lastNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  UserForms(User user){
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _surnameController.text = user.surname;
  }

  UserForms.undefined(){
    _emailController.text = "";
    _firstNameController.text = "";
    _lastNameController.text = "";
    _surnameController.text = "";
  }

  User getUser({bool checkPassword=false}){
    User newUser = User.undefined();
    newUser.email = _emailController.text;
    newUser.firstName = _firstNameController.text;
    newUser.lastName = _lastNameController.text;
    newUser.surname = _surnameController.text;
    if (_passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text){
      newUser.password = _passwordController.text;
    }else{
      if(checkPassword)
        throw PasswordError("Пароли не совпадают");
    }
    return newUser;
  }

  User getUserLogin(){
    User loginUser = User.undefined();
    loginUser.email = _emailController.text;
    loginUser.password = _passwordController.text;

    return loginUser;
  }

  Widget buildEmailNameField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        const emailPattern = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+$";
        final emailRegex = RegExp(emailPattern);
        final formattedEmail = value.toString().toLowerCase();
        if (value == null || value.isEmpty) {
          return 'Введи email';
        }
        if (value.length < 3) {
          return 'Длина должна быть больше 3 символов';
        }
        if(!emailRegex.hasMatch(formattedEmail)){
          return 'Почта неверна';
        }
        return null;
      },
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'Имя',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Имя';
        }
        if (value.length < 3) {
          return 'Длина должна быть больше 3 символов';
        }
        return null;
      },
    );
  }

  Widget buildSurnameField() {
    return TextFormField(
      controller: _surnameController,
      decoration: InputDecoration(
        labelText: 'Отчество',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'Фамилия',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Введи фамилию";
        }
        if (value.length < 3) {
          return "Длина должна быть больше 3 символов";
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Пароль',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length<6) {
          return 'PПароль должен быть больше 6 символов';
        }
        return null;
      },
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Подтверждение пароля',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
          return 'Пароли не совпадают';
        }
        return null;
      },
    );
  }
}