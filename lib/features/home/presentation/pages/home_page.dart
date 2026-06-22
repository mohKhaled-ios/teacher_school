// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/grades/presentation/grades_page.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../../auth/presentation/cubit/auth_cubit.dart';
// import '../../../auth/presentation/cubit/auth_state.dart';
// import '../cubit/home_cubit.dart';
// import '../cubit/home_state.dart';
// import '../widgets/dashboard_card.dart';
// import '../widgets/quick_action_card.dart';
// import '../widgets/recent_activity_item.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeCubit>().loadDashboard();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => context.read<HomeCubit>().refresh(),
//           color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
//           child: CustomScrollView(
//             slivers: [
//               // App Bar with Profile
//               SliverToBoxAdapter(
//                 child: _buildHeader(context),
//               ),

//               // Dashboard Stats
//               SliverToBoxAdapter(
//                 child: BlocBuilder<HomeCubit, HomeState>(
//                   builder: (context, state) {
//                     if (state is HomeLoading) {
//                       return const SizedBox(
//                         height: 300,
//                         child: LoadingWidget(message: 'جارٍ التحميل...'),
//                       );
//                     } else if (state is HomeLoaded) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildStatsSection(context, state),
//                           const SizedBox(height: 24),
//                           _buildQuickActions(context),
//                           const SizedBox(height: 24),
//                           _buildRecentActivities(context, state),
//                           const SizedBox(height: 24),
//                         ],
//                       );
//                     } else if (state is HomeError) {
//                       return SizedBox(
//                         height: 300,
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.error_outline,
//                                 size: 64,
//                                 color: AppColors.errorLight,
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 state.message,
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               ),
//                               const SizedBox(height: 16),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   context.read<HomeCubit>().loadDashboard();
//                                 },
//                                 child: Text('try_again'.tr()),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         final user = state is AuthAuthenticated ? state.user : null;

//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: isDark
//                 ? AppColors.primaryGradientDark
//                 : AppColors.primaryGradientLight,
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'welcome'.tr(),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         user?.name ?? 'Teacher',
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           // Navigate to notifications
//                         },
//                         icon: const Icon(
//                           Icons.notifications_outlined,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       CircleAvatar(
//                         radius: 24,
//                         backgroundColor: Colors.white,
//                         child: user?.profileImage != null
//                             ? ClipOval(
//                                 child: Image.network(
//                                   user!.profileImage!,
//                                   width: 48,
//                                   height: 48,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : Icon(
//                                 Icons.person,
//                                 color: isDark
//                                     ? AppColors.primaryDark
//                                     : AppColors.primaryLight,
//                               ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 DateFormat('EEEE, dd MMMM yyyy', 'ar').format(DateTime.now()),
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatsSection(BuildContext context, HomeLoaded state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'لوحة التحكم',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: DashboardCard(
//                   title: 'الصفوف',
//                   value: state.stats.totalClasses.toString(),
//                   icon: Icons.class_outlined,
//                   color: AppColors.primaryLight,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: DashboardCard(
//                   title: 'الطلاب',
//                   value: state.stats.totalStudents.toString(),
//                   icon: Icons.people_outline,
//                   color: AppColors.secondaryLight,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: DashboardCard(
//                   title: 'المواد',
//                   value: state.stats.totalSubjects.toString(),
//                   icon: Icons.book_outlined,
//                   color: AppColors.infoLight,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: DashboardCard(
//                   title: 'نسبة الحضور',
//                   value: '${state.stats.attendanceRate.toStringAsFixed(1)}%',
//                   icon: Icons.trending_up,
//                   color: AppColors.successLight,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'إجراءات سريعة',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: QuickActionCard(
//                   title: 'تسجيل الحضور',
//                   icon: Icons.checklist,
//                   color: AppColors.successLight,
//                   onTap: () {
//                     // Navigate to attendance
//                   },
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: QuickActionCard(
//                   title: 'رفع مواد',
//                   icon: Icons.upload_file,
//                   color: AppColors.infoLight,
//                   onTap: () {
//                     // Navigate to materials
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: QuickActionCard(
//                   title: 'إنشاء امتحان',
//                   icon: Icons.assignment_add,
//                   color: AppColors.warningLight,
//                   onTap: () {
//                     // Navigate to exams
//                   },
//                 ),
//               ),
//               const SizedBox(width: 12),
//               InkWell(
//                 onTap: () {
//                   ////////
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => GradesPage(),
//                     ),
//                   );
//                 },
//                 child: Expanded(
//                   child: QuickActionCard(
//                     title: 'إضافة درجات',
//                     icon: Icons.grade,
//                     color: AppColors.accentLight,
//                     onTap: () {
//                       // Navigate to grades
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivities(BuildContext context, HomeLoaded state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'النشاطات الأخيرة',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Show all activities
//                 },
//                 child: Text('عرض الكل'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...state.stats.recentActivities
//               .map((activity) => RecentActivityItem(activity: activity))
//               .toList(),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/grades/presentation/grades_page.dart';
import 'package:teacher_management_app/features/notfication/presentation/notifications_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_activity_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().refresh(),
          color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          child: CustomScrollView(
            slivers: [
              // App Bar with Profile
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),

              // Dashboard Stats
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const SizedBox(
                        height: 300,
                        child: LoadingWidget(message: 'جارٍ التحميل...'),
                      );
                    } else if (state is HomeLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsSection(context, state),
                          const SizedBox(height: 24),
                          _buildQuickActions(context),
                          const SizedBox(height: 24),
                          _buildRecentActivities(context, state),
                          const SizedBox(height: 24),
                        ],
                      );
                    } else if (state is HomeError) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: AppColors.errorLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeCubit>().loadDashboard();
                                },
                                child: Text('try_again'.tr()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.primaryGradientDark
                : AppColors.primaryGradientLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'Teacher',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigate to notifications
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NotificationsPage();
                          }));
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: user?.profileImage != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.profileImage!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                DateFormat('EEEE, dd MMMM yyyy', 'ar').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, HomeLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لوحة التحكم',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'الصفوف',
                  value: state.stats.totalClasses.toString(),
                  icon: Icons.class_outlined,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardCard(
                  title: 'الطلاب',
                  value: state.stats.totalStudents.toString(),
                  icon: Icons.people_outline,
                  color: AppColors.secondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'المواد',
                  value: state.stats.totalSubjects.toString(),
                  icon: Icons.book_outlined,
                  color: AppColors.infoLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardCard(
                  title: 'نسبة الحضور',
                  value: '${state.stats.attendanceRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: AppColors.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'تسجيل الحضور',
                  icon: Icons.checklist,
                  color: AppColors.successLight,
                  onTap: () {
                    // Navigate to attendance
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  title: 'رفع مواد',
                  icon: Icons.upload_file,
                  color: AppColors.infoLight,
                  onTap: () {
                    // Navigate to materials
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'إنشاء امتحان',
                  icon: Icons.assignment_add,
                  color: AppColors.warningLight,
                  onTap: () {
                    // Navigate to exams
                  },
                ),
              ),
              const SizedBox(width: 12),
              // ✅ تمت إزالة InkWell واستخدام onTap الموجود في QuickActionCard مباشرة
              Expanded(
                child: QuickActionCard(
                  title: 'إضافة درجات',
                  icon: Icons.grade,
                  color: AppColors.accentLight,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GradesPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, HomeLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النشاطات الأخيرة',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  // Show all activities
                },
                child: Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.stats.recentActivities
              .map((activity) => RecentActivityItem(activity: activity))
              .toList(),
        ],
      ),
    );
  }
}
