
import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailRentBloc extends Bloc<DetailRentEvent, DetailRentState> {
  final RentRepository repository;

  DetailRentBloc(this.repository) : super(DetailRentInitial()) {
    on<FetchRentDetail>(_fetchRentDetail);
  }

  Future<void> _fetchRentDetail(
    FetchRentDetail event,
    Emitter<DetailRentState> emit,
  ) async {
    emit(DetailRentLoading());

    try {
      final rent = await repository.getRentById(event.rentId);
      emit(DetailRentLoaded(rent));
    } catch (e) {
      emit(DetailRentError(e.toString()));
    }
  }
}