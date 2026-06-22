// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/exam_state.dart';
// import 'package:teacher_management_app/features/exams/presentation/wedget/create_exame_bottom_shette.dart';
// import 'package:teacher_management_app/features/exams/presentation/wedget/exam_card.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/loading_widget.dart';

// class ExamsPage extends StatefulWidget {
//   const ExamsPage({super.key});

//   @override
//   State<ExamsPage> createState() => _ExamsPageState();
// }

// class _ExamsPageState extends State<ExamsPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _selectedFilter = 'all';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     context.read<ExamsCubit>().loadExams();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _showCreateExamSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => const CreateExamBottomSheet(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('exams'.tr()),
//         bottom: TabBar(
//           controller: _tabController,
//           onTap: (index) {
//             setState(() {
//               switch (index) {
//                 case 0:
//                   _selectedFilter = 'all';
//                   context.read<ExamsCubit>().loadExams();
//                   break;
//                 case 1:
//                   _selectedFilter = 'upcoming';
//                   context.read<ExamsCubit>().filterByStatus('upcoming');
//                   break;
//                 case 2:
//                   _selectedFilter = 'past';
//                   context.read<ExamsCubit>().filterByStatus('past');
//                   break;
//               }
//             });
//           },
//           indicatorColor: isDark
//               ? AppColors.primaryDark
//               : AppColors.primaryLight,
//           labelColor: isDark
//               ? AppColors.primaryDark
//               : AppColors.primaryLight,
//           unselectedLabelColor: isDark
//               ? AppColors.textSecondaryDark
//               : AppColors.textSecondaryLight,
//           tabs: const [
//             Tab(text: 'الكل'),
//             Tab(text: 'القادمة'),
//             Tab(text: 'السابقة'),
//           ],
//         ),
//       ),
//       body: BlocConsumer<ExamsCubit, ExamsState>(
//         listener: (context, state) {
//           if (state is ExamsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorLight,
//               ),
//             );
//           } else if (state is ExamCreated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.successLight,
//               ),
//             );
//           } else if (state is ExamDeleted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.successLight,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ExamsLoading) {
//             return const LoadingWidget(message: 'جارٍ التحميل...');
//           } else if (state is ExamsLoaded) {
//             if (state.exams.isEmpty) {
//               return _buildEmptyState(context);
//             }
//             return _buildExamsList(state.exams);
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showCreateExamSheet,
//         backgroundColor: isDark
//             ? AppColors.primaryDark
//             : AppColors.primaryLight,
//         icon: const Icon(Icons.add),
//         label: Text('create_exam'.tr()),
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.assignment_outlined,
//             size: 80,
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.textSecondaryDark
//                 : AppColors.textSecondaryLight,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'لا توجد امتحانات',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ابدأ بإنشاء امتحان جديد',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamsList(List exams) {
//     return RefreshIndicator(
//       onRefresh: () => context.read<ExamsCubit>().loadExams(),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: exams.length,
//         itemBuilder: (context, index) {
//           final exam = exams[index];
//           return ExamCard(
//             exam: exam,
//             onDelete: () {
//               _showDeleteConfirmation(exam.id);
//             },
//             onTap: () {
//               // Navigate to exam details
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showDeleteConfirmation(String id) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: const Text('هل أنت متأكد من حذف هذا الامتحان؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('cancel'.tr()),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               this.context.read<ExamsCubit>().deleteExam(id);
//             },
//             child: Text(
//               'delete'.tr(),
//               style: const TextStyle(color: AppColors.errorLight),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// features/exams/presentation/pages/exams_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/exam_state.dart';
import 'package:teacher_management_app/features/exams/presentation/pages/create_exam_page.dart';
import 'package:teacher_management_app/features/exams/presentation/pages/exam_detail_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamCubit>().loadExams();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('exams'.tr()),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'all'.tr()),
            Tab(text: 'upcoming'.tr()),
            Tab(text: 'past'.tr()),
          ],
          indicatorColor:
              isDark ? AppColors.primaryDark : AppColors.primaryLight,
          labelColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          unselectedLabelColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ExamCubit>(),
                child: const CreateExamPage(),
              ),
            ),
          );
          if (result == true) {
            context.read<ExamCubit>().loadExams();
          }
        },
        icon: const Icon(Icons.add),
        label: Text('new_exam'.tr()),
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (context, state) {
          if (state is ExamError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          } else if (state is ExamDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('exam_deleted'.tr()),
                backgroundColor: AppColors.successLight,
              ),
            );
            context.read<ExamCubit>().loadExams();
          }
        },
        builder: (context, state) {
          if (state is ExamLoading) {
            return const LoadingWidget(message: 'جارٍ تحميل الامتحانات...');
          }

          if (state is ExamsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildExamsList(context, state.exams),
                _buildExamsList(
                  context,
                  state.exams
                      .where((e) => e.date.isAfter(DateTime.now()))
                      .toList(),
                ),
                _buildExamsList(
                  context,
                  state.exams
                      .where((e) => e.date.isBefore(DateTime.now()))
                      .toList(),
                ),
              ],
            );
          }

          return const Center(child: Text('لا توجد امتحانات'));
        },
      ),
    );
  }

  Widget _buildExamsList(BuildContext context, List<ExamEntity> exams) {
    if (exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'no_exams'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ExamCubit>().loadExams(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          return _ExamCard(
            exam: exams[index],
            onDelete: () => _confirmDelete(context, exams[index].id),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ExamCubit>(),
                    child: ExamDetailPage(exam: exams[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('delete_exam'.tr()),
        content: Text('confirm_delete_exam'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ExamCubit>().deleteExam(id);
            },
            child: Text(
              'delete'.tr(),
              style: const TextStyle(color: AppColors.errorLight),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamEntity exam;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _ExamCard({
    required this.exam,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpcoming = exam.date.isAfter(DateTime.now());
    final statusColor =
        isUpcoming ? AppColors.infoLight : AppColors.successLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exam.subjectName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        onTap: onDelete,
                        child: Row(
                          children: [
                            const Icon(Icons.delete,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text('delete'.tr()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.calendar_today,
                    label: DateFormat('dd/MM/yyyy').format(exam.date),
                    color: statusColor,
                  ),
                  const SizedBox(width: 8),
                  if (exam.duration != null)
                    _InfoChip(
                      icon: Icons.timer,
                      label: '${exam.duration} دقيقة',
                      color: AppColors.warningLight,
                    ),
                  const SizedBox(width: 8),
                  if (exam.totalMarks != null)
                    _InfoChip(
                      icon: Icons.grade,
                      label: '${exam.totalMarks} درجة',
                      color: AppColors.accentLight,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exam.className,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
