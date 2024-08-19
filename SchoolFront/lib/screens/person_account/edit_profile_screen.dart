import 'package:flutter/material.dart';
import 'package:school/api/user_api.dart';
import 'package:school/errors/user_errors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../dataclasses/user.dart';
import '../../errors/jwt_errors.dart';
import '../../widgets/side_menu.dart';
import '../forms/user_forms.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserApi _apiService = UserApi();
  final _formKey = GlobalKey<FormState>();
  UserForms userForms = UserForms.undefined();

  Future<User?> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if (jwt == null) {
      throw JwtIsNull("Token is not valid");
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    String? email = decodedToken['sub'];
    if (email == null) return null;
    return await _apiService.getUser(email);
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      User updateUser;
      try {
        updateUser = userForms.getUser();
      } on PasswordError catch (e) {
        _showErrorSnackbar(e.cause);
        return;
      }

      final result = await _apiService.updateUserProfile(updateUser);
      if (result) {
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
      body: FutureBuilder<User?>(
        future: _loadUserData(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            userForms = UserForms(snapshot.data!);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
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
            );
          } else {
            return const Center(child: Text('User data not found.'));
          }
        },
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
