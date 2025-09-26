import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart' as auth_provider;
import '../widgets/role_badge.dart';
import '../widgets/role_selector.dart';
import '../../../../shared/utils/notification_helper.dart';
import '../../../../shared/utils/loading_overlay.dart';
import '../../data/datasources/firestore_data_source.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  final FirestoreDataSource _firestoreDataSource = FirestoreDataSourceImpl();
  List<UserEntity> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _firestoreDataSource.getAllUsers();
      if (!mounted) return;
      setState(() {
        _users = users.map((u) => u.toEntity()).toList();
      });
    } catch (e) {
      if (mounted) {
        NotificationHelper.showError(context, 'Failed to load users: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createUser() async {
    await _showCreateUserDialog();
  }

  Future<void> _showCreateUserDialog() async {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    UserRole selectedRole = UserRole.softwareEngineer;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New User'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                RoleSelector(
                  selectedRole: selectedRole,
                  onChanged: (role) {
                    if (role != null) {
                      selectedRole = role;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                await _performCreateUser(
                  emailController.text.trim(),
                  passwordController.text,
                  fullNameController.text.trim(),
                  selectedRole,
                );
              }
            },
            child: const Text('Create User'),
          ),
        ],
      ),
    );
  }

  Future<void> _performCreateUser(String email, String password, String fullName, UserRole role) async {
    try {
      LoadingOverlay.show(context, message: 'Creating user...');
      
      final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);
      await authProvider.registerWithEmailAndPassword(
        email,
        password,
        fullName,
        role: role,
      );
      
      LoadingOverlay.hide();
      
      if (mounted) {
        NotificationHelper.showSuccess(context, 'User created successfully!');
        // No need to manually reload if using stream; still refresh once for safety
        _loadUsers();
      }
    } catch (e) {
      LoadingOverlay.hide();
      if (mounted) {
        NotificationHelper.showError(context, 'Failed to create user: $e');
      }
    }
  }

  

  Future<void> _deleteUser(String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        LoadingOverlay.show(context, message: 'Deleting user...');
        
        await _firestoreDataSource.deleteUser(userId);
        
        LoadingOverlay.hide();
        
        if (mounted) {
          NotificationHelper.showSuccess(context, 'User deleted successfully!');
          _loadUsers();
        }
      } catch (e) {
        LoadingOverlay.hide();
        if (mounted) {
          NotificationHelper.showError(context, 'Failed to delete user: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'User Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _createUser,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 4),
                      Text('Add'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              StreamBuilder<List<dynamic>>( // dynamic to avoid import cycle with model
                stream: _firestoreDataSource.getAllUsersStream(),
                builder: (context, snapshot) {
                  final users = snapshot.data?.map((u) => (u as dynamic).toEntity() as UserEntity).toList() ?? _users;
                  if (snapshot.connectionState == ConnectionState.waiting && users.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: users.map((user) {
                        return DataRow(cells: [
                          DataCell(Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                                child: Text((user.fullName ?? user.email).isNotEmpty ? (user.fullName ?? user.email)[0].toUpperCase() : 'U'),
                              ),
                              const SizedBox(width: 8),
                              Text(user.fullName ?? 'No Name'),
                            ],
                          )),
                          DataCell(RoleBadge(role: user.role, fontSize: 12, showIcon: true)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                tooltip: 'View & Edit',
                                onPressed: () => _showViewAndEditDialog(user),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete User',
                                onPressed: () => _deleteUser(user.id),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showViewAndEditDialog(UserEntity user) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.fullName ?? '');
    final emailController = TextEditingController(text: user.email);
    UserRole selectedRole = user.role;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                RoleSelector(
                  selectedRole: selectedRole,
                  onChanged: (role) {
                    if (role != null) selectedRole = role;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                LoadingOverlay.show(context, message: 'Saving...');
                await _firestoreDataSource.updateUser(user.id, {
                  'fullName': nameController.text.trim(),
                  'role': selectedRole.name,
                });
              } catch (e) {
                if (mounted) {
                  NotificationHelper.showError(context, 'Failed to save: $e');
                }
              } finally {
                LoadingOverlay.hide();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}