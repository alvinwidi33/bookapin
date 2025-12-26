abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;

  LoadProfile({required this.userId});
}

class LogoutProfile extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {
  final String userId;

  RefreshProfile({required this.userId});
}