import 'package:bookapin/data/models/books.dart';

abstract class DetailBookState {}

class DetailBookInitial extends DetailBookState {}

class DetailBookLoading extends DetailBookState {}

class DetailBookLoaded extends DetailBookState {
  final BookDetails book;
  DetailBookLoaded(this.book);
}

class DetailBookError extends DetailBookState {
  final String message;
  DetailBookError(this.message);
}