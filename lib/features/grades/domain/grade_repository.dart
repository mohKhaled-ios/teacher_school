import 'package:dartz/dartz.dart';
import 'package:teacher_management_app/core/network/api_client.dart';
import 'package:teacher_management_app/features/grades/data/grade_model.dart';
import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class GradeRepository {
  Future<Either<Failure, GradeEntity>> addGrade(Map<String, dynamic> data);

  Future<Either<Failure, List<GradeEntity>>> getGrades({
    String? studentId,
    String? subjectId,
    String? examId,
  });

  Future<Either<Failure, GradeStatsEntity>> getGradeStats({
    String? classId,
    String? subjectId,
    String? examId,
  });
}

// ========== IMPLEMENTATION ==========

class GradeRepositoryImpl implements GradeRepository {
  final ApiClient apiClient;

  GradeRepositoryImpl({required this.apiClient});

  // ── helper: استخرج رسالة الخطأ بأمان بغض النظر عن نوع response.data ──
  String _extractMessage(dynamic data, String fallback) {
    if (data is Map) {
      return data['message']?.toString() ?? fallback;
    }
    return fallback;
  }

  @override
  Future<Either<Failure, GradeEntity>> addGrade(
      Map<String, dynamic> data) async {
    try {
      final response = await apiClient.addGrade(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(GradeModel.fromJson(response.data).toEntity());
      }
      return Left(ServerFailure(
        _extractMessage(response.data, 'فشل إضافة الدرجة'),
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GradeEntity>>> getGrades({
    String? studentId,
    String? subjectId,
    String? examId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (studentId != null) queryParams['studentId'] = studentId;
      if (subjectId != null) queryParams['subjectId'] = subjectId;
      if (examId != null) queryParams['examId'] = examId;

      final response = await apiClient.getGrades(queryParams: queryParams);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return Right(
            data
                .map((j) => GradeModel.fromJson(
                      Map<String, dynamic>.from(j),
                    ).toEntity())
                .toList(),
          );
        }
        // لو رجع object مش list
        return const Right([]);
      }

      return Left(ServerFailure(
        _extractMessage(response.data, 'فشل تحميل الدرجات'),
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GradeStatsEntity>> getGradeStats({
    String? classId,
    String? subjectId,
    String? examId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (classId != null) queryParams['classId'] = classId;
      if (subjectId != null) queryParams['subjectId'] = subjectId;
      if (examId != null) queryParams['examId'] = examId;

      final response = await apiClient.getGradeStats(queryParams: queryParams);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return Right(GradeStatsModel.fromJson(data));
        }
        // fallback لو البيانات مش بالشكل المتوقع
        return Right(const GradeStatsEntity(
          average: 0,
          highest: 0,
          lowest: 0,
          totalStudents: 0,
          gradeDistribution: {},
        ));
      }

      return Left(ServerFailure(
        _extractMessage(response.data, 'فشل تحميل الإحصائيات'),
        statusCode: response.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
