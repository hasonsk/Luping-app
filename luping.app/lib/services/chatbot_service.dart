import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/chat_message.dart';
import '../models/chatbot_response.dart';
import '../models/chat_session.dart';

class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  // Hive box to store the chat session.
  late Box<ChatSession> _sessionBox;

  Box<ChatSession> get sessionBox => _sessionBox;

  /// Initialize Hive and open the chat session box.
  Future<void> initHive() async {
    _sessionBox = await Hive.openBox<ChatSession>('chatSession');
  }

  /// Initialize a new chat session (clearing any previous session).
  Future<void> initSession({
    required String role,
    required String topic,
    required String chineseLevel,
  }) async {
    // Create a new session and store it.
    ChatSession session = ChatSession(
      role: role,
      topic: topic,
      chineseLevel: chineseLevel,
    );
    await _sessionBox.put('current_session', session);
  }

  /// Retrieve the current chat session.
  ChatSession? get currentSession => _sessionBox.get('current_session');

  /// Add a message to the current session.
  Future<void> addMessage(ChatMessage message) async {
    final session = currentSession;
    if (session != null) {
      session.addMessage(message);
    } else {
      throw Exception("Chat session is not initialized.");
    }
  }

  /// Clear the current chat session.
  Future<void> clearSession() async {
    await _sessionBox.delete('current_session');
  }

  /// Build the chat history in the API required format.
  List<String> buildApiChatHistory() {
    final session = currentSession;
    if (session == null) return [];
    return session.messages.map((msg) => msg.toApiFormat()).toList();
  }

  /// Aggregate chatbot response by joining all sentences.
  String aggregateResponseSentences(ChatbotResponse response) {
    return response.responseSentences.map((s) => s.sentence).join(" ");
  }

  /// Makes the POST API call.
  Future<ChatbotResponse?> fetchChatResponse({required String userMessage}) async {
    final session = currentSession;
    if (session == null) {
      throw Exception("Chat session is not initialized.");
    }

    final serverBaseUrl = dotenv.env['SERVER_BASE_URL'] ?? '';
    final url = Uri.parse("$serverBaseUrl/chatbot/response");

    final Map<String, dynamic> requestData = {
      "role": session.role,
      "topic": session.topic,
      "chinese_level": session.chineseLevel,
      "user_message": userMessage,
      "chat_history": buildApiChatHistory(),
    };

    // Add user's message.
    await addMessage(ChatMessage(
      sender: "User",
      message: userMessage,
      timestamp: DateTime.now(),
    ));

    try {
      final response = await http
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatbotResponse = ChatbotResponse.fromJson(jsonResponse);

        final aggregatedResponse = aggregateResponseSentences(chatbotResponse);

        // Add AI's response.
        await addMessage(ChatMessage(
          sender: "AI",
          message: aggregatedResponse,
          timestamp: DateTime.now(),
        ));

        return chatbotResponse;
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Network error: $e");
      return null;
    }
  }
}
