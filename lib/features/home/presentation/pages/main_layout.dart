// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/core/constants/app_colors.dart';
// import 'package:teacher_management_app/features/attendance/presentation/cubit/attendance_cubit.dart';
// import 'package:teacher_management_app/features/auth/presentation/cubit/auth_state.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
// import 'package:teacher_management_app/features/exams/presentation/pages/exams_page.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
// import 'package:teacher_management_app/features/materials/presentation/cubit/material_cubit.dart';
// import 'package:teacher_management_app/features/materials/presentation/pages/materials_page.dart';
// import 'package:teacher_management_app/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:teacher_management_app/features/notfication/presentation/notification_cubit.dart';
// import '../../../../core/di/injection_container.dart' as di;
// import '../../../attendance/presentation/pages/attendance_page.dart';
// import 'home_page.dart';

// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int _currentIndex = 0;

//   final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
//     0: GlobalKey<NavigatorState>(),
//     1: GlobalKey<NavigatorState>(),
//     2: GlobalKey<NavigatorState>(),
//     3: GlobalKey<NavigatorState>(),
//     4: GlobalKey<NavigatorState>(),
//   };

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return MultiBlocProvider(
//       providers: [
//         // توفير MaterialCubit في مستوى أعلى
//         BlocProvider<MaterialCubit>(
//           create: (context) => di.sl<MaterialCubit>(),
//         ),
//         // توفير AttendanceCubit في مستوى أعلى
//         BlocProvider<AttendanceCubit>(
//           create: (context) => di.sl<AttendanceCubit>(),
//         ),
//         BlocProvider<ExamCubit>(
//           create: (context) => di.sl<ExamCubit>(),
//         ),
//         BlocProvider<GradeCubit>(
//           create: (context) => di.sl<GradeCubit>(),
//         ),
//         BlocProvider<NotificationCubit>(
//           create: (context) => di.sl<NotificationCubit>(),
//         ),
//       ],
//       child: WillPopScope(
//         onWillPop: _onWillPop,
//         child: Scaffold(
//           body: IndexedStack(
//             index: _currentIndex,
//             children: List.generate(5, (index) => _buildPage(index)),
//           ),
//           bottomNavigationBar: Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
//                   blurRadius: 10,
//                   offset: const Offset(0, -3),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               child: BottomNavigationBar(
//                 currentIndex: _currentIndex,
//                 onTap: (index) {
//                   if (_currentIndex == index) {
//                     final navigator = _navigatorKeys[index];
//                     if (navigator?.currentState?.canPop() == true) {
//                       navigator!.currentState!
//                           .popUntil((route) => route.isFirst);
//                     }
//                   } else {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   }
//                 },
//                 type: BottomNavigationBarType.fixed,
//                 backgroundColor:
//                     isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//                 selectedItemColor:
//                     isDark ? AppColors.primaryDark : AppColors.primaryLight,
//                 unselectedItemColor: isDark
//                     ? AppColors.textSecondaryDark
//                     : AppColors.textSecondaryLight,
//                 selectedFontSize: 12,
//                 unselectedFontSize: 12,
//                 showUnselectedLabels: true,
//                 elevation: 0,
//                 items: [
//                   BottomNavigationBarItem(
//                     icon: const Icon(Icons.home_outlined),
//                     activeIcon: const Icon(Icons.home),
//                     label: 'home'.tr(),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: const Icon(Icons.checklist_outlined),
//                     activeIcon: const Icon(Icons.checklist),
//                     label: 'attendance'.tr(),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: const Icon(Icons.folder_outlined),
//                     activeIcon: const Icon(Icons.folder),
//                     label: 'materials'.tr(),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: const Icon(Icons.assignment_outlined),
//                     activeIcon: const Icon(Icons.assignment),
//                     label: 'exams'.tr(),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: const Icon(Icons.person_outline),
//                     activeIcon: const Icon(Icons.person),
//                     label: 'profile'.tr(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPage(int index) {
//     switch (index) {
//       case 0:
//         return Navigator(
//           key: _navigatorKeys[0],
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (_) => const HomePage(),
//             );
//           },
//         );

//       case 1:
//         return Navigator(
//           key: _navigatorKeys[1],
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (_) => const AttendancePage(),
//             );
//           },
//         );

//       case 2:
//         return Navigator(
//           key: _navigatorKeys[2],
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (_) => const MaterialsPage(),
//             );
//           },
//         );

//       case 3:
//         return Navigator(
//           key: _navigatorKeys[3],
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (_) => const ExamsPage(),
//             );
//           },
//         );

//       case 4:
//         return Navigator(
//           key: _navigatorKeys[4],
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (_) => const ProfilePage(),
//             );
//           },
//         );

//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Future<bool> _onWillPop() async {
//     final currentNavigator = _navigatorKeys[_currentIndex];

//     if (currentNavigator?.currentState?.canPop() == true) {
//       currentNavigator!.currentState!.pop();
//       return false;
//     }

//     if (_currentIndex != 0) {
//       setState(() {
//         _currentIndex = 0;
//       });
//       return false;
//     }

//     return true;
//   }
// }

// // ================= Placeholders =================

// class ExamsPlaceholder extends StatelessWidget {
//   const ExamsPlaceholder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('exams'.tr()),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.assignment, size: 80, color: Colors.orange),
//             const SizedBox(height: 16),
//             Text(
//               'Exams Page - Coming Soon',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // صفحة الملف الشخصي
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         final user = state is AuthAuthenticated ? state.user : null;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text('profile'.tr()),
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Profile Header
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // Profile Image
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Theme.of(context).primaryColor,
//                         child: user?.profileImage != null
//                             ? ClipOval(
//                                 child: Image.network(
//                                   user!.profileImage!,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.white,
//                               ),
//                       ),
//                       const SizedBox(height: 16),

//                       // User Name
//                       Text(
//                         user?.name ?? 'Teacher',
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       const SizedBox(height: 8),

//                       // User Email
//                       Text(
//                         user?.email ?? 'email@example.com',
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                       const SizedBox(height: 4),

//                       // User Role
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color:
//                               Theme.of(context).primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           user?.role ?? 'teacher',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Profile Information
//                 _buildProfileCard(
//                   context,
//                   title: 'personal_info'.tr(),
//                   children: [
//                     _buildInfoItem(
//                       context,
//                       icon: Icons.person,
//                       label: 'name'.tr(),
//                       value: user?.name ?? 'Not Available',
//                     ),
//                     _buildInfoItem(
//                       context,
//                       icon: Icons.email,
//                       label: 'email'.tr(),
//                       value: user?.email ?? 'Not Available',
//                     ),
//                     _buildInfoItem(
//                       context,
//                       icon: Icons.phone,
//                       label: 'phone'.tr(),
//                       value: user?.phone ?? 'Not Available',
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // Actions
//                 _buildProfileCard(
//                   context,
//                   title: 'actions'.tr(),
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.settings),
//                       title: Text('settings'.tr()),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         // Navigate to settings
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.lock),
//                       title: Text('change_password'.tr()),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         // Navigate to change password
//                       },
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.logout, color: AppColors.errorLight),
//                       title: Text(
//                         'logout'.tr(),
//                         style: TextStyle(color: AppColors.errorLight),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios,
//                         size: 16,
//                         color: AppColors.errorLight,
//                       ),
//                       onTap: () {
//                         _showLogoutDialog(context);
//                       },
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Logout Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () => _showLogoutDialog(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.errorLight,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     icon: const Icon(Icons.logout),
//                     label: Text(
//                       'logout'.tr(),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildProfileCard(
//     BuildContext context, {
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 12),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoItem(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Theme.of(context).primaryColor,
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: Theme.of(context).hintColor,
//                       ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('confirm_logout'.tr()),
//         content: Text('are_you_sure_logout'.tr()),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('cancel'.tr()),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<AuthCubit>().logout();
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: AppColors.errorLight,
//             ),
//             child: Text('logout'.tr()),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/core/constants/app_colors.dart';
import 'package:teacher_management_app/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
import 'package:teacher_management_app/features/exams/presentation/pages/exams_page.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
import 'package:teacher_management_app/features/materials/presentation/cubit/material_cubit.dart';
import 'package:teacher_management_app/features/materials/presentation/pages/materials_page.dart';
import 'package:teacher_management_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teacher_management_app/features/notfication/presentation/notification_cubit.dart';
// ✅ Chat imports
import 'package:teacher_management_app/features/chat/presentation/chat_cubit.dart';
import 'package:teacher_management_app/features/chat/presentation/chat_list_page.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../attendance/presentation/pages/attendance_page.dart';
import 'home_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<MaterialCubit>(
          create: (_) => di.sl<MaterialCubit>(),
        ),
        BlocProvider<AttendanceCubit>(
          create: (_) => di.sl<AttendanceCubit>(),
        ),
        BlocProvider<ExamCubit>(
          create: (_) => di.sl<ExamCubit>(),
        ),
        BlocProvider<GradeCubit>(
          create: (_) => di.sl<GradeCubit>(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => di.sl<NotificationCubit>(),
        ),
        // ✅ ChatCubit
        BlocProvider<ChatCubit>(
          create: (_) => di.sl<ChatCubit>(),
        ),
      ],
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: List.generate(5, (index) => _buildPage(index)),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (_currentIndex == index) {
                    final navigator = _navigatorKeys[index];
                    if (navigator?.currentState?.canPop() == true) {
                      navigator!.currentState!
                          .popUntil((route) => route.isFirst);
                    }
                  } else {
                    setState(() => _currentIndex = index);
                  }
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                selectedItemColor:
                    isDark ? AppColors.primaryDark : AppColors.primaryLight,
                unselectedItemColor: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                showUnselectedLabels: true,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: const Icon(Icons.home),
                    label: 'home'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.checklist_outlined),
                    activeIcon: const Icon(Icons.checklist),
                    label: 'attendance'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.folder_outlined),
                    activeIcon: const Icon(Icons.folder),
                    label: 'materials'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.assignment_outlined),
                    activeIcon: const Icon(Icons.assignment),
                    label: 'exams'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person_outline),
                    activeIcon: const Icon(Icons.person),
                    label: 'profile'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Navigator(
          key: _navigatorKeys[0],
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      case 1:
        return Navigator(
          key: _navigatorKeys[1],
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const AttendancePage(),
          ),
        );
      case 2:
        return Navigator(
          key: _navigatorKeys[2],
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const MaterialsPage(),
          ),
        );
      case 3:
        return Navigator(
          key: _navigatorKeys[3],
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const ExamsPage(),
          ),
        );
      case 4:
        return Navigator(
          key: _navigatorKeys[4],
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<bool> _onWillPop() async {
    final currentNavigator = _navigatorKeys[_currentIndex];
    if (currentNavigator?.currentState?.canPop() == true) {
      currentNavigator!.currentState!.pop();
      return false;
    }
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }
    return true;
  }
}

// ═══════════════════════════════════════════════════
// Profile Page
// ═══════════════════════════════════════════════════
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: Text('profile'.tr()),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Profile Header ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: user?.profileImage != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.profileImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Teacher',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.email ?? 'email@example.com',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user?.role ?? 'teacher',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ قسم الروابط السريعة - يحتوي على زر الـ Chat
                _buildProfileCard(
                  context,
                  title: 'روابط سريعة',
                  children: [
                    // ✅ زر المحادثات
                    _buildNavItem(
                      context,
                      icon: Icons.chat_bubble_outline,
                      iconColor: AppColors.primaryLight,
                      title: 'المحادثات',
                      subtitle: 'تواصل مع الطلاب والإدارة',
                      onTap: () {
                        final chatCubit = context.read<ChatCubit>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: chatCubit,
                              child: const ChatListPage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Personal Info ──
                _buildProfileCard(
                  context,
                  title: 'personal_info'.tr(),
                  children: [
                    _buildInfoItem(
                      context,
                      icon: Icons.person,
                      label: 'name'.tr(),
                      value: user?.name ?? 'Not Available',
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.email,
                      label: 'email'.tr(),
                      value: user?.email ?? 'Not Available',
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.phone,
                      label: 'phone'.tr(),
                      value: user?.phone ?? 'Not Available',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Actions ──
                _buildProfileCard(
                  context,
                  title: 'actions'.tr(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text('settings'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text('change_password'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColors.errorLight,
                      ),
                      title: Text(
                        'logout'.tr(),
                        style: const TextStyle(color: AppColors.errorLight),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.errorLight,
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Logout Button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'logout'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  // ✅ Navigation item مع أيقونة وعنوان فرعي وسهم
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm_logout'.tr()),
        content: Text('are_you_sure_logout'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorLight,
            ),
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }
}
