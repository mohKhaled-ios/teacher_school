// features/grades/data/models/grade_model.dart
import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';

class GradeModel extends GradeEntity {
  const GradeModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.examId,
    required super.examTitle,
    required super.subjectId,
    required super.subjectName,
    required super.marksObtained,
    required super.totalMarks,
    required super.grade,
    super.comments,
    required super.createdAt,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['_id'] ?? json['id'] ?? '',
      studentId: json['studentId']?['_id'] ?? json['studentId'] ?? '',
      studentName: json['studentId']?['name'] ?? '',
      examId: json['examId']?['_id'] ?? json['examId'] ?? '',
      examTitle: json['examId']?['title'] ?? '',
      subjectId: json['subjectId']?['_id'] ?? json['subjectId'] ?? '',
      subjectName: json['subjectId']?['name'] ?? '',
      marksObtained: (json['marksObtained'] ?? 0).toDouble(),
      totalMarks: (json['totalMarks'] ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      comments: json['comments'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  GradeEntity toEntity() => GradeEntity(
        id: id,
        studentId: studentId,
        studentName: studentName,
        examId: examId,
        examTitle: examTitle,
        subjectId: subjectId,
        subjectName: subjectName,
        marksObtained: marksObtained,
        totalMarks: totalMarks,
        grade: grade,
        comments: comments,
        createdAt: createdAt,
      );
}

class GradeStatsModel extends GradeStatsEntity {
  const GradeStatsModel({
    required super.average,
    required super.highest,
    required super.lowest,
    required super.totalStudents,
    required super.gradeDistribution,
  });

  factory GradeStatsModel.fromJson(Map<String, dynamic> json) {
    return GradeStatsModel(
      average: (json['average'] ?? 0).toDouble(),
      highest: (json['highest'] ?? 0).toDouble(),
      lowest: (json['lowest'] ?? 0).toDouble(),
      totalStudents: json['totalStudents'] ?? 0,
      gradeDistribution: Map<String, int>.from(
        (json['gradeDistribution'] ?? {}).map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        ),
      ),
    );
  }
}
