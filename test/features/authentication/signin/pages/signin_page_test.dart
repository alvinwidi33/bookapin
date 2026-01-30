import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_state.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_event.dart';
import 'package:bookapin/data/models/users.dart';

import '../../mocks/mock_signin_bloc.dart';


void main() {
  
  late MockSignInBloc signInBloc;

  final mockUser = Users(
    id: '1',
    username: 'tester',
    email: 'test@mail.com',
    role: 'Customer',
    isActive: true,
    createdAt: DateTime(2024, 1, 1), 
    updatedAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeSignInEvent());
  });
  Widget makeTestableWidget() {
    return MaterialApp(
      routes: {
        '/home': (_) => const Scaffold(body: Text('Home Page')),
        '/dashboard': (_) => const Scaffold(body: Text('Dashboard Page')),
        '/signup': (_) => const Scaffold(body: Text('Signup Page')),
      },
      home: BlocProvider<SignInBloc>.value(
        value: signInBloc,
        child: const SigninPage(),
      ),
    );
  }

setUp(() {
  signInBloc = MockSignInBloc();

  when(() => signInBloc.close())
      .thenAnswer((_) async {});
});


testWidgets('renders signin page UI correctly', (tester) async {
  when(() => signInBloc.state).thenReturn(SignInInitial());

  await tester.pumpWidget(makeTestableWidget());

  expect(find.byKey(const Key('email_text_field')), findsOneWidget);
  expect(find.byKey(const Key('password_text_field')), findsOneWidget);
  expect(find.byKey(const Key('signin_button')), findsOneWidget);
  expect(find.text('Or sign in with '), findsOneWidget);
});

  testWidgets('typing email changes animation state', (tester) async {
    when(() => signInBloc.state).thenReturn(SignInInitial());

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(
      find.byType(TextField).first,
      'test@mail.com',
    );
    await tester.pump();

    expect(find.text('Typing email'), findsOneWidget);
  });

  testWidgets('shows password validation error', (tester) async {
    when(() => signInBloc.state).thenReturn(SignInInitial());

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(
      find.byType(TextField).at(1),
      '123',
    );
    await tester.pump();

    expect(
      find.textContaining('Password should be'),
      findsOneWidget,
    );
  });


  testWidgets('shows loading animation when SignInLoading',
      (tester) async {
    whenListen(
      signInBloc,
      Stream.fromIterable([SignInLoading()]),
      initialState: SignInInitial(),
    );

    await tester.pumpWidget(makeTestableWidget());
    
    await tester.pump();
    
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Loading'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('shows snackbar and navigates on success',
      (tester) async {
    whenListen(
      signInBloc,
      Stream.fromIterable([
        SignInLoading(),
        SignInSuccess(mockUser),
      ]),
      initialState: SignInInitial(),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

testWidgets('shows error snackbar when SignInError',
    (tester) async {
  whenListen(
    signInBloc,
    Stream.fromIterable([
      SignInLoading(),
      const SignInError('Wrong email or password'),
    ]),
    initialState: SignInInitial(),
  );

  await tester.pumpWidget(makeTestableWidget());

  await tester.pump();
  await tester.pump();
  await tester.pump();

  expect(
    find.text('Wrong email or password'),
    findsOneWidget,
  );
  
  await tester.pump(const Duration(seconds: 2));
});

 testWidgets('dispatch SignInWithEmailEvent on sign in tap',
    (tester) async {

  tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(() {
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
  });

  when(() => signInBloc.state).thenReturn(SignInInitial());
  whenListen(
    signInBloc,
    Stream<SignInState>.fromIterable([SignInInitial()]),
    initialState: SignInInitial(),
  );

  await tester.pumpWidget(makeTestableWidget());
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('email_text_field')),
    'test@mail.com',
  );
  await tester.enterText(
    find.byKey(const Key('password_text_field')),
    'password123',
  );

  final signInButton = find.byKey(const Key('signin_button'));

  expect(signInButton, findsOneWidget);

  await tester.tap(signInButton);
  await tester.pump();

  verify(() => signInBloc.add(
    any(that: isA<SignInWithEmailEvent>()),
  )).called(1);
});

}
