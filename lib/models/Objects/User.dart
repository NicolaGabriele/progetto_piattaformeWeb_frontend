import 'package:frontend_progetto_piattaforme/models/Objects/Paziente.dart';

class User {
  Paziente paziente;
  String email;
  String username;
  String password;


  User({required this.paziente, required this.email, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      paziente: Paziente.fromJson(json['paziente']),
      email: json['email'],
      username: json['username'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'paziente': paziente.toJson(),
    'username': username,
    'email':email,
    'password':password
  };

  @override
  String toString() {
    return email;
  }


}
