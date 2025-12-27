import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> allBooks;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final List<String> activeCategories;
  final String searchKeyword;
  final String? activeYear;
  final String? sortBy;

  HomeLoaded({
    required this.allBooks,
    required this.page,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.activeCategories = const [],
    this.searchKeyword = '',
    this.activeYear,
    this.sortBy,
  });

  HomeLoaded copyWith({
    List<dynamic>? allBooks,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
    List<String>? activeCategories,
    String? searchKeyword,
    String? activeYear,
    String? sortBy,
    bool clearYear = false,      // Flag untuk clear year
    bool clearSort = false,      // Flag untuk clear sort
  }) {
    return HomeLoaded(
      allBooks: allBooks ?? this.allBooks,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      activeCategories: activeCategories ?? this.activeCategories,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      activeYear: clearYear ? null : (activeYear ?? this.activeYear),
      sortBy: clearSort ? null : (sortBy ?? this.sortBy),
    );
  }

  @override
  List<Object?> get props => [
        allBooks,
        page,
        hasReachedMax,
        isLoadingMore,
        activeCategories,
        searchKeyword,
        activeYear,
        sortBy,
      ];

  bool get hasActiveFilter =>
      activeCategories.isNotEmpty ||
      searchKeyword.isNotEmpty ||
      activeYear != null ||
      sortBy != null;
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}