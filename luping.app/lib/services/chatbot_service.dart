import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import '../models/chat_message.dart';
import '../models/chatbot_response.dart';
import '../models/chat_session.dart';
import 'package:logger/logger.dart';

class ChatbotService {
  static final logger = Logger();

  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  // Hive box to store the chat session.
  late Box<ChatSession> _sessionBox;

  Box<ChatSession> get sessionBox => _sessionBox;

  // Create a BehaviorSubject to hold and stream the current session
  final _currentSessionSubject = BehaviorSubject<ChatSession?>.seeded(null);
  Stream<ChatSession?> get currentSessionStream =>
      _currentSessionSubject.stream;

  /// Retrieve the current chat session.
  ChatSession? get currentSession => _sessionBox.get('current_session');

  /// Initialize Hive and open the chat session box.
  Future<void> initHive() async {
    _sessionBox = await Hive.openBox<ChatSession>('chatSession');
    // Listen to changes on the 'current_session' and update the stream
    _sessionBox.watch(key: 'current_session').listen((event) {
      _currentSessionSubject.add(_sessionBox.get('current_session'));
    });
    //Initial load
    _currentSessionSubject.add(_sessionBox.get('current_session'));
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

  /// Add a message to the current session.
  // Updated to accept optional pinyin and meaningVN
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

  /// Makes the POST API call.
  Future<ChatbotResponse?> fetchChatResponse(
      {required String userMessage}) async {
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
      sentence: userMessage, // Changed from message to sentence
      pinyin: '', // Leave empty for user messages
      meaningVN: '', // Leave empty for user messages
      timestamp: DateTime.now(),
    ));

    logger.i("API request data: ${jsonEncode(requestData)}");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatbotResponse = ChatbotResponse.fromJson(jsonResponse);

        // Add AI's response.
        await addMessage(ChatMessage(
          sender: "AI",
          sentence: chatbotResponse.response.sentence, // Changed from message
          pinyin: chatbotResponse.response.pinyin,
          meaningVN: chatbotResponse.response.meaningVN,
          timestamp: DateTime.now(),
        ));

        return chatbotResponse;
      } else {
        logger.e("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      logger.e("Network error: $e");
      return null;
    }
  }

  /// Initialize a chat session and get first response from API
  Future<ChatbotResponse?> initChatSession({
    required String role,
    required String topic,
    required String chineseLevel,
  }) async {
    // Clear existing session
    await clearSession();

    // Create new session
    await initSession(
      role: role,
      topic: topic,
      chineseLevel: chineseLevel,
    );

    final serverBaseUrl = dotenv.env['SERVER_BASE_URL'] ?? '';
    final url = Uri.parse("$serverBaseUrl/chatbot/response");

    final Map<String, dynamic> requestData = {
      "role": role,
      "topic": topic,
      "chinese_level": chineseLevel,
      "user_message": "",
      "chat_history": [],
    };

    logger.i("API request data: ${jsonEncode(requestData)}");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatbotResponse = ChatbotResponse.fromJson(jsonResponse);

        // Add AI's initial response
        await addMessage(ChatMessage(
          sender: "AI",
          sentence: chatbotResponse.response.sentence, // Changed from message
          pinyin: chatbotResponse.response.pinyin,
          meaningVN: chatbotResponse.response.meaningVN,
          timestamp: DateTime.now(),
        ));

        return chatbotResponse;
      } else {
        logger.e("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      logger.e("Network error: $e");
      return null;
    }
  }
}