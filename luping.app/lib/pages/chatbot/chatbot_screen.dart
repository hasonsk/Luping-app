import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'chatbot_screen_appbar.dart';
import 'chatbot_screen_bottomsheet.dart';
import 'package:hanjii/services/chatbot_service.dart';
import 'package:hanjii/models/chat_message.dart';
import 'package:hanjii/models/chat_session.dart';

class ChatBotScreen extends StatefulWidget {
  final ChatbotService chatbotService;

  const ChatBotScreen({Key? key, required this.chatbotService}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {

  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();

  static const Color primaryColor = Color(0xFF96D962);
  static const Color botColor = Color(0xFFFAE3D9);
  static const Color userColor = Color(0xFFC2F0C2);
  static const List<String> botEmojis = ["🤖", "😊", "🎉", "💡"];

  bool _isLoading = false; // Thêm biến để hiển thị loading indicator


  @override
  void initState() {
    super.initState();
    // Đảm bảo màu status bar được set trước khi giao diện hiển thị
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  Future<void> _sendMessage() async {
    final userMessage = _textController.text.trim();
    if (userMessage.isEmpty) return; // Không gửi tin nhắn trống

    print("Người dùng gửi: $userMessage"); // In tin nhắn của người dùng

    setState(() {
      _messages.add(userMessage); // Thêm tin nhắn người dùng vào danh sách
      _textController.clear();
      _isLoading = true; // Hiển thị trạng thái loading
    });

    _scrollToBottom(); // Cuộn xuống tin nhắn mới nhất

    try {
      // Gửi tin nhắn đến chatbot và nhận phản hồi
      final botReply = await widget.chatbotService.fetchChatResponse(userMessage: userMessage);

      print("Chatbot phản hồi: $botReply"); // In phản hồi từ chatbot

      setState(() {
        _messages.add("${botEmojis[Random().nextInt(botEmojis.length)]} $botReply");
        _isLoading = false; // Kết thúc trạng thái loading
      });
    } catch (e) {
      print("Lỗi khi gọi chatbotService: $e"); // In lỗi nếu có vấn đề xảy ra
      setState(() => _isLoading = false);
    }

    _scrollToBottom(); // Cuộn xuống để hiển thị tin nhắn mới
  }



  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          Positioned(top: -40, left: -30, child: _buildFloatingCircle(90, Colors.green.withOpacity(0.2))),
          Positioned(top: 100, right: -50, child: _buildFloatingCircle(120, Colors.pink.withOpacity(0.2))),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 150 - MediaQuery.of(context).viewInsets.bottom : 150,
            left: -40,
            child: _buildFloatingCircle(80, Colors.orange.withOpacity(0.2)),
          ),
          Column(
            children: [
              const ChatBotAppBar(),
              Expanded(
                child: _buildChatList(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onEditingComplete: _sendMessage,
                        decoration: InputDecoration(
                          hintText: 'Nhập tin nhắn...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          prefixIcon: const Icon(Icons.sentiment_satisfied_alt, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _sendMessage,
                      backgroundColor: primaryColor,
                      mini: true,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildChatList() {
    return StreamBuilder<ChatSession?>(
      stream: widget.chatbotService.currentSessionStream, // Lắng nghe stream của session
      builder: (context, snapshot) {
        final session = snapshot.data;
        final messages = session?.messages ?? []; // Lấy danh sách tin nhắn

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildChatMessage(message); // Hàm tạo UI cho từng tin nhắn
          },
        );
      },
    );
  }

// Hàm xây dựng UI cho từng tin nhắn
  Widget _buildChatMessage(ChatMessage message) {
    final bool isUser = message.sender == "User"; // Kiểm tra xem tin nhắn là của người dùng hay chatbot

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isUser)
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 18,
            child: Icon(Icons.android, color: Colors.white),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent : Colors.green,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.sentence, // Nội dung câu
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.pinyin, // Hiển thị phiên âm Pinyin
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.meaningVN, // Hiển thị nghĩa tiếng Việt
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (isUser)
          const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(Icons.person, color: Colors.white),
          ),
      ],
    );
  }





  Widget _buildFloatingCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
