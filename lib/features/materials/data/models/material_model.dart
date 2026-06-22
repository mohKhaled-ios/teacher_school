// features/material/data/models/material_model.dart
import 'package:hive/hive.dart';
import 'package:teacher_management_app/core/constants/hive_constants.dart';
import '../../domain/entities/material_entity.dart';


part 'material_model.g.dart';

@HiveType(typeId: HiveConstants.materialTypeId)
class MaterialModel extends MaterialEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String subjectId;

  @HiveField(4)
  final String subjectName;

  @HiveField(5)
  final String classId;

  @HiveField(6)
  final String className;

  @HiveField(7)
  final String teacherId;

  @HiveField(8)
  final String teacherName;

  @HiveField(9)
  final String fileType;

  @HiveField(10)
  final String fileUrl;

  @HiveField(11)
  final String fileName;

  @HiveField(12)
  final int fileSize;

  @HiveField(13)
  final DateTime createdAt;

  const MaterialModel({
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
  }) : super(
          id: id,
          title: title,
          description: description,
          subjectId: subjectId,
          subjectName: subjectName,
          classId: classId,
          className: className,
          teacherId: teacherId,
          teacherName: teacherName,
          fileType: fileType,
          fileUrl: fileUrl,
          fileName: fileName,
          fileSize: fileSize,
          createdAt: createdAt,
        );

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subjectId: json['subjectId']?['_id'] ?? json['subjectId'] ?? '',
      subjectName: json['subjectId']?['name'] ?? '',
      classId: json['classId']?['_id'] ?? json['classId'] ?? '',
      className: json['classId']?['name'] ?? '',
      teacherId: json['teacherId']?['_id'] ?? json['teacherId'] ?? '',
      teacherName: json['teacherId']?['name'] ?? '',
      fileType: json['fileType'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileName: json['fileName'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'classId': classId,
      'className': className,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MaterialEntity toEntity() {
    return MaterialEntity(
      id: id,
      title: title,
      description: description,
      subjectId: subjectId,
      subjectName: subjectName,
      classId: classId,
      className: className,
      teacherId: teacherId,
      teacherName: teacherName,
      fileType: fileType,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      createdAt: createdAt,
    );
  }
}