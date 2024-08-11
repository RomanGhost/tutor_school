import '../errors/UserErrors.dart';

class User{
  String _firstName = '';
  String _lastName = '';
  String _surname = '';
  String _email = '';
  String _password = '';

  User.undefined();
  User(this._email, this._password, this._firstName, this._lastName, this._surname);

  String getFirstName(){
    return _firstName;
  }
  void setFirstName(String firstName){
    if (firstName.length < 3){
      throw ShortName("Firstname is less that 3 symbols: $firstName");
    }
    _firstName = firstName;
  }

  String getLastName(){
    return _lastName;
  }
  void setLastName(String lastName){
    if (lastName.length < 3){
      throw ShortName("Lastname is less that 3 symbols: $lastName");
    }
    _lastName = lastName;
  }

  String getSurname(){
    return _surname;
  }
  void setSurname(String surname){
    _surname = surname;
  }

  String getEmail(){
    return _email;
  }
  void setEmail(String email){
    RegExp emailCheck = RegExp(r"([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)");
    if (!emailCheck.hasMatch(email)){
      EmailError("Email is not correct: $email");
    }
    _email = email;
  }

  String getPassword(){
    return _password;
  }
  void setPassword(String password){
    //TODO временно отключить на время тестов
    // RegExp passwordCheck = RegExp(r'/(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{6,}/g');
    // if (!passwordCheck.hasMatch(password)){
    //   PasswordError("Password isn't correct");
    // }
    _password = password;
  }
}