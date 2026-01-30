import 'package:flutter_test/flutter_test.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/data/models/books.dart';
import 'fakes/fake_rent_repository.dart';

void main() {
  late FakeRentRepository repository;

  setUp(() {
    repository = FakeRentRepository();
  });

  group('FakeRentRepository', () {
    test('returnBook updates rent status and adds fine', () async {
      final now = DateTime.now();

      repository.addRent(Rents(
        id: 'rent-1',
        book: 'book-1',
        bookDetails: null,
        user: 'user-1',
        userDetails: null,
        fine: 0,
        duration: 5,
        price: 10000,
        borrowedAt: now,
        isReturn: false,
        returnedAt: null,
      ));

      await repository.returnBook('rent-1', 2000);

      final rent = await repository.getRentById('rent-1');

      expect(rent.isReturn, true);
      expect(rent.fine, 2000);
      expect(rent.returnedAt, isNotNull);
    });

    test('getUserRents returns rents for specific user with bookDetails', () async {
      final now = DateTime.now();

      repository.addRent(Rents(
        id: 'rent-1',
        book: 'book-1',
        bookDetails: null,
        user: 'user-1',
        userDetails: null,
        fine: 0,
        duration: 3,
        price: 5000,
        borrowedAt: now,
        isReturn: false,
        returnedAt: null,
      ));

      repository.addRent(Rents(
        id: 'rent-2',
        book: 'book-2',
        bookDetails: null,
        user: 'user-2',
        userDetails: null,
        fine: 0,
        duration: 5,
        price: 8000,
        borrowedAt: now,
        isReturn: false,
        returnedAt: null,
      ));

      final result = await repository.getUserRents('user-1');

      expect(result.length, 1);
      expect(result.first.user, 'user-1');
      expect(result.first.book, 'book-1');
      expect(result.first.bookDetails, isNotNull);
      expect(result.first.bookDetails!.title, 'Clean Architecture');
    });

    test('getUserRents returns empty list when user has no rents', () async {
      final result = await repository.getUserRents('user-999');

      expect(result, isEmpty);
    });

    test('returnBook throws when rent not found', () async {
      expect(
        () => repository.returnBook('non-existent', 0),
        throwsException,
      );
    });

    test('getRentById returns correct rent', () async {
      final now = DateTime.now();

      repository.addRent(Rents(
        id: 'rent-1',
        book: 'book-1',
        bookDetails: null,
        user: 'user-1',
        userDetails: null,
        fine: 0,
        duration: 7,
        price: 15000,
        borrowedAt: now,
        isReturn: false,
        returnedAt: null,
      ));

      final rent = await repository.getRentById('rent-1');

      expect(rent.id, 'rent-1');
      expect(rent.book, 'book-1');
    });

    test('getRentById throws when rent not found', () async {
      expect(
        () => repository.getRentById('non-existent'),
        throwsException,
      );
    });

    test('createRent adds new rent to repository', () async {
      await repository.createRent(
        bookId: 'book-1',
        userId: 'user-1',
        duration: 7,
        price: 10000,
      );

      final rents = repository.getAllRents();

      expect(rents.length, 1);
      expect(rents.first.book, 'book-1');
      expect(rents.first.user, 'user-1');
      expect(rents.first.duration, 7);
      expect(rents.first.price, 10000);
      expect(rents.first.isReturn, false);
      expect(rents.first.returnedAt, isNull);
    });

    test('createRent throws when shouldThrow is true', () async {
      repository = FakeRentRepository(shouldThrow: true);

      expect(
        () => repository.createRent(
          bookId: 'book-1',
          userId: 'user-1',
          duration: 7,
          price: 10000,
        ),
        throwsException,
      );
    });

    test('getUserRents throws when shouldThrow is true', () async {
      repository = FakeRentRepository(shouldThrow: true);

      expect(
        () => repository.getUserRents('user-1'),
        throwsException,
      );
    });

    test('can use custom book details', () async {
      final customBook = BookDetails(
        id: 'custom-1',
        title: 'Custom Book',
        coverImage: null,
        author: 'Custom Author',
        totalPages: '200',
        category: 'Fiction',
        summary: 'A custom book.',
        publishedDate: '2024',
        isbn: '999',
        publisher: 'Custom Publisher',
      );

      repository = FakeRentRepository(mockBookDetails: customBook);

      await repository.createRent(
        bookId: 'book-1',
        userId: 'user-1',
        duration: 7,
        price: 10000,
      );

      final rents = await repository.getUserRents('user-1');

      expect(rents.first.bookDetails?.title, 'Custom Book');
      expect(rents.first.bookDetails?.author, 'Custom Author');
    });
  });
}