import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  const LoadUsers();
}

class ToggleUserActive extends UsersEvent {
  final String userId;
  final bool isActive;

  ToggleUserActive({
    required this.userId,
    required this.isActive,
  });
}
