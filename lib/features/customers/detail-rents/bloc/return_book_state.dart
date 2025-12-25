import 'package:equatable/equatable.dart';

abstract class ReturnBookState extends Equatable {
  const ReturnBookState();

  @override
  List<Object?> get props => [];
}

class ReturnBookInitial extends ReturnBookState {}

class ReturnBookLoading extends ReturnBookState {}

class ReturnBookSuccess extends ReturnBookState {}

class ReturnBookFailure extends ReturnBookState {
  final String message;

  const ReturnBookFailure(this.message);

  @override
  List<Object?> get props => [message];
}
