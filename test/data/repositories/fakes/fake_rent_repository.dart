import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/repositories/rent_repository/rent_repository.dart';

class FakeRentRepository implements RentRepository {
  final List<Rents> _rents = [];
  final bool shouldThrow;
  final BookDetails? mockBookDetails;

  FakeRentRepository({
    this.shouldThrow = false,
    this.mockBookDetails,
    List<Rents>? initialRents,
  }) {
    if (initialRents != null) {
      _rents.addAll(initialRents);
    }
  }

  @override
  Future<List<Rents>> getUserRents(String userId) async {
    if (shouldThrow) {
      throw Exception('Failed to fetch rents');
    }

    return _rents
        .where((rent) => rent.user == userId)
        .map((rent) => Rents(
              id: rent.id,
              book: rent.book,
              bookDetails: rent.bookDetails ?? _getDefaultBookDetails(),
              user: rent.user,
              userDetails: rent.userDetails,
              fine: rent.fine,
              duration: rent.duration,
              price: rent.price,
              borrowedAt: rent.borrowedAt,
              isReturn: rent.isReturn,
              returnedAt: rent.returnedAt,
            ))
        .toList();
  }

  @override
  Future<void> createRent({
    required String bookId,
    required String userId,
    required int duration,
    required int price,
  }) async {
    if (shouldThrow) {
      throw Exception('Failed to create rent');
    }

    final newRent = Rents(
      id: 'rent-${_rents.length + 1}',
      book: bookId,
      bookDetails: mockBookDetails ?? _getDefaultBookDetails(),
      user: userId,
      userDetails: null,
      fine: 0,
      duration: duration,
      price: price,
      borrowedAt: DateTime.now(),
      isReturn: false,
      returnedAt: null,
    );

    _rents.add(newRent);
  }

  @override
  Future<Rents> getRentById(String rentId) async {
    if (shouldThrow) {
      throw Exception('Rent not found');
    }

    try {
      return _rents.firstWhere((rent) => rent.id == rentId);
    } catch (e) {
      throw Exception('Rent not found');
    }
  }

  @override
  Future<void> returnBook(String rentId, int fine) async {
    if (shouldThrow) {
      throw Exception('Failed to return book');
    }

    final index = _rents.indexWhere((rent) => rent.id == rentId);
    if (index == -1) {
      throw Exception('Rent not found');
    }

    final rent = _rents[index];

_rents[index] = Rents(
  id: rent.id,
  book: rent.book,
  bookDetails: rent.bookDetails,
  user: rent.user,
  userDetails: rent.userDetails,
  fine: fine,
  duration: rent.duration,
  price: rent.price,
  borrowedAt: rent.borrowedAt,
  isReturn: true,
  returnedAt: DateTime.now(),
);

  }

  void addRent(Rents rent) {
    _rents.add(rent);
  }

  void clear() {
    _rents.clear();
  }

  List<Rents> getAllRents() {
    return List.unmodifiable(_rents);
  }

  BookDetails _getDefaultBookDetails() {
    return BookDetails(
      id: 'book-1',
      title: 'Clean Architecture',
      coverImage: null,
      author: 'Robert C. Martin',
      totalPages: '350',
      category: 'Technology',
      summary: 'A handbook of agile software craftsmanship.',
      publishedDate: '2017',
      isbn: '123',
      publisher: 'Prentice Hall',
    );
  }
}