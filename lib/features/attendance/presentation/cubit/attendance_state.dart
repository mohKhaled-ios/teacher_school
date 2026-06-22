import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class ClassesLoaded extends AttendanceState {
  final List<ClassModel> classes;

  const ClassesLoaded(this.classes);

  @override
  List<Object?> get props => [classes];
}

class StudentsLoaded extends AttendanceState {
  final List<Student> students;
  final Map<String, AttendanceStatus> attendanceMap;

  const StudentsLoaded(this.students, this.attendanceMap);

  @override
  List<Object?> get props => [students, attendanceMap];
}

class AttendanceMarked extends AttendanceState {
  final String message;

  const AttendanceMarked(this.message);

  @override
  List<Object?> get props => [message];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
