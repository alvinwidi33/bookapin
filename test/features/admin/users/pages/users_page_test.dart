import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/features/admin/users/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/features/admin/users/bloc/users_bloc.dart';
import 'package:bookapin/features/admin/users/bloc/users_state.dart';
import 'package:bookapin/features/admin/users/bloc/users_event.dart';
import 'package:bookapin/data/models/users.dart';

class MockUsersBloc extends MockBloc<UsersEvent, UsersState> 
    implements UsersBloc {}

class FakeUsersEvent extends Fake implements UsersEvent {}
class FakeUsersState extends Fake implements UsersState {}

void main() {
  late MockUsersBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeUsersEvent());
    registerFallbackValue(FakeUsersState());
  });

  setUp(() {
    bloc = MockUsersBloc();
  });

  tearDown(() {
    bloc.close();
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(
      routes: {
        '/rents-user': (_) => const Scaffold(body: Text('Rents User Page')),
      },
      home: BlocProvider<UsersBloc>.value(
        value: bloc,
        child: child,
      ),
    );
  }

  final mockUser = Users(
    id: '1',
    username: 'Ayam',
    email: 'ayam@mail.com',
    isActive: true,
    role: 'Customer', 
    createdAt: DateTime(2024, 1, 1), 
    updatedAt: DateTime(2024, 1, 1),
  );

  testWidgets('shows loading animation when state is UsersLoading',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(UsersLoading()),
      initialState: UsersLoading(),
    );

    await tester.pumpWidget(
      makeTestable(const HistoryUI(currentIndex: 1)),
    );

    await tester.pump();

    expect(find.byType(LottieBuilder), findsOneWidget);
    expect(find.text('Customers'), findsNothing);
    expect(find.byType(UserCard), findsNothing);
  });

  testWidgets('shows error message when state is UsersError',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(const UsersError('Error test')),
      initialState: const UsersError('Error test'),
    );

    await tester.pumpWidget(
      makeTestable(const HistoryUI(currentIndex: 1)),
    );

    await tester.pump();

    expect(find.text('Error test'), findsOneWidget);
  });

  testWidgets('shows empty message when users list is empty',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(const UsersLoaded([])),
      initialState: const UsersLoaded([]),
    );

    await tester.pumpWidget(
      makeTestable(const HistoryUI(currentIndex: 1)),
    );

    await tester.pump();

    expect(find.text('No rent history yet 📭'), findsOneWidget);
  });

  testWidgets('renders UserCard when users exist',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(UsersLoaded([mockUser])),
      initialState: UsersLoaded([mockUser]),
    );

    await tester.pumpWidget(
      makeTestable(const HistoryUI(currentIndex: 1)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Customers'), findsOneWidget);
    expect(find.byType(UserCard), findsOneWidget);
    expect(find.text('Ayam'), findsOneWidget);
    expect(find.text('ayam@mail.com'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('tap Active button dispatches ToggleUserActive event',
      (tester) async {
    whenListen(
      bloc,
      Stream.value(UsersLoaded([mockUser])),
      initialState: UsersLoaded([mockUser]),
    );

    await tester.pumpWidget(
      makeTestable(const HistoryUI(currentIndex: 1)),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Active'));
    await tester.pumpAndSettle();

    expect(find.text('Confirmation'), findsOneWidget);

    await tester.tap(find.text('Yes'));
    await tester.pump();

    verify(() => bloc.add(
          ToggleUserActive(
            userId: '1',
            isActive: false,
          ),
        )).called(1);
  });
}