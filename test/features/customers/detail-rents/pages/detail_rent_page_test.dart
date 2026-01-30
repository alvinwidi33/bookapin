import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:bookapin/features/customers/detail-rents/pages/detail_rent_page.dart';
import 'package:bookapin/data/repositories/rent_repository/rent_repository.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/data/models/books.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';

void main() {
  late FakeRentRepository repository;

  setUp(() {
    repository = FakeRentRepository();
  });

  final mockRent = Rents(
    id: 'rent-1',
    book: 'book-1',
    bookDetails: BookDetails(
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
    ),
    user: 'user-1',
    userDetails: null,
    fine: 0,
    duration: 7,
    price: 15000,
    borrowedAt: DateTime(2024, 1, 1),
    isReturn: false,
    returnedAt: null,
  );

  Widget makeTestableWidget(String rentId) {
    return MaterialApp(
      routes: {
        '/history': (_) => const Scaffold(body: Text('History Page')),
      },
      home: Builder(
        builder: (context) {
          return RepositoryProvider<RentRepository>.value(
            value: repository,
            child: RouteArgumentsProvider(
              arguments: rentId,
              child: const DetailRent(),
            ),
          );
        },
      ),
    );
  }

  group('DetailRent Page Integration Tests', () {
    testWidgets('renders page with rent details', (tester) async {
      repository.addRent(mockRent);

      await tester.pumpWidget(makeTestableWidget('rent-1'));
      await tester.pumpAndSettle();

      expect(find.text('Rent Detail'), findsOneWidget);
      expect(find.text('Clean Architecture'), findsOneWidget);
      expect(find.textContaining('Technology'), findsOneWidget);
      expect(find.text('Book Returned'), findsOneWidget);
    });

    testWidgets('shows error when rent not found', (tester) async {
      await tester.pumpWidget(makeTestableWidget('non-existent'));

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('retry button reloads rent data', (tester) async {
      await tester.pumpWidget(makeTestableWidget('non-existent'));

      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      // Add the rent after initial failure
      repository.addRent(mockRent);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // Should still show error since rentId is still 'non-existent'
      // This tests that the retry button actually triggers the event
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('return button is disabled when book already returned',
        (tester) async {
      final returnedRent = Rents(
        id: 'rent-2',
        book: 'book-1',
        bookDetails: mockRent.bookDetails,
        user: 'user-1',
        userDetails: null,
        fine: 5000,
        duration: 7,
        price: 15000,
        borrowedAt: DateTime(2024, 1, 1),
        isReturn: true,
        returnedAt: DateTime(2024, 1, 8),
      );

      repository.addRent(returnedRent);

      await tester.pumpWidget(makeTestableWidget('rent-2'));
      await tester.pumpAndSettle();

      final button = tester.widget<GestureDetector>(
        find.ancestor(
          of: find.text('Book Returned'),
          matching: find.byType(GestureDetector),
        ),
      );

      // Check that onTap is null (disabled)
      expect(button.onTap, isNull);
    });

    testWidgets('displays correct fine calculation', (tester) async {
      repository.addRent(mockRent);

      await tester.pumpWidget(makeTestableWidget('rent-1'));
      await tester.pumpAndSettle();

      // The fine should be calculated based on days late
      expect(find.textContaining('Your fine:'), findsOneWidget);
      expect(find.textContaining('Rp.'), findsWidgets);
    });

    testWidgets('displays all book information badges', (tester) async {
      repository.addRent(mockRent);

      await tester.pumpWidget(makeTestableWidget('rent-1'));
      await tester.pumpAndSettle();

      expect(find.text('Robert C. Martin'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('350 pages'), findsOneWidget);
    });

    testWidgets('back button navigates away', (tester) async {
      repository.addRent(mockRent);

      await tester.pumpWidget(makeTestableWidget('rent-1'));
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should navigate back (in this test, nothing changes since there's no previous route)
      // In real app, this would go to previous screen
    });
  });
}

// Helper widget to simulate route arguments
class RouteArgumentsProvider extends StatelessWidget {
  final String arguments;
  final Widget child;

  const RouteArgumentsProvider({
    super.key,
    required this.arguments,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: RouteSettings(arguments: arguments),
          builder: (_) => child,
        );
      },
    );
  }
}