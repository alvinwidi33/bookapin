part of 'home_bloc.dart';

class HomeState {
  final int counter; 

  const HomeState(this.counter);

  copyWith({int? counter}) => HomeState(counter ?? this.counter);
}