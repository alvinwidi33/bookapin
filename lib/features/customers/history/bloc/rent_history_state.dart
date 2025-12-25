import 'package:equatable/equatable.dart';
import 'package:bookapin/data/models/rents.dart';

abstract class RentHistoryState extends Equatable {
  const RentHistoryState();

  @override
  List<Object?> get props => [];
}

class RentHistoryInitial extends RentHistoryState {}

class RentHistoryLoading extends RentHistoryState {}

class RentHistoryLoaded extends RentHistoryState {
  final List<Rents> rents;

  const RentHistoryLoaded(this.rents);

  @override
  List<Object?> get props => [rents];
}

class RentHistoryError extends RentHistoryState {
  final String message;

  const RentHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
