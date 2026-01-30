import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_bloc.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_event.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../data/repositories/fakes/fake_rent_repository.dart';

final fakeRent = Rents(
  id: 'rent-1',
  book: 'book-1',
  bookDetails: null,
  user: 'user-1',
  userDetails: null,
  fine: 0,
  duration: 7,
  price: 10000,
  borrowedAt: DateTime.now(),
  isReturn: false,
  returnedAt: null,
);


void main() {
  group('RentUsersBloc', () {
    test('initial state adalah RentUsersInitial', () {
      final bloc = RentUsersBloc(FakeRentRepository());
      expect(bloc.state, isA<RentUsersInitial>());
    });

blocTest<RentUsersBloc, RentUsersState>(
  'emit [Loading, Loaded] ketika fetch sukses',
  build: () => RentUsersBloc(
    FakeRentRepository(
      initialRents: [fakeRent],
    ),
  ),
  act: (bloc) => bloc.add(const FetchRentUsers('user-1')),
  expect: () => [
    RentUsersLoading(),
    isA<RentUsersLoaded>()
        .having((s) => s.rents.length, 'jumlah rent', 1),
  ],
);


    blocTest<RentUsersBloc, RentUsersState>(
      'emit [Loading, Error] ketika repository throw error',
      build: () =>
          RentUsersBloc(FakeRentRepository(shouldThrow: true)),
      act: (bloc) => bloc.add(const FetchRentUsers('user-1')),
      expect: () => [
        RentUsersLoading(),
        isA<RentUsersError>(),
      ],
    );
  });
}
