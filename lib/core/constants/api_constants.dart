class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://192.168.1.4:50000/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String getMe = '/auth/me';
  static const String socketUrl = 'http://192.168.1.4:50000';

  // User Endpoints
  static const String users = '/users';
  static const String getUserById = '/users/{id}';
  static const String updateUser = '/users/{id}';
  static const String deleteUser = '/users/{id}';
  static const String getStudentsByClass = '/users/students/by-class/{classId}';

  // Class Endpoints
  static const String classes = '/classes';
  static const String getClassById = '/classes/{id}';
  static const String updateClass = '/classes/{id}';
  static const String deleteClass = '/classes/{id}';
  static const String addSchedule = '/classes/{id}/schedule';

  // Subject Endpoints
  static const String subjects = '/subjects';
  static const String getSubjectById = '/subjects/{id}';
  static const String updateSubject = '/subjects/{id}';
  static const String deleteSubject = '/subjects/{id}';

  // Attendance Endpoints
  static const String attendance = '/attendance';
  static const String updateAttendance = '/attendance/{id}';
  static const String attendanceStats = '/attendance/stats';

  // Exam Endpoints
  static const String exams = '/exams';
  static const String getExamById = '/exams/{id}';
  static const String updateExam = '/exams/{id}';
  static const String deleteExam = '/exams/{id}';

  // Grade Endpoints
  static const String grades = '/grades';
  static const String gradeStats = '/grades/stats';

  // Material Endpoints
  static const String materials = '/materials';
  static const String uploadMaterial = '/materials/upload';
  static const String deleteMaterial = '/materials/{id}';

  // Payment Endpoints
  static const String invoices = '/payments/invoices';
  static const String createPaymentOrder = '/payments/create-order';
  static const String confirmPayment = '/payments/confirm';

  // Chat Endpoints
  static const String sendMessage = '/chat/send';
  static const String getChatRooms = '/chat/rooms';
  static const String getMessages = '/chat/messages';
  static const String markAsRead = '/chat/read';

  // Headers
  static Map<String, String> headers({String? token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}
