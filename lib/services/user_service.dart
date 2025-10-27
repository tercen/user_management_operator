import '../models/user.dart';

/// Abstract service class for managing user operations.
/// Implementations should provide concrete logic for user CRUD operations.
abstract class UserService {
  /// Retrieves all users from the data source.
  Future<List<User>> getAllUsers();

  /// Retrieves a user by their unique identifier.
  /// Returns null if the user is not found.
  Future<User?> getUserById(String id);

  /// Searches for users by name or email.
  /// Returns a list of users matching the query.
  Future<List<User>> searchUsers(String query);

  /// Adds a new user to the data source.
  /// Returns the created user with a generated ID.
  Future<User> addUser(String name, String email);

  /// Updates an existing user's information.
  /// Returns the updated user.
  Future<User> updateUser(User user);

  /// Deletes a user by their unique identifier.
  /// Returns true if the deletion was successful.
  Future<bool> deleteUser(String id);

  /// Enables a user account.
  /// Returns the updated user.
  Future<User> enableUser(String id);

  /// Disables a user account.
  /// Returns the updated user.
  Future<User> disableUser(String id);
}
