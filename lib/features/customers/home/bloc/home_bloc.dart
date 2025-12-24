import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchAllBooks>(_fetchBooks);
    on<LoadMoreBooks>(_loadMoreBooks);
  }

  Future<void> _fetchBooks(
    FetchAllBooks event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final response = await repository.getBooks(page: 1);

      emit(
        HomeLoaded(
          allBooks: response.books,
          page: 1,
          hasReachedMax: response.books.isEmpty,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _loadMoreBooks(
    LoadMoreBooks event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    if (currentState.isLoadingMore || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.page + 1;
      final response = await repository.getBooks(page: nextPage);

      emit(
        currentState.copyWith(
          allBooks: [...currentState.allBooks, ...response.books],
          page: nextPage,
          isLoadingMore: false,
          hasReachedMax: response.books.isEmpty,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
