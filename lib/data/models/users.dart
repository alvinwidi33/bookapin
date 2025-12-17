import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  dynamic id;
  String email;
  String username;
  String role;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Users({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    email: json["email"],
    username: json["username"], 
    role: json["role"],
    isActive: json["isActive"],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "role":"role",
    "isActive":isActive,
    "createdAt": createdAt,
    "updatedAt": updatedAt
  };
}