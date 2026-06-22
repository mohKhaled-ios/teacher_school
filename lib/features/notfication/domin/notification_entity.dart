// features/notfication/domin/notification_entity.dart
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, isRead, createdAt];
}

enum NotificationType {
  attendance,
  exam,
  grade,
  material,
  general;

  String get displayName {
    switch (this) {
      case NotificationType.attendance:
        return 'حضور';
      case NotificationType.exam:
        return 'امتحان';
      case NotificationType.grade:
        return 'درجات';
      case NotificationType.material:
        return 'مواد تعليمية';
      case NotificationType.general:
        return 'عام';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'attendance':
        return NotificationType.attendance;
      case 'exam':
        return NotificationType.exam;
      case 'grade':
        return NotificationType.grade;
      case 'material':
        return NotificationType.material;
      default:
        return NotificationType.general;
    }
  }
}
