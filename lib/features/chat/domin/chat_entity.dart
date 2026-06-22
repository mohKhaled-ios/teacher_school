// // features/chat/domain/entities/chat_entity.dart
// import 'package:equatable/equatable.dart';

// class MessageEntity extends Equatable {
//   final String id;
//   final String senderId;
//   final String senderName;
//   final String? senderImage;
//   final String receiverId;
//   final String message;
//   final String messageType; // text, image, file
//   final String? fileUrl;
//   final bool isRead;
//   final DateTime createdAt;

//   const MessageEntity({
//     required this.id,
//     required this.senderId,
//     required this.senderName,
//     this.senderImage,
//     required this.receiverId,
//     required this.message,
//     this.messageType = 'text',
//     this.fileUrl,
//     required this.isRead,
//     required this.createdAt,
//   });

//   bool isMine(String currentUserId) => senderId == currentUserId;

//   @override
//   List<Object?> get props => [id, senderId, receiverId, message, createdAt];
// }

// class ChatRoomEntity extends Equatable {
//   final String id;
//   final List<ChatParticipant> participants;
//   final MessageEntity? lastMessage;
//   final DateTime updatedAt;

//   const ChatRoomEntity({
//     required this.id,
//     required this.participants,
//     this.lastMessage,
//     required this.updatedAt,
//   });

//   ChatParticipant otherParticipant(String myId) {
//     return participants.firstWhere(
//       (p) => p.id != myId,
//       orElse: () => participants.first,
//     );
//   }

//   @override
//   List<Object?> get props => [id, participants, updatedAt];
// }

// class ChatParticipant extends Equatable {
//   final String id;
//   final String name;
//   final String? profileImage;
//   final String role;
//   final bool isOnline;
//   final DateTime? lastSeen;

//   const ChatParticipant({
//     required this.id,
//     required this.name,
//     this.profileImage,
//     required this.role,
//     this.isOnline = false,
//     this.lastSeen,
//   });

//   ChatParticipant copyWith({bool? isOnline, DateTime? lastSeen}) {
//     return ChatParticipant(
//       id: id,
//       name: name,
//       profileImage: profileImage,
//       role: role,
//       isOnline: isOnline ?? this.isOnline,
//       lastSeen: lastSeen ?? this.lastSeen,
//     );
//   }

//   @override
//   List<Object?> get props => [id, name, role, isOnline, lastSeen];
// }
// features/chat/domain/entities/chat_entity.dart
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String receiverId;
  final String message;
  final String messageType; // text, image, file
  final String? fileUrl;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.receiverId,
    required this.message,
    this.messageType = 'text',
    this.fileUrl,
    required this.isRead,
    required this.createdAt,
  });

  bool isMine(String currentUserId) => senderId == currentUserId;

  @override
  List<Object?> get props => [id, senderId, receiverId, message, createdAt];
}

class ChatRoomEntity extends Equatable {
  final String id;
  final List<ChatParticipant> participants;
  final MessageEntity? lastMessage;
  final DateTime updatedAt;

  const ChatRoomEntity({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.updatedAt,
  });

  /// Get the other participant in the chat room
  /// Returns null if no other participant found
  ChatParticipant? otherParticipant(String myId) {
    if (participants.isEmpty) return null;

    final others = participants.where((p) => p.id != myId);
    return others.isNotEmpty ? others.first : participants.first;
  }

  @override
  List<Object?> get props => [id, participants, lastMessage, updatedAt];
}

class ChatParticipant extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final String role;
  final bool isOnline;
  final DateTime? lastSeen;

  const ChatParticipant({
    required this.id,
    required this.name,
    this.profileImage,
    required this.role,
    this.isOnline = false,
    this.lastSeen,
  });

  ChatParticipant copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? role,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  List<Object?> get props => [id, name, profileImage, role, isOnline, lastSeen];
}
