import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/features/authentication/signup/pages/signup_page.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_state.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_event.dart';

import '../../mocks/mock_signup_bloc.dart';

final users = Users(
  id: '1',
  email: 'test@mail.com',
  username: 'tester',
  role: 'Customer',
  isActive: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

void main() {
  late MockSignUpBloc signUpBloc;

  Widget makeTestableWidget() {
    return MaterialApp(
      routes: {
        '/signin': (_) => const Scaffold(body: Text('Signin Page')),
      },
      home: BlocProvider<SignUpBloc>.value(
        value: signUpBloc,
        child: const SignupPage(),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeSignUpEvent());
    registerFallbackValue(FakeSignUpState());
  });

setUp(() {
  signUpBloc = MockSignUpBloc();

  when(() => signUpBloc.state).thenReturn(SignUpInitial());
  when(() => signUpBloc.stream)
      .thenAnswer((_) => const Stream<SignUpState>.empty());

  when(() => signUpBloc.close()).thenAnswer((_) async {});
});



  tearDown(() {
    signUpBloc.close();
  });

testWidgets('renders signup page UI correctly', (tester) async {

  await tester.pumpWidget(makeTestableWidget());

  expect(find.byKey(const Key('signup_username_field')), findsOneWidget);
  expect(find.byKey(const Key('signup_email_field')), findsOneWidget);
  expect(find.byKey(const Key('signup_password_field')), findsOneWidget);

  expect(find.byKey(const Key('signup_submit_button')), findsOneWidget);
  expect(find.text('Or sign up with '), findsOneWidget);
});


  testWidgets('shows password validation error', (tester) async {

    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(
      find.byKey(const Key('signup_password_field')),
      '123',
    );

    await tester.pump();

    expect(
      find.textContaining('Password should be'),
      findsOneWidget,
    );
  });

 testWidgets(
  'tap Sign Up button dispatches SignUpWithUsernameEmailEvent',
  (tester) async {

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('signup_username_field')),
      'tester',
    );
    await tester.enterText(
      find.byKey(const Key('signup_email_field')),
      'test@mail.com',
    );
    await tester.enterText(
      find.byKey(const Key('signup_password_field')),
      'Password123',
    );

    final signUpButton = find.byKey(const Key('signup_submit_button'));

    await tester.ensureVisible(signUpButton);
    await tester.pump();

    await tester.tap(signUpButton);
    await tester.pump();

    verify(() => signUpBloc.add(
      any(that: isA<SignUpWithUsernameEmailEvent>()),
    )).called(1);
  },
);


testWidgets('navigates to signin page on SignUpSuccess', (tester) async {
  whenListen(
    signUpBloc,
    Stream<SignUpState>.fromIterable([
      SignUpSuccess(users),
    ]),
    initialState: SignUpInitial(),
  );

  await tester.pumpWidget(makeTestableWidget());
  await tester.pump(); 
  await tester.pump(); 

  expect(find.text('Signin Page'), findsOneWidget);
});


  testWidgets('shows snackbar on SignUpError', (tester) async {
    whenListen(
      signUpBloc,
      Stream.fromIterable([const SignUpError('Signup failed')]),
      initialState: SignUpInitial(),
    );

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.text('Signup failed'), findsOneWidget);
  });
}
