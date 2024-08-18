import 'package:flutter/material.dart';
import 'package:school/errors/UserErrors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../api/AuthApi.dart';
import '../../dataclasses/User.dart';
import '../../errors/JwtError.dart';
import '../../widgets/side_menu.dart';
import '../forms/user_forms.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  User user = User.undefined();
  UserForms userForms = UserForms.undefined();

  // Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    try {
      _loadUserData();
    }on JwtIsNull catch(e){
      print(e);
      Navigator.pop(context);
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if(jwt == null) {
      throw JwtIsNull("Token is not valid");
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    String? email = decodedToken['sub'];
    if(email == null) return;
    final user = await _apiService.getUser(email);
    setState(() {
      if (user != null) {
        this.user.email = user.email;
        userForms = UserForms(user);
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      User updateUser;
      try {
        updateUser = userForms.getUser();
      } on PasswordError catch(e) {
        _showErrorSnackbar(e as String);
        return;
      }

      final result = await _apiService.updateUserProfile(updateUser);
      if (result) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        _showErrorSnackbar('Failed to update profile');
      }

    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    userForms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      drawer: const SideMenu(), // Добавление боковой панели
      body: user.email == ""
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // userForms.buildEmailNameField(),
              // const SizedBox(height: 20),
              userForms.buildFirstNameField(),
              const SizedBox(height: 20),
              userForms.buildLastNameField(),
              const SizedBox(height: 20),
              userForms.buildSurnameField(),
              const SizedBox(height: 20),
              userForms.buildPasswordField(),
              const SizedBox(height: 20),
              userForms.buildConfirmPasswordField(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProfile,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('Save Changes'),
    );
  }
}
