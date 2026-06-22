// features/exams/presentation/pages/exam_detail_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
import '../../../../core/constants/app_colors.dart';

class ExamDetailPage extends StatelessWidget {
  final ExamEntity exam;

  const ExamDetailPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpcoming = exam.date.isAfter(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('exam_details'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isUpcoming
                    ? (isDark
                        ? AppColors.primaryGradientDark
                        : AppColors.primaryGradientLight)
                    : LinearGradient(
                        colors: [
                          AppColors.successLight,
                          AppColors.successLight.withOpacity(0.7)
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exam.subjectName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _StatBadge(
                        icon: Icons.class_,
                        label: exam.className,
                      ),
                      const SizedBox(width: 12),
                      _StatBadge(
                        icon: Icons.calendar_today,
                        label: DateFormat('dd/MM/yyyy').format(exam.date),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                if (exam.duration != null)
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer,
                      label: 'المدة',
                      value: '${exam.duration} دقيقة',
                      color: AppColors.warningLight,
                    ),
                  ),
                if (exam.totalMarks != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.grade,
                      label: 'الدرجة الكلية',
                      value: '${exam.totalMarks}',
                      color: AppColors.accentLight,
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.quiz,
                    label: 'الأسئلة',
                    value: '${exam.questions.length}',
                    color: AppColors.infoLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Questions List
            if (exam.questions.isNotEmpty) ...[
              Text(
                'questions'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...List.generate(exam.questions.length, (index) {
                final q = exam.questions[index];
                return _QuestionCard(
                  index: index + 1,
                  question: q,
                  isDark: isDark,
                );
              }),
            ] else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'no_questions'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final ExamQuestion question;
  final bool isDark;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (question.marks != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${question.marks} د',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.accentLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (question.options.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...question.options.map((option) {
              final isCorrect = option == question.correctAnswer;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.successLight.withOpacity(0.15)
                      : (isDark
                          ? AppColors.surfaceDark
                          : AppColors.borderLight),
                  borderRadius: BorderRadius.circular(8),
                  border: isCorrect
                      ? Border.all(color: AppColors.successLight)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: isCorrect
                          ? AppColors.successLight
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 13,
                        color: isCorrect ? AppColors.successLight : null,
                        fontWeight: isCorrect ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
