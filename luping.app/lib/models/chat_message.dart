import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String sender; // "User" or "AI"

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  /// Convert the message to the API format.
  /// For example: "[User] Hello"
  String toApiFormat() => "[$sender] $message";
}
