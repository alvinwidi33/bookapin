import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_event.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthHelper authHelper;

  SignUpBloc(this.authHelper) : super(SignUpInitial()) {
    on<SignUpWithUsernameEmailEvent>(_onSignUpWithUsernameEmail);
    on<SignUpWithGoogleEvent>(_onSignUpWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }

Future<void> _onSignUpWithUsernameEmail(
  SignUpWithUsernameEmailEvent event,
  Emitter<SignUpState> emit,
) async {
  emit(SignUpLoading());
  try {
    final Users user =
        await authHelper.signUpWithEmailUsernameAndPassword(
          event.username,
          event.email,
          event.password,
        );

    emit(SignUpSuccess(user));
  } on FirebaseAuthException catch (e) {
    emit(SignUpError(e.message ?? 'Signup failed'));
  } catch (e) {
    emit(SignUpError(e.toString()));
  }
}


Future<void> _onSignUpWithGoogle(
  SignUpWithGoogleEvent event,
  Emitter<SignUpState> emit,
) async {
  emit(SignUpLoading());
  try {
    final Users user = await authHelper.signInWithGoogle();
    emit(SignUpSuccess(user));
  } catch (e) {
    emit(SignUpError(e.toString()));
  }
}


  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<SignUpState> emit,
  ) async {
    await authHelper.signOut();
    emit(SignUpInitial());
  }
}
