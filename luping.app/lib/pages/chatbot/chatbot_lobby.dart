import 'package:flutter/material.dart';
import 'chatbot_screen.dart';

class ChatBotLobby extends StatefulWidget {
  const ChatBotLobby({Key? key}) : super(key: key);

  @override
  _ChatBotLobbyState createState() => _ChatBotLobbyState();
}

class _ChatBotLobbyState extends State<ChatBotLobby> {
  static const Color primaryColor = Color(0xFF96D962);

  String? _selectedTarget;
  String? _selectedLevel;
  String? _selectedTopic;

  final List<String> targets = ["AI Chatbot", "Trợ lý học tập", "Hỗ trợ viên"];
  final List<String> levels = ["Cơ bản", "Trung cấp", "Nâng cao"];
  final List<String> topics = ["Công nghệ", "Kinh doanh", "Học tập", "Giải trí"];

  void _startChat() {
    if (_selectedTarget != null && _selectedLevel != null && _selectedTopic != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatBotScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn đầy đủ thông tin trước khi bắt đầu chat!")),
      );
    }
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          value: selectedItem,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontSize: 16)));
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Chatbot hoạt hình
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/chatbot.png"), // Thay bằng hình ảnh chatbot
                ),
                const SizedBox(height: 20),
                Text(
                  "Chào mừng bạn đến với ChatBot!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDropdown("Chọn đối tượng chat", targets, _selectedTarget,
                              (val) => setState(() => _selectedTarget = val)),
                      _buildDropdown("Chọn trình độ", levels, _selectedLevel,
                              (val) => setState(() => _selectedLevel = val)),
                      _buildDropdown("Chọn chủ đề", topics, _selectedTopic,
                              (val) => setState(() => _selectedTopic = val)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _startChat,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade300,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Bắt đầu chat",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
