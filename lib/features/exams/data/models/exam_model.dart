// // features/exams/data/models/exam_model.dart
// import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';

// class ExamModel extends ExamEntity {
//   const ExamModel({
//     required super.id,
//     required super.title,
//     required super.subjectId,
//     required super.subjectName,
//     required super.classId,
//     required super.className,
//     required super.date,
//     super.duration,
//     super.totalMarks,
//     super.questions,
//   });

//   factory ExamModel.fromJson(Map<String, dynamic> json) {
//     return ExamModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       title: json['title'] ?? '',
//       subjectId: json['subjectId']?['_id'] ?? json['subjectId'] ?? '',
//       subjectName: json['subjectId']?['name'] ?? '',
//       classId: json['classId']?['_id'] ?? json['classId'] ?? '',
//       className: json['classId']?['name'] ?? '',
//       date:
//           json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
//       duration: json['duration'],
//       totalMarks: json['totalMarks'],
//       questions: (json['questions'] as List<dynamic>?)
//               ?.map((q) => ExamQuestion.fromJson(q))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'subjectId': subjectId,
//       'classId': classId,
//       'date': date.toIso8601String(),
//       'duration': duration,
//       'totalMarks': totalMarks,
//       'questions': questions.map((q) => q.toJson()).toList(),
//     };
//   }

//   ExamEntity toEntity() => ExamEntity(
//         id: id,
//         title: title,
//         subjectId: subjectId,
//         subjectName: subjectName,
//         classId: classId,
//         className: className,
//         date: date,
//         duration: duration,
//         totalMarks: totalMarks,
//         questions: questions,
//       );
// }
// features/exams/data/models/exam_model.dart
import 'package:teacher_management_app/features/exams/domain/entities/exam.dart';

class ExamModel extends ExamEntity {
  const ExamModel({
    required super.id,
    required super.title,
    required super.subjectId,
    required super.subjectName,
    required super.classId,
    required super.className,
    required super.date,
    super.duration,
    super.totalMarks,
    super.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subjectId: _extractId(json['subjectId']),
      subjectName: _extractName(json['subjectId']),
      classId: _extractId(json['classId']),
      className: _extractName(json['classId']),
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      duration: json['duration'] as int?,
      totalMarks: json['totalMarks'] as int?,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// لو value عبارة عن Map (populated) نجيب _id منه
  /// لو عبارة عن String مباشرة نرجعها كما هي
  static String _extractId(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString() ?? '';
    }
    return value.toString();
  }

  /// نجيب name بس لو الـ value كانت Map (populated)
  static String _extractName(dynamic value) {
    if (value is Map) return value['name']?.toString() ?? '';
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subjectId': subjectId,
      'classId': classId,
      'date': date.toIso8601String(),
      'duration': duration,
      'totalMarks': totalMarks,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  ExamEntity toEntity() => ExamEntity(
        id: id,
        title: title,
        subjectId: subjectId,
        subjectName: subjectName,
        classId: classId,
        className: className,
        date: date,
        duration: duration,
        totalMarks: totalMarks,
        questions: questions,
      );
}
