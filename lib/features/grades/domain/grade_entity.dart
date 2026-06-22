// features/grades/domain/entities/grade_entity.dart
import 'package:equatable/equatable.dart';

class GradeEntity extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String examId;
  final String examTitle;
  final String subjectId;
  final String subjectName;
  final double marksObtained;
  final double totalMarks;
  final String grade;
  final String? comments;
  final DateTime createdAt;

  const GradeEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.examId,
    required this.examTitle,
    required this.subjectId,
    required this.subjectName,
    required this.marksObtained,
    required this.totalMarks,
    required this.grade,
    this.comments,
    required this.createdAt,
  });

  double get percentage =>
      totalMarks > 0 ? (marksObtained / totalMarks) * 100 : 0;

  @override
  List<Object?> get props => [id, studentId, examId, subjectId, marksObtained];
}

class GradeStatsEntity extends Equatable {
  final double average;
  final double highest;
  final double lowest;
  final int totalStudents;
  final Map<String, int> gradeDistribution;

  const GradeStatsEntity({
    required this.average,
    required this.highest,
    required this.lowest,
    required this.totalStudents,
    required this.gradeDistribution,
  });

  @override
  List<Object?> get props =>
      [average, highest, lowest, totalStudents, gradeDistribution];
}
