// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
// import 'package:teacher_management_app/features/grades/presentation/grade_state.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/di/injection_container.dart' as di;

// class AddGradePage extends StatefulWidget {
//   const AddGradePage({super.key});

//   @override
//   State<AddGradePage> createState() => _AddGradePageState();
// }

// class _AddGradePageState extends State<AddGradePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _marksController = TextEditingController();
//   final _commentsController = TextEditingController();

//   String? _selectedStudentId;
//   String? _selectedExamId;
//   String? _selectedSubjectId;

//   List<Map<String, dynamic>> _students = [];
//   List<Map<String, dynamic>> _exams = [];
//   List<Map<String, dynamic>> _subjects = [];
//   bool _loadingData = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final api = di.sl<ApiClient>();
//       final studentsRes = await api.getUsers(queryParams: {'role': 'student'});
//       final examsRes = await api.getExams();
//       final subjectsRes = await api.getSubjects();

//       if (mounted) {
//         setState(() {
//           if (studentsRes.statusCode == 200) {
//             _students = List<Map<String, dynamic>>.from(studentsRes.data);
//           }
//           if (examsRes.statusCode == 200) {
//             _exams = List<Map<String, dynamic>>.from(examsRes.data);
//           }
//           if (subjectsRes.statusCode == 200) {
//             _subjects = List<Map<String, dynamic>>.from(subjectsRes.data);
//           }
//           _loadingData = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _loadingData = false);
//     }
//   }

//   // ── استخراج ID بأمان من map ──
//   String? _getId(Map<String, dynamic> map) =>
//       (map['_id'] ?? map['id'])?.toString();

//   String _getName(Map<String, dynamic> map) =>
//       map['name']?.toString() ?? map['title']?.toString() ?? '';

//   String? _getTotalMarks() {
//     if (_selectedExamId == null) return null;
//     try {
//       final exam = _exams.firstWhere(
//         (e) => _getId(e) == _selectedExamId,
//       );
//       return exam['totalMarks']?.toString();
//     } catch (_) {
//       return null;
//     }
//   }

//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedStudentId == null ||
//         _selectedExamId == null ||
//         _selectedSubjectId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى اختيار الطالب والامتحان والمادة')),
//       );
//       return;
//     }

//     final totalMarks = int.tryParse(_getTotalMarks() ?? '100') ?? 100;

//     context.read<GradeCubit>().addGrade({
//       'studentId': _selectedStudentId,
//       'examId': _selectedExamId,
//       'subjectId': _selectedSubjectId,
//       'marksObtained': double.tryParse(_marksController.text) ?? 0,
//       'totalMarks': totalMarks,
//       'comments':
//           _commentsController.text.isEmpty ? null : _commentsController.text,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ── بناء الـ items بنوع صريح قبل الـ build ──
//     final List<DropdownMenuItem<String>> studentItems = _students
//         .map((s) => DropdownMenuItem<String>(
//               value: _getId(s),
//               child: Text(_getName(s)),
//             ))
//         .toList();

//     final List<DropdownMenuItem<String>> examItems = _exams
//         .map((e) => DropdownMenuItem<String>(
//               value: _getId(e),
//               child: Text(e['title']?.toString() ?? ''),
//             ))
//         .toList();

//     final List<DropdownMenuItem<String>> subjectItems = _subjects
//         .map((s) => DropdownMenuItem<String>(
//               value: _getId(s),
//               child: Text(_getName(s)),
//             ))
//         .toList();

//     return Scaffold(
//       appBar: AppBar(title: Text('add_grade'.tr())),
//       body: BlocConsumer<GradeCubit, GradeState>(
//         listener: (context, state) {
//           if (state is GradeAdded) {
//             Navigator.pop(context, true);
//           } else if (state is GradeError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorLight,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (_loadingData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Student Dropdown
//                   _buildDropdown(
//                     label: 'student'.tr(),
//                     value: _selectedStudentId,
//                     items: studentItems,
//                     onChanged: (v) => setState(() => _selectedStudentId = v),
//                   ),
//                   const SizedBox(height: 16),

//                   // Exam Dropdown
//                   _buildDropdown(
//                     label: 'exam'.tr(),
//                     value: _selectedExamId,
//                     items: examItems,
//                     onChanged: (v) => setState(() => _selectedExamId = v),
//                   ),
//                   const SizedBox(height: 16),

//                   // Subject Dropdown
//                   _buildDropdown(
//                     label: 'subject'.tr(),
//                     value: _selectedSubjectId,
//                     items: subjectItems,
//                     onChanged: (v) => setState(() => _selectedSubjectId = v),
//                   ),
//                   const SizedBox(height: 16),

//                   // Marks Obtained
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           controller: _marksController,
//                           label: 'marks_obtained'.tr(),
//                           hint: '0',
//                           keyboardType: TextInputType.number,
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'field_required'.tr();
//                             }
//                             final marks = double.tryParse(v);
//                             if (marks == null) {
//                               return 'invalid_number'.tr();
//                             }
//                             final total =
//                                 double.tryParse(_getTotalMarks() ?? '100') ??
//                                     100;
//                             if (marks > total) {
//                               return 'marks_exceed_total'.tr();
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       if (_selectedExamId != null &&
//                           _getTotalMarks() != null) ...[
//                         const SizedBox(width: 12),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: AppColors.accentLight.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: AppColors.accentLight.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Column(
//                             children: [
//                               const Text('من', style: TextStyle(fontSize: 12)),
//                               Text(
//                                 _getTotalMarks() ?? '?',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.accentLight,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Comments
//                   CustomTextField(
//                     controller: _commentsController,
//                     label: 'comments'.tr(),
//                     hint: 'optional_comments'.tr(),
//                   ),
//                   const SizedBox(height: 32),

//                   CustomButton(
//                     text: 'save_grade'.tr(),
//                     icon: Icons.save,
//                     isLoading: state is GradeLoading,
//                     onPressed: _submit,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String>> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: Theme.of(context).textTheme.titleLarge),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: value,
//           items: items,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: isDark ? AppColors.borderDark : AppColors.borderLight,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _marksController.dispose();
//     _commentsController.dispose();
//     super.dispose();
//   }
// }

// features/grades/presentation/pages/add_grade_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_cubit.dart';
import 'package:teacher_management_app/features/grades/presentation/grade_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/di/injection_container.dart' as di;

class AddGradePage extends StatefulWidget {
  const AddGradePage({super.key});

  @override
  State<AddGradePage> createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  final _formKey = GlobalKey<FormState>();
  final _marksController = TextEditingController();
  final _commentsController = TextEditingController();

  String? _selectedStudentId;
  String? _selectedExamId;
  String? _selectedSubjectId;

  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> _subjects = [];
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final api = di.sl<ApiClient>();
      final studentsRes = await api.getUsers(queryParams: {'role': 'student'});
      final examsRes = await api.getExams();
      final subjectsRes = await api.getSubjects();

      if (mounted) {
        setState(() {
          if (studentsRes.statusCode == 200) {
            _students = List<Map<String, dynamic>>.from(studentsRes.data);
          }
          if (examsRes.statusCode == 200) {
            _exams = List<Map<String, dynamic>>.from(examsRes.data);
          }
          if (subjectsRes.statusCode == 200) {
            _subjects = List<Map<String, dynamic>>.from(subjectsRes.data);
          }
          _loadingData = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingData = false);
    }
  }

  String? _getId(Map<String, dynamic> map) =>
      (map['_id'] ?? map['id'])?.toString();

  String _getName(Map<String, dynamic> map) =>
      map['name']?.toString() ?? map['title']?.toString() ?? '';

  String? _getTotalMarks() {
    if (_selectedExamId == null) return null;
    try {
      final exam = _exams.firstWhere((e) => _getId(e) == _selectedExamId);
      return exam['totalMarks']?.toString();
    } catch (_) {
      return null;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentId == null ||
        _selectedExamId == null ||
        _selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الطالب والامتحان والمادة')),
      );
      return;
    }

    final totalMarks = int.tryParse(_getTotalMarks() ?? '100') ?? 100;

    context.read<GradeCubit>().addGrade({
      'studentId': _selectedStudentId,
      'examId': _selectedExamId,
      'subjectId': _selectedSubjectId,
      'marksObtained': double.tryParse(_marksController.text) ?? 0,
      'totalMarks': totalMarks,
      'comments':
          _commentsController.text.isEmpty ? null : _commentsController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_grade'.tr())),
      body: BlocConsumer<GradeCubit, GradeState>(
        listener: (context, state) {
          if (state is GradeAdded) {
            Navigator.pop(context, true);
          } else if (state is GradeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          }
        },
        builder: (context, state) {
          if (_loadingData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student
                  _buildDropdown<String>(
                    label: 'student'.tr(),
                    value: _selectedStudentId,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('select_student'.tr()),
                      ),
                      ..._students.map((s) => DropdownMenuItem<String>(
                            value: _getId(s),
                            child: Text(_getName(s)),
                          )),
                    ],
                    onChanged: (v) => setState(() => _selectedStudentId = v),
                  ),
                  const SizedBox(height: 16),

                  // Exam
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
                    onChanged: (v) => setState(() => _selectedExamId = v),
                  ),
                  const SizedBox(height: 16),

                  // Subject
                  _buildDropdown<String>(
                    label: 'subject'.tr(),
                    value: _selectedSubjectId,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('select_subject'.tr()),
                      ),
                      ..._subjects.map((s) => DropdownMenuItem<String>(
                            value: _getId(s),
                            child: Text(_getName(s)),
                          )),
                    ],
                    onChanged: (v) => setState(() => _selectedSubjectId = v),
                  ),
                  const SizedBox(height: 16),

                  // Marks
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _marksController,
                          label: 'marks_obtained'.tr(),
                          hint: '0',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'field_required'.tr();
                            }
                            final marks = double.tryParse(v);
                            if (marks == null) return 'invalid_number'.tr();
                            final total =
                                double.tryParse(_getTotalMarks() ?? '100') ??
                                    100;
                            if (marks > total) {
                              return 'marks_exceed_total'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_selectedExamId != null &&
                          _getTotalMarks() != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accentLight.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text('من', style: TextStyle(fontSize: 12)),
                              Text(
                                _getTotalMarks() ?? '?',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Comments
                  CustomTextField(
                    controller: _commentsController,
                    label: 'comments'.tr(),
                    hint: 'optional_comments'.tr(),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'save_grade'.tr(),
                    icon: Icons.save,
                    isLoading: state is GradeLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _marksController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
}
