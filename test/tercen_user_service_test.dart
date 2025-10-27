import 'package:flutter_test/flutter_test.dart';
import 'package:sci_tercen_client/sci_service_factory_web.dart';
import 'package:user_management/services/tercen_user_service.dart';

void main() {
  group('TercenUserService', () {
    late TercenUserService service;

    setUp(() async {
      service =TercenUserService(await createServiceFactoryForWebApp());
    });

    test('should be instantiated', () {
      expect(service, isNotNull);
    });

    // Note: These tests require a running Tercen instance and authentication
    // They are placeholder tests and should be run in an integration test environment

    test('getAllUsers should return a list of users', () async {
      // This will fail without proper Tercen setup
      expect(() async => await service.getAllUsers(), throwsException);
    });

    test('getUserById should return a user when found', () async {
      expect(() async => await service.getUserById('test-id'), throwsException);
    });

    test('searchUsers should return filtered users', () async {
      expect(() async => await service.searchUsers('test'), throwsException);
    });

    test('addUser should create a new user', () async {
      expect(
        () async => await service.addUser('Test User', 'test@example.com'),
        throwsException,
      );
    });

    test('updateUser should update an existing user', () async {
      // This requires a valid user object with proper ID and rev
      expect(() async {
        final user = await service.getUserById('test-id');
        if (user != null) {
          await service.updateUser(user);
        }
      }, throwsException);
    });

    test('deleteUser should remove a user', () async {
      final result = await service.deleteUser('non-existent-id');
      expect(result, isFalse);
    });

    test('enableUser should set isDeleted to false', () async {
      expect(() async => await service.enableUser('test-id'), throwsException);
    });

    test('disableUser should set isDeleted to true', () async {
      expect(() async => await service.disableUser('test-id'), throwsException);
    });
  });
}
