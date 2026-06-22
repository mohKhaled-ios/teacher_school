import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalClasses;
  final int totalStudents;
  final int totalSubjects;
  final int todayAttendance;
  final int pendingExams;
  final int pendingGrades;
  final double attendanceRate;
  final List<RecentActivity> recentActivities;

  const DashboardStats({
    required this.totalClasses,
    required this.totalStudents,
    required this.totalSubjects,
    required this.todayAttendance,
    required this.pendingExams,
    required this.pendingGrades,
    required this.attendanceRate,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [
        totalClasses,
        totalStudents,
        totalSubjects,
        todayAttendance,
        pendingExams,
        pendingGrades,
        attendanceRate,
        recentActivities,
      ];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime timestamp;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, description, type, timestamp];
}