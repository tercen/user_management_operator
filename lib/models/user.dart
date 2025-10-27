/// Represents a user in the system.
abstract class User {
  String get id;
  String get name;
  String get email;
  bool get isEnabled;

  /// Creates a copy of this user with the given fields replaced with new values.
  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEnabled,
  });

  /// Converts the user to a JSON map.
  Map<String, dynamic> toJson();

  /// Creates a user from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) = _UserImpl.fromJson;
}

/// Default implementation of the User abstract class.
class _UserImpl implements User {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final bool isEnabled;

  _UserImpl({
    required this.id,
    required this.name,
    required this.email,
    this.isEnabled = true,
  });

  @override
  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEnabled,
  }) {
    return _UserImpl(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isEnabled': isEnabled,
    };
  }

  factory _UserImpl.fromJson(Map<String, dynamic> json) {
    return _UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }
}
