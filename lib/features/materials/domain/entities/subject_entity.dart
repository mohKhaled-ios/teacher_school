// features/material/domain/entities/subject_entity.dart
class SubjectEntity {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String? teacherId;
  final String? classId;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.teacherId,
    this.classId,
  });
}