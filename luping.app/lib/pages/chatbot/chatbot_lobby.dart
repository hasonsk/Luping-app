import 'package:flutter/material.dart';
import 'package:luping/services/chatbot_service.dart';
import 'chatbot_screen.dart';

class ChatBotLobby extends StatefulWidget {
  const ChatBotLobby({super.key});

  @override
  _ChatBotLobbyState createState() => _ChatBotLobbyState();
}

class _ChatBotLobbyState extends State<ChatBotLobby> {
  static const Color primaryColor = Color(0xFF96D962);

  String? _selectedTarget;
  String? _selectedLevel;
  String? _selectedTopic;

  final List<String> targets = [
    "Nữ sinh viên Trung Quốc 22 tuổi",
    "Nam hướng dẫn viên du lịch 30 tuổi",
    "Giáo viên tiếng Trung 35 tuổi",
    "Người bán hàng online 28 tuổi",
    "Nhân viên văn phòng 29 tuổi"
  ];
  final List<String> levels = ["Cơ bản", "Trung cấp", "Nâng cao"];
  final List<String> topics = [
    "Học tiếng Trung",
    "Giao tiếp hàng ngày",
    "Văn hóa giao tiếp Trung Quốc",
    "Lịch sử & Lễ hội Trung Quốc",
    "Cuộc sống hàng ngày của người Trung Quốc"
  ];

  final List<String> chatHistory = [
    "Bạn: Xin chào! 🤖",
    "Bot: Chào bạn! Tôi có thể giúp gì?",
    "Bạn: Hôm nay thời tiết thế nào?",
    "Bot: Hôm nay trời nắng đẹp! 🌞",
    "Bạn: Cảm ơn nhé!",
  ];

  Map<String, String> userOptions = {}; // Lưu trữ lựa chọn của người dùng

  // Import Chatbot Service
  final ChatbotService _chatbotService = ChatbotService();
  bool _isLoading = false; // Thêm biến để hiển thị loading indicator

  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định ngay khi mở màn hình
    _selectedTarget = targets.first;
    _selectedLevel = levels.first;
    _selectedTopic = topics.first;

    // Lưu vào userOptions với key hợp lý hơn
    userOptions["role"] = _selectedTarget!;
    userOptions["level"] = _selectedLevel!;
    userOptions["topic"] = _selectedTopic!;
  }

  Future<void> _initChat() async {
    setState(() => _isLoading = true); // Bắt đầu loading

    await _chatbotService.initChatSession(
      role: userOptions["role"] ?? "AI Chatbot", // Giá trị mặc định
      topic: userOptions["topic"] ?? "Công nghệ",
      chineseLevel: userOptions["level"] ?? "Cơ bản",
    );

    setState(() => _isLoading = false); // Kết thúc loading

    if (mounted) {
      Navigator.of(context).push(_createRoute());
    }

    print('Start chat screen');
  }

  /// Tạo hiệu ứng fade transition mượt mà
  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 500), // Thời gian hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatBotScreen(chatbotService: _chatbotService),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
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
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              ),
              value: selectedItem,
              onChanged: (val) {
                setState(() {
                  onChanged(val);
                  if (label == "🎯 Chọn đối tượng") {
                    userOptions["role"] = val ?? '';
                  } else if (label == "📖 Trình độ") {
                    userOptions["level"] = val ?? '';
                  } else if (label == "📌 Chủ đề") {
                    userOptions["topic"] = val ?? '';
                  }
                  print("Lựa chọn hiện tại: $userOptions");
                });
              },
              dropdownColor: Colors.white,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(item,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
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
        _buildDropdown("🎯 Chọn đối tượng", targets, _selectedTarget,
            (val) => _selectedTarget = val),
        _buildDropdown("📖 Trình độ", levels, _selectedLevel,
            (val) => _selectedLevel = val),
        _buildDropdown(
            "📌 Chủ đề", topics, _selectedTopic, (val) => _selectedTopic = val),
      ],
    );
  }

  Widget _buildChatHistoryTab() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
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
        SizedBox(
          height: 40,
        )
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
                SizedBox(
                  height: 20,
                ),
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
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 18),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: _buildNewChatTab(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                  onTap: _isLoading
                      ? null
                      : _initChat, // Vô hiệu hóa khi đang loading
                  child: Container(
                    width: 160, // Đặt chiều rộng cố định
                    height: 45, // Đặt chiều cao cố định
                    alignment: Alignment.center, // Căn giữa nội dung bên trong
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade400,
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Bắt đầu chat",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
