// features/chat/data/models/chat_model.dart
import 'package:teacher_management_app/features/chat/domin/chat_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    super.senderImage,
    required super.receiverId,
    required super.message,
    super.messageType,
    super.fileUrl,
    required super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['senderId'];
    final receiver = json['receiverId'];

    return MessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      senderId: sender is Map
          ? sender['_id']?.toString() ?? ''
          : sender?.toString() ?? '',
      senderName: sender is Map ? sender['name']?.toString() ?? '' : '',
      senderImage: sender is Map ? sender['profileImage']?.toString() : null,
      receiverId: receiver is Map
          ? receiver['_id']?.toString() ?? ''
          : receiver?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      messageType: json['messageType']?.toString() ?? 'text',
      fileUrl: json['fileUrl']?.toString(),
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.participants,
    super.lastMessage,
    required super.updatedAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final participants = (json['participants'] as List<dynamic>?)
            ?.map((p) => ChatParticipantModel.fromJson(p))
            .toList() ??
        [];

    MessageEntity? lastMessage;
    if (json['lastMessage'] != null && json['lastMessage'] is Map) {
      lastMessage =
          MessageModel.fromJson(Map<String, dynamic>.from(json['lastMessage']));
    }

    return ChatRoomModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      participants: participants,
      lastMessage: lastMessage,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ChatParticipantModel extends ChatParticipant {
  const ChatParticipantModel({
    required super.id,
    required super.name,
    super.profileImage,
    required super.role,
    super.isOnline,
    super.lastSeen,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      role: json['role']?.toString() ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'].toString())
          : null,
    );
  }
}
