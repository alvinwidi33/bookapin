import 'package:bookapin/data/models/books.dart';

abstract class HomeState {}
class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Book> carouselBooks;
  final List<Book> allBooks;

  HomeLoaded({
    required this.carouselBooks,
    required this.allBooks,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
