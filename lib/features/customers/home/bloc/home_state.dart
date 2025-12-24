abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> allBooks;
  final int page;
  final bool isLoadingMore;
  final bool hasReachedMax;

  HomeLoaded({
    required this.allBooks,
    this.page = 1,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  HomeLoaded copyWith({
    List<dynamic>? allBooks,
    int? page,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return HomeLoaded(
      allBooks: allBooks ?? this.allBooks,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
