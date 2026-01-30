import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapin/features/customers/detail/bloc/detail_book_bloc.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_state.dart';

import '../../../../data/repositories/fakes/fake_book_repository.dart';

void main() {
  group('DetailBookBloc', () {
    late FakeBookRepository bookRepository;
    late DetailBookBloc detailBookBloc;

    const bookId = 'book-1';

    setUp(() {
      bookRepository = FakeBookRepository();
      detailBookBloc = DetailBookBloc(bookRepository);
    });

    tearDown(() {
      detailBookBloc.close();
    });

    test('initial state is DetailBookInitial', () {
      expect(detailBookBloc.state, isA<DetailBookInitial>());
    });

    blocTest<DetailBookBloc, DetailBookState>(
      'emits [Loading, Loaded] when FetchBookDetail succeeds',
      build: () => DetailBookBloc(bookRepository),
      act: (bloc) => bloc.add(
        FetchBookDetail(bookId: bookId),
      ),
      expect: () => [
        isA<DetailBookLoading>(),
        isA<DetailBookLoaded>()
            .having((state) => state.book.id, 'book id', bookId),
      ],
    );

    blocTest<DetailBookBloc, DetailBookState>(
      'emits [Loading, Error] when repository throws exception',
      build: () {
        bookRepository = FakeBookRepository(shouldThrow: true);
        return DetailBookBloc(bookRepository);
      },
      act: (bloc) => bloc.add(
        FetchBookDetail(bookId: bookId),
      ),
      expect: () => [
        isA<DetailBookLoading>(),
        isA<DetailBookError>(),
      ],
    );
  });
}
