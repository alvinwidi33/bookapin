import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_event.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_state.dart';

import '../../mocks/mock_auth_helper.dart';


void main() {
  late MockAuthHelper authHelper;
  late SignUpBloc signUpBloc;

  final mockUser = Users(
    id: '1',
    username: 'tester',
    email: 'test@mail.com',
    role: 'Customer',
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now()
  );

  setUp(() {
    authHelper = MockAuthHelper();
    signUpBloc = SignUpBloc(authHelper);
  });

  tearDown(() {
    signUpBloc.close();
  });

  test('initial state is SignUpInitial', () {
    expect(signUpBloc.state, SignUpInitial());
  });

  blocTest<SignUpBloc, SignUpState>(
    'emits [Loading, Success] when signup with email succeeds',
    build: () {
      when(() => authHelper.signUpWithEmailUsernameAndPassword(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => mockUser);

      return signUpBloc;
    },
    act: (bloc) => bloc.add(
      SignUpWithUsernameEmailEvent(
        username: 'tester',
        email: 'test@mail.com',
        password: 'Password123',
      ),
    ),
    expect: () => [
      SignUpLoading(),
      SignUpSuccess(mockUser),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits [Loading, Error] when signup throws FirebaseAuthException',
    build: () {
      when(() => authHelper.signUpWithEmailUsernameAndPassword(
            any(),
            any(),
            any(),
          )).thenThrow(
        FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already used',
        ),
      );

      return signUpBloc;
    },
    act: (bloc) => bloc.add(
      SignUpWithUsernameEmailEvent(
        username: 'tester',
        email: 'test@mail.com',
        password: 'Password123',
      ),
    ),
    expect: () => [
      SignUpLoading(),
      const SignUpError('Email already used'),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits [Loading, Success] when signup with Google succeeds',
    build: () {
      when(() => authHelper.signInWithGoogle())
          .thenAnswer((_) async => mockUser);

      return signUpBloc;
    },
    act: (bloc) => bloc.add(SignUpWithGoogleEvent()),
    expect: () => [
      SignUpLoading(),
      SignUpSuccess(mockUser),
    ],
  );

  blocTest<SignUpBloc, SignUpState>(
    'emits [Initial] after sign out',
    build: () {
      when(() => authHelper.signOut()).thenAnswer((_) async {});
      return signUpBloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      SignUpInitial(),
    ],
  );
}
