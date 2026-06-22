// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:teacher_management_app/core/widgets/customdrobdown.dart';
// import 'package:teacher_management_app/features/materials/domain/entities/subject_entity.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../cubit/material_cubit.dart';
// import '../cubit/material_state.dart';

// class UploadMaterialPage extends StatefulWidget {
//   const UploadMaterialPage({super.key});

//   @override
//   State<UploadMaterialPage> createState() => _UploadMaterialPageState();
// }

// class _UploadMaterialPageState extends State<UploadMaterialPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   String? _selectedSubjectId;
//   String? _selectedClassId;
//   String? _selectedFileType;
//   File? _selectedFile;
//   String? _fileName;

//   final List<String> _fileTypes = ['pdf', 'video', 'image', 'document'];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MaterialCubit>().loadSubjects();
//     });
//   }

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//       allowMultiple: false,
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//         _fileName = result.files.single.name;
//         _selectedFileType = _getFileType(result.files.single.extension);
//       });
//     }
//   }

//   String _getFileType(String? extension) {
//     if (extension == null) return 'document';

//     final ext = extension.toLowerCase();
//     if (ext == 'pdf') return 'pdf';
//     if (ext == 'mp4' || ext == 'avi' || ext == 'mov') return 'video';
//     if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') return 'image';
//     return 'document';
//   }

//   Future<void> _uploadMaterial() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('select_file_first'.tr()),
//           backgroundColor: AppColors.errorLight,
//         ),
//       );
//       return;
//     }

//     // تحقق من أن _selectedClassId ليس فارغًا
//     if (_selectedClassId == null || _selectedClassId!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('select_class_first'.tr()), // أضف هذا المفتاح في ملف الترجمة
//           backgroundColor: AppColors.errorLight,
//         ),
//       );
//       return;
//     }

//     final formData = FormData.fromMap({
//       'title': _titleController.text,
//       'description': _descriptionController.text,
//       'subjectId': _selectedSubjectId,
//       'classId': _selectedClassId,
//       'fileType': _selectedFileType,
//       'file': await MultipartFile.fromFile(
//         _selectedFile!.path,
//         filename: _fileName,
//       ),
//     });

//     context.read<MaterialCubit>().uploadMaterial(formData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('upload_material'.tr()),
//       ),
//       body: BlocConsumer<MaterialCubit, MaterialStateeee>(
//         listener: (context, state) {
//           if (state is MaterialUploadSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('upload_success'.tr()),
//                 backgroundColor: AppColors.successLight,
//               ),
//             );
//             Navigator.pop(context);
//           } else if (state is MaterialError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.errorLight,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title Field
//                   CustomTextField(
//                     controller: _titleController,
//                     label: 'title'.tr(),
//                     hint: 'enter_material_title'.tr(),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'field_required'.tr();
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Description Field
//                   CustomTextField(
//                     controller: _descriptionController,
//                     label: 'description'.tr(),
//                     hint: 'enter_material_description'.tr(),
//                   ),
//                   const SizedBox(height: 16),

//                   // Subject Dropdown
//                   BlocBuilder<MaterialCubit, MaterialStateeee>(
//                     builder: (context, state) {
//                       return CustomDropdown<SubjectEntity?>(
//                         value: _findSubjectById(
//                             state.subjects, _selectedSubjectId),
//                         items: [
//                           DropdownMenuItem(
//                             value: null,
//                             child: Text('select_subject'.tr()),
//                           ),
//                           ...state.subjects.map((subject) {
//                             return DropdownMenuItem(
//                               value: subject,
//                               child: Text(subject.name),
//                             );
//                           }).toList(),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedSubjectId = value?.id;
//                             _selectedClassId =
//                                 null; // إعادة تعيين classId عند اختيار موضوع جديد
//                           });
//                         },
//                         label: 'subject'.tr(),
//                         hint: 'select_subject'.tr(),
//                         validator: (value) {
//                           if (value == null) {
//                             return 'field_required'.tr();
//                           }
//                           return null;
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // File Type Dropdown
//                   CustomDropdown<String?>(
//                     value: _selectedFileType,
//                     items: _fileTypes.map((type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(_getFileTypeTranslation(type)),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedFileType = value;
//                       });
//                     },
//                     label: 'file_type'.tr(),
//                     hint: 'select_file_type'.tr(),
//                     validator: (value) {
//                       if (value == null) {
//                         return 'field_required'.tr();
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // File Picker
//                   _buildFilePicker(),
//                   const SizedBox(height: 24),

//                   // Upload Button
//                   CustomButton(
//                     text: 'upload'.tr(),
//                     onPressed:
//                         state is MaterialUploading ? null : _uploadMaterial,
//                     isLoading: state is MaterialUploading,
//                     icon: Icons.upload,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildFilePicker() {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'file'.tr(),
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 8),
//         InkWell(
//           onTap: _pickFile,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isDark ? AppColors.borderDark : AppColors.borderLight,
//                 width: 2,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.cloud_upload_outlined,
//                   size: 50,
//                   color:
//                       isDark ? AppColors.primaryDark : AppColors.primaryLight,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   _selectedFile != null ? _fileName! : 'select_file'.tr(),
//                   style: Theme.of(context).textTheme.bodyLarge,
//                   textAlign: TextAlign.center,
//                 ),
//                 if (_selectedFile != null) ...[
//                   const SizedBox(height: 8),
//                   Text(
//                     '${(_selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//                 const SizedBox(height: 8),
//                 Text(
//                   'max_file_size_50mb'.tr(),
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   SubjectEntity? _findSubjectById(List<SubjectEntity> subjects, String? id) {
//     if (id == null || subjects.isEmpty) return null;
//     try {
//       return subjects.firstWhere((subject) => subject.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   String _getFileTypeTranslation(String type) {
//     switch (type) {
//       case 'pdf':
//         return 'pdf'.tr();
//       case 'video':
//         return 'video'.tr();
//       case 'image':
//         return 'image'.tr();
//       case 'document':
//         return 'document'.tr();
//       default:
//         return type;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:teacher_management_app/core/widgets/customdrobdown.dart';
import 'package:teacher_management_app/features/materials/domain/entities/subject_entity.dart';
import 'package:teacher_management_app/features/materials/domain/entities/class_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/material_cubit.dart';
import '../cubit/material_state.dart';

class UploadMaterialPage extends StatefulWidget {
  const UploadMaterialPage({super.key});

  @override
  State<UploadMaterialPage> createState() => _UploadMaterialPageState();
}

class _UploadMaterialPageState extends State<UploadMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedSubjectId;
  String? _selectedClassId;
  String? _selectedFileType;
  File? _selectedFile;
  String? _fileName;

  final List<String> _fileTypes = ['pdf', 'video', 'image', 'document'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterialCubit>().loadSubjects();
      context.read<MaterialCubit>().loadClasses();
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _selectedFileType = _getFileType(result.files.single.extension);
      });
    }
  }

  String _getFileType(String? extension) {
    if (extension == null) return 'document';

    final ext = extension.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (ext == 'mp4' || ext == 'avi' || ext == 'mov') return 'video';
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') return 'image';
    return 'document';
  }

  Future<void> _uploadMaterial() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('select_file_first'.tr()),
          backgroundColor: AppColors.errorLight,
        ),
      );
      return;
    }

    // إنشاء FormData مع التعامل الصحيح مع القيم الفارغة
    final formData = FormData.fromMap({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'subjectId': _selectedSubjectId ?? '',
      // هنا المشكلة: إذا كان classId فارغاً، لا نرسله أصلاً
      if (_selectedClassId != null && _selectedClassId!.isNotEmpty)
        'classId': _selectedClassId,
      'fileType': _selectedFileType ?? 'document',
      'file': await MultipartFile.fromFile(
        _selectedFile!.path,
        filename: _fileName,
      ),
    });

    context.read<MaterialCubit>().uploadMaterial(formData);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('upload_material'.tr()),
      ),
      body: BlocConsumer<MaterialCubit, MaterialStateeee>(
        listener: (context, state) {
          if (state is MaterialUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('upload_success'.tr()),
                backgroundColor: AppColors.successLight,
              ),
            );
            Navigator.pop(context);
          } else if (state is MaterialError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorLight,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  CustomTextField(
                    controller: _titleController,
                    label: 'title'.tr(),
                    hint: 'enter_material_title'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'description'.tr(),
                    hint: 'enter_material_description'.tr(),
                  ),
                  const SizedBox(height: 16),

                  // Subject Dropdown
                  BlocBuilder<MaterialCubit, MaterialStateeee>(
                    builder: (context, state) {
                      return CustomDropdown<SubjectEntity?>(
                        value: _findSubjectById(
                            state.subjects, _selectedSubjectId),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('select_subject'.tr()),
                          ),
                          ...state.subjects.map((subject) {
                            return DropdownMenuItem(
                              value: subject,
                              child: Text(subject.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSubjectId = value?.id;
                          });
                        },
                        label: 'subject'.tr(),
                        hint: 'select_subject'.tr(),
                        validator: (value) {
                          if (value == null) {
                            return 'field_required'.tr();
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Class Dropdown
                  BlocBuilder<MaterialCubit, MaterialStateeee>(
                    builder: (context, state) {
                      return CustomDropdown<ClassEntity?>(
                        value: _findClassById(state.classes, _selectedClassId),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('select_class'.tr()),
                          ),
                          ...state.classes.map((classItem) {
                            return DropdownMenuItem(
                              value: classItem,
                              child: Text(classItem.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedClassId = value?.id;
                          });
                        },
                        label: 'class'.tr(),
                        hint: 'select_class'.tr(),
                        // الصف اختياري
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // File Type Dropdown
                  CustomDropdown<String?>(
                    value: _selectedFileType,
                    items: _fileTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getFileTypeTranslation(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFileType = value;
                      });
                    },
                    label: 'file_type'.tr(),
                    hint: 'select_file_type'.tr(),
                    validator: (value) {
                      if (value == null) {
                        return 'field_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // File Picker
                  _buildFilePicker(),
                  const SizedBox(height: 24),

                  // Upload Button
                  CustomButton(
                    text: 'upload'.tr(),
                    onPressed:
                        state is MaterialUploading ? null : _uploadMaterial,
                    isLoading: state is MaterialUploading,
                    icon: Icons.upload,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'file'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 50,
                  color:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedFile != null ? _fileName! : 'select_file'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                if (_selectedFile != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${(_selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'max_file_size_50mb'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SubjectEntity? _findSubjectById(List<SubjectEntity> subjects, String? id) {
    if (id == null || subjects.isEmpty) return null;
    try {
      return subjects.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }

  ClassEntity? _findClassById(List<ClassEntity> classes, String? id) {
    if (id == null || classes.isEmpty) return null;
    try {
      return classes.firstWhere((classItem) => classItem.id == id);
    } catch (e) {
      return null;
    }
  }

  String _getFileTypeTranslation(String type) {
    switch (type) {
      case 'pdf':
        return 'pdf'.tr();
      case 'video':
        return 'video'.tr();
      case 'image':
        return 'image'.tr();
      case 'document':
        return 'document'.tr();
      default:
        return type;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
