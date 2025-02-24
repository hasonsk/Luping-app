import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String sender; // "User" or "AI"

  @HiveField(1)
  final String sentence;

  @HiveField(2)
  final String pinyin;

  @HiveField(3)
  final String meaningVN;

  @HiveField(4)
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.sentence,
    required this.pinyin,
    required this.meaningVN,
    required this.timestamp,
  });

  String toApiFormat() =>
      "[$sender] $sentence"; // Changed from message to sentence
}
