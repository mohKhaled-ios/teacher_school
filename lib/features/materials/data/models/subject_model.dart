// features/material/data/models/subject_model.dart
import 'package:hive/hive.dart';
import 'package:teacher_management_app/core/constants/hive_constants.dart';

import '../../domain/entities/subject_entity.dart';

part 'subject_model.g.dart';

@HiveType(typeId: HiveConstants.subjectTypeId)
class SubjectModel extends SubjectEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String code;

  @HiveField(3)
  @override
  final String? description;

  @HiveField(4)
  @override
  final String? teacherId;

  @HiveField(5)
  @override
  final String? classId;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.teacherId,
    this.classId,
  }) : super(
          id: id,
          name: name,
          code: code,
          description: description,
          teacherId: teacherId,
          classId: classId,
        );

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      teacherId: json['teacherId'],
      classId: json['classId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'teacherId': teacherId,
      'classId': classId,
    };
  }

  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      code: code,
      description: description,
      teacherId: teacherId,
      classId: classId,
    );
  }
}