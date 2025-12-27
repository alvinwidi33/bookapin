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
    on<SortBooks>(_sortBooks);
    on<FilterByYear>(_filterByYear);
    on<ApplyFilterAndSort>(_applyFilterAndSort);
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
      String? genreFilter;
      if (currentState != null && currentState.activeCategories.isNotEmpty) {
        genreFilter = currentState.activeCategories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        keyword: event.keyword.isEmpty ? null : event.keyword,
        genre: genreFilter,
        year: currentState?.activeYear,
        sort: currentState?.sortBy != null 
            ? (currentState!.sortBy == 'newest' ? 'desc' : 'asc')
            : null,
      );

      List<dynamic> filteredBooks = response.books;

      emit(
        HomeLoaded(
          allBooks: filteredBooks,
          page: 1,
          hasReachedMax: filteredBooks.isEmpty,
          activeCategories: currentState?.activeCategories ?? [],
          searchKeyword: event.keyword,
          activeYear: currentState?.activeYear,
          sortBy: currentState?.sortBy,
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
        year: currentState.activeYear,
        sort: currentState.sortBy != null 
            ? (currentState.sortBy == 'newest' ? 'desc' : 'asc')
            : null,
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

    final currentState = state as HomeLoaded;
    emit(HomeLoading());

    try {
      String? genreFilter;
      if (event.categories.isNotEmpty) {
        genreFilter = event.categories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        genre: genreFilter,
        keyword: currentState.searchKeyword.isEmpty 
            ? null 
            : currentState.searchKeyword,
        year: currentState.activeYear,
        sort: currentState.sortBy != null 
            ? (currentState.sortBy == 'newest' ? 'desc' : 'asc')
            : null,
      );

      List<dynamic> filteredBooks = response.books;

      emit(
        HomeLoaded(
          allBooks: filteredBooks,
          page: 1,
          hasReachedMax: filteredBooks.isEmpty,
          activeCategories: event.categories,
          searchKeyword: currentState.searchKeyword,
          activeYear: currentState.activeYear,
          sortBy: currentState.sortBy,
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
          searchKeyword: '',
          activeYear: null,
          sortBy: null,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _sortBooks(
    SortBooks event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    // Gunakan API sorting untuk 'newest' dan 'oldest'
    if (event.sortKey == 'newest' || event.sortKey == 'oldest') {
      emit(HomeLoading());

      try {
        String? genreFilter;
        if (currentState.activeCategories.isNotEmpty) {
          genreFilter = currentState.activeCategories.join(',');
        }

        final response = await repository.getBooks(
          page: 1,
          genre: genreFilter,
          keyword: currentState.searchKeyword.isEmpty 
              ? null 
              : currentState.searchKeyword,
          year: currentState.activeYear,
          sort: event.sortKey == 'newest' ? 'desc' : 'asc',
        );

        emit(
          currentState.copyWith(
            allBooks: response.books,
            page: 1,
            hasReachedMax: response.books.isEmpty,
            sortBy: event.sortKey,
          ),
        );
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    } else {
      // Local sorting untuk sort key lainnya (jika ada)
      final books = List.of(currentState.allBooks);

      // Contoh: tambahkan sorting lain di sini jika diperlukan
      // if (event.sortKey == 'title') {
      //   books.sort((a, b) => a.title.compareTo(b.title));
      // }

      emit(
        currentState.copyWith(
          allBooks: books,
          sortBy: event.sortKey,
        ),
      );
    }
  }

  Future<void> _filterByYear(
    FilterByYear event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }

    final currentState = state is HomeLoaded ? state as HomeLoaded : null;

    emit(HomeLoading());

    try {
      String? genreFilter;
      if (currentState != null && currentState.activeCategories.isNotEmpty) {
        genreFilter = currentState.activeCategories.join(',');
      }

      final response = await repository.getBooks(
        page: 1,
        genre: genreFilter,
        keyword: currentState?.searchKeyword.isEmpty ?? true
            ? null
            : currentState?.searchKeyword,
        year: event.year,
        sort: currentState?.sortBy != null 
            ? (currentState!.sortBy == 'newest' ? 'desc' : 'asc')
            : null,
      );

      emit(
        HomeLoaded(
          allBooks: response.books,
          page: 1,
          hasReachedMax: response.books.isEmpty,
          activeCategories: currentState?.activeCategories ?? [],
          searchKeyword: currentState?.searchKeyword ?? '',
          activeYear: event.year,
          sortBy: currentState?.sortBy,
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

  int _extractYear(dynamic book) {
    final publishedDate = book.publishedDate;
    if (publishedDate == null) return 0;

    final match = RegExp(r'\d{4}').firstMatch(publishedDate.toString());
    return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
  }
  Future<void> _applyFilterAndSort(
    ApplyFilterAndSort event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(HomeLoading());

    try {
      List<dynamic> allBooks = [];

      if (event.categories.isNotEmpty) {
        final Set<String> bookIds = {}; 
        
        for (final category in event.categories) {
          try {
            final response = await repository.getBooks(
              page: 1,
              genre: category, 
              keyword: currentState.searchKeyword.isEmpty 
                  ? null 
                  : currentState.searchKeyword,
              year: event.year,
              sort: event.sortKey != null 
                  ? (event.sortKey == 'newest' ? 'desc' : 'asc')
                  : null,
            );
            
            for (final book in response.books) {
              if (!bookIds.contains(book.id)) {
                bookIds.add(book.id);
                allBooks.add(book);
              }
            }
          } catch (e) {
            continue;
          }
        }
      } else {
        final response = await repository.getBooks(
          page: 1,
          keyword: currentState.searchKeyword.isEmpty 
              ? null 
              : currentState.searchKeyword,
          year: event.year,
          sort: event.sortKey != null 
              ? (event.sortKey == 'newest' ? 'desc' : 'asc')
              : null,
        );
        allBooks = response.books;
      }

      emit(
        HomeLoaded(
          allBooks: allBooks,
          page: 1,
          hasReachedMax: allBooks.isEmpty,
          activeCategories: event.categories,
          searchKeyword: currentState.searchKeyword,
          activeYear: event.year,
          sortBy: event.sortKey,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}