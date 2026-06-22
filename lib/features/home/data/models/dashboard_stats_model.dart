import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalClasses,
    required super.totalStudents,
    required super.totalSubjects,
    required super.todayAttendance,
    required super.pendingExams,
    required super.pendingGrades,
    required super.attendanceRate,
    required super.recentActivities,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalClasses: json['totalClasses'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      totalSubjects: json['totalSubjects'] ?? 0,
      todayAttendance: json['todayAttendance'] ?? 0,
      pendingExams: json['pendingExams'] ?? 0,
      pendingGrades: json['pendingGrades'] ?? 0,
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
      recentActivities: (json['recentActivities'] as List<dynamic>?)
              ?.map((e) => RecentActivityModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Mock data for development
  factory DashboardStatsModel.mock() {
    return DashboardStatsModel(
      totalClasses: 5,
      totalStudents: 120,
      totalSubjects: 8,
      todayAttendance: 95,
      pendingExams: 3,
      pendingGrades: 12,
      attendanceRate: 87.5,
      recentActivities: [
        RecentActivityModel(
          id: '1',
          title: 'تم رفع مادة جديدة',
          description: 'مادة الرياضيات - الصف الأول',
          type: 'material',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        RecentActivityModel(
          id: '2',
          title: 'تم تسجيل الحضور',
          description: 'الصف الثاني - 30 طالب',
          type: 'attendance',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        RecentActivityModel(
          id: '3',
          title: 'امتحان جديد',
          description: 'امتحان اللغة العربية',
          type: 'exam',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );
  }
}

class RecentActivityModel extends RecentActivity {
  const RecentActivityModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.timestamp,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}