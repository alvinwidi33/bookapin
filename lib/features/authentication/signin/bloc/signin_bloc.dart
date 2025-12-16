import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_event.dart';
import 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
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
      final UserCredential result =
          await authHelper.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(SignInSuccess(result.user!));
    } on FirebaseAuthException catch (e) {
      emit(SignInError(e.message ?? 'Login failed'));
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
      final UserCredential? result =
          await authHelper.signInWithGoogle();
      emit(SignInSuccess(result!.user!));
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
