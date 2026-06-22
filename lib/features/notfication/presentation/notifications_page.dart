// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/core/constants/app_colors.dart';
// import '../domin/notification_entity.dart';
// import 'notification_cubit.dart';
// import 'notification_state.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<NotificationCubit>().loadNotifications();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('notifications'.tr()),
//         actions: [
//           BlocBuilder<NotificationCubit, NotificationState>(
//             builder: (context, state) {
//               if (state is NotificationsLoaded && state.unreadCount > 0) {
//                 return TextButton.icon(
//                   onPressed: () =>
//                       context.read<NotificationCubit>().markAllAsRead(),
//                   icon: const Icon(Icons.done_all, size: 18),
//                   label: const Text('قراءة الكل'),
//                   style: TextButton.styleFrom(
//                     foregroundColor:
//                         isDark ? AppColors.primaryDark : AppColors.primaryLight,
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//           PopupMenuButton(
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 onTap: () => context.read<NotificationCubit>().clearAll(),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.delete_sweep, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('حذف الكل'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: BlocBuilder<NotificationCubit, NotificationState>(
//         builder: (context, state) {
//           if (state is NotificationLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is NotificationError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline,
//                       size: 64, color: AppColors.errorLight),
//                   const SizedBox(height: 16),
//                   Text(state.message),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () =>
//                         context.read<NotificationCubit>().loadNotifications(),
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state is NotificationsLoaded) {
//             if (state.notifications.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.notifications_none,
//                         size: 80, color: Theme.of(context).disabledColor),
//                     const SizedBox(height: 16),
//                     Text(
//                       'لا توجد إشعارات',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'ستظهر الإشعارات هنا عند وجودها',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () =>
//                   context.read<NotificationCubit>().loadNotifications(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: state.notifications.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (context, index) {
//                   final notification = state.notifications[index];
//                   return _NotificationTile(
//                     notification: notification,
//                     onTap: () => context
//                         .read<NotificationCubit>()
//                         .markAsRead(notification.id),
//                     onDelete: () => context
//                         .read<NotificationCubit>()
//                         .deleteNotification(notification.id),
//                   );
//                 },
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════
// class _NotificationTile extends StatelessWidget {
//   final NotificationEntity notification;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;

//   const _NotificationTile({
//     required this.notification,
//     required this.onTap,
//     required this.onDelete,
//   });

//   Color _getTypeColor(NotificationType type) {
//     switch (type) {
//       case NotificationType.attendance:
//         return AppColors.successLight;
//       case NotificationType.exam:
//         return AppColors.warningLight;
//       case NotificationType.grade:
//         return AppColors.accentLight;
//       case NotificationType.material:
//         return AppColors.infoLight;
//       case NotificationType.general:
//         return AppColors.primaryLight;
//     }
//   }

//   IconData _getTypeIcon(NotificationType type) {
//     switch (type) {
//       case NotificationType.attendance:
//         return Icons.checklist;
//       case NotificationType.exam:
//         return Icons.assignment;
//       case NotificationType.grade:
//         return Icons.grade;
//       case NotificationType.material:
//         return Icons.folder;
//       case NotificationType.general:
//         return Icons.notifications;
//     }
//   }

//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final diff = now.difference(time);
//     if (diff.inMinutes < 1) return 'الآن';
//     if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
//     if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
//     if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
//     return DateFormat('dd/MM/yyyy').format(time);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final color = _getTypeColor(notification.type);

//     return Dismissible(
//       key: Key(notification.id),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) => onDelete(),
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         color: AppColors.errorLight,
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           color: notification.isRead
//               ? Colors.transparent
//               : (isDark
//                   ? AppColors.primaryDark.withOpacity(0.05)
//                   : AppColors.primaryLight.withOpacity(0.05)),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // أيقونة النوع
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(_getTypeIcon(notification.type),
//                     color: color, size: 22),
//               ),
//               const SizedBox(width: 12),

//               // المحتوى
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             notification.title,
//                             style: TextStyle(
//                               fontWeight: notification.isRead
//                                   ? FontWeight.normal
//                                   : FontWeight.bold,
//                               fontSize: 14,
//                               color: isDark
//                                   ? AppColors.textPrimaryDark
//                                   : AppColors.textPrimaryLight,
//                             ),
//                           ),
//                         ),
//                         if (!notification.isRead)
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: color,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       notification.body,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: isDark
//                             ? AppColors.textSecondaryDark
//                             : AppColors.textSecondaryLight,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             notification.type.displayName,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: color,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           _formatTime(notification.createdAt),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: isDark
//                                 ? AppColors.textSecondaryDark
//                                 : AppColors.textSecondaryLight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///////////
///
///
// features/notfication/presentation/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/core/constants/app_colors.dart';
import '../domin/notification_entity.dart';
import 'notification_cubit.dart';
import 'notification_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadNotifications();
    });
  }

  // ── فتح dialog إضافة إشعار جديد ──
  void _showAddNotificationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<NotificationCubit>(),
        child: const _AddNotificationSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr()),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoaded && state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () =>
                      context.read<NotificationCubit>().markAllAsRead(),
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('قراءة الكل'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => context.read<NotificationCubit>().clearAll(),
                child: const Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('حذف الكل'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // ── زر إضافة إشعار ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNotificationDialog,
        icon: const Icon(Icons.add),
        label: const Text('إضافة إشعار'),
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),

      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
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
                        context.read<NotificationCubit>().loadNotifications(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none,
                        size: 80, color: Theme.of(context).disabledColor),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد إشعارات',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ستظهر الإشعارات هنا عند وجودها',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddNotificationDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('أضف إشعار الآن'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    onTap: () => context
                        .read<NotificationCubit>()
                        .markAsRead(notification.id),
                    onDelete: () => context
                        .read<NotificationCubit>()
                        .deleteNotification(notification.id),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Bottom Sheet لإضافة إشعار جديد
// ══════════════════════════════════════════════
class _AddNotificationSheet extends StatefulWidget {
  const _AddNotificationSheet();

  @override
  State<_AddNotificationSheet> createState() => _AddNotificationSheetState();
}

class _AddNotificationSheetState extends State<_AddNotificationSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  NotificationType _selectedType = NotificationType.general;
  bool _isLoading = false;

  final List<NotificationType> _types = NotificationType.values;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await context.read<NotificationCubit>().addNotification(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          type: _selectedType,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'إضافة إشعار جديد',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // العنوان
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'العنوان',
              hintText: 'أدخل عنوان الإشعار',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),

          // النص
          TextField(
            controller: _bodyController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'النص',
              hintText: 'أدخل نص الإشعار',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.message_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // نوع الإشعار
          Text('نوع الإشعار', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.map((type) {
              final isSelected = _selectedType == type;
              final color = _getTypeColor(type);
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.2)
                        : (isDark
                            ? AppColors.surfaceDark
                            : AppColors.borderLight),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getTypeIcon(type),
                          size: 14, color: isSelected ? color : null),
                      const SizedBox(width: 6),
                      Text(
                        type.displayName,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? color : null,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // زر الإرسال
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.primaryDark : AppColors.primaryLight,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_isLoading ? 'جارٍ الإرسال...' : 'إرسال الإشعار'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.attendance:
        return AppColors.successLight;
      case NotificationType.exam:
        return AppColors.warningLight;
      case NotificationType.grade:
        return AppColors.accentLight;
      case NotificationType.material:
        return AppColors.infoLight;
      case NotificationType.general:
        return AppColors.primaryLight;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.attendance:
        return Icons.checklist;
      case NotificationType.exam:
        return Icons.assignment;
      case NotificationType.grade:
        return Icons.grade;
      case NotificationType.material:
        return Icons.folder;
      case NotificationType.general:
        return Icons.notifications;
    }
  }
}

// ══════════════════════════════════════════════
// Notification Tile
// ══════════════════════════════════════════════
class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.attendance:
        return AppColors.successLight;
      case NotificationType.exam:
        return AppColors.warningLight;
      case NotificationType.grade:
        return AppColors.accentLight;
      case NotificationType.material:
        return AppColors.infoLight;
      case NotificationType.general:
        return AppColors.primaryLight;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.attendance:
        return Icons.checklist;
      case NotificationType.exam:
        return Icons.assignment;
      case NotificationType.grade:
        return Icons.grade;
      case NotificationType.material:
        return Icons.folder;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return DateFormat('dd/MM/yyyy').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getTypeColor(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.errorLight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: notification.isRead
              ? Colors.transparent
              : (isDark
                  ? AppColors.primaryDark.withOpacity(0.05)
                  : AppColors.primaryLight.withOpacity(0.05)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getTypeIcon(notification.type),
                    color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            notification.type.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.createdAt),
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
            ],
          ),
        ),
      ),
    );
  }
}
