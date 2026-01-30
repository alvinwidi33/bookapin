import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapin/features/customers/detail/bloc/rent_book_bloc.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_state.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';

void main() {
  group('RentBookBloc', () {
    late FakeRentRepository rentRepository;
    late RentBookBloc rentBookBloc;

    const bookId = 'book-1';
    const userId = 'user-1';
    const duration = 7;
    const price = duration * 5000;

    setUp(() {
      rentRepository = FakeRentRepository();
      rentBookBloc = RentBookBloc(rentRepository);
    });

    tearDown(() {
      rentBookBloc.close();
    });

    test('initial state is RentBookInitial', () {
      expect(rentBookBloc.state, isA<RentBookInitial>());
    });

    blocTest<RentBookBloc, RentBookState>(
      'emits [Loading, Success] when SubmitRentBook succeeds',
      build: () => RentBookBloc(rentRepository),
      act: (bloc) => bloc.add(
        SubmitRentBook(
          bookId: bookId,
          userId: userId,
          duration: duration,
          price: price,
        ),
      ),
      expect: () => [
        isA<RentBookLoading>(),
        isA<RentBookSuccess>(),
      ],
    );

    blocTest<RentBookBloc, RentBookState>(
      'emits [Loading, Failure] when repository throws exception',
      build: () {
        rentRepository = FakeRentRepository(shouldThrow: true);
        return RentBookBloc(rentRepository);
      },
      act: (bloc) => bloc.add(
        SubmitRentBook(
          bookId: bookId,
          userId: userId,
          duration: duration,
          price: price,
        ),
      ),
      expect: () => [
        isA<RentBookLoading>(),
        isA<RentBookFailure>(),
      ],
    );
  });
}
