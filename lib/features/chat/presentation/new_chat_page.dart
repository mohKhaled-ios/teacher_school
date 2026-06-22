// features/chat/presentation/pages/new_chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:teacher_management_app/features/chat/domin/chat_entity.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_cubit.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_message_page.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRole = 'all';

  final List<Map<String, String>> _roles = [
    {'value': 'all', 'label': 'الكل'},
    {'value': 'admin', 'label': 'أدمن'},
    {'value': 'teacher', 'label': 'مدرس'},
    {'value': 'student', 'label': 'طالب'},
    {'value': 'parent', 'label': 'ولي أمر'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatParticipant> _filterUsers(List<ChatParticipant> users) {
    return users.where((u) {
      final matchesSearch = _searchQuery.isEmpty ||
          u.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRole == 'all' || u.role == _selectedRole;
      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('محادثة جديدة'),
      ),
      body: Column(
        children: [
          // Search + Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم المستخدم...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Role Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _roles.map((role) {
                      final isSelected = _selectedRole == role['value'];
                      final color = _getRoleColor(role['value']!);
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedRole = role['value']!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withOpacity(0.2)
                                  : (isDark
                                      ? AppColors.cardDark
                                      : AppColors.cardLight),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? color : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              role['label']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? color : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const LoadingWidget(
                      message: 'جارٍ تحميل المستخدمين...');
                }

                if (state is UsersLoaded) {
                  final filtered = _filterUsers(state.users);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search,
                              size: 64, color: Theme.of(context).disabledColor),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'لا يوجد مستخدمون'
                                : 'لا توجد نتائج لـ "$_searchQuery"',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 76),
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      return _UserTile(
                        user: user,
                        isDark: isDark,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ChatCubit>(),
                                child: ChatMessagePage(
                                  receiverId: user.id,
                                  receiverName: user.name,
                                  receiverImage: user.profileImage,
                                  receiverRole: user.role,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: AppColors.errorLight),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ChatCubit>().loadUsers(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.errorLight;
      case 'teacher':
        return AppColors.primaryLight;
      case 'student':
        return AppColors.successLight;
      case 'parent':
        return AppColors.warningLight;
      default:
        return AppColors.infoLight;
    }
  }
}

// ══════════════════════════════════════════════
class _UserTile extends StatelessWidget {
  final ChatParticipant user;
  final bool isDark;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.isDark,
    required this.onTap,
  });

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.errorLight;
      case 'teacher':
        return AppColors.primaryLight;
      case 'student':
        return AppColors.successLight;
      case 'parent':
        return AppColors.warningLight;
      default:
        return AppColors.infoLight;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'أدمن';
      case 'teacher':
        return 'مدرس';
      case 'student':
        return 'طالب';
      case 'parent':
        return 'ولي أمر';
      default:
        return role;
    }
  }

  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return '';
    final now = DateTime.now();
    final diff = now.difference(lastSeen);
    if (diff.inMinutes < 1) return 'للتو';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    return 'منذ ${diff.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(user.role);
    // نتحقق من الأونلاين عبر الـ cubit
    final isOnline =
        context.read<ChatCubit>().isUserOnline(user.id) || user.isOnline;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: roleColor.withOpacity(0.2),
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: roleColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Online indicator
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: isOnline
                          ? AppColors.successLight
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.backgroundDark : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getRoleLabel(user.role),
                          style: TextStyle(
                            fontSize: 11,
                            color: roleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Online status
                      if (isOnline)
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.successLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'نشط الآن',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.successLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else if (user.lastSeen != null)
                        Text(
                          'آخر ظهور: ${_formatLastSeen(user.lastSeen)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Chat Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: roleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
