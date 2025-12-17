import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpWithUsernameEmailEvent extends SignUpEvent {
  final String username;
  final String email;
  final String password;

  const SignUpWithUsernameEmailEvent({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];
}

class SignUpWithGoogleEvent extends SignUpEvent {}

class SignOutEvent extends SignUpEvent {}
