import '../models/user.dart';
import 'user_service.dart';

/// In-memory implementation of UserService for local data storage.
/// This implementation stores users in memory and is useful for testing and development.
class InMemoryUserService implements UserService {
  final List<User> _users = [
    User.fromJson({'id': '1', 'name': 'John Doe', 'email': 'john@example.com', 'isEnabled': true}),
    User.fromJson({'id': '2', 'name': 'Jane Smith', 'email': 'jane@example.com', 'isEnabled': true}),
    User.fromJson({'id': '3', 'name': 'Bob Johnson', 'email': 'bob@example.com', 'isEnabled': false}),
  ];

  @override
  Future<List<User>> getAllUsers() async {
    return List.from(_users);
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    if (query.isEmpty) {
      return getAllUsers();
    }
    
    final lowerQuery = query.toLowerCase();
    return _users
        .where((user) =>
            user.name.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<User> addUser(String name, String email) async {
    final newUser = User.fromJson({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'isEnabled': true,
    });
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<User> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index == -1) {
      throw Exception('User not found');
    }
    _users[index] = user;
    return user;
  }

  @override
  Future<bool> deleteUser(String id) async {
    final initialLength = _users.length;
    _users.removeWhere((user) => user.id == id);
    return _users.length < initialLength;
  }

  @override
  Future<User> enableUser(String id) async {
    final user = await getUserById(id);
    if (user == null) {
      throw Exception('User not found');
    }
    final updatedUser = user.copyWith(isEnabled: true);
    return updateUser(updatedUser);
  }

  @override
  Future<User> disableUser(String id) async {
    final user = await getUserById(id);
    if (user == null) {
      throw Exception('User not found');
    }
    final updatedUser = user.copyWith(isEnabled: false);
    return updateUser(updatedUser);
  }
}
