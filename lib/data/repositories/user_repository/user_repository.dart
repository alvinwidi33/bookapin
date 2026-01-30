import 'package:bookapin/data/models/users.dart';

abstract class UserRepository {
  Future<List<Users>> getAllCustomer();

  Future<void> updateUserActive(
    String userId,
    bool isActive,
  );
}
