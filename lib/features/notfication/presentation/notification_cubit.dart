// features/notfication/presentation/notification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_management_app/core/network/api_client.dart';
import '../data/notification_model.dart';
import '../domin/notification_entity.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final ApiClient _apiClient;

  NotificationCubit(this._apiClient) : super(NotificationInitial());

  // ── تحميل الإشعارات من الـ backend ──
  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final response = await _apiClient.getNotifications();

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final notifications = data
            .map((j) => NotificationModel.fromJson(
                  Map<String, dynamic>.from(j),
                ).toEntity())
            .toList();

        final unread = notifications.where((n) => !n.isRead).length;
        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unread,
        ));
      } else {
        emit(const NotificationError('فشل تحميل الإشعارات'));
      }
    } catch (e) {
      emit(NotificationError('فشل تحميل الإشعارات: $e'));
    }
  }

  // ── إضافة إشعار جديد عبر الـ backend ──
  Future<void> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'title': title,
        'body': body,
        'type': type.name,
        if (userId != null) 'userId': userId,
        if (data != null) 'data': data,
      };

      final response = await _apiClient.createNotification(payload);

      if (response.statusCode == 201) {
        // أعد تحميل الإشعارات بعد الإضافة
        await loadNotifications();
      }
    } catch (e) {
      emit(NotificationError('فشل إضافة الإشعار: $e'));
    }
  }

  // ── تحديد إشعار كمقروء ──
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _apiClient.markNotificationAsRead(notificationId);

      if (response.statusCode == 200) {
        // تحديث الـ state محلياً بدون request جديد
        final currentState = state;
        if (currentState is NotificationsLoaded) {
          final updated = currentState.notifications.map((n) {
            if (n.id == notificationId) return n.copyWith(isRead: true);
            return n;
          }).toList();

          final unread = updated.where((n) => !n.isRead).length;
          emit(NotificationsLoaded(
            notifications: updated,
            unreadCount: unread,
          ));
        }
      }
    } catch (e) {
      emit(NotificationError('فشل تحديث الإشعار: $e'));
    }
  }

  // ── تحديد جميع الإشعارات كمقروءة ──
  Future<void> markAllAsRead() async {
    try {
      final response = await _apiClient.markAllNotificationsAsRead();

      if (response.statusCode == 200) {
        final currentState = state;
        if (currentState is NotificationsLoaded) {
          final updated = currentState.notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
          emit(NotificationsLoaded(
            notifications: updated,
            unreadCount: 0,
          ));
        }
      }
    } catch (e) {
      emit(NotificationError('فشل تحديث الإشعارات: $e'));
    }
  }

  // ── حذف إشعار ──
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await _apiClient.deleteNotification(notificationId);

      if (response.statusCode == 200) {
        final currentState = state;
        if (currentState is NotificationsLoaded) {
          final updated = currentState.notifications
              .where((n) => n.id != notificationId)
              .toList();
          final unread = updated.where((n) => !n.isRead).length;
          emit(NotificationsLoaded(
            notifications: updated,
            unreadCount: unread,
          ));
        }
      }
    } catch (e) {
      emit(NotificationError('فشل حذف الإشعار: $e'));
    }
  }

  // ── حذف جميع الإشعارات ──
  Future<void> clearAll() async {
    try {
      final response = await _apiClient.clearAllNotifications();

      if (response.statusCode == 200) {
        emit(const NotificationsLoaded(
          notifications: [],
          unreadCount: 0,
        ));
      }
    } catch (e) {
      emit(NotificationError('فشل مسح الإشعارات: $e'));
    }
  }

  // ══════════════════════════════════════════════
  // Helper methods - استدعيها بعد أي action ناجح
  // ══════════════════════════════════════════════

  void notifyAttendanceSaved(String className, int studentCount) {
    addNotification(
      title: 'تم تسجيل الحضور',
      body: 'تم تسجيل حضور $studentCount طالب في $className',
      type: NotificationType.attendance,
      data: {'className': className, 'count': studentCount},
    );
  }

  void notifyExamCreated(String examTitle, String className) {
    addNotification(
      title: 'امتحان جديد',
      body: 'تم إنشاء امتحان "$examTitle" للصف $className',
      type: NotificationType.exam,
      data: {'examTitle': examTitle, 'className': className},
    );
  }

  void notifyGradeAdded(String studentName, String examTitle, String grade) {
    addNotification(
      title: 'تمت إضافة درجة',
      body: 'درجة $studentName في "$examTitle": $grade',
      type: NotificationType.grade,
      data: {'studentName': studentName, 'grade': grade},
    );
  }

  void notifyMaterialUploaded(String materialTitle, String subjectName) {
    addNotification(
      title: 'مادة تعليمية جديدة',
      body: 'تم رفع "$materialTitle" في $subjectName',
      type: NotificationType.material,
      data: {'title': materialTitle, 'subject': subjectName},
    );
  }
}
