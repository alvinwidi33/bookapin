part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeIncrementEvent extends HomeEvent {}

final class HomeDecrementEvent extends HomeEvent {}