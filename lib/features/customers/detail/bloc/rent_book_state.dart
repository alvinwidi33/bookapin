import 'package:equatable/equatable.dart';

abstract class RentBookState extends Equatable {
  const RentBookState();

  @override
  List<Object?> get props => [];
}

class RentBookInitial extends RentBookState {}

class RentBookLoading extends RentBookState {}

class RentBookSuccess extends RentBookState {}

class RentBookFailure extends RentBookState {
  final String message;

  const RentBookFailure(this.message);

  @override
  List<Object?> get props => [message];
}
