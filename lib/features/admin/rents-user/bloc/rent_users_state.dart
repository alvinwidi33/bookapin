import 'package:equatable/equatable.dart';
import 'package:bookapin/data/models/rents.dart';

abstract class RentUsersState extends Equatable {
  const RentUsersState();

  @override
  List<Object?> get props => [];
}

class RentUsersInitial extends RentUsersState {}

class RentUsersLoading extends RentUsersState {}

class RentUsersLoaded extends RentUsersState {
  final List<Rents> rents;

  const RentUsersLoaded(this.rents);

  @override
  List<Object?> get props => [rents];
}

class RentUsersError extends RentUsersState {
  final String message;

  const RentUsersError(this.message);

  @override
  List<Object?> get props => [message];
}
