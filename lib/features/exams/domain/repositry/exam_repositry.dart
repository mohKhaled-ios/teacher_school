// features/exams/domain/repositories/exam_repository.dart
import 'package:dartz/dartz.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
import '../../../../core/errors/failures.dart';

abstract class ExamRepository {
  Future<Either<Failure, List<ExamEntity>>> getExams({
    String? subjectId,
    String? classId,
  });

  Future<Either<Failure, ExamEntity>> getExamById(String id);

  Future<Either<Failure, ExamEntity>> createExam(Map<String, dynamic> data);

  Future<Either<Failure, ExamEntity>> updateExam(
    String id,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, void>> deleteExam(String id);
}
