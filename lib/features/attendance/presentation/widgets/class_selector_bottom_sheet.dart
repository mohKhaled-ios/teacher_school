// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../domain/entities/attendance.dart';
// import '../cubit/attendance_cubit.dart';
// import '../cubit/attendance_state.dart';

// class ClassSelectorBottomSheet extends StatelessWidget {
//   final Function(ClassModel) onClassSelected;

//   const ClassSelectorBottomSheet({
//     super.key,
//     required this.onClassSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           Container(
//             margin: const EdgeInsets.only(top: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: isDark
//                   ? AppColors.textSecondaryDark
//                   : AppColors.textSecondaryLight,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           // Title
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Text(
//               'select_class'.tr(),
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ),

//           // Classes List
//           BlocBuilder<AttendanceCubit, AttendanceState>(
//             builder: (context, state) {
//               if (state is ClassesLoaded) {
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   itemCount: state.classes.length,
//                   itemBuilder: (context, index) {
//                     final classModel = state.classes[index];
//                     return _buildClassItem(
//                       context,
//                       classModel,
//                       isDark,
//                     );
//                   },
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildClassItem(
//     BuildContext context,
//     ClassModel classModel,
//     bool isDark,
//   ) {
//     return InkWell(
//       onTap: () {
//         onClassSelected(classModel);
//         Navigator.pop(context);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.cardDark : AppColors.cardLight,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isDark ? AppColors.borderDark : AppColors.borderLight,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
//                     .withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 Icons.class_,
//                 color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     classModel.name,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isDark
//                           ? AppColors.textPrimaryDark
//                           : AppColors.textPrimaryLight,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${classModel.grade}${classModel.section != null ? ' - ${classModel.section}' : ''}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isDark
//                           ? AppColors.textSecondaryDark
//                           : AppColors.textSecondaryLight,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: isDark
//                   ? AppColors.textSecondaryDark
//                   : AppColors.textSecondaryLight,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/attendance.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';

class ClassSelectorBottomSheet extends StatelessWidget {
  final Function(ClassModel) onClassSelected;

  const ClassSelectorBottomSheet({
    super.key,
    required this.onClassSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'select_class'.tr(),
              style: theme.textTheme.headlineMedium,
            ),
          ),

          // Classes List
          BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              if (state is ClassesLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.classes.length,
                  itemBuilder: (context, index) {
                    final classModel = state.classes[index];
                    return _buildClassItem(context, classModel);
                  },
                );
              } else if (state is AttendanceError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (state is AttendanceLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, ClassModel classModel) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onClassSelected(classModel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.class_,
                color: theme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classModel.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${classModel.grade}${classModel.section != null ? ' - ${classModel.section}' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
