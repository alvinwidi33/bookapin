import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rents {
  final String id;
  final String book; 
  final BookDetails? bookDetails;

  final String user;
  final Users? userDetails;

  final int duration;
  final int price;

  final DateTime borrowedAt;
  final bool isReturn;
  final DateTime? returnedAt;

  Rents({
    required this.id,
    required this.book,
    this.bookDetails,
    required this.user,
    this.userDetails,
    required this.duration,
    required this.price,
    required this.borrowedAt,
    required this.isReturn,
    this.returnedAt,
  });

  factory Rents.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    BookDetails? bookDetails,
    Users? userDetails,
  }) {
    final data = doc.data()!;

    return Rents(
      id: doc.id,
      book: data['book'],
      bookDetails: bookDetails,
      user: data['user'],
      userDetails: userDetails,
      duration: data['duration'],
      price: data['price'],
      borrowedAt: (data['borrowedAt'] as Timestamp).toDate(),
      isReturn: data['isReturn'] as bool,
      returnedAt: data['returnedAt'] != null
          ? (data['returnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'book': book,
    'user': user,
    'duration': duration,
    'price': price,
    'borrowedAt': Timestamp.fromDate(borrowedAt),
    'isReturn': isReturn,
    'returnedAt':
        returnedAt != null ? Timestamp.fromDate(returnedAt!) : null,
  };
}
extension RentsCopy on Rents {
  Rents copyWith({
    BookDetails? bookDetails,
    Users? userDetails,
  }) {
    return Rents(
      id: id,
      book: book,
      bookDetails: bookDetails ?? this.bookDetails,
      user: user,
      userDetails: userDetails ?? this.userDetails,
      duration: duration,
      price: price,
      borrowedAt: borrowedAt,
      isReturn: isReturn,
      returnedAt: returnedAt,
    );
  }
}
