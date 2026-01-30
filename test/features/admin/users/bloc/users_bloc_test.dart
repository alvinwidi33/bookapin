import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bookapin/features/admin/users/bloc/users_bloc.dart';
import 'package:bookapin/features/admin/users/bloc/users_event.dart';
import 'package:bookapin/features/admin/users/bloc/users_state.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/data/repositories/user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UsersBloc usersBloc;
  late MockUserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    usersBloc = UsersBloc(userRepository);
  });

  tearDown(() {
    usersBloc.close();
  });

  final mockUsers = [
    Users(
      id: '1',
      username: 'User A',
      email: 'usera@mail.com',
      isActive: true, 
      role: 'Customer', 
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(),
    ),
    Users(
      id: '2',
      username: 'User B',
      email: 'userb@mail.com',
      isActive: false,
      role: 'Customer', 
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(),
    ),
  ];

  test('initial state should be UsersInitial', () {
    expect(usersBloc.state, UsersInitial());
  });

  blocTest<UsersBloc, UsersState>(
    'emit [UsersLoading, UsersLoaded] ketika LoadUsers sukses',
    build: () {
      when(() => userRepository.getAllCustomer())
          .thenAnswer((_) async => mockUsers);
      return usersBloc;
    },
    act: (bloc) => bloc.add(const LoadUsers()),
    expect: () => [
      UsersLoading(),
      UsersLoaded(mockUsers),
    ],
    verify: (_) {
      verify(() => userRepository.getAllCustomer()).called(1);
    },
  );

  blocTest<UsersBloc, UsersState>(
    'emit [UsersLoading, UsersError] ketika LoadUsers gagal',
    build: () {
      when(() => userRepository.getAllCustomer())
          .thenThrow(Exception('error'));
      return usersBloc;
    },
    act: (bloc) => bloc.add(const LoadUsers()),
    expect: () => [
      UsersLoading(),
      const UsersError('Gagal memuat data user'),
    ],
  );

  blocTest<UsersBloc, UsersState>(
    'emit UsersLoaded setelah ToggleUserActive berhasil',
    build: () {
      when(() => userRepository.updateUserActive(
            '1',
            false,
          )).thenAnswer((_) async {});
      when(() => userRepository.getAllCustomer())
          .thenAnswer((_) async => mockUsers);
      return usersBloc;
    },
    act: (bloc) => bloc.add(
      ToggleUserActive(
        userId: '1',
        isActive: false,
      ),
    ),
    expect: () => [
      UsersLoaded(mockUsers),
    ],
    verify: (_) {
      verify(() => userRepository.updateUserActive('1', false)).called(1);
      verify(() => userRepository.getAllCustomer()).called(1);
    },
  );

  blocTest<UsersBloc, UsersState>(
    'emit UsersError ketika ToggleUserActive gagal',
    build: () {
      when(() => userRepository.updateUserActive(
            any(),
            any(),
          )).thenThrow(Exception('error'));
      return usersBloc;
    },
    act: (bloc) => bloc.add(
      ToggleUserActive(
        userId: '1',
        isActive: false,
      ),
    ),
    expect: () => [
      const UsersError('Gagal update status user'),
    ],
  );
}
