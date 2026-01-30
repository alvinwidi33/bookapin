import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_state.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:bookapin/features/customers/detail/pages/detail_book_page.dart';
import 'package:bookapin/data/repositories/book_repository/book_repository.dart';
import 'package:bookapin/data/repositories/rent_repository/rent_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../data/repositories/fakes/fake_book_repository.dart';
import '../../../../data/repositories/fakes/fake_rent_repository.dart';
import '../../../authentication/mocks/mock_signin_bloc.dart';


Widget createTestWidget({
  required BookRepository bookRepository,
  required RentRepository rentRepository,
  SignInBloc? signInBloc,
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<BookRepository>.value(value: bookRepository),
      RepositoryProvider<RentRepository>.value(value: rentRepository),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>.value(
          value: signInBloc ?? _createDefaultMockSignInBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            context.read<BookRepository>(),
          )..add(const FetchAllBooks(isRefresh: true)),
        ),
        BlocProvider(
          create: (context) => RentBookBloc(
            context.read<RentRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/history': (_) => const Scaffold(body: Text('History Page')),
        },
        onGenerateRoute: (_) {
          return MaterialPageRoute(
            settings: const RouteSettings(arguments: 'book-1'),
            builder: (_) => const DetailBook(),
          );
        },
      ),
    ),
  );
}

MockSignInBloc _createDefaultMockSignInBloc({bool isActive = true}) {
  final mockBloc = MockSignInBloc();
  final fixedDate = DateTime(2024, 1, 1);
  final user = Users(
    id: 'test-user-id',
    email: 'test@example.com',
    username: 'Test User',
    isActive: isActive,
    role: 'Customer',
    createdAt: fixedDate,
    updatedAt: fixedDate,
  );

  final initialState = SignInSuccess(user);

  when(() => mockBloc.state).thenReturn(initialState);

  whenListen(
    mockBloc,
    Stream.fromIterable([initialState]),
    initialState: initialState,
  );

  return mockBloc;
}

void main() {
  testWidgets(
    'Menampilkan data buku ketika repository sukses',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository();
      final fakeRentRepo = FakeRentRepository();

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Clean Architecture'), findsOneWidget);
      expect(find.text('Robert C. Martin'), findsOneWidget);
      expect(find.text('Technology'), findsWidgets);

      expect(
        find.text('Rent Now'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Menampilkan error ketika repository gagal',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository(shouldThrow: true);
      final fakeRentRepo = FakeRentRepository();

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    },
  );

  testWidgets(
    'Qty tidak bisa kurang dari 1',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository();
      final fakeRentRepo = FakeRentRepository();

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    },
  );

  testWidgets(
    'Qty dapat ditambah hingga 7 hari',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository();
      final fakeRentRepo = FakeRentRepository();

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
        ),
      );

      await tester.pumpAndSettle();

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      expect(find.text('4'), findsOneWidget);
      expect(find.text(' Days'), findsOneWidget);
    },
  );

  testWidgets(
    'Tombol Rent Now disabled ketika user tidak aktif',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository();
      final fakeRentRepo = FakeRentRepository();
      final mockSignInBloc = _createDefaultMockSignInBloc(isActive: false);

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
          signInBloc: mockSignInBloc,
        ),
      );

      await tester.pumpAndSettle();

      final rentButton = find.ancestor(
        of: find.text('Rent Now'),
        matching: find.byType(GestureDetector),
      );

      expect(rentButton, findsOneWidget);

      await tester.tap(rentButton);
      await tester.pump();

      expect(find.text('History Page'), findsNothing);
    },
  );

testWidgets(
  'Tab switching antara Summary dan Details berfungsi',
  (WidgetTester tester) async {
    final fakeBookRepo = FakeBookRepository();
    final fakeRentRepo = FakeRentRepository();

    await tester.pumpWidget(
      createTestWidget(
        bookRepository: fakeBookRepo,
        rentRepository: fakeRentRepo,
      ),
    );

    await tester.pump(); 
    await tester.pump(const Duration(milliseconds: 500)); 


    expect(find.text('Summary'), findsNWidgets(2));

    final detailsTab = find.ancestor(
      of: find.text('Details'),
      matching: find.byType(GestureDetector),
    );
    
    await tester.tap(detailsTab);
    await tester.pumpAndSettle();

    // 3. Verify content switched
    expect(find.text('Author'), findsOneWidget);
    
    // Now only the Tab label says "Summary"
    expect(find.text('Summary'), findsOneWidget); 
  },
);

  testWidgets(
    'Harga total dihitung dengan benar',
    (WidgetTester tester) async {
      final fakeBookRepo = FakeBookRepository();
      final fakeRentRepo = FakeRentRepository();

      await tester.pumpWidget(
        createTestWidget(
          bookRepository: fakeBookRepo,
          rentRepository: fakeRentRepo,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rp. 5,000'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Rp. 15,000'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    },
  );
}