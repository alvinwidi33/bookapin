import 'package:bookapin/data/models/users.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Users user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

class ProfileLogoutLoading extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {}