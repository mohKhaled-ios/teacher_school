// features/material/data/models/class_model.dart
import 'package:hive/hive.dart';
import 'package:teacher_management_app/core/constants/hive_constants.dart';
import '../../domain/entities/class_entity.dart';

part 'class_model.g.dart';

@HiveType(typeId: HiveConstants.classTypeId)
class ClassModel extends ClassEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String grade;

  @HiveField(3)
  @override
  final String section;

  @HiveField(4)
  @override
  final int capacity;

  const ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.capacity,
  }) : super(
          id: id,
          name: name,
          grade: grade,
          section: section,
          capacity: capacity,
        );

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      section: json['section'] ?? '',
      capacity: json['capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'section': section,
      'capacity': capacity,
    };
  }

  ClassEntity toEntity() {
    return ClassEntity(
      id: id,
      name: name,
      grade: grade,
      section: section,
      capacity: capacity,
    );
  }
}
