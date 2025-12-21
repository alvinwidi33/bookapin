import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_event.dart';
import 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'Wrong email or password';
      case 'user-disabled':
        return 'Your account is inactive';
      case 'account-exists-with-different-credential':
        return 'Your account already exists';
      case 'network-request-failed':
        return 'Your internet connection is bad';
      default:
        return 'Something went wrong. Please try again';
    }
  }

  final AuthHelper authHelper;

  SignInBloc(this.authHelper) : super(SignInInitial()) {
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final Users user =
          await authHelper.signInWithEmailAndPassword(
            event.email,
            event.password,
          );

      emit(SignInSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(SignInError(_mapFirebaseAuthError(e)));
    } catch (e) {
      emit(SignInError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final Users user =
          await authHelper.signInWithGoogle();
      emit(SignInSuccess(user));
    } catch (e) {
      emit(SignInError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<SignInState> emit,
  ) async {
    await authHelper.signOut();
    emit(SignInInitial());
  }
}
