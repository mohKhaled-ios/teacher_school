// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_state.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/di/injection_container.dart' as di;
// import '../../../../core/widgets/loading_widget.dart';

// class GradeStatsPage extends StatefulWidget {
//   const GradeStatsPage({super.key});

//   @override
//   State<GradeStatsPage> createState() => _GradeStatsPageState();
// }

// class _GradeStatsPageState extends State<GradeStatsPage> {
//   String? _selectedExamId;
//   String? _selectedClassId;
//   List<Map<String, dynamic>> _exams = [];
//   List<Map<String, dynamic>> _classes = [];
//   bool _loadingData = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final api = di.sl<ApiClient>();
//       final examsRes = await api.getExams();
//       final classesRes = await api.getClasses();
//       if (mounted) {
//         setState(() {
//           if (examsRes.statusCode == 200) {
//             _exams = List<Map<String, dynamic>>.from(examsRes.data);
//           }
//           if (classesRes.statusCode == 200) {
//             _classes = List<Map<String, dynamic>>.from(classesRes.data);
//           }
//           _loadingData = false;
//         });
//       }
//     } catch (_) {
//       if (mounted) setState(() => _loadingData = false);
//     }
//   }

//   // ── استخراج ID بأمان ──
//   String? _getId(Map<String, dynamic> map) =>
//       (map['_id'] ?? map['id'])?.toString();

//   void _loadStats() {
//     if (_selectedExamId == null) return;
//     context.read<GradeCubit>().loadGradeStats(
//           examId: _selectedExamId,
//           classId: _selectedClassId,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // ── بناء items بنوع صريح ──
//     final List<DropdownMenuItem<String>> examItems = _exams
//         .map((e) => DropdownMenuItem<String>(
//               value: _getId(e),
//               child: Text(e['title']?.toString() ?? ''),
//             ))
//         .toList();

//     final List<DropdownMenuItem<String?>> classItems = [
//       DropdownMenuItem<String?>(
//         value: null,
//         child: Text('all_classes'.tr()),
//       ),
//       ..._classes.map((c) => DropdownMenuItem<String?>(
//             value: _getId(c),
//             child: Text(c['name']?.toString() ?? ''),
//           )),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: Text('grade_stats'.tr())),
//       body: Column(
//         children: [
//           // Filter Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//             child: _loadingData
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                     children: [
//                       // Exam Dropdown
//                       _buildExamDropdown(
//                         label: 'exam'.tr(),
//                         value: _selectedExamId,
//                         items: examItems,
//                         onChanged: (v) {
//                           setState(() => _selectedExamId = v);
//                           if (v != null) _loadStats();
//                         },
//                       ),
//                       const SizedBox(height: 12),

//                       // Class Dropdown (nullable value)
//                       _buildClassDropdown(
//                         label: 'class'.tr(),
//                         value: _selectedClassId,
//                         items: classItems,
//                         onChanged: (v) {
//                           setState(() => _selectedClassId = v);
//                           if (_selectedExamId != null) _loadStats();
//                         },
//                       ),
//                     ],
//                   ),
//           ),

//           // Stats Content
//           Expanded(
//             child: BlocBuilder<GradeCubit, GradeState>(
//               builder: (context, state) {
//                 if (state is GradeLoading) {
//                   return const LoadingWidget(
//                       message: 'جارٍ تحميل الإحصائيات...');
//                 }

//                 if (state is GradeStatsLoaded) {
//                   return _buildStats(context, state.stats, isDark);
//                 }

//                 if (_selectedExamId == null) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.bar_chart,
//                             size: 80, color: Theme.of(context).disabledColor),
//                         const SizedBox(height: 16),
//                         Text(
//                           'select_exam_for_stats'.tr(),
//                           style: Theme.of(context).textTheme.headlineSmall,
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStats(
//       BuildContext context, GradeStatsEntity stats, bool isDark) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Overview Cards
//           GridView.count(
//             crossAxisCount: 2,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.4,
//             children: [
//               _StatCard(
//                 label: 'average'.tr(),
//                 value: stats.average.toStringAsFixed(1),
//                 icon: Icons.analytics,
//                 color: AppColors.infoLight,
//               ),
//               _StatCard(
//                 label: 'highest'.tr(),
//                 value: '${stats.highest.toInt()}',
//                 icon: Icons.trending_up,
//                 color: AppColors.successLight,
//               ),
//               _StatCard(
//                 label: 'lowest'.tr(),
//                 value: '${stats.lowest.toInt()}',
//                 icon: Icons.trending_down,
//                 color: AppColors.errorLight,
//               ),
//               _StatCard(
//                 label: 'total_students'.tr(),
//                 value: '${stats.totalStudents}',
//                 icon: Icons.people,
//                 color: AppColors.primaryLight,
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // Grade Distribution
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDark ? AppColors.cardDark : AppColors.cardLight,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'grade_distribution'.tr(),
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 16),
//                 ...stats.gradeDistribution.entries.map((entry) {
//                   final color = _getGradeColor(entry.key);
//                   final percentage = stats.totalStudents > 0
//                       ? entry.value / stats.totalStudents
//                       : 0.0;
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               entry.key,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: color,
//                               ),
//                             ),
//                             Text('${entry.value} طالب'),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         LinearProgressIndicator(
//                           value: percentage,
//                           backgroundColor: color.withOpacity(0.15),
//                           valueColor: AlwaysStoppedAnimation<Color>(color),
//                           borderRadius: BorderRadius.circular(4),
//                           minHeight: 8,
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getGradeColor(String grade) {
//     switch (grade) {
//       case 'A+':
//       case 'A':
//         return AppColors.gradeA;
//       case 'B':
//         return AppColors.gradeB;
//       case 'C':
//         return AppColors.gradeC;
//       case 'D':
//         return AppColors.gradeD;
//       default:
//         return AppColors.gradeF;
//     }
//   }

//   // ── Dropdown للامتحانات (String غير nullable) ──
//   Widget _buildExamDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return DropdownButtonFormField<String>(
//       value: value,
//       items: items,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: isDark ? AppColors.borderDark : AppColors.borderLight,
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Dropdown للصفوف (String? nullable لأن فيه "الكل") ──
//   Widget _buildClassDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String?>> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return DropdownButtonFormField<String?>(
//       value: value,
//       items: items,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: isDark ? AppColors.borderDark : AppColors.borderLight,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════
// class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.cardDark : AppColors.cardLight,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// features/grades/presentation/pages/grade_stats_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/loading_widget.dart';

class GradeStatsPage extends StatefulWidget {
  const GradeStatsPage({super.key});

  @override
  State<GradeStatsPage> createState() => _GradeStatsPageState();
}

class _GradeStatsPageState extends State<GradeStatsPage> {
  String? _selectedExamId;
  String? _selectedClassId;
  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> _classes = [];
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final api = di.sl<ApiClient>();
      final examsRes = await api.getExams();
      final classesRes = await api.getClasses();
      if (mounted) {
        setState(() {
          if (examsRes.statusCode == 200) {
            _exams = List<Map<String, dynamic>>.from(examsRes.data);
          }
          if (classesRes.statusCode == 200) {
            _classes = List<Map<String, dynamic>>.from(classesRes.data);
          }
          _loadingData = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingData = false);
    }
  }

  String? _getId(Map<String, dynamic> map) =>
      (map['_id'] ?? map['id'])?.toString();

  void _loadStats() {
    if (_selectedExamId == null) return;
    context.read<GradeCubit>().loadGradeStats(
          examId: _selectedExamId,
          classId: _selectedClassId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('grade_stats'.tr())),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            child: _loadingData
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Exam dropdown — value ابتدائي null مع placeholder
                      _buildDropdown<String>(
                        label: 'exam'.tr(),
                        value: _selectedExamId,
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('select_exam'.tr()),
                          ),
                          ..._exams.map((e) => DropdownMenuItem<String>(
                                value: _getId(e),
                                child: Text(e['title']?.toString() ?? ''),
                              )),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedExamId = v);
                          if (v != null) _loadStats();
                        },
                      ),
                      const SizedBox(height: 12),

                      // Class dropdown — nullable
                      _buildDropdown<String>(
                        label: 'class'.tr(),
                        value: _selectedClassId,
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('all_classes'.tr()),
                          ),
                          ..._classes.map((c) => DropdownMenuItem<String>(
                                value: _getId(c),
                                child: Text(c['name']?.toString() ?? ''),
                              )),
                        ],
                        onChanged: (v) {
                          setState(() => _selectedClassId = v);
                          if (_selectedExamId != null) _loadStats();
                        },
                      ),
                    ],
                  ),
          ),

          // Stats Content
          Expanded(
            child: BlocBuilder<GradeCubit, GradeState>(
              builder: (context, state) {
                if (state is GradeLoading) {
                  return const LoadingWidget(
                      message: 'جارٍ تحميل الإحصائيات...');
                }

                if (state is GradeStatsLoaded) {
                  return _buildStats(context, state.stats, isDark);
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart,
                          size: 80, color: Theme.of(context).disabledColor),
                      const SizedBox(height: 16),
                      Text(
                        'select_exam_for_stats'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
      BuildContext context, GradeStatsEntity stats, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _StatCard(
                label: 'average'.tr(),
                value: stats.average.toStringAsFixed(1),
                icon: Icons.analytics,
                color: AppColors.infoLight,
              ),
              _StatCard(
                label: 'highest'.tr(),
                value: '${stats.highest.toInt()}',
                icon: Icons.trending_up,
                color: AppColors.successLight,
              ),
              _StatCard(
                label: 'lowest'.tr(),
                value: '${stats.lowest.toInt()}',
                icon: Icons.trending_down,
                color: AppColors.errorLight,
              ),
              _StatCard(
                label: 'total_students'.tr(),
                value: '${stats.totalStudents}',
                icon: Icons.people,
                color: AppColors.primaryLight,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'grade_distribution'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ...stats.gradeDistribution.entries.map((entry) {
                  final color = _getGradeColor(entry.key);
                  final pct = stats.totalStudents > 0
                      ? entry.value / stats.totalStudents
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: color)),
                            Text('${entry.value} طالب'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: pct,
                          backgroundColor: color.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
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

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
