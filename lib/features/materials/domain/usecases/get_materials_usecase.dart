// features/material/domain/usecases/get_materials_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/material_entity.dart';
import '../repositories/material_repository.dart';

class GetMaterialsUseCase {
  final MaterialRepository repository;

  GetMaterialsUseCase(this.repository);

  Future<Either<Failure, List<MaterialEntity>>> call({
    String? subjectId,
    String? classId,
    String? fileType,
  }) async {
    return await repository.getMaterials(
      subjectId: subjectId,
      classId: classId,
      fileType: fileType,
    );
  }
}
