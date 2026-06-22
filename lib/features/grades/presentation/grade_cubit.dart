// features/grades/presentation/cubit/grade_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_management_app/features/grades/domain/grade_repository.dart';
import 'grade_state.dart';

class GradeCubit extends Cubit<GradeState> {
  final GradeRepository gradeRepository;

  GradeCubit({required this.gradeRepository}) : super(GradeInitial());

  Future<void> loadGrades({
    String? studentId,
    String? subjectId,
    String? examId,
  }) async {
    emit(GradeLoading());
    final result = await gradeRepository.getGrades(
      studentId: studentId,
      subjectId: subjectId,
      examId: examId,
    );
    result.fold(
      (failure) => emit(GradeError(failure.message)),
      (grades) => emit(GradesLoaded(grades)),
    );
  }

  Future<void> addGrade(Map<String, dynamic> data) async {
    emit(GradeLoading());
    final result = await gradeRepository.addGrade(data);
    result.fold(
      (failure) => emit(GradeError(failure.message)),
      (grade) => emit(GradeAdded(grade)),
    );
  }

  Future<void> loadGradeStats({
    String? classId,
    String? subjectId,
    String? examId,
  }) async {
    emit(GradeLoading());
    final result = await gradeRepository.getGradeStats(
      classId: classId,
      subjectId: subjectId,
      examId: examId,
    );
    result.fold(
      (failure) => emit(GradeError(failure.message)),
      (stats) => emit(GradeStatsLoaded(stats)),
    );
  }
}
