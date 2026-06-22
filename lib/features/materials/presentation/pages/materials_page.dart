import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:teacher_management_app/core/widgets/customdrobdown.dart';
import 'package:teacher_management_app/core/widgets/search_fild%20.dart';
import 'package:teacher_management_app/features/materials/domain/entities/material_entity.dart';
import 'package:teacher_management_app/features/materials/domain/entities/subject_entity.dart';
import 'package:teacher_management_app/features/materials/presentation/cubit/material_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/material_cubit.dart';
import '../widgets/material_card.dart';
import 'upload_material_page.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  String? _selectedSubjectId;
  String? _selectedFileType;
  final List<String> _fileTypes = ['all', 'pdf', 'video', 'image', 'document'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMaterials();
      _loadSubjects();
    });
  }

  void _loadMaterials() {
    context.read<MaterialCubit>().loadMaterials(
          subjectId: _selectedSubjectId,
          fileType: _selectedFileType == 'all' ? null : _selectedFileType,
        );
  }

  void _loadSubjects() {
    context.read<MaterialCubit>().loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('materials'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadMaterialPage(),
                ),
              );
            },
          ),
        ],
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
          return Column(
            children: [
              // Filters Section
              _buildFiltersSection(context, state),

              // Materials List
              Expanded(
                child: _buildMaterialsList(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context, MaterialStateeee state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Field
          SearchField(
            onChanged: (value) {
              // يمكن إضافة بحث
            },
            hint: 'search_materials'.tr(),
          ),
          const SizedBox(height: 12),

          // Filters Row
          Row(
            children: [
              // Subject Dropdown
              Expanded(
                child: CustomDropdown<SubjectEntity?>(
                  value: _findSubjectById(state.subjects, _selectedSubjectId),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('all_subjects'.tr()),
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
                    _loadMaterials();
                  },
                  hint: 'select_subject'.tr(),
                ),
              ),
              const SizedBox(width: 12),

              // File Type Dropdown
              Expanded(
                child: CustomDropdown<String?>(
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
                    _loadMaterials();
                  },
                  hint: 'file_type'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(BuildContext context, MaterialStateeee state) {
    if (state is MaterialLoading) {
      return const LoadingWidget(message: 'جارٍ تحميل المواد...');
    } else if (state is MaterialsLoaded) {
      final materials = state.materials;

      if (materials.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 80,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'no_materials'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'add_first_material'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          _loadMaterials();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: materials.length,
          itemBuilder: (context, index) {
            final material = materials[index];
            return MaterialCard(
              material: material,
              onDelete: () {
                _showDeleteDialog(context, material);
              },
              onDownload: () {
                _downloadMaterial(material);
              },
            );
          },
        ),
      );
    } else if (state is MaterialError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'try_again'.tr(),
              onPressed: _loadMaterials,
              isOutlined: true,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showDeleteDialog(BuildContext context, MaterialEntity material) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete'.tr()),
        content: Text('confirm_delete_material'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MaterialCubit>().deleteMaterial(material.id);
            },
            child: Text(
              'delete'.tr(),
              style: TextStyle(color: AppColors.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadMaterial(MaterialEntity material) {
    // تنزيل الملف
  }

  // Helper Methods
  SubjectEntity? _findSubjectById(List<SubjectEntity> subjects, String? id) {
    if (id == null || subjects.isEmpty) return null;
    try {
      return subjects.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }

  String _getFileTypeTranslation(String type) {
    switch (type) {
      case 'all':
        return 'all'.tr();
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
}
