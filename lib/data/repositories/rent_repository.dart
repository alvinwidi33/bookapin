import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BookRepository _bookApi;

  RentRepository({required BookRepository bookApi})
      : _bookApi = bookApi;

  Future<void> createRent({
    required String bookId,
    required String userId,
    required int duration,
    required int price,
  }) async {
    await _firestore.collection('rents').add({
      'book': bookId,
      'user': userId,
      'duration': duration,
      'price': price,
      'borrowedAt': Timestamp.now(),
      'isReturn': false,
      'returnedAt': null,
    });
  }
  
Future<List<Rents>> getUserRents(String userId) async {
    final rentQuery = await _firestore
      .collection('rents')
      .where('user', isEqualTo: userId)
      .orderBy('borrowedAt', descending: true)
      .get();

    final Map<String, BookDetails> bookCache = {};
    List<Rents> result = [];

    for (final doc in rentQuery.docs) {
      final rent = Rents.fromFirestore(doc);

      if (!bookCache.containsKey(rent.book)) {
        bookCache[rent.book] =
            await _bookApi.getBookById(rent.book);
      }

      result.add(
        rent.copyWith(
          bookDetails: bookCache[rent.book],
        ),
      );
    }

    return result;
  }
  Future<Rents> getRentById(String rentId) async {
    final doc = await _firestore
        .collection('rents')
        .doc(rentId)
        .get();

    if (!doc.exists) {
      throw Exception('Rent not found');
    }

    final rent = Rents.fromFirestore(doc);
    final bookDetails = await _bookApi.getBookById(rent.book);
    return rent.copyWith(
      bookDetails: bookDetails,
    );
  }

  Future<void> returnBook(String rentId, int fine) async {
    await _firestore
      .collection('rents')
      .doc(rentId)
      .update({
        'isReturn': true,
        'fine':fine,
        'returnedAt': Timestamp.now(),
      });
  }
}
