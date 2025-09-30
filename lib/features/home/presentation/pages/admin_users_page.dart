import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage>
    with AutomaticKeepAliveClientMixin {
  final List<UserDirectory> _users = [
    UserDirectory(
      id: 'user-1',
      name: 'Fatima Al Noor',
      email: 'fatima@meetly.app',
      role: 'Admin',
      isActive: true,
    ),
    UserDirectory(
      id: 'user-2',
      name: 'Jordan Blake',
      email: 'jordan@meetly.app',
      role: 'Project Manager',
      isActive: true,
    ),
    UserDirectory(
      id: 'user-3',
      name: 'Selena Maze',
      email: 'selena@meetly.app',
      role: 'Member',
      isActive: false,
    ),
  ];

  String _searchQuery = '';

  static const List<String> _roles = [
    'Admin',
    'Project Manager',
    'Member',
    'Guest',
  ];

  @override
  bool get wantKeepAlive => true;

  List<UserDirectory> get _filteredUsers {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _users;
    return _users.where((user) {
      final haystack = '${user.name.toLowerCase()} ${user.email.toLowerCase()} ${user.role.toLowerCase()}';
      return haystack.contains(query);
    }).toList();
  }

  void _showUserForm({UserDirectory? user, int? index}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    String roleValue = user?.role ?? _roles.first;

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user == null ? 'Invite User' : 'Update User',
                      style: const TextStyle(
                        color: AppTheme.brandBlack,
                        fontSize: 18,
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
                    const SizedBox(height: 16),
                    Text(
                      'Role',
                      style: TextStyle(
                        color: AppTheme.brandBlack.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: roleValue,
                      items: _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role,
                                style: const TextStyle(
                                  color: AppTheme.brandBlack,
                                  fontSize: 13,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side:
                                  const BorderSide(color: AppTheme.brandBlack),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppTheme.brandBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!(formKey.currentState?.validate() ?? false)) {
                                return;
                              }

                              final record = UserDirectory(
                                id: user?.id ??
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                role: roleValue,
                                isActive: user?.isActive ?? true,
                              );

                              setState(() {
                                if (index != null) {
                                  _users[index] = record;
                                } else {
                                  _users.add(record);
                                }
                              });

                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandBlack,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              user == null ? 'Send Invite' : 'Save Changes',
                              style: const TextStyle(
                                color: AppTheme.brandBg,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
    });
  }

  void _toggleActivation(UserDirectory user, bool value) {
    final index = _users.indexWhere((entry) => entry.id == user.id);
    if (index == -1) return;

    setState(() {
      _users[index] = _users[index].copyWith(isActive: value);
    });
  }

  void _deleteUser(UserDirectory user) {
    setState(() {
      _users.removeWhere((entry) => entry.id == user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final users = _filteredUsers;

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
            fontSize: 18,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(),
        backgroundColor: AppTheme.brandGreen,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: AppTheme.brandBlack),
        label: const Text(
          'Invite User',
          style: TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.w700,
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
                style: const TextStyle(color: AppTheme.brandBg),
                decoration: InputDecoration(
                  hintText: 'Search name, email or role',
                  hintStyle: TextStyle(
                    color: AppTheme.brandBg.withOpacity(0.55),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppTheme.brandBlack.withOpacity(0.35),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.brandBg.withOpacity(0.7),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                child: users.isEmpty
                    ? _EmptyUsersState(onInviteTap: () => _showUserForm())
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return _UserCard(
                            user: user,
                            onEdit: () {
                              final originalIndex =
                                  _users.indexWhere((element) => element.id == user.id);
                              _showUserForm(user: user, index: originalIndex);
                            },
                            onDelete: () => _deleteUser(user),
                            onToggleActivation: (value) =>
                                _toggleActivation(user, value),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: users.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDirectory {
  const UserDirectory({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;

  UserDirectory copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isActive,
  }) {
    return UserDirectory(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActivation,
  });

  final UserDirectory user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleActivation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.brandGreen.withOpacity(0.15),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              color: AppTheme.brandBlack,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Remove')),
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
                          icon: const Icon(
                            Icons.more_horiz,
                            color: AppTheme.brandBlack,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: AppTheme.brandBlack.withOpacity(0.65),
                        fontSize: 13,
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
                                size: 16,
                                color: AppTheme.brandBlack,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user.role,
                                style: const TextStyle(
                                  color: AppTheme.brandBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: user.isActive
                                    ? AppTheme.brandGreen.withOpacity(0.15)
                                    : AppTheme.brandBullet,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                user.isActive ? 'Active' : 'Suspended',
                                style: TextStyle(
                                  color: user.isActive
                                      ? AppTheme.brandGreen
                                      : AppTheme.brandBlack.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch.adaptive(
                              value: user.isActive,
                              activeColor: AppTheme.brandGreen,
                              onChanged: onToggleActivation,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
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
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

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
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppTheme.brandBullet,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _EmptyUsersState extends StatelessWidget {
  const _EmptyUsersState({required this.onInviteTap});

  final VoidCallback onInviteTap;

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
                size: 36,
                color: AppTheme.brandBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No users yet',
              style: TextStyle(
                color: AppTheme.brandBg,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Invite your teammates to collaborate and keep everyone aligned in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.brandBg.withOpacity(0.7),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onInviteTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.brandBg,
                side: const BorderSide(color: AppTheme.brandBg),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text(
                'Invite User',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
