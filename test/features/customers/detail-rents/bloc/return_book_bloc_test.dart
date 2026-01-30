import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapin/features/customers/detail-rents/bloc/return_book_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_state.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';

void main() {
  group('ReturnBookBloc', () {
    late FakeRentRepository repository;
    late ReturnBookBloc bloc;

    const rentId = 'rent-1';
    const fine = 5000;

    setUp(() {
      repository = FakeRentRepository();
      bloc = ReturnBookBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is ReturnBookInitial', () {
      expect(bloc.state, isA<ReturnBookInitial>());
    });

  blocTest<ReturnBookBloc, ReturnBookState>(
    'emits [Loading, Success] when return book succeeds',
    build: () {
      final now = DateTime.now();

      repository.addRent(
        Rents(
          id: rentId,
          book: 'book-1',
          bookDetails: null,
          user: 'user-1',
          userDetails: null,
          fine: 0,
          duration: 5,
          price: 10000,
          borrowedAt: now,
          isReturn: false,
          returnedAt: null,
        ),
      );

      return ReturnBookBloc(repository);
    },
    act: (bloc) => bloc.add(
      SubmitReturnBook(
        rentId: rentId,
        fine: fine,
      ),
    ),
    expect: () => [
      isA<ReturnBookLoading>(),
      isA<ReturnBookSuccess>(),
    ],
  );


    blocTest<ReturnBookBloc, ReturnBookState>(
      'emits [Loading, Failure] when return book fails',
      build: () => ReturnBookBloc(
        FakeRentRepository(shouldThrow: true),
      ),
      act: (bloc) => bloc.add(
        SubmitReturnBook(
          rentId: rentId,
          fine: fine,
        ),
      ),
      expect: () => [
        isA<ReturnBookLoading>(),
        isA<ReturnBookFailure>(),
      ],
    );
  });
}
