import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_event.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_state.dart';
import '../../mocks/mock_auth_helper.dart';


void main() {
  late MockAuthHelper authHelper;
  late SignInBloc bloc;

  final mockUser = Users(
    id: '1',
    username: 'testuser',
    email: 'test@mail.com',
    role: 'Customer',
    isActive: true,
    createdAt: DateTime.now(), 
    updatedAt: DateTime.now(),
  );

  setUp(() {
    authHelper = MockAuthHelper();
    bloc = SignInBloc(authHelper);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is SignInInitial', () {
    expect(bloc.state, SignInInitial());
  });

  blocTest<SignInBloc, SignInState>(
    'emit [Loading, Success] when sign in with email success',
    build: () {
      when(() => authHelper.signInWithEmailAndPassword(
            any(),
            any(),
          )).thenAnswer((_) async => mockUser);
      return bloc;
    },
    act: (bloc) => bloc.add(
      SignInWithEmailEvent(
        email: 'test@mail.com',
        password: 'password123',
      ),
    ),
    expect: () => [
      SignInLoading(),
      SignInSuccess(mockUser),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emit [Loading, Error] when wrong credential',
    build: () {
      when(() => authHelper.signInWithEmailAndPassword(
            any(),
            any(),
          )).thenThrow(
        FirebaseAuthException(code: 'invalid-credential'),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(
      SignInWithEmailEvent(
        email: 'wrong@mail.com',
        password: 'wrongpass',
      ),
    ),
    expect: () => [
      SignInLoading(),
      const SignInError('Wrong email or password'),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emit [Loading, Error] when network error',
    build: () {
      when(() => authHelper.signInWithEmailAndPassword(
            any(),
            any(),
          )).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(
      SignInWithEmailEvent(
        email: 'test@mail.com',
        password: 'password123',
      ),
    ),
    expect: () => [
      SignInLoading(),
      const SignInError('Your internet connection is bad'),
    ],
  );


  blocTest<SignInBloc, SignInState>(
    'emit [Loading, Success] when google sign in success',
    build: () {
      when(() => authHelper.signInWithGoogle())
          .thenAnswer((_) async => mockUser);
      return bloc;
    },
    act: (bloc) => bloc.add(SignInWithGoogleEvent()),
    expect: () => [
      SignInLoading(),
      SignInSuccess(mockUser),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emit [Loading, Error] when google sign in fails',
    build: () {
      when(() => authHelper.signInWithGoogle())
          .thenThrow(Exception('Google error'));
      return bloc;
    },
    act: (bloc) => bloc.add(SignInWithGoogleEvent()),
    expect: () => [
      SignInLoading(),
      const SignInError('Exception: Google error'),
    ],
  );


  blocTest<SignInBloc, SignInState>(
    'emit Initial when sign out',
    build: () {
      when(() => authHelper.signOut())
          .thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(SignOutEvent()),
    expect: () => [
      SignInInitial(),
    ],
  );
}
