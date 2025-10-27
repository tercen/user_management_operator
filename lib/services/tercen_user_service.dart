import 'package:sci_tercen_client/sci_client.dart' as tercen_model;
import 'package:sci_tercen_client/sci_client_service_factory.dart';
import 'package:sci_tercen_client/sci_client.dart' as sci;
import 'package:sci_tercen_client/sci_client_service_factory.dart' as tercen;

import '../models/user.dart';
import 'user_service.dart' as local;

// Conditional import for platform-specific HTTP client
import 'package:sci_http_client/http_browser_client.dart'
    if (dart.library.io) 'package:sci_http_client/http_io_client.dart';

/// Tercen client implementation of UserService.
/// This implementation uses the tercen client library to manage users.
class TercenUserService implements local.UserService {
  final ServiceFactory _factory;

  TercenUserService(this._factory);

  UserService get _userService => _factory.userService;

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final tercenUsers = await _userService.findUserByCreatedDateAndName(
        startKey: ['', ''],
        endKey: ["\uffff", "\uffff"],
        limit: 10000,
        descending: false,
      );
      return tercenUsers.map(_tercenUserToUser).toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      final tercenUser = await _userService.get(id);
      return _tercenUserToUser(tercenUser);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    if (query.isEmpty) {
      return getAllUsers();
    }

    try {
      final lowerQuery = query.toLowerCase();
      final results = <User>[];

      // Search by email
      try {
        final emailResults = await _userService.findUserByEmail(
          keys: [lowerQuery],
        );
        results.addAll(emailResults.map(_tercenUserToUser));
      } catch (e) {
        // Email search might fail if no exact match
      }

      // Search by name using the date/name index
      try {
        final nameResults = await _userService.findUserByCreatedDateAndName(
          startKey: [null, lowerQuery],
          endKey: [null, '$lowerQuery\uffff'],
          limit: 100,
        );

        // Combine results and remove duplicates
        for (final user in nameResults.map(_tercenUserToUser)) {
          if (!results.any((u) => u.id == user.id)) {
            results.add(user);
          }
        }
      } catch (e) {
        // Name search might fail
      }

      // If no results from index searches, fallback to getting all and filtering
      if (results.isEmpty) {
        final allUsers = await getAllUsers();
        return allUsers
            .where(
              (user) =>
                  user.name.toLowerCase().contains(lowerQuery) ||
                  user.email.toLowerCase().contains(lowerQuery),
            )
            .toList();
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<User> addUser(String name, String email) async {
    throw UnimplementedError('addUser not implemented yet');
  }

  @override
  Future<User> updateUser(User user) async {
    throw UnimplementedError('updateUser not implemented yet');
  }

  @override
  Future<bool> deleteUser(String id) async {
    throw UnimplementedError('deleteUser not implemented yet');
  }

  @override
  Future<User> enableUser(String id) async {
    throw UnimplementedError('enableUser not implemented yet');
  }

  @override
  Future<User> disableUser(String id) async {
    throw UnimplementedError('disableUser not implemented yet');
  }

  /// Converts a Tercen User model to our User model.
  User _tercenUserToUser(tercen_model.User tercenUser) {
    return User.fromJson({
      'id': tercenUser.id,
      'name': tercenUser.name,
      'email': tercenUser.email,
      'isEnabled': !tercenUser.isDeleted,
    });
  }
}
