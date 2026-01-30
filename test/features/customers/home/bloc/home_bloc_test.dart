import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/bloc/home_state.dart';

import '../../../../data/repositories/fakes/fake_book_repository.dart';
void main() {
  group('HomeBloc with FakeBookRepository', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when FetchAllBooks succeeds',
      build: () => HomeBloc(FakeBookRepository()),
      act: (bloc) => bloc.add(FetchAllBooks(isRefresh: true)),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.allBooks.length, 'books length', 2)
            .having((s) => s.hasReachedMax, 'hasReachedMax', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when repository throws exception',
      build: () => HomeBloc(FakeBookRepository(shouldThrow: true)),
      act: (bloc) => bloc.add(FetchAllBooks(isRefresh: true)),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'search updates keyword and results',
      build: () => HomeBloc(FakeBookRepository()),
      act: (bloc) => bloc.add(SearchBooks('Flutter')),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.searchKeyword, 'keyword', 'Flutter'),
      ],
    );
  });
}
