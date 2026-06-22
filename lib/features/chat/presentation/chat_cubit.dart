// features/chat/presentation/cubit/chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:teacher_management_app/features/chat/data/chat_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ApiClient apiClient;
  IO.Socket? _socket;
  String? _currentUserId;
  String? _currentReceiverId;

  // تتبع حالة الأونلاين محلياً
  final Map<String, bool> _onlineStatus = {};
  final Map<String, DateTime?> _lastSeenMap = {};

  ChatCubit({required this.apiClient}) : super(ChatInitial());

  // ══════════════════════════════════════════
  // Socket.io Connection
  // ══════════════════════════════════════════

  void connectSocket(String userId) {
    _currentUserId = userId;

    _socket = IO.io(
      ApiConstants.socketUrl, // 'http://192.168.1.4:50000'
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'userId': userId})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      // إبلاغ السيرفر بأن المستخدم أونلاين
      _socket!.emit('user-online', userId);
    });

    // استقبال رسالة جديدة
    _socket!.on('receive-message', (data) {
      final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
      final current = state;
      if (current is MessagesLoaded) {
        // إضافة الرسالة للقائمة الحالية
        final updated = [...current.messages, msg];
        emit(current.copyWith(messages: updated));
      }
    });

    // تحديث حالة الأونلاين
    _socket!.on('user-status-changed', (data) {
      final userId = data['userId']?.toString() ?? '';
      final isOnline = data['isOnline'] ?? false;
      final lastSeenStr = data['lastSeen']?.toString();

      _onlineStatus[userId] = isOnline;
      if (lastSeenStr != null) {
        _lastSeenMap[userId] = DateTime.tryParse(lastSeenStr);
      }

      // تحديث الـ state إذا كان المستخدم في محادثة
      _refreshOnlineInState();
    });

    // مؤشر الكتابة
    _socket!.on('user-typing', (data) {
      final isTyping = data['isTyping'] ?? false;
      final current = state;
      if (current is MessagesLoaded) {
        emit(current.copyWith(isTyping: isTyping));
      }
    });

    _socket!.onDisconnect((_) {});
    _socket!.onError((e) {});
  }

  void _refreshOnlineInState() {
    // يمكن تطوير هذا لاحقاً لتحديث الـ UI
  }

  void disconnectSocket() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  // ══════════════════════════════════════════
  // Chat Rooms
  // ══════════════════════════════════════════

  Future<void> loadChatRooms() async {
    emit(ChatLoading());
    try {
      final response = await apiClient.getChatRooms();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final rooms = data
            .map((j) => ChatRoomModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        emit(ChatRoomsLoaded(rooms));
      } else {
        emit(const ChatError('فشل تحميل المحادثات'));
      }
    } catch (e) {
      emit(ChatError('فشل تحميل المحادثات: $e'));
    }
  }

  // ══════════════════════════════════════════
  // Messages
  // ══════════════════════════════════════════

  Future<void> loadMessages(String receiverId) async {
    _currentReceiverId = receiverId;
    emit(ChatLoading());
    try {
      final response =
          await apiClient.getMessages(queryParams: {'receiverId': receiverId});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final messages = data
            .map((j) => MessageModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        emit(MessagesLoaded(messages));

        // تحديد الرسائل كمقروءة
        await markMessagesAsRead(receiverId);
      } else {
        emit(const ChatError('فشل تحميل الرسائل'));
      }
    } catch (e) {
      emit(ChatError('فشل تحميل الرسائل: $e'));
    }
  }

  Future<void> sendMessage(String receiverId, String message) async {
    if (message.trim().isEmpty) return;

    try {
      final response = await apiClient.sendMessage({
        'receiverId': receiverId,
        'message': message.trim(),
        'messageType': 'text',
      });

      if (response.statusCode == 201) {
        final msg =
            MessageModel.fromJson(Map<String, dynamic>.from(response.data));

        // إرسال عبر Socket للـ real-time
        _socket?.emit('send-message', {
          'receiverId': receiverId,
          'senderId': _currentUserId,
          '_id': msg.id,
          'senderId': {'_id': _currentUserId, 'name': ''},
          'receiverId': receiverId,
          'message': message,
          'messageType': 'text',
          'isRead': false,
          'createdAt': DateTime.now().toIso8601String(),
        });

        final current = state;
        if (current is MessagesLoaded) {
          emit(current.copyWith(messages: [...current.messages, msg]));
        }
      }
    } catch (e) {
      emit(ChatError('فشل إرسال الرسالة: $e'));
    }
  }

  Future<void> markMessagesAsRead(String senderId) async {
    try {
      await apiClient.markAsRead({'senderId': senderId});
    } catch (_) {}
  }

  // مؤشر الكتابة
  void sendTyping(String receiverId, bool isTyping) {
    _socket?.emit('typing', {
      'senderId': _currentUserId,
      'receiverId': receiverId,
      'isTyping': isTyping,
    });
  }

  // ══════════════════════════════════════════
  // Users (لبدء محادثة جديدة)
  // ══════════════════════════════════════════

  Future<void> loadUsers() async {
    emit(ChatLoading());
    try {
      final response = await apiClient.getUsers();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final users = data
            .map((j) =>
                ChatParticipantModel.fromJson(Map<String, dynamic>.from(j)))
            .where((u) => u.id != _currentUserId)
            .toList();
        emit(UsersLoaded(users));
      } else {
        emit(const ChatError('فشل تحميل المستخدمين'));
      }
    } catch (e) {
      emit(ChatError('فشل تحميل المستخدمين: $e'));
    }
  }

  // الحصول على حالة الأونلاين
  bool isUserOnline(String userId) => _onlineStatus[userId] ?? false;
  DateTime? getUserLastSeen(String userId) => _lastSeenMap[userId];

  @override
  Future<void> close() {
    disconnectSocket();
    return super.close();
  }
}
