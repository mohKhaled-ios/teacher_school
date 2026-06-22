// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/attendance/presentation/widgets/attend.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../domain/entities/attendance.dart';
// import '../cubit/attendance_cubit.dart';
// import '../cubit/attendance_state.dart';
// import '../widgets/class_selector_bottom_sheet.dart';
// import '../widgets/student_attendance_card.dart';

// class AttendancePage extends StatefulWidget {
//   const AttendancePage({super.key});

//   @override
//   State<AttendancePage> createState() => _AttendancePageState();
// }

// class _AttendancePageState extends State<AttendancePage> {
//   DateTime _selectedDate = DateTime.now();
//   ClassModel? _selectedClass;

//   @override
//   void initState() {
//     super.initState();
//     context.read<AttendanceCubit>().loadClasses();
//   }

//   void _showClassSelector() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => ClassSelectorBottomSheet(
//         onClassSelected: (classModel) {
//           setState(() {
//             _selectedClass = classModel;
//           });
//           context.read<AttendanceCubit>().loadStudents(classModel.id);
//         },
//       ),
//     );
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: isDark ? AppColors.primaryDark : AppColors.primaryLight,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//       context.read<AttendanceCubit>().setDate(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('mark_attendance'.tr()),
//         actions: [
//           IconButton(
//             onPressed: _selectDate,
//             icon: const Icon(Icons.calendar_today),
//           ),
//         ],
//       ),
//       body: BlocConsumer<AttendanceCubit, AttendanceState>(
//         listener: (context, state) {
//           if (state is AttendanceError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorLight,
//               ),
//             );
//           } else if (state is AttendanceMarked) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.successLight,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AttendanceLoading) {
//             return const LoadingWidget(message: 'جارٍ التحميل...');
//           }

//           return Column(
//             children: [
//               // Date & Class Selection
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//                 child: Column(
//                   children: [
//                     // Date Display
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color:
//                             isDark ? AppColors.cardDark : AppColors.cardLight,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isDark
//                               ? AppColors.borderDark
//                               : AppColors.borderLight,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today,
//                             color: isDark
//                                 ? AppColors.primaryDark
//                                 : AppColors.primaryLight,
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             DateFormat('EEEE, dd MMMM yyyy', 'ar')
//                                 .format(_selectedDate),
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // Class Selector
//                     InkWell(
//                       onTap: _showClassSelector,
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color:
//                               isDark ? AppColors.cardDark : AppColors.cardLight,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isDark
//                                 ? AppColors.primaryDark
//                                 : AppColors.primaryLight,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.class_,
//                               color: isDark
//                                   ? AppColors.primaryDark
//                                   : AppColors.primaryLight,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 _selectedClass?.name ?? 'select_class'.tr(),
//                                 style: Theme.of(context).textTheme.titleLarge,
//                               ),
//                             ),
//                             const Icon(Icons.arrow_drop_down),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Students List or Empty State
//               Expanded(
//                 child: _selectedClass == null
//                     ? _buildEmptyState(context)
//                     : _buildStudentsList(context, state),
//               ),

//               // Submit Button
//               if (state is StudentsLoaded)
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color:
//                         isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//                     boxShadow: [
//                       BoxShadow(
//                         color: isDark
//                             ? AppColors.shadowDark
//                             : AppColors.shadowLight,
//                         blurRadius: 10,
//                         offset: const Offset(0, -3),
//                       ),
//                     ],
//                   ),
//                   child: CustomButton(
//                     text: 'حفظ الحضور',
//                     icon: Icons.save,
//                     onPressed: () {
//                       context.read<AttendanceCubit>().submitAttendance();
//                     },
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.class_,
//             size: 80,
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.textSecondaryDark
//                 : AppColors.textSecondaryLight,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'select_class'.tr(),
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'يرجى اختيار الصف لعرض الطلاب',
//             style: Theme.of(context).textTheme.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStudentsList(BuildContext context, AttendanceState state) {
//     if (state is! StudentsLoaded) {
//       return const SizedBox.shrink();
//     }

//     final cubit = context.read<AttendanceCubit>();

//     return Column(
//       children: [
//         // Summary Card
//         AttendanceSummaryCard(
//           presentCount: cubit.getPresentCount(),
//           absentCount: cubit.getAbsentCount(),
//           lateCount: cubit.getLateCount(),
//           totalCount: state.students.length,
//         ),

//         // Students List
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: state.students.length,
//             itemBuilder: (context, index) {
//               final student = state.students[index];
//               final status =
//                   state.attendanceMap[student.id] ?? AttendanceStatus.present;

//               return StudentAttendanceCard(
//                 student: student,
//                 status: status,
//                 onStatusChanged: (newStatus) {
//                   cubit.updateAttendance(student.id, newStatus);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/attendance/domain/entities/attendance.dart';
import 'package:teacher_management_app/features/attendance/presentation/widgets/attend.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';
import '../widgets/class_selector_bottom_sheet.dart';
import '../widgets/student_attendance_card.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selectedDate = DateTime.now();
  ClassModel? _selectedClass;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceCubit>().loadClasses();
    });
  }

  Future<void> _refreshData() async {
    if (_selectedClass != null) {
      await context.read<AttendanceCubit>().loadStudents(_selectedClass!.id);
    } else {
      await context.read<AttendanceCubit>().loadClasses();
    }
  }

  void _showClassSelector() {
    final cubit = context.read<AttendanceCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: ClassSelectorBottomSheet(
          onClassSelected: (classModel) {
            setState(() {
              _selectedClass = classModel;
            });
            cubit.loadStudents(classModel.id);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<AttendanceCubit>().setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('mark_attendance'.tr()),
        actions: [
          IconButton(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today),
            tooltip: 'change_date'.tr(),
          ),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh'.tr(),
          ),
        ],
      ),
      body: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is AttendanceMarked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // إعادة تحميل البيانات بعد الحفظ
            Future.delayed(const Duration(seconds: 1), () {
              if (_selectedClass != null) {
                context
                    .read<AttendanceCubit>()
                    .loadStudents(_selectedClass!.id);
              }
            });
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AttendanceState state) {
    final theme = Theme.of(context);

    if (state is AttendanceLoading) {
      return const LoadingWidget(message: 'جارٍ التحميل...');
    }

    return Column(
      children: [
        // Date & Class Selection
        Container(
          padding: const EdgeInsets.all(20),
          color: theme.cardColor,
          child: Column(
            children: [
              // Date Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('EEEE, dd MMMM yyyy', 'ar')
                            .format(_selectedDate),
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Class Selector
              InkWell(
                onTap: _showClassSelector,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedClass == null
                          ? theme.colorScheme.error
                          : theme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.class_,
                        color: _selectedClass == null
                            ? theme.colorScheme.error
                            : theme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'class'.tr(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedClass?.name ?? 'select_class'.tr(),
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Students List or Empty State
        Expanded(
          child: _selectedClass == null
              ? _buildEmptyState(context)
              : _buildStudentsList(context, state),
        ),

        // Submit Button
        if (state is StudentsLoaded && state.students.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: CustomButton(
              text: 'save_attendance'.tr(),
              icon: Icons.save,
              isLoading: state is AttendanceLoading,
              onPressed: () {
                context.read<AttendanceCubit>().submitAttendance();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.class_,
              size: 80,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 20),
            Text(
              'select_class_first'.tr(),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'يرجى اختيار الصف لعرض قائمة الطلاب وبدء تسجيل الحضور',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'choose_class'.tr(),
              icon: Icons.arrow_forward,
              onPressed: _showClassSelector,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsList(BuildContext context, AttendanceState state) {
    if (state is! StudentsLoaded) {
      return _buildEmptyState(context);
    }

    if (state.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 80,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'no_students_found'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

    final cubit = context.read<AttendanceCubit>();

    return Column(
      children: [
        // Summary Card
        AttendanceSummaryCard(
          presentCount: cubit.getPresentCount(),
          absentCount: cubit.getAbsentCount(),
          lateCount: cubit.getLateCount(),
          totalCount: state.students.length,
        ),

        // Students List Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text(
                'students_list'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '${state.students.length} ${'student'.tr()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),

        // Students List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            itemCount: state.students.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final student = state.students[index];
              final status =
                  state.attendanceMap[student.id] ?? AttendanceStatus.present;

              return StudentAttendanceCard(
                student: student,
                status: status,
                onStatusChanged: (newStatus) {
                  cubit.updateAttendance(student.id, newStatus);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
