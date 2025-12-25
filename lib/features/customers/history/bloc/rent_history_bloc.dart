import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'rent_history_event.dart';
import 'rent_history_state.dart';

class RentHistoryBloc
    extends Bloc<RentHistoryEvent, RentHistoryState> {
  final RentRepository repository;

  RentHistoryBloc(this.repository)
      : super(RentHistoryInitial()) {
    on<FetchRentHistory>(_onFetchRentHistory);
  }

  Future<void> _onFetchRentHistory(
    FetchRentHistory event,
    Emitter<RentHistoryState> emit,
  ) async {
    emit(RentHistoryLoading());

    try {
      final rents = await repository.getUserRents(event.userId);
      emit(RentHistoryLoaded(rents));
    } catch (e) {
      emit(RentHistoryError(e.toString()));
    }
  }
}
