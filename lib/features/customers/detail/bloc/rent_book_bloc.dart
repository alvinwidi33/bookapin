import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentBookBloc extends Bloc<RentBookEvent, RentBookState> {
  final RentRepository repository;

  RentBookBloc(this.repository) : super(RentBookInitial()) {
    on<SubmitRentBook>((event, emit) async {
      emit(RentBookLoading());
      try {
        await repository.createRent(
          bookId: event.bookId,
          userId: event.userId,
          duration: event.duration,
          price: event.price,
        );
        emit(RentBookSuccess());
      } catch (e) {
        emit(RentBookFailure(e.toString()));
      }
    });
  }
}
