// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/constants/api_constants.dart';
// import '../../data/models/attendance_model.dart';
// import '../../domain/entities/attendance.dart';
// import 'attendance_state.dart';

// class AttendanceCubit extends Cubit<AttendanceState> {
//   final ApiClient _apiClient;
//   final Dio _dio;

//   AttendanceCubit(this._apiClient)
//       : _dio = _apiClient.dio,
//         super(AttendanceInitial());

//   final Map<String, AttendanceStatus> _attendanceMap = {};
//   List<Student> _students = [];
//   String? _classId;
//   DateTime _date = DateTime.now();

//   // ================= Classes =================
//   Future<void> loadClasses() async {
//     emit(AttendanceLoading());
//     try {
//       final res = await _dio.get(ApiConstants.classes);
//       final classes =
//           (res.data as List).map((e) => ClassModelData.fromJson(e)).toList();
//       emit(ClassesLoaded(classes));
//     } catch (_) {
//       emit(const AttendanceError('فشل تحميل الصفوف'));
//     }
//   }

//   // ================= Students =================
//   Future<void> loadStudents(String classId) async {
//     emit(AttendanceLoading());
//     _classId = classId;
//     _attendanceMap.clear();

//     try {
//       final res = await _dio.get(
//         ApiConstants.getStudentsByClass.replaceAll('{classId}', classId),
//       );

//       _students =
//           (res.data as List).map((e) => StudentModel.fromJson(e)).toList();

//       await _loadExistingAttendance();

//       emit(StudentsLoaded(_students, Map.from(_attendanceMap)));
//     } catch (_) {
//       emit(const AttendanceError('فشل تحميل الطلاب'));
//     }
//   }

//   // ================= Existing Attendance =================
//   Future<void> _loadExistingAttendance() async {
//     final start =
//         DateTime(_date.year, _date.month, _date.day).toIso8601String();
//     final end = DateTime(_date.year, _date.month, _date.day, 23, 59, 59)
//         .toIso8601String();

//     try {
//       final res = await _dio.get(
//         ApiConstants.attendance,
//         queryParameters: {
//           'classId': _classId,
//           'startDate': start,
//           'endDate': end,
//         },
//       );

//       for (var item in res.data) {
//         final att = AttendanceModel.fromJson(item);
//         _attendanceMap[att.studentId] = att.status;
//       }
//     } catch (_) {}

//     for (var s in _students) {
//       _attendanceMap.putIfAbsent(s.id, () => AttendanceStatus.present);
//     }
//   }

//   // ================= Actions =================
//   void updateAttendance(String id, AttendanceStatus status) {
//     _attendanceMap[id] = status;
//     emit(StudentsLoaded(_students, Map.from(_attendanceMap)));
//   }

//   void setDate(DateTime date) {
//     _date = date;
//     if (_classId != null) loadStudents(_classId!);
//   }

//   Future<void> submitAttendance() async {
//     if (_classId == null) {
//       emit(const AttendanceError('اختر الصف أولًا'));
//       return;
//     }

//     emit(AttendanceLoading());

//     try {
//       for (var s in _students) {
//         await _dio.post(
//           ApiConstants.attendance,
//           data: {
//             'studentId': s.id,
//             'classId': _classId,
//             'date': _date.toIso8601String(),
//             'status': (_attendanceMap[s.id] ?? AttendanceStatus.present).value,
//           },
//         );
//       }
//       emit(const AttendanceMarked('تم حفظ الحضور'));
//     } catch (_) {
//       emit(const AttendanceError('فشل تسجيل الحضور'));
//     }
//   }

//   // ================= Counters =================
//   int getPresentCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.present).length;

//   int getAbsentCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.absent).length;

//   int getLateCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.late).length;
// }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/constants/api_constants.dart';
// import '../../data/models/attendance_model.dart';
// import '../../domain/entities/attendance.dart';
// import 'attendance_state.dart';

// class AttendanceCubit extends Cubit<AttendanceState> {
//   final ApiClient _apiClient;
//   final Dio _dio;

//   AttendanceCubit(this._apiClient)
//       : _dio = _apiClient.dio,
//         super(AttendanceInitial());

//   final Map<String, AttendanceStatus> _attendanceMap = {};
//   List<Student> _students = [];
//   String? _classId;
//   DateTime _date = DateTime.now();
//   List<ClassModel> _classes = [];
//   bool _isLoading = false;

//   // ================= Classes =================
//   Future<void> loadClasses() async {
//     if (_isLoading) return;

//     _isLoading = true;
//     emit(AttendanceLoading());

//     try {
//       final res = await _dio.get(
//         ApiConstants.classes,
//         queryParameters: {
//           '_t': DateTime.now().millisecondsSinceEpoch,
//         },
//       );

//       if (res.statusCode == 200) {
//         _classes =
//             (res.data as List).map((e) => ClassModelData.fromJson(e)).toList();
//         emit(ClassesLoaded(List.from(_classes)));
//       } else {
//         emit(const AttendanceError('فشل تحميل الصفوف'));
//       }
//     } on DioException catch (e) {
//       emit(AttendanceError(_getErrorMessage(e, 'تحميل الصفوف')));
//     } catch (e) {
//       emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
//     } finally {
//       _isLoading = false;
//     }
//   }

//   // ================= Students =================
//   Future<void> loadStudents(String classId) async {
//     if (_isLoading) return;

//     _isLoading = true;
//     emit(AttendanceLoading());
//     _classId = classId;
//     _attendanceMap.clear();

//     try {
//       final res = await _dio.get(
//         ApiConstants.getStudentsByClass.replaceAll('{classId}', classId),
//         queryParameters: {
//           '_t': DateTime.now().millisecondsSinceEpoch,
//         },
//       );

//       if (res.statusCode == 200) {
//         _students =
//             (res.data as List).map((e) => StudentModel.fromJson(e)).toList();

//         await _loadExistingAttendance();

//         emit(StudentsLoaded(List.from(_students), Map.from(_attendanceMap)));
//       } else {
//         emit(const AttendanceError('فشل تحميل الطلاب'));
//       }
//     } on DioException catch (e) {
//       emit(AttendanceError(_getErrorMessage(e, 'تحميل الطلاب')));
//     } catch (e) {
//       emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
//     } finally {
//       _isLoading = false;
//     }
//   }

//   // ================= Existing Attendance =================
//   Future<void> _loadExistingAttendance() async {
//     final start =
//         DateTime(_date.year, _date.month, _date.day).toIso8601String();
//     final end = DateTime(_date.year, _date.month, _date.day, 23, 59, 59)
//         .toIso8601String();

//     try {
//       final res = await _dio.get(
//         ApiConstants.attendance,
//         queryParameters: {
//           'classId': _classId,
//           'startDate': start,
//           'endDate': end,
//           '_t': DateTime.now().millisecondsSinceEpoch,
//         },
//       );

//       if (res.statusCode == 200) {
//         for (var item in res.data) {
//           final att = AttendanceModel.fromJson(item);
//           _attendanceMap[att.studentId] = att.status;
//         }
//       }
//     } catch (_) {
//       // تجاهل الخطأ في حالة عدم وجود حضور سابق
//     }

//     // تهيئة جميع الطلاب بحالة الحضور الافتراضية
//     for (var s in _students) {
//       _attendanceMap.putIfAbsent(s.id, () => AttendanceStatus.present);
//     }
//   }

//   // ================= Actions =================
//   void updateAttendance(String id, AttendanceStatus status) {
//     _attendanceMap[id] = status;
//     if (state is StudentsLoaded) {
//       emit(StudentsLoaded(List.from(_students), Map.from(_attendanceMap)));
//     }
//   }

//   void setDate(DateTime date) {
//     _date = date;
//     if (_classId != null) {
//       loadStudents(_classId!);
//     }
//   }

//   Future<void> submitAttendance() async {
//     if (_classId == null) {
//       emit(const AttendanceError('اختر الصف أولًا'));
//       return;
//     }

//     if (_isLoading) return;

//     _isLoading = true;
//     emit(AttendanceLoading());

//     try {
//       bool allSuccessful = true;
//       String? errorMessage;

//       for (var s in _students) {
//         try {
//           await _dio.post(
//             ApiConstants.attendance,
//             data: {
//               'studentId': s.id,
//               'classId': _classId,
//               'date': _date.toIso8601String(),
//               'status':
//                   (_attendanceMap[s.id] ?? AttendanceStatus.present).value,
//             },
//           );
//         } on DioException catch (e) {
//           allSuccessful = false;
//           errorMessage = _getErrorMessage(e, 'تسجيل حضور الطالب ${s.name}');
//           break;
//         }
//       }

//       if (allSuccessful) {
//         emit(const AttendanceMarked('تم حفظ الحضور بنجاح'));
//       } else {
//         emit(AttendanceError(errorMessage ?? 'فشل تسجيل الحضور'));
//       }
//     } catch (e) {
//       emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
//     } finally {
//       _isLoading = false;
//     }
//   }

//   // ================= Counters =================
//   int getPresentCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.present).length;

//   int getAbsentCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.absent).length;

//   int getLateCount() =>
//       _attendanceMap.values.where((e) => e == AttendanceStatus.late).length;

//   // ================= Helper Methods =================
//   String _getErrorMessage(DioException e, String operation) {
//     if (e.type == DioExceptionType.connectionError ||
//         e.type == DioExceptionType.unknown &&
//             e.error?.toString().contains('SocketException') == true) {
//       return 'لا يوجد اتصال بالإنترنت';
//     } else if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.sendTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       return 'انتهت مهلة الاتصال';
//     } else if (e.response?.statusCode == 404) {
//       return 'المورد غير موجود';
//     } else if (e.response?.statusCode == 500) {
//       return 'خطأ في الخادم';
//     } else {
//       return 'فشل $operation. حاول مرة أخرى';
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:teacher_management_app/core/network/api_client.dart';
import 'package:teacher_management_app/core/constants/api_constants.dart';
import '../../data/models/attendance_model.dart';
import '../../domain/entities/attendance.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final ApiClient _apiClient;
  final Dio _dio;

  AttendanceCubit(this._apiClient)
      : _dio = _apiClient.dio,
        super(AttendanceInitial());

  final Map<String, AttendanceStatus> _attendanceMap = {};
  List<Student> _students = [];
  String? _classId;
  DateTime _date = DateTime.now();
  List<ClassModel> _classes = [];
  bool _isLoading = false;

  // ================= Classes =================
  Future<void> loadClasses() async {
    if (_isLoading) return;

    _isLoading = true;
    emit(AttendanceLoading());

    try {
      final res = await _dio.get(
        ApiConstants.classes,
        queryParameters: {
          '_t': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (res.statusCode == 200) {
        _classes =
            (res.data as List).map((e) => ClassModelData.fromJson(e)).toList();
        emit(ClassesLoaded(List.from(_classes)));
      } else if (res.statusCode == 401) {
        emit(const AttendanceError(
            'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى'));
      } else {
        emit(AttendanceError(res.data['message'] ?? 'فشل تحميل الصفوف'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(const AttendanceError(
            'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى'));
      } else {
        emit(AttendanceError(_getErrorMessage(e, 'تحميل الصفوف')));
      }
    } catch (e) {
      emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
    } finally {
      _isLoading = false;
    }
  }

  // ================= Students =================
  Future<void> loadStudents(String classId) async {
    if (_isLoading) return;

    _isLoading = true;
    emit(AttendanceLoading());
    _classId = classId;
    _attendanceMap.clear();

    try {
      final res = await _dio.get(
        ApiConstants.getStudentsByClass.replaceAll('{classId}', classId),
        queryParameters: {
          '_t': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (res.statusCode == 200) {
        _students =
            (res.data as List).map((e) => StudentModel.fromJson(e)).toList();

        await _loadExistingAttendance();

        emit(StudentsLoaded(List.from(_students), Map.from(_attendanceMap)));
      } else if (res.statusCode == 401) {
        emit(const AttendanceError(
            'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى'));
      } else {
        emit(AttendanceError(res.data['message'] ?? 'فشل تحميل الطلاب'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(const AttendanceError(
            'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى'));
      } else {
        emit(AttendanceError(_getErrorMessage(e, 'تحميل الطلاب')));
      }
    } catch (e) {
      emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
    } finally {
      _isLoading = false;
    }
  }

  // ================= Existing Attendance =================
  Future<void> _loadExistingAttendance() async {
    final start =
        DateTime(_date.year, _date.month, _date.day).toIso8601String();
    final end = DateTime(_date.year, _date.month, _date.day, 23, 59, 59)
        .toIso8601String();

    try {
      final res = await _dio.get(
        ApiConstants.attendance,
        queryParameters: {
          'classId': _classId,
          'startDate': start,
          'endDate': end,
          '_t': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (res.statusCode == 200) {
        for (var item in res.data) {
          final att = AttendanceModel.fromJson(item);
          _attendanceMap[att.studentId] = att.status;
        }
      }
    } catch (_) {
      // تجاهل الخطأ في حالة عدم وجود حضور سابق
    }

    // تهيئة جميع الطلاب بحالة الحضور الافتراضية
    for (var s in _students) {
      _attendanceMap.putIfAbsent(s.id, () => AttendanceStatus.present);
    }
  }

  // ================= Actions =================
  void updateAttendance(String id, AttendanceStatus status) {
    _attendanceMap[id] = status;
    if (state is StudentsLoaded) {
      emit(StudentsLoaded(List.from(_students), Map.from(_attendanceMap)));
    }
  }

  void setDate(DateTime date) {
    _date = date;
    if (_classId != null) {
      loadStudents(_classId!);
    }
  }

  Future<void> submitAttendance() async {
    if (_classId == null) {
      emit(const AttendanceError('اختر الصف أولًا'));
      return;
    }

    if (_isLoading) return;

    _isLoading = true;
    emit(AttendanceLoading());

    try {
      bool allSuccessful = true;
      String? errorMessage;

      for (var s in _students) {
        try {
          await _dio.post(
            ApiConstants.attendance,
            data: {
              'studentId': s.id,
              'classId': _classId,
              'date': _date.toIso8601String(),
              'status':
                  (_attendanceMap[s.id] ?? AttendanceStatus.present).value,
            },
          );
        } on DioException catch (e) {
          allSuccessful = false;
          if (e.response?.statusCode == 401) {
            errorMessage = 'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى';
          } else {
            errorMessage = _getErrorMessage(e, 'تسجيل حضور الطالب ${s.name}');
          }
          break;
        }
      }

      if (allSuccessful) {
        emit(const AttendanceMarked('تم حفظ الحضور بنجاح'));
      } else {
        emit(AttendanceError(errorMessage ?? 'فشل تسجيل الحضور'));
      }
    } catch (e) {
      emit(AttendanceError('خطأ غير متوقع: ${e.toString()}'));
    } finally {
      _isLoading = false;
    }
  }

  // ================= Counters =================
  int getPresentCount() =>
      _attendanceMap.values.where((e) => e == AttendanceStatus.present).length;

  int getAbsentCount() =>
      _attendanceMap.values.where((e) => e == AttendanceStatus.absent).length;

  int getLateCount() =>
      _attendanceMap.values.where((e) => e == AttendanceStatus.late).length;

  // ================= Helper Methods =================
  String _getErrorMessage(DioException e, String operation) {
    if (e.response?.statusCode == 401) {
      return 'ليس لديك صلاحية للوصول. يرجى تسجيل الدخول مرة أخرى';
    } else if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown &&
            e.error?.toString().contains('SocketException') == true) {
      return 'لا يوجد اتصال بالإنترنت';
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال';
    } else if (e.response?.statusCode == 404) {
      return 'المورد غير موجود';
    } else if (e.response?.statusCode == 500) {
      return 'خطأ في الخادم';
    } else {
      return 'فشل $operation. حاول مرة أخرى';
    }
  }
}
