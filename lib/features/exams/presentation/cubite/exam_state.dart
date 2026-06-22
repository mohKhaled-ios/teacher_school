// import 'package:equatable/equatable.dart';
// import '../../domain/entities/exam.dart';

// abstract class ExamsState extends Equatable {
//   const ExamsState();

//   @override
//   List<Object?> get props => [];
// }

// class ExamsInitial extends ExamsState {}

// class ExamsLoading extends ExamsState {}

// class ExamsLoaded extends ExamsState {
//   final List<Exam> exams;

//   const ExamsLoaded(this.exams);

//   @override
//   List<Object?> get props => [exams];
// }

// class ExamCreated extends ExamsState {
//   final String message;

//   const ExamCreated(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class ExamDeleted extends ExamsState {
//   final String message;

//   const ExamDeleted(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class ExamsError extends ExamsState {
//   final String message;

//   const ExamsError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
// features/exams/presentation/cubit/exam_state.dart
import 'package:equatable/equatable.dart';
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';

abstract class ExamState extends Equatable {
  const ExamState();
  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamsLoaded extends ExamState {
  final List<ExamEntity> exams;
  const ExamsLoaded(this.exams);
  @override
  List<Object?> get props => [exams];
}

class ExamDetailLoaded extends ExamState {
  final ExamEntity exam;
  const ExamDetailLoaded(this.exam);
  @override
  List<Object?> get props => [exam];
}

class ExamCreated extends ExamState {
  final ExamEntity exam;
  const ExamCreated(this.exam);
  @override
  List<Object?> get props => [exam];
}

class ExamUpdated extends ExamState {
  final ExamEntity exam;
  const ExamUpdated(this.exam);
  @override
  List<Object?> get props => [exam];
}

class ExamDeleted extends ExamState {}

class ExamError extends ExamState {
  final String message;
  const ExamError(this.message);
  @override
  List<Object?> get props => [message];
}
