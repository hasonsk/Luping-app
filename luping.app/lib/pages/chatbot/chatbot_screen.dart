import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'chatbot_screen_appbar.dart';
import 'chatbot_screen_bottomsheet.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();

  static const Color primaryColor = Color(0xFF96D962);
  static const Color botColor = Color(0xFFFAE3D9);
  static const Color userColor = Color(0xFFC2F0C2);
  static const List<String> botEmojis = ["🤖", "😊", "🎉", "💡"];

  @override
  void initState() {
    super.initState();
    // Đảm bảo màu status bar được set trước khi giao diện hiển thị
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
        _controller.clear();
        _scrollToBottom();

        // Bot phản hồi ngẫu nhiên
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _messages.add("${botEmojis[Random().nextInt(botEmojis.length)]} Tôi đã nhận tin nhắn của bạn!");
            _scrollToBottom();
          });
        });
      });
    }
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
    _controller.dispose();
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
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    bool isUser = index.isEven;
                    return GestureDetector(
                      onLongPress: () {
                        showChatBotBottomSheet(context, _messages[index]);
                      },
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser)
                            const CircleAvatar(
                              backgroundColor: botColor,
                              radius: 18,
                              child: Icon(Icons.android, color: Colors.brown),
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isUser ? userColor : botColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _messages[index],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isUser)
                            const CircleAvatar(
                              backgroundColor: userColor,
                              radius: 18,
                              child: Icon(Icons.person, color: Colors.blueGrey),
                            ),
                        ],
                      ),
                    );
                  },
                ),
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
                        controller: _controller,
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
