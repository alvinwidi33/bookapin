import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookapin/features/customers/home/pages/home_page.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import '../../../../data/repositories/fakes/fake_book_repository.dart';

void main() {

  Widget makeTestableWidget(HomeBloc bloc) {
    return MaterialApp(
      routes: {
        '/home': (_) => const Scaffold(body: Text('Home Page')),
        '/history': (_) => const Scaffold(body: Text('History Page')),
        '/profile': (_) => const Scaffold(body: Text('Profile Page')),
        '/detail-book': (_) => const Scaffold(body: Text('Detail Book Page')),
      },
      home: BlocProvider<HomeBloc>.value(
        value: bloc,
        child: const HomePage(),
      ),
    );
  }

  group('HomePage - Get All Books', () {
    testWidgets(
    'Menampilkan grid buku ketika data berhasil dimuat',
    (WidgetTester tester) async {
      final bloc = HomeBloc(FakeBookRepository());
    
      await tester.pumpWidget(makeTestableWidget(bloc));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Clean Architecture'), findsOneWidget);
      expect(find.text('Flutter in Action'), findsOneWidget);
    },
  );


    testWidgets(
      'Menampilkan UI error ketika gagal mengambil data',
      (WidgetTester tester) async {
        final bloc = HomeBloc(FakeBookRepository(shouldThrow: true));

        await tester.pumpWidget(makeTestableWidget(bloc));

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.textContaining('Error'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'Menekan tombol Retry akan memicu loading ulang',
      (WidgetTester tester) async {
        final bloc = HomeBloc(FakeBookRepository(shouldThrow: true));

        await tester.pumpWidget(makeTestableWidget(bloc));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'Search bar ditampilkan di halaman Home',
      (WidgetTester tester) async {
        final bloc = HomeBloc(FakeBookRepository());

        await tester.pumpWidget(makeTestableWidget(bloc));

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search here'), findsOneWidget);
      },
    );
  });
}
