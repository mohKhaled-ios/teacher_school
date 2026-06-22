// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:teacher_management_app/features/exams/presentation/cubite/exam_state.dart';
// import '../../domain/entities/exam.dart';
// import '../../data/models/exam_model.dart';

// class ExamsCubit extends Cubit<ExamsState> {
//   ExamsCubit() : super(ExamsInitial());

//   List<Exam> _allExams = [];

//   Future<void> loadExams() async {
//     emit(ExamsLoading());

//     try {
//       await Future.delayed(const Duration(seconds: 1));

//       // Mock data
//       _allExams = [
//         ExamModel(
//           id: '1',
//           title: 'امتحان الرياضيات - الفصل الأول',
//           subjectId: '1',
//           subjectName: 'الرياضيات',
//           classId: '1',
//           className: 'الصف الأول',
//           date: DateTime.now().add(const Duration(days: 3)),
//           duration: 90,
//           totalMarks: 50,
//           questions: [
//             const QuestionModel(
//               id: '1',
//               question: 'ما هو ناتج 5 + 3؟',
//               options: ['6', '7', '8', '9'],
//               correctAnswer: '8',
//               marks: 2,
//             ),
//             const QuestionModel(
//               id: '2',
//               question: 'ما هو ناتج 10 - 4؟',
//               options: ['4', '5', '6', '7'],
//               correctAnswer: '6',
//               marks: 2,
//             ),
//           ],
//           createdAt: DateTime.now().subtract(const Duration(days: 2)),
//         ),
//         ExamModel(
//           id: '2',
//           title: 'امتحان العلوم - الوحدة الثانية',
//           subjectId: '2',
//           subjectName: 'العلوم',
//           classId: '2',
//           className: 'الصف الثاني',
//           date: DateTime.now().add(const Duration(days: 7)),
//           duration: 60,
//           totalMarks: 40,
//           questions: [],
//           createdAt: DateTime.now().subtract(const Duration(days: 1)),
//         ),
//         ExamModel(
//           id: '3',
//           title: 'امتحان اللغة العربية',
//           subjectId: '3',
//           subjectName: 'اللغة العربية',
//           classId: '1',
//           className: 'الصف الأول',
//           date: DateTime.now().subtract(const Duration(days: 2)),
//           duration: 120,
//           totalMarks: 60,
//           questions: [],
//           createdAt: DateTime.now().subtract(const Duration(days: 5)),
//         ),
//       ];

//       emit(ExamsLoaded(_allExams));
//     } catch (e) {
//       emit(ExamsError(e.toString()));
//     }
//   }

//   Future<void> createExam(Exam exam, {
//     required String title,
//     required String subjectId,
//     required String classId,
//     required DateTime date,
//     required int duration,
//     required int totalMarks,
//     required List<Question> questions,
//   }) async {
//     emit(ExamsLoading());

//     try {
//       await Future.delayed(const Duration(seconds: 1));

//       final newExam = ExamModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: title,
//         subjectId: subjectId,
//         subjectName: 'المادة',
//         classId: classId,
//         className: 'الصف',
//         date: date,
//         duration: duration,
//         totalMarks: totalMarks,
//         questions: questions,
//         createdAt: DateTime.now(),
//       );

//       _allExams.add(newExam);

//       emit(const ExamCreated('تم إنشاء الامتحان بنجاح'));
//       await loadExams();
//     } catch (e) {
//       emit(ExamsError(e.toString()));
//     }
//   }

//   Future<void> deleteExam(String id) async {
//     emit(ExamsLoading());

//     try {
//       await Future.delayed(const Duration(milliseconds: 500));

//       _allExams.removeWhere((exam) => exam.id == id);

//       emit(const ExamDeleted('تم حذف الامتحان بنجاح'));
//       await loadExams();
//     } catch (e) {
//       emit(ExamsError(e.toString()));
//     }
//   }

//   void filterByStatus(String status) {
//     List<Exam> filtered;

//     switch (status) {
//       case 'upcoming':
//         filtered = _allExams.where((exam) => exam.isUpcoming).toList();
//         break;
//       case 'past':
//         filtered = _allExams.where((exam) => exam.isPast).toList();
//         break;
//       case 'today':
//         filtered = _allExams.where((exam) => exam.isToday).toList();
//         break;
//       default:
//         filtered = _allExams;
//     }

//     emit(ExamsLoaded(filtered));
//   }
// }
// features/exams/presentation/cubit/exam_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_management_app/features/exams/domain/repositry/exam_repositry.dart';

import 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository examRepository;

  ExamCubit({required this.examRepository}) : super(ExamInitial());

  Future<void> loadExams({String? subjectId, String? classId}) async {
    emit(ExamLoading());
    final result = await examRepository.getExams(
      subjectId: subjectId,
      classId: classId,
    );
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (exams) => emit(ExamsLoaded(exams)),
    );
  }

  Future<void> loadExamById(String id) async {
    emit(ExamLoading());
    final result = await examRepository.getExamById(id);
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (exam) => emit(ExamDetailLoaded(exam)),
    );
  }

  Future<void> createExam(Map<String, dynamic> data) async {
    emit(ExamLoading());
    final result = await examRepository.createExam(data);
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (exam) => emit(ExamCreated(exam)),
    );
  }

  Future<void> updateExam(String id, Map<String, dynamic> data) async {
    emit(ExamLoading());
    final result = await examRepository.updateExam(id, data);
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (exam) => emit(ExamUpdated(exam)),
    );
  }

  Future<void> deleteExam(String id) async {
    emit(ExamLoading());
    final result = await examRepository.deleteExam(id);
    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (_) => emit(ExamDeleted()),
    );
  }
}
