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

  final List<String> chatHistory = [
    "Bạn: Xin chào! 🤖",
    "Bot: Chào bạn! Tôi có thể giúp gì?",
    "Bạn: Hôm nay thời tiết thế nào?",
    "Bot: Hôm nay trời nắng đẹp! 🌞",
    "Bạn: Cảm ơn nhé!",
  ];

  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định ngay khi mở màn hình
    _selectedTarget = targets.isNotEmpty ? targets.first : null;
    _selectedLevel = levels.isNotEmpty ? levels.first : null;
    _selectedTopic = topics.isNotEmpty ? topics.first : null;
  }

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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              ),
              value: selectedItem,
              onChanged: (val) {
                setState(() => onChanged(val));
              },
              dropdownColor: Colors.white,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChatTab() {
    return Column(
      children: [
        _buildDropdown("🎯 Chọn đối tượng", targets, _selectedTarget, (val) => _selectedTarget = val),
        _buildDropdown("📖 Trình độ", levels, _selectedLevel, (val) => _selectedLevel = val),
        _buildDropdown("📌 Chủ đề", topics, _selectedTopic, (val) => _selectedTopic = val),
      ],
    );
  }

  Widget _buildChatHistoryTab() {
    return Column(
      children: [
        SizedBox(height: 10,),
        // Danh sách lịch sử chat (sẽ chiếm toàn bộ không gian trống)
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: chatHistory.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return Text(
                chatHistory[index],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              );
            },
          ),
        ),

        // Nút "Tiếp tục chat" cố định ở dưới, căn phải
        SafeArea(
          child: Align(
            alignment: Alignment.centerRight, // Căn phải
            child: GestureDetector(
              onTap: () {
                // Điều hướng đến màn hình ChatBot
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ChatBotScreen()),
                // );
              },
              child: const Text(
                "Tiếp tục chat",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/logo.png"),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Chào mừng đến với AI Chatbot!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                          child: TabBar(
                            labelColor: primaryColor,
                            unselectedLabelColor: Colors.black54,
                            indicatorColor: primaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 3.0,
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(text: "Mới"),
                              Tab(text: "Lịch sử"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 12,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: _buildNewChatTab(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: _buildChatHistoryTab(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _startChat,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade400,
                          blurRadius: 10,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Bắt đầu chat",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
