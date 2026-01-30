import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/data/repositories/user_repository/user_repository.dart';

class FakeUserRepository implements UserRepository {
  final List<Users> _users = [];
  final bool shouldThrow;

  FakeUserRepository({this.shouldThrow = false, List<Users>? initialUsers}) {
    if (initialUsers != null) {
      _users.addAll(initialUsers);
    }
  }

  @override
  Future<List<Users>> getAllCustomer() async {
    if (shouldThrow) {
      throw Exception('Failed to fetch customers');
    }
    return _users.where((user) => user.role == 'Customer').toList();
  }

  @override
  Future<void> updateUserActive(String userId, bool isActive) async {
    if (shouldThrow) {
      throw Exception('Failed to update user');
    }
    
    final index = _users.indexWhere((user) => user.id == userId);
    if (index == -1) {
      throw Exception('User not found');
    }

    _users[index] = Users(
      id: _users[index].id,
      username: _users[index].username,
      email: _users[index].email,
      role: _users[index].role,
      isActive: isActive,
      createdAt: _users[index].createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Helper methods for testing
  void addUser(Users user) {
    _users.add(user);
  }

  void addUsers(List<Users> users) {
    _users.addAll(users);
  }

  void clear() {
    _users.clear();
  }

  Users? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  List<Users> getAllUsers() {
    return List.unmodifiable(_users);
  }
}