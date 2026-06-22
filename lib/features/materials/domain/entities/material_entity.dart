// features/material/domain/entities/material_entity.dart
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class MaterialEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String subjectName;
  final String classId;
  final String className;
  final String teacherId;
  final String teacherName;
  final String fileType;
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final DateTime createdAt;

  const MaterialEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.subjectName,
    required this.classId,
    required this.className,
    required this.teacherId,
    required this.teacherName,
    required this.fileType,
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        subjectId,
        classId,
        teacherId,
        fileType,
        fileUrl,
        fileName,
        fileSize,
        createdAt,
      ];

  MaterialEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? subjectId,
    String? subjectName,
    String? classId,
    String? className,
    String? teacherId,
    String? teacherName,
    String? fileType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    DateTime? createdAt,
  }) {
    return MaterialEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}