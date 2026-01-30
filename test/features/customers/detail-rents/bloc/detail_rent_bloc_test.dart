import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_state.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';

void main() {
  group('DetailRentBloc', () {
    late FakeRentRepository repository;
    late DetailRentBloc bloc;

    const rentId = 'rent-1';

    setUp(() {
      repository = FakeRentRepository();
      bloc = DetailRentBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is DetailRentInitial', () {
      expect(bloc.state, isA<DetailRentInitial>());
    });

  blocTest<DetailRentBloc, DetailRentState>(
    'emits [Loading, Loaded] when fetch rent detail succeeds',
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

      return DetailRentBloc(repository);
    },
    act: (bloc) => bloc.add(
      FetchRentDetail(rentId: rentId),
    ),
    expect: () => [
      isA<DetailRentLoading>(),
      isA<DetailRentLoaded>()
          .having((s) => s.rent.id, 'rent id', rentId),
    ],
  );

    blocTest<DetailRentBloc, DetailRentState>(
      'emits [Loading, Error] when fetch rent detail fails',
      build: () => DetailRentBloc(
        FakeRentRepository(shouldThrow: true),
      ),
      act: (bloc) =>
          bloc.add(FetchRentDetail(rentId: rentId)),
      expect: () => [
        isA<DetailRentLoading>(),
        isA<DetailRentError>(),
      ],
    );
  });
}
