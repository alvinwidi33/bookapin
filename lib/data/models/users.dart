import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String email;
  final String username;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Users({
    this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// From Firestore
  factory Users.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Users(
      id: doc.id,
      email: data['email'],
      username: data['username'],
      role: data['role'],
      isActive: data['isActive'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'role': role,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
