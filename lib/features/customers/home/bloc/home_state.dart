abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> allBooks;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;
  
  final List<String> activeCategories;

  final String searchKeyword; 

  HomeLoaded({
    required this.allBooks,
    required this.page,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.activeCategories = const [],
    this.searchKeyword = '',          
  });

  HomeLoaded copyWith({
    List<dynamic>? allBooks,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
    List<String>? activeCategories,
    String? searchKeyword,            
  }) {
    return HomeLoaded(
      allBooks: allBooks ?? this.allBooks,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      activeCategories: activeCategories ?? this.activeCategories,
      searchKeyword: searchKeyword ?? this.searchKeyword, 
    );
  }

  bool get hasActiveFilter => 
      activeCategories.isNotEmpty || 
      searchKeyword.isNotEmpty;        
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}