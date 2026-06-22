// features/exams/data/repositories/exam_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';
import 'package:teacher_management_app/features/exams/domain/repositry/exam_repositry.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';

import '../models/exam_model.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ApiClient apiClient;

  ExamRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<ExamEntity>>> getExams({
    String? subjectId,
    String? classId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (subjectId != null) queryParams['subjectId'] = subjectId;
      if (classId != null) queryParams['classId'] = classId;

      final response = await apiClient.getExams(queryParams: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final exams =
            data.map((json) => ExamModel.fromJson(json).toEntity()).toList();
        return Right(exams);
      } else {
        return Left(ServerFailure(
          response.data['message'] ?? 'فشل تحميل الامتحانات',
          statusCode: response.statusCode,
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> getExamById(String id) async {
    try {
      final response = await apiClient.getExamById(id);

      if (response.statusCode == 200) {
        return Right(ExamModel.fromJson(response.data).toEntity());
      } else {
        return Left(ServerFailure(
          response.data['message'] ?? 'فشل تحميل الامتحان',
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> createExam(
      Map<String, dynamic> data) async {
    try {
      final response = await apiClient.createExam(data);

      if (response.statusCode == 201) {
        return Right(ExamModel.fromJson(response.data).toEntity());
      } else {
        return Left(ServerFailure(
          response.data['message'] ?? 'فشل إنشاء الامتحان',
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExamEntity>> updateExam(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.updateExam(id, data);

      if (response.statusCode == 200) {
        return Right(ExamModel.fromJson(response.data).toEntity());
      } else {
        return Left(ServerFailure(
          response.data['message'] ?? 'فشل تحديث الامتحان',
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExam(String id) async {
    try {
      final response = await apiClient.deleteExam(id);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure(
          response.data['message'] ?? 'فشل حذف الامتحان',
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
