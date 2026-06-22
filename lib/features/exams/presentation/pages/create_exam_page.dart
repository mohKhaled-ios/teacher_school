// // features/exams/presentation/pages/create_exam_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/exam_state.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/di/injection_container.dart' as di;

// class CreateExamPage extends StatefulWidget {
//   const CreateExamPage({super.key});

//   @override
//   State<CreateExamPage> createState() => _CreateExamPageState();
// }

// class _CreateExamPageState extends State<CreateExamPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _durationController = TextEditingController();
//   final _totalMarksController = TextEditingController();

//   String? _selectedSubjectId;
//   String? _selectedClassId;
//   DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

//   List<Map<String, dynamic>> _subjects = [];
//   List<Map<String, dynamic>> _classes = [];
//   bool _loadingData = true;

//   final List<ExamQuestion> _questions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSubjectsAndClasses();
//   }

//   Future<void> _loadSubjectsAndClasses() async {
//     try {
//       final apiClient = di.sl<ApiClient>();
//       final subjectsResponse = await apiClient.getSubjects();
//       final classesResponse = await apiClient.getClasses();

//       if (mounted) {
//         setState(() {
//           if (subjectsResponse.statusCode == 200) {
//             _subjects = List<Map<String, dynamic>>.from(subjectsResponse.data);
//           }
//           if (classesResponse.statusCode == 200) {
//             _classes = List<Map<String, dynamic>>.from(classesResponse.data);
//           }
//           _loadingData = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _loadingData = false);
//     }
//   }

//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       locale: const Locale('ar'),
//     );
//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   void _addQuestion() {
//     showDialog(
//       context: context,
//       builder: (_) => _AddQuestionDialog(
//         onAdd: (question) {
//           setState(() => _questions.add(question));
//         },
//       ),
//     );
//   }

//   void _submitExam() {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedSubjectId == null || _selectedClassId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى اختيار المادة والصف')),
//       );
//       return;
//     }

//     final data = {
//       'title': _titleController.text.trim(),
//       'subjectId': _selectedSubjectId,
//       'classId': _selectedClassId,
//       'date': _selectedDate.toIso8601String(),
//       'duration': int.tryParse(_durationController.text) ?? 60,
//       'totalMarks': int.tryParse(_totalMarksController.text) ?? 100,
//       'questions': _questions.map((q) => q).toList(),
//     };

//     context.read<ExamCubit>().createExam(data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(title: Text('new_exam'.tr())),
//       body: BlocConsumer<ExamCubit, ExamState>(
//         listener: (context, state) {
//           if (state is ExamCreated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('exam_created_successfully'.tr()),
//                 backgroundColor: AppColors.successLight,
//               ),
//             );
//             Navigator.pop(context, true);
//           } else if (state is ExamError) {
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
//                   // Title
//                   CustomTextField(
//                     controller: _titleController,
//                     label: 'exam_title'.tr(),
//                     hint: 'enter_exam_title'.tr(),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? 'field_required'.tr() : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // Subject Dropdown
//                   _buildDropdown(
//                     label: 'subject'.tr(),
//                     value: _selectedSubjectId,
//                     items: _subjects.map((s) {
//                       return DropdownMenuItem(
//                         value: s['_id'] ?? s['id'],
//                         child: Text(s['name'] ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (v) => setState(() => _selectedSubjectId = v),
//                   ),
//                   const SizedBox(height: 16),

//                   // Class Dropdown
//                   _buildDropdown(
//                     label: 'class'.tr(),
//                     value: _selectedClassId,
//                     items: _classes.map((c) {
//                       return DropdownMenuItem(
//                         value: c['_id'] ?? c['id'],
//                         child: Text(c['name'] ?? ''),
//                       );
//                     }).toList(),
//                     onChanged: (v) => setState(() => _selectedClassId = v),
//                   ),
//                   const SizedBox(height: 16),

//                   // Date Picker
//                   Text('exam_date'.tr(),
//                       style: Theme.of(context).textTheme.titleLarge),
//                   const SizedBox(height: 8),
//                   InkWell(
//                     onTap: _selectDate,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: isDark
//                               ? AppColors.borderDark
//                               : AppColors.borderLight,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         color: isDark
//                             ? AppColors.surfaceDark
//                             : AppColors.surfaceLight,
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.calendar_today,
//                               color: isDark
//                                   ? AppColors.primaryDark
//                                   : AppColors.primaryLight),
//                           const SizedBox(width: 12),
//                           Text(
//                             DateFormat('dd/MM/yyyy').format(_selectedDate),
//                             style: Theme.of(context).textTheme.bodyLarge,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Duration & Total Marks Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           controller: _durationController,
//                           label: 'duration_minutes'.tr(),
//                           hint: '60',
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: CustomTextField(
//                           controller: _totalMarksController,
//                           label: 'total_marks'.tr(),
//                           hint: '100',
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Questions Section
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'questions'.tr(),
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                       TextButton.icon(
//                         onPressed: _addQuestion,
//                         icon: const Icon(Icons.add),
//                         label: Text('add_question'.tr()),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   if (_questions.isEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? AppColors.surfaceDark
//                             : AppColors.borderLight,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'no_questions_added'.tr(),
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ),
//                     )
//                   else
//                     ...List.generate(_questions.length, (index) {
//                       final q = _questions[index];
//                       return _QuestionTile(
//                         index: index + 1,
//                         question: q,
//                         onDelete: () =>
//                             setState(() => _questions.removeAt(index)),
//                       );
//                     }),

//                   const SizedBox(height: 32),

//                   CustomButton(
//                     text: 'create_exam'.tr(),
//                     icon: Icons.assignment_add,
//                     isLoading: state is ExamLoading,
//                     onPressed: _submitExam,
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
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color:
//                     isDark ? AppColors.borderDark : AppColors.borderLight,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _durationController.dispose();
//     _totalMarksController.dispose();
//     super.dispose();
//   }
// }

// // ===== Add Question Dialog =====
// class _AddQuestionDialog extends StatefulWidget {
//   final Function(ExamQuestion) onAdd;
//   const _AddQuestionDialog({required this.onAdd});

//   @override
//   State<_AddQuestionDialog> createState() => _AddQuestionDialogState();
// }

// class _AddQuestionDialogState extends State<_AddQuestionDialog> {
//   final _questionController = TextEditingController();
//   final _marksController = TextEditingController();
//   final List<TextEditingController> _optionControllers =
//       List.generate(4, (_) => TextEditingController());
//   int _correctAnswerIndex = 0;

//   @override
//   void dispose() {
//     _questionController.dispose();
//     _marksController.dispose();
//     for (final c in _optionControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('add_question'.tr()),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _questionController,
//               decoration: InputDecoration(
//                 labelText: 'question'.tr(),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8)),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 12),
//             ...List.generate(4, (i) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   children: [
//                     Radio<int>(
//                       value: i,
//                       groupValue: _correctAnswerIndex,
//                       onChanged: (v) =>
//                           setState(() => _correctAnswerIndex = v!),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: _optionControllers[i],
//                         decoration: InputDecoration(
//                           labelText: 'option_${i + 1}'.tr(),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _marksController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'marks'.tr(),
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('cancel'.tr()),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_questionController.text.isEmpty) return;
//             final options = _optionControllers
//                 .map((c) => c.text)
//                 .where((t) => t.isNotEmpty)
//                 .toList();

//             widget.onAdd(ExamQuestion(
//               question: _questionController.text,
//               options: options,
//               correctAnswer:
//                   options.isNotEmpty && _correctAnswerIndex < options.length
//                       ? options[_correctAnswerIndex]
//                       : null,
//               marks: int.tryParse(_marksController.text),
//             ));
//             Navigator.pop(context);
//           },
//           child: Text('add'.tr()),
//         ),
//       ],
//     );
//   }
// }

// // ===== Question Tile =====
// class _QuestionTile extends StatelessWidget {
//   final int index;
//   final ExamQuestion question;
//   final VoidCallback onDelete;

//   const _QuestionTile({
//     required this.index,
//     required this.question,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               color: AppColors.primaryLight.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 '$index',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 12),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(question.question,
//                     style: Theme.of(context).textTheme.bodyLarge),
//                 if (question.marks != null)
//                   Text(
//                     '${question.marks} درجة',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: onDelete,
//             icon: const Icon(Icons.close, size: 18, color: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }
// }

// features/exams/presentation/pages/create_exam_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/cubite.dart';
import 'package:teacher_management_app/features/exams/presentation/cubite/exam_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/di/injection_container.dart' as di;

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({super.key});

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _totalMarksController = TextEditingController();

  String? _selectedSubjectId;
  String? _selectedClassId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _classes = [];
  bool _loadingData = true;

  final List<ExamQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadSubjectsAndClasses();
  }

  Future<void> _loadSubjectsAndClasses() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final subjectsResponse = await apiClient.getSubjects();
      final classesResponse = await apiClient.getClasses();

      if (mounted) {
        setState(() {
          if (subjectsResponse.statusCode == 200) {
            _subjects = List<Map<String, dynamic>>.from(subjectsResponse.data);
          }
          if (classesResponse.statusCode == 200) {
            _classes = List<Map<String, dynamic>>.from(classesResponse.data);
          }
          _loadingData = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingData = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (_) => _AddQuestionDialog(
        onAdd: (question) {
          setState(() => _questions.add(question));
        },
      ),
    );
  }

  void _submitExam() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjectId == null || _selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار المادة والصف')),
      );
      return;
    }

    final data = {
      'title': _titleController.text.trim(),
      'subjectId': _selectedSubjectId,
      'classId': _selectedClassId,
      'date': _selectedDate.toIso8601String(),
      'duration': int.tryParse(_durationController.text) ?? 60,
      'totalMarks': int.tryParse(_totalMarksController.text) ?? 100,
      'questions': _questions.map((q) => q.toJson()).toList(),
    };

    context.read<ExamCubit>().createExam(data);
  }

  // ── helper: extract String id safely from dynamic map ──
  String? _getId(Map<String, dynamic> map) {
    final v = map['_id'] ?? map['id'];
    return v?.toString();
  }

  // ── helper: extract String name safely ──
  String _getName(Map<String, dynamic> map) {
    return map['name']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build typed items once so Dart infers List<DropdownMenuItem<String>>
    final List<DropdownMenuItem<String>> subjectItems = _subjects
        .map((s) => DropdownMenuItem<String>(
              value: _getId(s),
              child: Text(_getName(s)),
            ))
        .toList();

    final List<DropdownMenuItem<String>> classItems = _classes
        .map((c) => DropdownMenuItem<String>(
              value: _getId(c),
              child: Text(_getName(c)),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('new_exam'.tr())),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (context, state) {
          if (state is ExamCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('exam_created_successfully'.tr()),
                backgroundColor: AppColors.successLight,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ExamError) {
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
                  // Title
                  CustomTextField(
                    controller: _titleController,
                    label: 'exam_title'.tr(),
                    hint: 'enter_exam_title'.tr(),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'field_required'.tr() : null,
                  ),
                  const SizedBox(height: 16),

                  // Subject Dropdown
                  _buildDropdown(
                    label: 'subject'.tr(),
                    value: _selectedSubjectId,
                    items: subjectItems,
                    onChanged: (v) => setState(() => _selectedSubjectId = v),
                  ),
                  const SizedBox(height: 16),

                  // Class Dropdown
                  _buildDropdown(
                    label: 'class'.tr(),
                    value: _selectedClassId,
                    items: classItems,
                    onChanged: (v) => setState(() => _selectedClassId = v),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
                  Text('exam_date'.tr(),
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration & Total Marks Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _durationController,
                          label: 'duration_minutes'.tr(),
                          hint: '60',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _totalMarksController,
                          label: 'total_marks'.tr(),
                          hint: '100',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Questions Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'questions'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton.icon(
                        onPressed: _addQuestion,
                        icon: const Icon(Icons.add),
                        label: Text('add_question'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_questions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'no_questions_added'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ...List.generate(_questions.length, (index) {
                      final q = _questions[index];
                      return _QuestionTile(
                        index: index + 1,
                        question: q,
                        onDelete: () =>
                            setState(() => _questions.removeAt(index)),
                      );
                    }),

                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'create_exam'.tr(),
                    icon: Icons.assignment_add,
                    isLoading: state is ExamLoading,
                    onPressed: _submitExam,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
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
    _titleController.dispose();
    _durationController.dispose();
    _totalMarksController.dispose();
    super.dispose();
  }
}

// ===== Add Question Dialog =====
class _AddQuestionDialog extends StatefulWidget {
  final Function(ExamQuestion) onAdd;
  const _AddQuestionDialog({required this.onAdd});

  @override
  State<_AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<_AddQuestionDialog> {
  final _questionController = TextEditingController();
  final _marksController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());
  int _correctAnswerIndex = 0;

  @override
  void dispose() {
    _questionController.dispose();
    _marksController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add_question'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'question'.tr(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: _correctAnswerIndex,
                      onChanged: (v) =>
                          setState(() => _correctAnswerIndex = v!),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[i],
                        decoration: InputDecoration(
                          labelText: 'option_${i + 1}'.tr(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'marks'.tr(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_questionController.text.isEmpty) return;
            final options = _optionControllers
                .map((c) => c.text)
                .where((t) => t.isNotEmpty)
                .toList();

            widget.onAdd(ExamQuestion(
              question: _questionController.text,
              options: options,
              correctAnswer:
                  options.isNotEmpty && _correctAnswerIndex < options.length
                      ? options[_correctAnswerIndex]
                      : null,
              marks: int.tryParse(_marksController.text),
            ));
            Navigator.pop(context);
          },
          child: Text('add'.tr()),
        ),
      ],
    );
  }
}

// ===== Question Tile =====
class _QuestionTile extends StatelessWidget {
  final int index;
  final ExamQuestion question;
  final VoidCallback onDelete;

  const _QuestionTile({
    required this.index,
    required this.question,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.question,
                    style: Theme.of(context).textTheme.bodyLarge),
                if (question.marks != null)
                  Text(
                    '${question.marks} درجة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
