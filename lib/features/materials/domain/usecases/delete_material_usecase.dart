// features/material/domain/usecases/delete_material_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/material_repository.dart';

class DeleteMaterialUseCase {
  final MaterialRepository repository;

  DeleteMaterialUseCase(this.repository);

  Future<Either<Failure, void>> call(String materialId) async {
    return await repository.deleteMaterial(materialId);
  }
}
