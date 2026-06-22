// import '../../domain/entities/attendance.dart';

// class AttendanceModel extends Attendance {
//   const AttendanceModel({
//     required super.id,
//     required super.studentId,
//     required super.studentName,
//     required super.classId,
//     required super.date,
//     required super.status,
//     super.notes,
//   });

//   factory AttendanceModel.fromJson(Map<String, dynamic> json) {
//     return AttendanceModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       studentId: json['studentId']?['_id'] ?? json['studentId'] ?? '',
//       studentName: json['studentId']?['name'] ?? '',
//       classId: json['classId']?['_id'] ?? json['classId'] ?? '',
//       date: DateTime.parse(json['date']),
//       status: AttendanceStatus.fromString(json['status']),
//       notes: json['notes'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'studentId': studentId,
//       'classId': classId,
//       'date': date.toIso8601String(),
//       'status': status.value,
//       'notes': notes,
//     };
//   }
// }

// class StudentModel extends Student {
//   const StudentModel({
//     required super.id,
//     required super.name,
//     required super.email,
//     super.profileImage,
//   });

//   factory StudentModel.fromJson(Map<String, dynamic> json) {
//     return StudentModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       profileImage: json['profileImage'],
//     );
//   }
// }

// class ClassModelData extends ClassModel {
//   const ClassModelData({
//     required super.id,
//     required super.name,
//     required super.grade,
//     super.section,
//   });

//   factory ClassModelData.fromJson(Map<String, dynamic> json) {
//     return ClassModelData(
//       id: json['_id'] ?? json['id'] ?? '',
//       name: json['name'] ?? '',
//       grade: json['grade'] ?? '',
//       section: json['section'],
//     );
//   }
// }
import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.classId,
    required super.date,
    required super.status,
    super.notes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] ?? json['id'] ?? '',
      studentId: json['studentId']?['_id'] ?? json['studentId'] ?? '',
      studentName: json['studentId']?['name'] ?? json['studentName'] ?? '',
      classId: json['classId']?['_id'] ?? json['classId'] ?? '',
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.fromString(json['status']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'classId': classId,
      'date': date.toIso8601String(),
      'status': status.value,
      'notes': notes,
    };
  }
}

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class ClassModelData extends ClassModel {
  const ClassModelData({
    required super.id,
    required super.name,
    required super.grade,
    super.section,
  });

  factory ClassModelData.fromJson(Map<String, dynamic> json) {
    return ClassModelData(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      section: json['section'],
    );
  }
}
