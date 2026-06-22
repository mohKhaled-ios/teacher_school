// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../constants/api_constants.dart';
// import '../constants/hive_constants.dart';

// class ApiClient {
//   late final Dio _dio;
//   String? _token;
//   bool _isTokenLoaded = false;

//   ApiClient() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout:
//             const Duration(milliseconds: ApiConstants.connectTimeout),
//         receiveTimeout:
//             const Duration(milliseconds: ApiConstants.receiveTimeout),
//         sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         receiveDataWhenStatusError: true,
//         validateStatus: (status) {
//           return status! < 500;
//         },
//       ),
//     );

//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // تحميل الـ token من Hive إذا لم يكن محملاً
//           if (!_isTokenLoaded) {
//             await _loadTokenFromHive();
//           }

//           if (_token != null && _token!.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $_token';
//           }

//           options.queryParameters['_t'] = DateTime.now().millisecondsSinceEpoch;
//           return handler.next(options);
//         },
//         onError: (error, handler) async {
//           // إذا كان الخطأ 401 Unauthorized، نحذف الـ token
//           if (error.response?.statusCode == 401) {
//             await _clearToken();
//           }
//           _handleError(error);
//           return handler.next(error);
//         },
//       ),
//     );

//     // Add logger in debug mode
//     _dio.interceptors.add(
//       PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         error: true,
//         compact: true,
//         maxWidth: 90,
//       ),
//     );
//   }

//   Future<void> _loadTokenFromHive() async {
//     try {
//       final userBox = Hive.box(HiveConstants.userBox);
//       _token = userBox.get(HiveConstants.tokenKey);
//       _isTokenLoaded = true;
//     } catch (e) {
//       _token = null;
//       _isTokenLoaded = true;
//     }
//   }

//   Future<void> _clearToken() async {
//     try {
//       final userBox = Hive.box(HiveConstants.userBox);
//       await userBox.delete(HiveConstants.tokenKey);
//       _token = null;
//     } catch (_) {}
//   }

//   Future<void> _saveTokenToHive(String token) async {
//     try {
//       final userBox = Hive.box(HiveConstants.userBox);
//       await userBox.put(HiveConstants.tokenKey, token);
//       _token = token;
//       _isTokenLoaded = true;
//     } catch (_) {}
//   }

//   void setToken(String? token) {
//     _token = token;
//     if (token != null) {
//       _saveTokenToHive(token);
//     } else {
//       _clearToken();
//     }
//   }

//   void clearToken() {
//     _token = null;
//     _clearToken();
//   }

//   String? get token => _token;

//   Dio get dio => _dio;

//   void _handleError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         throw TimeoutException();
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         final message = error.response?.data?['message']?.toString() ??
//             error.response?.statusMessage ??
//             'Server error';

//         if (statusCode == 401) {
//           throw UnauthorizedException(message: message);
//         } else if (statusCode == 403) {
//           throw ForbiddenException(message: message);
//         } else if (statusCode == 404) {
//           throw NotFoundException(message: message);
//         } else {
//           throw ServerException(
//             message: message,
//             statusCode: statusCode,
//           );
//         }
//       case DioExceptionType.cancel:
//         throw RequestCancelledException();
//       case DioExceptionType.connectionError:
//         throw NoInternetException();
//       case DioExceptionType.badCertificate:
//         throw BadCertificateException();
//       case DioExceptionType.unknown:
//         if (error.error?.toString().contains('SocketException') == true ||
//             error.error?.toString().contains('Network is unreachable') ==
//                 true) {
//           throw NoInternetException();
//         }
//         throw UnknownException(message: error.message ?? 'Unknown error');
//       default:
//         throw UnknownException(message: error.message ?? 'Unknown error');
//     }
//   }

//   // Auth APIs
//   Future<Response> login(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.login, data: data);
//   }

//   Future<Response> register(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.register, data: data);
//   }

//   Future<Response> getMe() async {
//     return await _dio.get(ApiConstants.getMe);
//   }

//   // User APIs
//   Future<Response> getUsers({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(ApiConstants.users, queryParameters: queryParams);
//   }

//   Future<Response> getUserById(String id) async {
//     return await _dio.get(ApiConstants.getUserById.replaceAll('{id}', id));
//   }

//   Future<Response> updateUser(String id, Map<String, dynamic> data) async {
//     return await _dio.put(
//       ApiConstants.updateUser.replaceAll('{id}', id),
//       data: data,
//     );
//   }

//   Future<Response> deleteUser(String id) async {
//     return await _dio.delete(ApiConstants.deleteUser.replaceAll('{id}', id));
//   }

//   Future<Response> getStudentsByClass(String classId) async {
//     return await _dio.get(
//       ApiConstants.getStudentsByClass.replaceAll('{classId}', classId),
//     );
//   }

//   // Class APIs
//   Future<Response> getClasses({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(ApiConstants.classes, queryParameters: queryParams);
//   }

//   Future<Response> getClassById(String id) async {
//     return await _dio.get(ApiConstants.getClassById.replaceAll('{id}', id));
//   }

//   // Subject APIs
//   Future<Response> getSubjects({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(ApiConstants.subjects, queryParameters: queryParams);
//   }

//   Future<Response> createSubject(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.subjects, data: data);
//   }

//   // Attendance APIs
//   Future<Response> markAttendance(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.attendance, data: data);
//   }

//   Future<Response> getAttendance({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(
//       ApiConstants.attendance,
//       queryParameters: queryParams,
//     );
//   }

//   Future<Response> updateAttendance(
//     String id,
//     Map<String, dynamic> data,
//   ) async {
//     return await _dio.put(
//       ApiConstants.updateAttendance.replaceAll('{id}', id),
//       data: data,
//     );
//   }

//   Future<Response> getAttendanceStats({
//     Map<String, dynamic>? queryParams,
//   }) async {
//     return await _dio.get(
//       ApiConstants.attendanceStats,
//       queryParameters: queryParams,
//     );
//   }

//   // Exam APIs
//   Future<Response> createExam(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.exams, data: data);
//   }

//   Future<Response> getExams({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(ApiConstants.exams, queryParameters: queryParams);
//   }

//   Future<Response> getExamById(String id) async {
//     return await _dio.get(ApiConstants.getExamById.replaceAll('{id}', id));
//   }

//   Future<Response> updateExam(String id, Map<String, dynamic> data) async {
//     return await _dio.put(
//       ApiConstants.updateExam.replaceAll('{id}', id),
//       data: data,
//     );
//   }

//   Future<Response> deleteExam(String id) async {
//     return await _dio.delete(ApiConstants.deleteExam.replaceAll('{id}', id));
//   }

//   // Grade APIs
//   Future<Response> addGrade(Map<String, dynamic> data) async {
//     return await _dio.post(ApiConstants.grades, data: data);
//   }

//   Future<Response> getGrades({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(ApiConstants.grades, queryParameters: queryParams);
//   }

//   Future<Response> getGradeStats({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(
//       ApiConstants.gradeStats,
//       queryParameters: queryParams,
//     );
//   }

//   // Material APIs
//   Future<Response> uploadMaterial(FormData data) async {
//     return await _dio.post(
//       ApiConstants.uploadMaterial,
//       data: data,
//       options: Options(
//         headers: {'Content-Type': 'multipart/form-data'},
//       ),
//     );
//   }

//   Future<Response> getMaterials({Map<String, dynamic>? queryParams}) async {
//     return await _dio.get(
//       ApiConstants.materials,
//       queryParameters: queryParams,
//     );
//   }

//   Future<Response> deleteMaterial(String id) async {
//     return await _dio.delete(
//       ApiConstants.deleteMaterial.replaceAll('{id}', id),
//     );
//   }
// }

// // Custom Exceptions
// class ServerException implements Exception {
//   final String message;
//   final int? statusCode;

//   ServerException({required this.message, this.statusCode});
// }

// class NoInternetException implements Exception {}

// class TimeoutException implements Exception {}

// class RequestCancelledException implements Exception {}

// class UnknownException implements Exception {
//   final String message;

//   UnknownException({this.message = 'Unknown error occurred'});
// }

// class UnauthorizedException implements Exception {
//   final String message;

//   UnauthorizedException({this.message = 'Unauthorized access'});
// }

// class ForbiddenException implements Exception {
//   final String message;

//   ForbiddenException({this.message = 'Access forbidden'});
// }

// class NotFoundException implements Exception {
//   final String message;

//   NotFoundException({this.message = 'Resource not found'});
// }

// class BadCertificateException implements Exception {}
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../constants/hive_constants.dart';

class ApiClient {
  late final Dio _dio;
  String? _token;
  bool _isTokenLoaded = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeout),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // تحميل الـ token من Hive إذا لم يكن محملاً
          if (!_isTokenLoaded) {
            await _loadTokenFromHive();
          }

          if (_token != null && _token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }

          options.queryParameters['_t'] = DateTime.now().millisecondsSinceEpoch;
          return handler.next(options);
        },
        onError: (error, handler) async {
          // إذا كان الخطأ 401 Unauthorized
          if (error.response?.statusCode == 401) {
            await _handleUnauthorizedError();
            return handler.reject(error);
          }

          // إذا كان الخطأ 403 Forbidden
          if (error.response?.statusCode == 403) {
            _handleForbiddenError();
            return handler.reject(error);
          }

          return handler.next(error);
        },
      ),
    );

    // Add logger in debug mode
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<void> _loadTokenFromHive() async {
    try {
      final userBox = Hive.box(HiveConstants.userBox);
      _token = userBox.get(HiveConstants.tokenKey);
      _isTokenLoaded = true;
    } catch (e) {
      _token = null;
      _isTokenLoaded = true;
    }
  }

  Future<void> _clearToken() async {
    try {
      final userBox = Hive.box(HiveConstants.userBox);
      await userBox.delete(HiveConstants.tokenKey);
      _token = null;
    } catch (_) {}
  }

  Future<void> _saveTokenToHive(String token) async {
    try {
      final userBox = Hive.box(HiveConstants.userBox);
      await userBox.put(HiveConstants.tokenKey, token);
      _token = token;
      _isTokenLoaded = true;
    } catch (_) {}
  }

  void setToken(String? token) {
    _token = token;
    if (token != null) {
      _saveTokenToHive(token);
    } else {
      _clearToken();
    }
  }

  void clearToken() {
    _token = null;
    _clearToken();
  }

  String? get token => _token;

  Dio get dio => _dio;

  Future<void> _handleUnauthorizedError() async {
    // حذف الـ token
    await _clearToken();
    _token = null;

    // تنبيه المستخدم
    _showSessionExpiredDialog();
  }

  void _handleForbiddenError() {
    // يمكن إضافة منطق للتعامل مع خطأ 403
    // مثل إعادة توجيه المستخدم أو إظهار رسالة
  }

  void _showSessionExpiredDialog() {
    // استخدام WidgetsBinding للوصول إلى BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // البحث عن أقرب ScaffoldMessenger لإظهار الـ SnackBar
      if (navigatorKey.currentContext != null) {
        final context = navigatorKey.currentContext!;

        // إظهار SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('session_expired'.tr()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'login'.tr(),
              textColor: Colors.white,
              onPressed: () {
                // إعادة التوجيه إلى صفحة تسجيل الدخول
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
            ),
          ),
        );
      }
    });
  }

  // =========== Auth APIs ===========
  Future<Response> login(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.login, data: data);
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.register, data: data);
  }

  Future<Response> getMe() async {
    return await _dio.get(ApiConstants.getMe);
  }

  // =========== User APIs ===========
  Future<Response> getUsers({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.users, queryParameters: queryParams);
  }

  Future<Response> getUserById(String id) async {
    return await _dio.get(ApiConstants.getUserById.replaceAll('{id}', id));
  }

  Future<Response> updateUser(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      ApiConstants.updateUser.replaceAll('{id}', id),
      data: data,
    );
  }

  Future<Response> deleteUser(String id) async {
    return await _dio.delete(ApiConstants.deleteUser.replaceAll('{id}', id));
  }

  Future<Response> getStudentsByClass(String classId) async {
    return await _dio.get(
      ApiConstants.getStudentsByClass.replaceAll('{classId}', classId),
    );
  }

  // =========== Class APIs ===========
  Future<Response> getClasses({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.classes, queryParameters: queryParams);
  }

  Future<Response> getClassById(String id) async {
    return await _dio.get(ApiConstants.getClassById.replaceAll('{id}', id));
  }

  Future<Response> updateClass(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      ApiConstants.updateClass.replaceAll('{id}', id),
      data: data,
    );
  }

  Future<Response> deleteClass(String id) async {
    return await _dio.delete(ApiConstants.deleteClass.replaceAll('{id}', id));
  }

  Future<Response> addSchedule(String id, Map<String, dynamic> data) async {
    return await _dio.post(
      ApiConstants.addSchedule.replaceAll('{id}', id),
      data: data,
    );
  }

  // =========== Subject APIs ===========
  Future<Response> getSubjects({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.subjects, queryParameters: queryParams);
  }

  Future<Response> getSubjectById(String id) async {
    return await _dio.get(ApiConstants.getSubjectById.replaceAll('{id}', id));
  }

  Future<Response> createSubject(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.subjects, data: data);
  }

  Future<Response> updateSubject(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      ApiConstants.updateSubject.replaceAll('{id}', id),
      data: data,
    );
  }

  Future<Response> deleteSubject(String id) async {
    return await _dio.delete(ApiConstants.deleteSubject.replaceAll('{id}', id));
  }

  // =========== Attendance APIs ===========
  Future<Response> markAttendance(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.attendance, data: data);
  }

  Future<Response> getAttendance({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(
      ApiConstants.attendance,
      queryParameters: queryParams,
    );
  }

  Future<Response> updateAttendance(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await _dio.put(
      ApiConstants.updateAttendance.replaceAll('{id}', id),
      data: data,
    );
  }

  Future<Response> getAttendanceStats({
    Map<String, dynamic>? queryParams,
  }) async {
    return await _dio.get(
      ApiConstants.attendanceStats,
      queryParameters: queryParams,
    );
  }

  // =========== Exam APIs ===========
  Future<Response> createExam(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.exams, data: data);
  }

  Future<Response> getExams({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.exams, queryParameters: queryParams);
  }

  Future<Response> getExamById(String id) async {
    return await _dio.get(ApiConstants.getExamById.replaceAll('{id}', id));
  }

  Future<Response> updateExam(String id, Map<String, dynamic> data) async {
    return await _dio.put(
      ApiConstants.updateExam.replaceAll('{id}', id),
      data: data,
    );
  }

  Future<Response> deleteExam(String id) async {
    return await _dio.delete(ApiConstants.deleteExam.replaceAll('{id}', id));
  }

  // =========== Grade APIs ===========
  Future<Response> addGrade(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.grades, data: data);
  }

  Future<Response> getGrades({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.grades, queryParameters: queryParams);
  }

  Future<Response> getGradeStats({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(
      ApiConstants.gradeStats,
      queryParameters: queryParams,
    );
  }

  // =========== Material APIs ===========
  Future<Response> uploadMaterial(FormData data) async {
    return await _dio.post(
      ApiConstants.uploadMaterial,
      data: data,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<Response> getMaterials({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(
      ApiConstants.materials,
      queryParameters: queryParams,
    );
  }

  Future<Response> deleteMaterial(String id) async {
    return await _dio.delete(
      ApiConstants.deleteMaterial.replaceAll('{id}', id),
    );
  }

  // =========== Payment APIs ===========
  Future<Response> getInvoices({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.invoices, queryParameters: queryParams);
  }

  Future<Response> createPaymentOrder(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.createPaymentOrder, data: data);
  }

  Future<Response> confirmPayment(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.confirmPayment, data: data);
  }

  // =========== Chat APIs ===========
  Future<Response> sendMessage(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.sendMessage, data: data);
  }

  Future<Response> getChatRooms({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.getChatRooms,
        queryParameters: queryParams);
  }

  Future<Response> getMessages({Map<String, dynamic>? queryParams}) async {
    return await _dio.get(ApiConstants.getMessages,
        queryParameters: queryParams);
  }

  Future<Response> markAsRead(Map<String, dynamic> data) async {
    return await _dio.post(ApiConstants.markAsRead, data: data);
  }

  ///
  Future<Response> getNotifications() async {
    return await _dio.get('/notifications');
  }

  Future<Response> getUnreadCount() async {
    return await _dio.get('/notifications/unread-count');
  }

  Future<Response> createNotification(Map<String, dynamic> data) async {
    return await _dio.post('/notifications', data: data);
  }

  Future<Response> markNotificationAsRead(String id) async {
    return await _dio.put('/notifications/$id/read');
  }

  Future<Response> markAllNotificationsAsRead() async {
    return await _dio.put('/notifications/read-all');
  }

  Future<Response> deleteNotification(String id) async {
    return await _dio.delete('/notifications/$id');
  }

  Future<Response> clearAllNotifications() async {
    return await _dio.delete('/notifications');
  }

  // =========== Helper Methods ===========
  String getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'timeout_error';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'session_expired';
        } else if (statusCode == 403) {
          return 'forbidden_error';
        } else if (statusCode == 404) {
          return 'not_found_error';
        } else if (statusCode == 500) {
          return 'server_error';
        } else {
          return error.response?.data?['message']?.toString() ??
              error.response?.statusMessage ??
              'server_error';
        }
      case DioExceptionType.cancel:
        return 'request_cancelled';
      case DioExceptionType.connectionError:
        return 'network_error';
      case DioExceptionType.badCertificate:
        return 'bad_certificate';
      case DioExceptionType.unknown:
        if (error.error?.toString().contains('SocketException') == true) {
          return 'network_error';
        }
        return 'unknown_error';
      default:
        return 'unknown_error';
    }
  }
}

// Custom Exceptions
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException implements Exception {
  @override
  String toString() => 'network_error';
}

class TimeoutException implements Exception {
  @override
  String toString() => 'timeout_error';
}

class RequestCancelledException implements Exception {
  @override
  String toString() => 'request_cancelled';
}

class UnknownException implements Exception {
  final String message;

  UnknownException({String? message}) : message = message ?? 'unknown_error';

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({String? message})
      : message = message ?? 'session_expired';

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;

  ForbiddenException({String? message})
      : message = message ?? 'forbidden_error';

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({String? message}) : message = message ?? 'not_found_error';

  @override
  String toString() => message;
}

class BadCertificateException implements Exception {
  @override
  String toString() => 'bad_certificate';
}
