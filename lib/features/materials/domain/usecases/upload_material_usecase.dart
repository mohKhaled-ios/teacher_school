// features/material/domain/usecases/upload_material_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../entities/material_entity.dart';
import '../repositories/material_repository.dart';

class UploadMaterialUseCase {
  final MaterialRepository repository;

  UploadMaterialUseCase(this.repository);

  Future<Either<Failure, MaterialEntity>> call(FormData formData) async {
    return await repository.uploadMaterial(formData);
  }
}
