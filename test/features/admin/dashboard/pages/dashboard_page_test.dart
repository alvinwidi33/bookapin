import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_bloc.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_event.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_state.dart';
import 'package:bookapin/features/admin/dashboard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardBloc
    extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

void main() {
  late DashboardBloc bloc;

  setUp(() {
    bloc = MockDashboardBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<DashboardBloc>.value(
        value: bloc,
        child: const DashboardPage(),
      ),
    );
  }

  testWidgets('menampilkan loading ketika state DashboardLoading',
      (tester) async {
    when(() => bloc.state).thenReturn(DashboardLoading());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Lottie), findsOneWidget);
  });

  testWidgets('menampilkan data ketika DashboardLoaded',
      (tester) async {
    when(() => bloc.state).thenReturn(
      DashboardLoaded(
        [
          GenreStatistic(genre: 'Technology', count: 5),
          GenreStatistic(genre: 'Novel', count: 3),
        ],
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Book Genre Dashboard'), findsOneWidget);
    expect(find.text('Technology'), findsWidgets);
    expect(find.text('Novel'), findsWidgets);
    expect(find.text('Total Books'), findsOneWidget);
  });

  testWidgets('menampilkan error + tombol retry',
      (tester) async {
    when(() => bloc.state).thenReturn(
      const DashboardError('Gagal memuat data dashboard'),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Gagal memuat data dashboard'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
  });

testWidgets('klik Coba Lagi memicu LoadDashboardStats',
    (tester) async {
  whenListen(
    bloc,
    Stream.value(const DashboardError('Gagal memuat data dashboard')),
    initialState: const DashboardError('Gagal memuat data dashboard'),
  );

  await tester.pumpWidget(makeTestableWidget());
  await tester.pump();

  clearInteractions(bloc);

  await tester.tap(find.text('Coba Lagi'));
  await tester.pump();

  verify(() => bloc.add(LoadDashboardStats())).called(1);
});
}
