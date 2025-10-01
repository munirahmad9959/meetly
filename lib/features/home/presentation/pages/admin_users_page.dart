import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetly/shared/theme/app_theme.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/users_provider.dart';
import '../../../../shared/utils/notification_helper.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage>
    with AutomaticKeepAliveClientMixin {
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load users on init - will be called after first frame when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UsersProvider>().loadUsers();
      }
    });
  }

  List<UserEntity> _filterUsers(List<UserEntity> users) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      final haystack =
          '${user.fullName?.toLowerCase() ?? ''} ${user.email.toLowerCase()} ${_getRoleDisplayName(user.role).toLowerCase()}';
      return haystack.contains(query);
    }).toList();
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.softwareEngineer:
        return 'Software Engineer';
      case UserRole.hr:
        return 'HR';
      case UserRole.salesEngineer:
        return 'Sales Engineer';
      case UserRole.manager:
        return 'Manager';
    }
  }

  void _showUserForm({UserEntity? user}) {
    // Capture the provider before opening the modal
    final usersProvider = context.read<UsersProvider>();
    
    final formKey = GlobalKey<FormState>(
      debugLabel: 'userForm_${DateTime.now().millisecondsSinceEpoch}',
    );
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final passwordController = TextEditingController();
    UserRole roleValue = user?.role ?? UserRole.softwareEngineer;
    bool obscurePassword = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.brandBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null ? 'Add New User' : 'Update User',
                        style: const TextStyle(
                          color: AppTheme.brandBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _UserTextField(
                        controller: nameController,
                        label: 'Full Name',
                        hintText: 'E.g. Aisha Khan',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _UserTextField(
                        controller: emailController,
                        label: 'Email Address',
                        hintText: 'name@company.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: user == null,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          const emailPattern =
                              r'^([a-zA-Z0-9_.+-]+)@([a-zA-Z0-9-]+)\.([a-zA-Z0-9-.]+)$';
                          if (email.isEmpty) {
                            return 'Email is required';
                          }
                          final regExp = RegExp(emailPattern);
                          if (!regExp.hasMatch(email)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      if (user == null) ...[
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: const TextStyle(
                                color: AppTheme.brandBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 12),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter password (min 6 characters)',
                                hintStyle: const TextStyle(fontSize: 12),
                                filled: true,
                                fillColor: AppTheme.brandBullet,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                    color: AppTheme.brandBlack.withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    setModalState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        'Role',
                        style: TextStyle(
                          color: AppTheme.brandBlack.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<UserRole>(
                        value: roleValue,
                        items: UserRole.values
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(
                                  _getRoleDisplayName(role),
                                  style: const TextStyle(
                                    color: AppTheme.brandBlack,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() => roleValue = value);
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        borderRadius: BorderRadius.circular(16),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.brandBullet,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                  color: AppTheme.brandBlack,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppTheme.brandBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!(formKey.currentState?.validate() ?? false)) {
                                  return;
                                }

                                try {
                                  if (user == null) {
                                    await usersProvider.createUser(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      fullName: nameController.text.trim(),
                                      role: roleValue,
                                    );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      NotificationHelper.showSuccess(
                                        context,
                                        'User created successfully',
                                      );
                                    }
                                  } else {
                                    await usersProvider.updateUser(
                                      userId: user.id,
                                      fullName: nameController.text.trim(),
                                      role: roleValue,
                                    );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      NotificationHelper.showSuccess(
                                        context,
                                        'User updated successfully',
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    NotificationHelper.showError(
                                      context,
                                      e.toString().replaceAll('Exception: ', ''),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.brandBlack,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                user == null ? 'Add User' : 'Save Changes',
                                style: const TextStyle(
                                  color: AppTheme.brandBg,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        nameController.dispose();
        emailController.dispose();
        passwordController.dispose();
      });
    });
  }

  void _deleteUser(UserEntity user) {
    // Capture the provider before opening the dialog
    final usersProvider = context.read<UsersProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete User',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete ${user.fullName ?? user.email}? This action cannot be undone.',
          style: const TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 12),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await usersProvider.deleteUser(user.id);
                if (context.mounted) {
                  NotificationHelper.showSuccess(
                    context,
                    'User deleted successfully',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  NotificationHelper.showError(
                    context,
                    e.toString().replaceAll('Exception: ', ''),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<UsersProvider>(
      builder: (context, usersProvider, _) {
        final users = _filterUsers(usersProvider.users);
        final isLoading = usersProvider.isLoading;

        return Scaffold(
            backgroundColor: AppTheme.brandBlack,
            appBar: AppBar(
              backgroundColor: AppTheme.brandBlack,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                'Users',
                style: TextStyle(
                  color: AppTheme.brandBg,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'addUserFAB',
              onPressed: () => _showUserForm(),
              backgroundColor: AppTheme.brandGreen,
              icon: const Icon(
                Icons.person_add_alt_1_rounded,
                color: AppTheme.brandBlack,
              ),
              label: const Text(
                'Add User',
                style: TextStyle(
                  color: AppTheme.brandBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    color: AppTheme.brandBlack,
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: const TextStyle(
                        color: AppTheme.brandBg,
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search name, email or role',
                        hintStyle: TextStyle(
                          color: AppTheme.brandBg.withOpacity(0.55),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppTheme.brandBlack.withOpacity(0.35),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppTheme.brandBg.withOpacity(0.7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: AppTheme.brandBlack,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.brandGreen,
                              ),
                            )
                          : users.isEmpty
                              ? _EmptyUsersState(onAddTap: () => _showUserForm())
                              : RefreshIndicator(
                                  onRefresh: () => context.read<UsersProvider>().loadUsers(),
                                  color: AppTheme.brandGreen,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return _UserCard(
                                        user: user,
                                        roleDisplayName: _getRoleDisplayName(user.role),
                                        onEdit: () => _showUserForm(user: user),
                                        onDelete: () => _deleteUser(user),
                                      );
                                    },
                                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                                    itemCount: users.length,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.roleDisplayName,
    required this.onEdit,
    required this.onDelete,
  });

  final UserEntity user;
  final String roleDisplayName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.brandGreen.withOpacity(0.15),
                child: Text(
                  (user.fullName?.isNotEmpty ?? false)
                      ? user.fullName![0].toUpperCase()
                      : user.email[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  user.fullName ?? user.email,
                  style: const TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit', style: TextStyle(fontSize: 12)),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove', style: TextStyle(fontSize: 12)),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(Icons.more_horiz, color: AppTheme.brandBlack),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              color: AppTheme.brandBlack.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.brandBullet,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 14,
                      color: AppTheme.brandBlack,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      roleDisplayName,
                      style: const TextStyle(
                        color: AppTheme.brandBlack,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: user.emailVerified
                      ? AppTheme.brandGreen.withOpacity(0.15)
                      : Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  user.emailVerified ? 'Verified' : 'Pending',
                  style: TextStyle(
                    color: user.emailVerified ? AppTheme.brandGreen : Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserTextField extends StatelessWidget {
  const _UserTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: enabled ? AppTheme.brandBullet : AppTheme.brandBullet.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyUsersState extends StatelessWidget {
  const _EmptyUsersState({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppTheme.brandBg,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppTheme.cardShadow,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.group_add_rounded,
                size: 32,
                color: AppTheme.brandBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No users yet',
              style: TextStyle(
                color: AppTheme.brandBg,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first user to get started with user management.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.brandBg.withOpacity(0.7),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onAddTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.brandBg,
                side: const BorderSide(color: AppTheme.brandBg),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(
                Icons.person_add_alt_1_rounded,
                size: 16,
              ),
              label: const Text(
                'Add User',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
