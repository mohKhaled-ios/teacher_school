// // features/material/domain/repositories/material_repository.dart
// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failures.dart';
// import '../entities/material_entity.dart';
// import '../entities/subject_entity.dart';
// import 'package:dio/dio.dart';

// abstract class MaterialRepository {
//   Future<Either<Failure, List<MaterialEntity>>> getMaterials({
//     String? subjectId,
//     String? classId,
//     String? fileType,
//   });

//   Future<Either<Failure, List<SubjectEntity>>> getSubjects({
//     String? classId,
//     String? teacherId,
//   });

//   Future<Either<Failure, MaterialEntity>> uploadMaterial(FormData formData);
//   Future<Either<Failure, void>> deleteMaterial(String materialId);
// }
// features/material/domain/repositories/material_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/material_entity.dart';
import '../entities/subject_entity.dart';
import '../entities/class_entity.dart';
import 'package:dio/dio.dart';

abstract class MaterialRepository {
  Future<Either<Failure, List<MaterialEntity>>> getMaterials({
    String? subjectId,
    String? classId,
    String? fileType,
  });

  Future<Either<Failure, List<SubjectEntity>>> getSubjects({
    String? classId,
    String? teacherId,
  });

  Future<Either<Failure, List<ClassEntity>>> getClasses();

  Future<Either<Failure, MaterialEntity>> uploadMaterial(FormData formData);
  Future<Either<Failure, void>> deleteMaterial(String materialId);
}
