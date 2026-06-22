// features/grades/presentation/pages/grades_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';
import 'package:teacher_management_app/features/grades/presentation/add_grade_page.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_state.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_stats_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GradeCubit>().loadGrades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('grades'.tr()),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<GradeCubit>(),
                  child: const GradeStatsPage(),
                ),
              ),
            ),
            icon: const Icon(Icons.bar_chart),
            tooltip: 'stats'.tr(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<GradeCubit>(),
                child: const AddGradePage(),
              ),
            ),
          );
          if (result == true) {
            context.read<GradeCubit>().loadGrades();
          }
        },
        icon: const Icon(Icons.add),
        label: Text('add_grade'.tr()),
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<GradeCubit, GradeState>(
        listener: (context, state) {
          if (state is GradeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          } else if (state is GradeAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('grade_added_successfully'.tr()),
                backgroundColor: AppColors.successLight,
              ),
            );
            context.read<GradeCubit>().loadGrades();
          }
        },
        builder: (context, state) {
          if (state is GradeLoading) {
            return const LoadingWidget(message: 'جارٍ تحميل الدرجات...');
          }

          if (state is GradesLoaded) {
            if (state.grades.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.grade_outlined,
                      size: 80,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_grades'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<GradeCubit>().loadGrades(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.grades.length,
                itemBuilder: (context, index) {
                  return _GradeCard(grade: state.grades[index]);
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

class _GradeCard extends StatelessWidget {
  final GradeEntity grade;

  const _GradeCard({required this.grade});

  Color _getGradeColor(String g) {
    switch (g) {
      case 'A+':
      case 'A':
        return AppColors.gradeA;
      case 'B':
        return AppColors.gradeB;
      case 'C':
        return AppColors.gradeC;
      case 'D':
        return AppColors.gradeD;
      default:
        return AppColors.gradeF;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradeColor = _getGradeColor(grade.grade);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradeColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Grade Badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: gradeColor, width: 2),
            ),
            child: Center(
              child: Text(
                grade.grade,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.studentName,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  grade.examTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  grade.subjectName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${grade.marksObtained.toInt()}/${grade.totalMarks.toInt()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${grade.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
