import 'package:bookapin/data/models/rents.dart';

abstract class DetailRentState {}

class DetailRentInitial extends DetailRentState {}

class DetailRentLoading extends DetailRentState {}

class DetailRentLoaded extends DetailRentState {
  final Rents rent;
  DetailRentLoaded(this.rent);
}

class DetailRentError extends DetailRentState {
  final String message;
  DetailRentError(this.message);
}