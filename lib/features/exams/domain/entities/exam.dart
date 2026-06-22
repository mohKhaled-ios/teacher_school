// import 'package:equatable/equatable.dart';

// class Exam extends Equatable {
//   final String id;
//   final String title;
//   final String subjectId;
//   final String subjectName;
//   final String classId;
//   final String className;
//   final DateTime date;
//   final int duration; // in minutes
//   final int totalMarks;
//   final List<Question> questions;
//   final DateTime createdAt;

//   const Exam({
//     required this.id,
//     required this.title,
//     required this.subjectId,
//     required this.subjectName,
//     required this.classId,
//     required this.className,
//     required this.date,
//     required this.duration,
//     required this.totalMarks,
//     required this.questions,
//     required this.createdAt,
//   });

//   bool get isUpcoming => date.isAfter(DateTime.now());
//   bool get isPast => date.isBefore(DateTime.now());
//   bool get isToday {
//     final now = DateTime.now();
//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         subjectId,
//         subjectName,
//         classId,
//         className,
//         date,
//         duration,
//         totalMarks,
//         questions,
//         createdAt,
//       ];
// }

// class Question extends Equatable {
//   final String id;
//   final String question;
//   final List<String> options;
//   final String correctAnswer;
//   final int marks;

//   const Question({
//     required this.id,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//     required this.marks,
//   });

//   @override
//   List<Object?> get props => [id, question, options, correctAnswer, marks];
// }
// features/exams/domain/entities/exam_entity.dart
import 'package:equatable/equatable.dart';

class ExamEntity extends Equatable {
  final String id;
  final String title;
  final String subjectId;
  final String subjectName;
  final String classId;
  final String className;
  final DateTime date;
  final int? duration; // in minutes
  final int? totalMarks;
  final List<ExamQuestion> questions;

  const ExamEntity({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.subjectName,
    required this.classId,
    required this.className,
    required this.date,
    this.duration,
    this.totalMarks,
    this.questions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subjectId,
        classId,
        date,
        duration,
        totalMarks,
      ];

  ExamEntity copyWith({
    String? id,
    String? title,
    String? subjectId,
    String? subjectName,
    String? classId,
    String? className,
    DateTime? date,
    int? duration,
    int? totalMarks,
    List<ExamQuestion>? questions,
  }) {
    return ExamEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      totalMarks: totalMarks ?? this.totalMarks,
      questions: questions ?? this.questions,
    );
  }
}

class ExamQuestion extends Equatable {
  final String question;
  final List<String> options;
  final String? correctAnswer;
  final int? marks;

  const ExamQuestion({
    required this.question,
    this.options = const [],
    this.correctAnswer,
    this.marks,
  });

  @override
  List<Object?> get props => [question, options, correctAnswer, marks];

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'marks': marks,
    };
  }

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'],
      marks: json['marks'],
    );
  }
}
