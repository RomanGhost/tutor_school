import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dataclasses/User.dart';
import '../../errors/UserErrors.dart';

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

  User getUser(){
    User newUser = User.undefined();
    newUser.email = _emailController.text;
    newUser.firstName = _firstNameController.text;
    newUser.lastName = _lastNameController.text;
    newUser.surname = _surnameController.text;
    if (_passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text){
      newUser.password = _passwordController.text;
    }else{
      throw PasswordError("Passwords do not match");
    }
    return newUser;
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
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters long';
        }
        return null;
      },
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters long';
        }
        return null;
      },
    );
  }

  Widget buildSurnameField() {
    return TextFormField(
      controller: _surnameController,
      decoration: InputDecoration(
        labelText: 'Surname',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your surname';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters long';
        }
        return null;
      },
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'Last name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter last name';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters long';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'New Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length<6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm New Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}