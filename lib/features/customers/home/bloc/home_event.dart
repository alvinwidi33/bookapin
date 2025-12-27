import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  
  @override
  List<Object?> get props => [];
}

class FetchAllBooks extends HomeEvent {
  final bool isRefresh;

  const FetchAllBooks({this.isRefresh = false});
  
  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreBooks extends HomeEvent {
  const LoadMoreBooks();
}

class FetchBooksWithFilter extends HomeEvent {
  final List<String> categories;
  final bool isRefresh;

  const FetchBooksWithFilter({
    required this.categories,
    this.isRefresh = false,
  });
  
  @override
  List<Object?> get props => [categories, isRefresh];
}

class ApplyFilter extends HomeEvent {
  final List<String> categories;

  const ApplyFilter({
    required this.categories,
  });
  
  @override
  List<Object?> get props => [categories];
}

class ClearFilter extends HomeEvent {
  const ClearFilter();
}

class SearchBooks extends HomeEvent {
  final String keyword;

  const SearchBooks(this.keyword);
  
  @override
  List<Object?> get props => [keyword];
}

class SortBooks extends HomeEvent {
  final String sortKey;
  
  const SortBooks({required this.sortKey});
  
  @override
  List<Object?> get props => [sortKey];
}

class FilterByYear extends HomeEvent {
  final String? year;
  
  const FilterByYear({this.year});
  
  @override
  List<Object?> get props => [year];
}

class ApplyFilterAndSort extends HomeEvent {
  final List<String> categories;
  final String? year;
  final String? sortKey;

  const ApplyFilterAndSort({
    required this.categories,
    this.year,
    this.sortKey,
  });
  
  @override
  List<Object?> get props => [categories, year, sortKey];
}