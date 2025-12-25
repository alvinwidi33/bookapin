import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailBookBloc extends Bloc<DetailBookEvent, DetailBookState> {
  final BookRepository repository;

  DetailBookBloc(this.repository) : super(DetailBookInitial()) {
    on<FetchBookDetail>(_fetchBookDetail);
  }

  Future<void> _fetchBookDetail(
    FetchBookDetail event,
    Emitter<DetailBookState> emit,
  ) async {
    emit(DetailBookLoading());

    try {
      final book = await repository.getBookById(event.bookId);
      emit(DetailBookLoaded(book));
    } catch (e) {
      emit(DetailBookError(e.toString()));
    }
  }
}