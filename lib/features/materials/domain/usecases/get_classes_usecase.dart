// features/material/domain/usecases/get_classes_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/class_entity.dart';
import '../repositories/material_repository.dart';

class GetClassesUseCase {
  final MaterialRepository repository;

  GetClassesUseCase(this.repository);

  Future<Either<Failure, List<ClassEntity>>> call() async {
    return await repository.getClasses();
  }
}
