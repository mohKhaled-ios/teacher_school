// features/grades/presentation/cubit/grade_state.dart
import 'package:equatable/equatable.dart';
import 'package:teacher_management_app/features/grades/domain/grade_entity.dart';

abstract class GradeState extends Equatable {
  const GradeState();
  @override
  List<Object?> get props => [];
}

class GradeInitial extends GradeState {}

class GradeLoading extends GradeState {}

class GradesLoaded extends GradeState {
  final List<GradeEntity> grades;
  const GradesLoaded(this.grades);
  @override
  List<Object?> get props => [grades];
}

class GradeAdded extends GradeState {
  final GradeEntity grade;
  const GradeAdded(this.grade);
  @override
  List<Object?> get props => [grade];
}

class GradeStatsLoaded extends GradeState {
  final GradeStatsEntity stats;
  const GradeStatsLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class GradeError extends GradeState {
  final String message;
  const GradeError(this.message);
  @override
  List<Object?> get props => [message];
}
