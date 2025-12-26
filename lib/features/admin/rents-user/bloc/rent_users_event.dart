import 'package:equatable/equatable.dart';

abstract class RentUsersEvent extends Equatable {
  const RentUsersEvent();

  @override
  List<Object?> get props => [];
}

class FetchRentUsers extends RentUsersEvent {
  final String userId;

  const FetchRentUsers(this.userId);

  @override
  List<Object?> get props => [userId];
}
