import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'rent_users_event.dart';
import 'rent_users_state.dart';

class RentUsersBloc extends Bloc<RentUsersEvent, RentUsersState> {
  final RentRepository repository;

  RentUsersBloc(this.repository)
      : super(RentUsersInitial()) {
    on<FetchRentUsers>(_onFetchRentUsers);
  }

  Future<void> _onFetchRentUsers(
    FetchRentUsers event,
    Emitter<RentUsersState> emit,
  ) async {
    emit(RentUsersLoading());

    try {
      final rents = await repository.getUserRents(event.userId);
      emit(RentUsersLoaded(rents));
    } catch (e) {
      emit(RentUsersError(e.toString()));
    }
  }
}
