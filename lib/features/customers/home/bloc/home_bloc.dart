import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchAllBooks>(_fetchBooks);
    on<LoadMoreBooks>(_loadMoreBooks);
    on<FetchBooksWithFilter>(_fetchBooksWithFilter);
    on<ApplyFilter>(_applyFilter);
    on<ClearFilter>(_clearFilter);
    on<SearchBooks>(_searchBooks);
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

  Future<void> _searchBooks(
    SearchBooks event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    final currentState = state is HomeLoaded ? state as HomeLoaded : null;

    try {
      // Maintain filter yang sudah aktif
      String? genreFilter;
      if (currentState != null && currentState.activeCategories.isNotEmpty) {
        genreFilter = currentState.activeCategories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        keyword: event.keyword.isEmpty ? null : event.keyword,
        genre: genreFilter,
      );

      List<dynamic> filteredBooks = response.books;

      emit(
        HomeLoaded(
          allBooks: filteredBooks,
          page: 1,
          hasReachedMax: filteredBooks.isEmpty,
          activeCategories: currentState?.activeCategories ?? [],
          searchKeyword: event.keyword,
        ),
      );
    } catch (e) {
      if (currentState != null) {
        emit(currentState);
      } else {
        emit(HomeError(e.toString()));
      }
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
            String? genreFilter;
      if (currentState.activeCategories.isNotEmpty) {
        genreFilter = currentState.activeCategories.join(',');
      }

      final response = await repository.getBooks(
        page: nextPage,
        genre: genreFilter,
        keyword: currentState.searchKeyword.isEmpty 
            ? null 
            : currentState.searchKeyword,
      );

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

  Future<void> _fetchBooksWithFilter(
    FetchBooksWithFilter event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // Convert categories list to comma-separated string untuk genre parameter
      String? genreFilter;
      if (event.categories.isNotEmpty) {
        genreFilter = event.categories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        genre: genreFilter,
      );

      emit(
        HomeLoaded(
          allBooks: response.books,
          page: 1,
          hasReachedMax: response.books.isEmpty,
          activeCategories: event.categories,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _applyFilter(
    ApplyFilter event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    emit(HomeLoading());

    try {
      // Convert categories to genre parameter
      String? genreFilter;
      if (event.categories.isNotEmpty) {
        genreFilter = event.categories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        genre: genreFilter,
      );

      List<dynamic> filteredBooks = response.books;

      emit(
        HomeLoaded(
          allBooks: filteredBooks,
          page: 1,
          hasReachedMax: filteredBooks.isEmpty,
          activeCategories: event.categories,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _clearFilter(
    ClearFilter event,
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
          activeCategories: [],
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}