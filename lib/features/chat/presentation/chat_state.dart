// features/chat/presentation/cubit/chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:teacher_management_app/features/chat/domin/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

// قائمة المحادثات
class ChatRoomsLoaded extends ChatState {
  final List<ChatRoomEntity> rooms;
  const ChatRoomsLoaded(this.rooms);
  @override
  List<Object?> get props => [rooms];
}

// الرسائل داخل محادثة
class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  final bool isTyping;
  const MessagesLoaded(this.messages, {this.isTyping = false});

  MessagesLoaded copyWith({List<MessageEntity>? messages, bool? isTyping}) {
    return MessagesLoaded(
      messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

// قائمة المستخدمين لبدء محادثة جديدة
class UsersLoaded extends ChatState {
  final List<ChatParticipant> users;
  const UsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}
