// // features/chat/presentation/pages/chat_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:teacher_management_app/features/auth/presentation/cubit/auth_state.dart';
// import 'package:teacher_management_app/features/chat/domin/chat_entity.dart';
// import 'package:teacher_management_app/features/chat/presentation/chat_cubit.dart';
// import 'package:teacher_management_app/features/chat/presentation/chat_message_page.dart';
// import 'package:teacher_management_app/features/chat/presentation/chat_state.dart';
// import 'package:teacher_management_app/features/chat/presentation/new_chat_page.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/loading_widget.dart';

// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authState = context.read<AuthCubit>().state;
//       if (authState is AuthAuthenticated) {
//         context.read<ChatCubit>().connectSocket(authState.user.id);
//       }
//       context.read<ChatCubit>().loadChatRooms();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('المحادثات'),
//         actions: [
//           IconButton(
//             onPressed: () => context.read<ChatCubit>().loadChatRooms(),
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BlocProvider.value(
//               value: context.read<ChatCubit>(),
//               child: const NewChatPage(),
//             ),
//           ),
//         ),
//         icon: const Icon(Icons.chat),
//         label: const Text('محادثة جديدة'),
//         backgroundColor:
//             isDark ? AppColors.primaryDark : AppColors.primaryLight,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocConsumer<ChatCubit, ChatState>(
//         listener: (context, state) {
//           if (state is ChatError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorLight,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ChatLoading) {
//             return const LoadingWidget(message: 'جارٍ تحميل المحادثات...');
//           }

//           if (state is ChatRoomsLoaded) {
//             if (state.rooms.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.chat_bubble_outline,
//                         size: 80, color: Theme.of(context).disabledColor),
//                     const SizedBox(height: 16),
//                     Text('لا توجد محادثات',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                     const SizedBox(height: 8),
//                     const Text('ابدأ محادثة جديدة الآن',
//                         textAlign: TextAlign.center),
//                   ],
//                 ),
//               );
//             }

//             final authState = context.read<AuthCubit>().state;
//             final myId =
//                 authState is AuthAuthenticated ? authState.user.id : '';

//             return RefreshIndicator(
//               onRefresh: () => context.read<ChatCubit>().loadChatRooms(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.only(bottom: 80),
//                 itemCount: state.rooms.length,
//                 separatorBuilder: (_, __) =>
//                     const Divider(height: 1, indent: 76),
//                 itemBuilder: (context, index) {
//                   final room = state.rooms[index];
//                   final other = room.otherParticipant(myId);
//                   return _ChatRoomTile(
//                     room: room,
//                     other: other,
//                     myId: myId,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BlocProvider.value(
//                           value: context.read<ChatCubit>(),
//                           child: ChatMessagePage(
//                             receiverId: other!.id,
//                             receiverName: other!.name,
//                             receiverImage: other.profileImage,
//                             receiverRole: other.role,
//                           ),
//                         ),
//                       ),
//                     ),
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

// class _ChatRoomTile extends StatelessWidget {
//   final ChatRoomEntity room;
//   final ChatParticipant other;
//   final String myId;
//   final VoidCallback onTap;

//   const _ChatRoomTile({
//     required this.room,
//     required this.other,
//     required this.myId,
//     required this.onTap,
//   });

//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final diff = now.difference(time);
//     if (diff.inMinutes < 1) return 'الآن';
//     if (diff.inHours < 1) return '${diff.inMinutes}د';
//     if (diff.inDays < 1) return '${diff.inHours}س';
//     if (diff.inDays < 7) return '${diff.inDays}ي';
//     return DateFormat('dd/MM').format(time);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final lastMsg = room.lastMessage;
//     final isOnline = context.read<ChatCubit>().isUserOnline(other.id);

//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             // Avatar with online indicator
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor:
//                       isDark ? AppColors.primaryDark : AppColors.primaryLight,
//                   backgroundImage: other.profileImage != null
//                       ? NetworkImage(other.profileImage!)
//                       : null,
//                   child: other.profileImage == null
//                       ? Text(
//                           other.name.isNotEmpty
//                               ? other.name[0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       : null,
//                 ),
//                 Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     width: 14,
//                     height: 14,
//                     decoration: BoxDecoration(
//                       color: isOnline || other.isOnline
//                           ? AppColors.successLight
//                           : AppColors.textSecondaryLight,
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: isDark ? AppColors.backgroundDark : Colors.white,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 14),

//             // Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         other.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: isDark
//                               ? AppColors.textPrimaryDark
//                               : AppColors.textPrimaryLight,
//                         ),
//                       ),
//                       if (lastMsg != null)
//                         Text(
//                           _formatTime(lastMsg.createdAt),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: isDark
//                                 ? AppColors.textSecondaryDark
//                                 : AppColors.textSecondaryLight,
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       // Role badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 1),
//                         decoration: BoxDecoration(
//                           color: _getRoleColor(other.role).withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           _getRoleLabel(other.role),
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: _getRoleColor(other.role),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           lastMsg?.message ?? 'ابدأ المحادثة...',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: isDark
//                                 ? AppColors.textSecondaryDark
//                                 : AppColors.textSecondaryLight,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getRoleColor(String role) {
//     switch (role) {
//       case 'admin':
//         return AppColors.errorLight;
//       case 'teacher':
//         return AppColors.primaryLight;
//       case 'student':
//         return AppColors.successLight;
//       case 'parent':
//         return AppColors.warningLight;
//       default:
//         return AppColors.infoLight;
//     }
//   }

//   String _getRoleLabel(String role) {
//     switch (role) {
//       case 'admin':
//         return 'أدمن';
//       case 'teacher':
//         return 'مدرس';
//       case 'student':
//         return 'طالب';
//       case 'parent':
//         return 'ولي أمر';
//       default:
//         return role;
//     }
//   }
// }
// features/chat/presentation/pages/chat_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:teacher_management_app/features/chat/domin/chat_entity.dart';
// تعديل المسار
import 'package:teacher_management_app/features/chat/presentation/chat_cubit.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_message_page.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_state.dart';
import 'package:teacher_management_app/features/chat/presentation/new_chat_page.dart';
// تعديل المسار
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<ChatCubit>().connectSocket(authState.user.id);
      }
      context.read<ChatCubit>().loadChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        actions: [
          IconButton(
            onPressed: () => context.read<ChatCubit>().loadChatRooms(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<ChatCubit>(),
              child: const NewChatPage(),
            ),
          ),
        ),
        icon: const Icon(Icons.chat),
        label: const Text('محادثة جديدة'),
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingWidget(message: 'جارٍ تحميل المحادثات...');
          }

          if (state is ChatRoomsLoaded) {
            if (state.rooms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 80, color: Theme.of(context).disabledColor),
                    const SizedBox(height: 16),
                    Text('لا توجد محادثات',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('ابدأ محادثة جديدة الآن',
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            final authState = context.read<AuthCubit>().state;
            final myId =
                authState is AuthAuthenticated ? authState.user.id : '';

            return RefreshIndicator(
              onRefresh: () => context.read<ChatCubit>().loadChatRooms(),
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.rooms.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 76),
                itemBuilder: (context, index) {
                  final room = state.rooms[index];
                  final other = room.otherParticipant(myId);

                  // التحقق من وجود other قبل استخدامه
                  if (other == null) {
                    return const SizedBox.shrink();
                  }

                  return _ChatRoomTile(
                    room: room,
                    other: other,
                    myId: myId,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ChatCubit>(),
                          child: ChatMessagePage(
                            receiverId: other.id,
                            receiverName: other.name,
                            receiverImage: other.profileImage,
                            receiverRole: other.role,
                          ),
                        ),
                      ),
                    ),
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

class _ChatRoomTile extends StatelessWidget {
  final ChatRoomEntity room;
  final ChatParticipant other;
  final String myId;
  final VoidCallback onTap;

  const _ChatRoomTile({
    required this.room,
    required this.other,
    required this.myId,
    required this.onTap,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return '${diff.inMinutes}د';
    if (diff.inDays < 1) return '${diff.inHours}س';
    if (diff.inDays < 7) return '${diff.inDays}ي';
    return DateFormat('dd/MM').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lastMsg = room.lastMessage;
    final isOnline = context.read<ChatCubit>().isUserOnline(other.id);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  backgroundImage: other.profileImage != null
                      ? NetworkImage(other.profileImage!)
                      : null,
                  child: other.profileImage == null
                      ? Text(
                          other.name.isNotEmpty
                              ? other.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isOnline || other.isOnline
                          ? AppColors.successLight
                          : AppColors.textSecondaryLight,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        other.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (lastMsg != null)
                        Text(
                          _formatTime(lastMsg.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _getRoleColor(other.role).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getRoleLabel(other.role),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getRoleColor(other.role),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lastMsg?.message ?? 'ابدأ المحادثة...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
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
}
