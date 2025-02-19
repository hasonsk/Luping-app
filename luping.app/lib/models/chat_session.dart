import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 1)
class ChatSession extends HiveObject {
  @HiveField(0)
  String role;

  @HiveField(1)
  String topic;

  @HiveField(2)
  String chineseLevel;

  @HiveField(3)
  List<ChatMessage> messages;

  ChatSession({
    required this.role,
    required this.topic,
    required this.chineseLevel,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  /// Add a new message to the session.
  void addMessage(ChatMessage message) {
    messages.add(message);
    save(); // Persist changes.
  }

  /// Clear all messages in this session.
  void clearMessages() {
    messages.clear();
    save();
  }
}
