import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_event.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc
    extends Bloc<DashboardEvent, DashboardState> {
  final BookRepository bookRepository;

  DashboardBloc(this.bookRepository)
      : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final stats =
          await bookRepository.getGenreStatistics();

      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(const DashboardError(
          'Gagal memuat data dashboard'));
    }
  }
}
