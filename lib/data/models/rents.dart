import 'dart:convert';

import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Rents usersFromJson(String str) => Rents.fromJson(json.decode(str));

String usersToJson(Rents data) => json.encode(data.toJson());

class Rents {
  dynamic id;
  String book;
  BookDetails? bookDetails;
  String user;
  Users? userDetails;
  int duration;
  double price;
  bool isReturn;

  Rents({
    required this.id,
    required this.book,
    this.bookDetails,
    required this.user,
    this.userDetails,
    required this.duration,
    required this.price,
    required this.isReturn,
  });

  factory Rents.fromJson(Map<String, dynamic> json) => Rents(
    id: json["id"],
    book: json["book"],
    user: json["user"],
    duration: json["duration"],
    price: json["price"],
    isReturn: json["isReturn"] == 0,
  );

  factory Rents.fromFirestore(
    DocumentSnapshot<Map<String,dynamic>> doc, {
      BookDetails? bookDetails,
      Users? userDetails
    }) {
      final data = doc.data()!;
      return Rents(
        id: doc.id,
        book: data["book"],
        bookDetails: bookDetails,
        user: data["user"],
        userDetails: userDetails,
        duration: data["duration"],
        price: data["price"],
        isReturn: data["isReturn"] == 0,
      );
    }
    
  Map<String, dynamic> toJson() => {
    "id": id,
    "book": book,
    "user": user,
    "duration": duration,
    "price": price,
    "isReturn": isReturn ? 0 : 1,
  };
}
