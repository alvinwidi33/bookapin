import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/admin/rents-user/pages/rent_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/features/admin/rents-user/bloc/rent_users_bloc.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_event.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_state.dart';
import 'package:bookapin/data/models/rents.dart';

class MockRentUsersBloc extends MockBloc<RentUsersEvent, RentUsersState> 
    implements RentUsersBloc {}

class FakeRentUsersEvent extends Fake implements RentUsersEvent {}
class FakeRentUsersState extends Fake implements RentUsersState {}

void main() {
  late MockRentUsersBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeRentUsersEvent());
    registerFallbackValue(FakeRentUsersState());
  });

  setUp(() {
    bloc = MockRentUsersBloc();
  });

  tearDown(() {
    bloc.close();
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<RentUsersBloc>.value(
        value: bloc,
        child: child,
      ),
    );
  }

  final mockRent = Rents(
    id: '1',
    book: 'Book-1',
    bookDetails: BookDetails(
      id: 'book-1',
      title: 'Clean Code',
      coverImage: null,
      author: 'Robert C. Martin',
      totalPages: '464',
      category: 'Programming',
      summary: 'A handbook of agile software craftsmanship.',
      publishedDate: '2008',
      isbn: '9780132350884',
      publisher: 'Prentice Hall',
    ),
    user: 'user-1',
    userDetails: Users(
      id: 'user-1',
      username: 'Vin',
      email: 'vin@mail.com',
      role: 'Customer',
      isActive: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    fine: 0,
    duration: 1,
    price: 15000,
    borrowedAt: DateTime(2024, 1, 1),
    isReturn: true,
    returnedAt: DateTime(2024, 1, 2),
  );

  testWidgets('shows loading animation when state is loading',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(RentUsersLoading()),
      initialState: RentUsersLoading(),
    );

    await tester.pumpWidget(
      makeTestable(
        const RentUsersUI(currentIndex: 1, user: 'Vin'),
      ),
    );

    await tester.pump();

    // Use specific widget instead of Center
    expect(find.byType(LottieBuilder), findsOneWidget);
  });

  testWidgets('shows error message when state is error', (tester) async {
    whenListen(
      bloc,
      Stream.value(const RentUsersError('Error occurred')),
      initialState: const RentUsersError('Error occurred'),
    );

    await tester.pumpWidget(
      makeTestable(
        const RentUsersUI(currentIndex: 1, user: 'Vin'),
      ),
    );

    await tester.pump();

    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets('shows empty message when rents is empty',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(const RentUsersLoaded([])),
      initialState: const RentUsersLoaded([]),
    );

    await tester.pumpWidget(
      makeTestable(
        const RentUsersUI(currentIndex: 1, user: 'Vin'),
      ),
    );

    await tester.pump();

    expect(find.text('No rent history yet 📭'), findsOneWidget);
  });

testWidgets('renders RentCard when rents exist',
    (tester) async {
  whenListen(
    bloc,
    Stream.value(RentUsersLoaded([mockRent])),
    initialState: RentUsersLoaded([mockRent]),
  );

  await tester.pumpWidget(
    makeTestable(
      const RentUsersUI(currentIndex: 1, user: 'Vin'),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.byType(RentCard), findsOneWidget);
  expect(find.text('Clean Code'), findsOneWidget);
  expect(find.text('Programming'), findsOneWidget); 
  expect(find.text('Returned'), findsOneWidget);
  
  expect(find.textContaining('Rp. 15,000'), findsOneWidget);
  
  final rentCard = tester.widget<RentCard>(find.byType(RentCard));
  expect(rentCard.rent.bookDetails?.author, 'Robert C. Martin');
});
}