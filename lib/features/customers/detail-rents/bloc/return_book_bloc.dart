import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReturnBookBloc extends Bloc<ReturnBookEvent, ReturnBookState> {
  final RentRepository repository;

  ReturnBookBloc(this.repository) : super(ReturnBookInitial()) {
    on<SubmitReturnBook>(_onReturnBook);
  }

  Future<void> _onReturnBook(
    SubmitReturnBook event,
    Emitter<ReturnBookState> emit,
  ) async {
    emit(ReturnBookLoading());

    try {
      await repository.returnBook(event.rentId, event.fine,);
      emit(ReturnBookSuccess());
    } catch (e) {
      emit(ReturnBookFailure(e.toString()));
    }
  }
}
