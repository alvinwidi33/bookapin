abstract class HomeEvent {}

class FetchAllBooks extends HomeEvent {
  final bool isRefresh;
  FetchAllBooks({this.isRefresh = false});
}

class LoadMoreBooks extends HomeEvent {}
