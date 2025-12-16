import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final User user;

  const SignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInError extends SignInState {
  final String message;

  const SignInError(this.message);

  @override
  List<Object?> get props => [message];
}
