import 'package:flutter_test/flutter_test.dart';
import 'package:bookapin/data/models/users.dart';
import 'fakes/fake_user_repository.dart';

void main() {
  late FakeUserRepository repository;

  setUp(() {
    repository = FakeUserRepository();
  });

  group('FakeUserRepository', () {
    test('getAllCustomer returns only Customer role users', () async {
      final now = DateTime.now();

      repository.addUser(Users(
        id: '1',
        email: 'admin@mail.com',
        username: 'admin',
        role: 'Admin',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      repository.addUser(Users(
        id: '2',
        email: 'user@mail.com',
        username: 'customer',
        role: 'Customer',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final result = await repository.getAllCustomer();

      expect(result.length, 1);
      expect(result.first.role, 'Customer');
      expect(result.first.email, 'user@mail.com');
    });

    test('getAllCustomer returns empty list when no customers', () async {
      final now = DateTime.now();

      repository.addUser(Users(
        id: '1',
        email: 'admin@mail.com',
        username: 'admin',
        role: 'Admin',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ));

      final result = await repository.getAllCustomer();

      expect(result, isEmpty);
    });

    test('updateUserActive changes user active status', () async {
  final now = DateTime.now();

  repository.addUser(Users(
    id: 'user-id',
    email: 'user2@mail.com',
    username: 'user2',
    role: 'Customer',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  ));

  await repository.updateUserActive('user-id', false);

  final user = repository.getUserById('user-id');
  expect(user?.isActive, false);
expect(user?.updatedAt, isNotNull);
});


    test('updateUserActive throws when user not found', () async {
      expect(
        () => repository.updateUserActive('non-existent', false),
        throwsException,
      );
    });

    test('getAllCustomer throws when shouldThrow is true', () async {
      repository = FakeUserRepository(shouldThrow: true);

      expect(
        () => repository.getAllCustomer(),
        throwsException,
      );
    });

    test('can initialize with users', () async {
      final now = DateTime.now();
      final initialUsers = [
        Users(
          id: '1',
          email: 'user1@mail.com',
          username: 'user1',
          role: 'Customer',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      repository = FakeUserRepository(initialUsers: initialUsers);

      final result = await repository.getAllCustomer();
      expect(result.length, 1);
    });
  });
}