// features/material/domain/usecases/get_subjects_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subject_entity.dart';
import '../repositories/material_repository.dart';

class GetSubjectsUseCase {
  final MaterialRepository repository;

  GetSubjectsUseCase(this.repository);

  Future<Either<Failure, List<SubjectEntity>>> call({
    String? classId,
    String? teacherId,
  }) async {
    return await repository.getSubjects(
      classId: classId,
      teacherId: teacherId,
    );
  }
}
