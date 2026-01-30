import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_bloc.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_event.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';


void main() {
  group('RentHistoryBloc', () {
    late FakeRentRepository rentRepository;
    late RentHistoryBloc rentHistoryBloc;

    const userId = 'user-1';

    setUp(() {
      rentRepository = FakeRentRepository();
      rentHistoryBloc = RentHistoryBloc(rentRepository);
    });

    tearDown(() {
      rentHistoryBloc.close();
    });

    test('initial state is RentHistoryInitial', () {
      expect(rentHistoryBloc.state, isA<RentHistoryInitial>());
    });

    blocTest<RentHistoryBloc, RentHistoryState>(
      'emits [Loading, Loaded] when FetchRentHistory succeeds',
      build: () {
        rentRepository.addRent(
          Rents(
            id: 'rent-1',
            book: 'book-1',
            bookDetails: null,
            user: userId,
            userDetails: null,
            fine: 0,
            duration: 5,
            price: 10000,
            borrowedAt: DateTime.now(),
            isReturn: false,
            returnedAt: null,
          ),
        );

        return RentHistoryBloc(rentRepository);
      },
      act: (bloc) => bloc.add(
        const FetchRentHistory(userId: userId),
      ),
      expect: () => [
        isA<RentHistoryLoading>(),
        isA<RentHistoryLoaded>()
            .having((state) => state.rents.length, 'rents length', 1),
      ],
    );

    blocTest<RentHistoryBloc, RentHistoryState>(
      'emits [Loading, Error] when repository throws exception',
      build: () {
        rentRepository = FakeRentRepository(shouldThrow: true);
        return RentHistoryBloc(rentRepository);
      },
      act: (bloc) => bloc.add(
        const FetchRentHistory(userId: userId),
      ),
      expect: () => [
        isA<RentHistoryLoading>(),
        isA<RentHistoryError>(),
      ],
    );
  });
}
