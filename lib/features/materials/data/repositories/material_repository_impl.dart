// // features/material/data/repositories/material_repository_impl.dart
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/errors/failures.dart';
// import '../../domain/entities/material_entity.dart';
// import '../../domain/entities/subject_entity.dart';
// import '../../domain/repositories/material_repository.dart';
// import '../datasources/material_local_datasource.dart';
// import '../datasources/material_remote_datasource.dart';
// import '../models/material_model.dart';
// import '../models/subject_model.dart';

// class MaterialRepositoryImpl implements MaterialRepository {
//   final MaterialRemoteDataSource remoteDataSource;
//   final MaterialLocalDataSource localDataSource;

//   MaterialRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//   });

//   @override
//   Future<Either<Failure, List<MaterialEntity>>> getMaterials({
//     String? subjectId,
//     String? classId,
//     String? fileType,
//   }) async {
//     try {
//       final materials = await remoteDataSource.getMaterials(
//         subjectId: subjectId,
//         classId: classId,
//         fileType: fileType,
//       );

//       // Cache the materials
//       await localDataSource.cacheMaterials(materials);

//       return Right(materials.map((model) => model.toEntity()).toList());
//     } on Exception catch (e) {
//       // Try to get cached materials
//       try {
//         final cachedMaterials = await localDataSource.getCachedMaterials();
//         if (cachedMaterials.isNotEmpty) {
//           return Right(
//               cachedMaterials.map((model) => model.toEntity()).toList());
//         }
//         return Left(ServerFailure(e.toString()));
//       } catch (_) {
//         return Left(ServerFailure(e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, List<SubjectEntity>>> getSubjects({
//     String? classId,
//     String? teacherId,
//   }) async {
//     try {
//       final subjects = await remoteDataSource.getSubjects(
//         classId: classId,
//         teacherId: teacherId,
//       );

//       return Right(subjects.map((model) => model.toEntity()).toList());
//     } on Exception catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, MaterialEntity>> uploadMaterial(
//     FormData formData,
//   ) async {
//     try {
//       final material = await remoteDataSource.uploadMaterial(formData);

//       // Clear cache to refresh data
//       await localDataSource.clearMaterialsCache();

//       return Right(material.toEntity());
//     } on Exception catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteMaterial(String materialId) async {
//     try {
//       await remoteDataSource.deleteMaterial(materialId);

//       // Clear cache to refresh data
//       await localDataSource.clearMaterialsCache();

//       return const Right(null);
//     } on Exception catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
// features/material/data/repositories/material_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/material_repository.dart';
import '../datasources/material_local_datasource.dart';
import '../datasources/material_remote_datasource.dart';
import '../models/material_model.dart';
import '../models/subject_model.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  final MaterialRemoteDataSource remoteDataSource;
  final MaterialLocalDataSource localDataSource;

  MaterialRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MaterialEntity>>> getMaterials({
    String? subjectId,
    String? classId,
    String? fileType,
  }) async {
    try {
      final materials = await remoteDataSource.getMaterials(
        subjectId: subjectId,
        classId: classId,
        fileType: fileType,
      );

      // Cache the materials
      await localDataSource.cacheMaterials(materials);

      return Right(materials.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      // Try to get cached materials
      try {
        final cachedMaterials = await localDataSource.getCachedMaterials();
        if (cachedMaterials.isNotEmpty) {
          return Right(
              cachedMaterials.map((model) => model.toEntity()).toList());
        }
        return Left(ServerFailure(e.toString()));
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjects({
    String? classId,
    String? teacherId,
  }) async {
    try {
      final subjects = await remoteDataSource.getSubjects(
        classId: classId,
        teacherId: teacherId,
      );

      return Right(subjects.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassEntity>>> getClasses() async {
    try {
      final classes = await remoteDataSource.getClasses();
      return Right(classes.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaterialEntity>> uploadMaterial(
    FormData formData,
  ) async {
    try {
      final material = await remoteDataSource.uploadMaterial(formData);

      // Clear cache to refresh data
      await localDataSource.clearMaterialsCache();

      return Right(material.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterial(String materialId) async {
    try {
      await remoteDataSource.deleteMaterial(materialId);

      // Clear cache to refresh data
      await localDataSource.clearMaterialsCache();

      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
