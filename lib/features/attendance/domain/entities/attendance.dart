import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String classId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;

  const Attendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.date,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        studentName,
        classId,
        date,
        status,
        notes,
      ];
}

enum AttendanceStatus {
  present,
  absent,
  late;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'حاضر';
      case AttendanceStatus.absent:
        return 'غائب';
      case AttendanceStatus.late:
        return 'متأخر';
    }
  }

  String get value {
    switch (this) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.late:
        return 'late';
    }
  }

  static AttendanceStatus fromString(String value) {
    switch (value) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      default:
        return AttendanceStatus.absent;
    }
  }
}

class Student extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, email, profileImage];
}

class ClassModel extends Equatable {
  final String id;
  final String name;
  final String grade;
  final String? section;

  const ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    this.section,
  });

  @override
  List<Object?> get props => [id, name, grade, section];
}
