// features/material/presentation/widgets/material_card.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/material_entity.dart';

class MaterialCard extends StatelessWidget {
  final MaterialEntity material;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  const MaterialCard({
    super.key,
    required this.material,
    required this.onDelete,
    required this.onDownload,
  });

  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      default:
        return Icons.description;
    }
  }

  Color _getFileColor(String fileType, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (fileType) {
      case 'pdf':
        return AppColors.errorLight;
      case 'video':
        return AppColors.infoLight;
      case 'image':
        return AppColors.successLight;
      default:
        return isDark ? AppColors.primaryDark : AppColors.primaryLight;
    }
  }

  String _formatFileSize(int size) {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // File Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    _getFileColor(material.fileType, context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileIcon(material.fileType),
                color: _getFileColor(material.fileType, context),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // File Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    material.subjectName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        material.fileName,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatFileSize(material.fileSize),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        material.createdAt.day.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.download, size: 20),
                      const SizedBox(width: 8),
                      Text('download'.tr()),
                    ],
                  ),
                  onTap: onDownload,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'delete'.tr(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
