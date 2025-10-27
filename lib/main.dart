import 'package:flutter/material.dart';
import 'package:sci_tercen_client/sci_service_factory_web.dart';
import 'models/user.dart';
import 'services/user_service.dart';
import 'services/tercen_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userService = TercenUserService(await createServiceFactoryForWebApp());

  runApp(MyApp(userService: userService));
}

class MyApp extends StatelessWidget {
  final UserService userService;

  const MyApp({super.key, required this.userService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: UserManagementPage(userService: userService),
    );
  }
}

class UserManagementPage extends StatefulWidget {
  final UserService userService;

  const UserManagementPage({super.key, required this.userService});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  late final UserService _userService;
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userService = widget.userService;
    _searchController.addListener(_filterUsers);
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _userService.getAllUsers();
    setState(() {
      _filteredUsers = users;
      _isLoading = false;
    });
  }

  Future<void> _filterUsers() async {
    final query = _searchController.text;
    final users = await _userService.searchUsers(query);
    setState(() {
      _filteredUsers = users;
    });
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => _UserFormDialog(
        onSave: (name, email) async {
          await _userService.addUser(name, email);
          await _loadUsers();
        },
      ),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => _UserFormDialog(
        initialName: user.name,
        initialEmail: user.email,
        onSave: (name, email) async {
          final updatedUser = user.copyWith(name: name, email: email);
          await _userService.updateUser(updatedUser);
          await _loadUsers();
        },
      ),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _userService.deleteUser(user.id);
              await _loadUsers();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleUserStatus(User user) async {
    if (user.isEnabled) {
      await _userService.disableUser(user.id);
    } else {
      await _userService.enableUser(user.id);
    }
    await _loadUsers();
  }

  void _viewUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            const SizedBox(height: 8),
            Text('Name: ${user.name}'),
            const SizedBox(height: 8),
            Text('Email: ${user.email}'),
            const SizedBox(height: 8),
            Text('Status: ${user.isEnabled ? "Enabled" : "Disabled"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('User Management'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search users',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text(user.name[0])),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('View Details'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Text(
                                    user.isEnabled ? 'Disable' : 'Enable',
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'view':
                                    _viewUserDetails(user);
                                    break;
                                  case 'edit':
                                    _editUser(user);
                                    break;
                                  case 'toggle':
                                    _toggleUserStatus(user);
                                    break;
                                  case 'delete':
                                    _deleteUser(user);
                                    break;
                                }
                              },
                            ),
                            tileColor: user.isEnabled ? null : Colors.grey[800],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  final Future<void> Function(String name, String email) onSave;

  const _UserFormDialog({
    this.initialName,
    this.initialEmail,
    required this.onSave,
  });

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Add User' : 'Edit User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await widget.onSave(_nameController.text, _emailController.text);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
