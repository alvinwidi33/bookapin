import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchAllBooks2024>(_fetchHomes2024);
  }

  Future<void> _fetchHomes2024(
    FetchAllBooks2024 event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final response = await repository.getBooks(year: '2024', page: 1);

      emit(
        HomeLoaded(
          carouselBooks: response.books.take(3).toList(),
          allBooks: response.books,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
