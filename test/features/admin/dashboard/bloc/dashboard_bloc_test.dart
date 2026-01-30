import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_bloc.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_event.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../data/repositories/fakes/fake_book_repository.dart';
void main() {
  group('DashboardBloc', () {
    test('initial state adalah DashboardInitial', () {
      final bloc = DashboardBloc(
        FakeBookRepository(),
      );

      expect(bloc.state, isA<DashboardInitial>());
    });

    blocTest<DashboardBloc, DashboardState>(
      'emit [Loading, Loaded] ketika LoadDashboardStats sukses',
      build: () => DashboardBloc(
        FakeBookRepository(),
      ),
      act: (bloc) => bloc.add(LoadDashboardStats()),
      expect: () => [
        DashboardLoading(),
        isA<DashboardLoaded>()
            .having(
              (state) => state.genreStatistics.length,
              'jumlah genre',
              2,
            ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emit [Loading, Error] ketika repository throw error',
      build: () => DashboardBloc(
        FakeBookRepository(shouldThrow: true),
      ),
      act: (bloc) => bloc.add(LoadDashboardStats()),
      expect: () => [
        DashboardLoading(),
        const DashboardError('Gagal memuat data dashboard'),
      ],
    );
  });
}
