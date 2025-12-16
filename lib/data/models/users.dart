import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  dynamic id;
  String email;
  String username;
  String role;
  bool isActive;

  Users({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isActive
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    email: json["email"],
    username: json["username"], 
    role: json["role"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "role":"role",
    "isActive":isActive
  };
}