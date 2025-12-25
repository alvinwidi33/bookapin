abstract class HomeEvent {}

class FetchAllBooks extends HomeEvent {
  final bool isRefresh;

  FetchAllBooks({this.isRefresh = false});
}

class LoadMoreBooks extends HomeEvent {}

class FetchBooksWithFilter extends HomeEvent {
  final List<String> categories;
  final bool isRefresh;

  FetchBooksWithFilter({
    required this.categories,
    this.isRefresh = false,
  });
}

class ApplyFilter extends HomeEvent {
  final List<String> categories;

  ApplyFilter({
    required this.categories,
  });
}

class ClearFilter extends HomeEvent {}
class SearchBooks extends HomeEvent {
  final String keyword;

  SearchBooks(this.keyword);
}