import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(0)) {
    on<HomeIncrementEvent>(
      (event, emit) => emit(state.copyWith(counter: state.counter + 1)),
    );
    on<HomeDecrementEvent>(
      (event, emit) => emit(state.copyWith(counter: state.counter - 1)),
    );
  }
}