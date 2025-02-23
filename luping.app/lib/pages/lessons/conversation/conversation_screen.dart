import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/pages/lessons/conversation/pronunciation_assessment_screen.dart';
import '/models/pronunciation_assessment_result.dart';
import '/services/pronunciation_assessment_service.dart';
import '../../../models/lesson.dart';
import '/services/tts_service.dart';

class ConversationScreen extends StatefulWidget {
  final Lesson lesson;

  const ConversationScreen({super.key, required this.lesson});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // Danh sách tất cả tin nhắn
  final List<String> messages = [
    '你好！', // "Chào bạn!"
    '你好！你好吗？', // "Chào bạn! Bạn khỏe không?"
    '我很好，谢谢。你呢？！', // "Tôi khỏe, cảm ơn!"
    '我也很好。谢谢！', // "Tôi cũng khỏe, cảm ơn!"
  ];

  // Chỉ số tin nhắn hiện tại đang được hiển thị
  int currentMessageIndex = 0;

  // Hàm hiển thị tin nhắn tiếp theo
  void showNextMessage() {
    if (currentMessageIndex < messages.length - 1) {
      setState(() {
        currentMessageIndex++;
        _speakText(messages[currentMessageIndex]); // Tự động phát âm tin nhắn
      });
    }
  }

  void _speakText(message) {
    try {
      TtsService().playAudio(message);
    } catch (e) {
      debugPrint("Lỗi phát âm thanh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách các tin nhắn cần hiển thị (từ đầu đến currentMessageIndex)
    final List<String> displayedMessages = messages.sublist(
        0,
        currentMessageIndex < messages.length
            ? currentMessageIndex + 1
            : messages.length);

    return PopScope(
      canPop: false, // Prevents default pop behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // If pop was already handled, do nothing

        bool exit = await _showExitDialog(context);
        if (exit) {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 20),
              onPressed: () async {
                bool exit = await _showExitDialog(context);
                if (exit) Navigator.pop(context);
              },
            ),
            title: Text(
              'Bài ${widget.lesson.lessonId} / Hội thoại',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 4,
            centerTitle: true,
            shadowColor: Colors.black87,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: displayedMessages.length,
                  itemBuilder: (context, index) {
                    bool isUser = index % 2 != 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUser) _buildAvatar(isUser),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.green : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: isUser
                                      ? const Radius.circular(18)
                                      : Radius.zero,
                                  bottomRight: isUser
                                      ? Radius.zero
                                      : const Radius.circular(18),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayedMessages[index],
                                      style: TextStyle(
                                        color: isUser
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(
                                      Icons.volume_up,
                                      color: isUser
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                    onPressed: () =>
                                        _speakText(displayedMessages[index]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isUser) _buildAvatar(isUser),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Kiểm tra điều kiện để hiển thị phần micro hoặc thông báo hoàn thành
              if (currentMessageIndex < messages.length)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            String textToAssess = messages[currentMessageIndex];
                            final assessmentService =
                                PronunciationAssessmentService();

                            bool? isAssessmentComplete =
                                await showModalBottomSheet<bool>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.4,
                                  child: Center(
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 600),
                                      padding: const EdgeInsets.all(16),
                                      child: PronunciationAssessmentWidget(
                                        textToPronounce: textToAssess,
                                        assessmentService: assessmentService,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            if (isAssessmentComplete == true) {
                              setState(() {
                                if (currentMessageIndex < messages.length - 1) {
                                  showNextMessage();
                                } else {
                                  // Nếu đã đạt tin nhắn cuối, cập nhật lại giao diện
                                  currentMessageIndex = messages.length;
                                  // Dispose service sau khi tin nhắn cuối cùng được thực hiện
                                  assessmentService.dispose();
                                }
                              });
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: const Icon(Icons.mic,
                                size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const Text('Hãy lắng nghe và chọn micro để kiểm tra',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // Cập nhật giá trị hoặc thực hiện hành động khi nhấn
                    },
                    onHover: (isHovering) {
                      // Chỉnh sửa hiệu ứng khi hover (nếu cần)
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Thêm icon đáng yêu và màu sắc tươi sáng
                        Icon(
                          Icons.emoji_events, // Icon chiến thắng
                          size: 60,
                          color: Colors.yellow.shade600, // Màu vàng tươi sáng
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Chúc mừng! Bạn đã hoàn thành bài tập.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Colors.blue.shade700, // Màu xanh dương dễ chịu
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green, // Nền màu xanh dễ thương
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back, // Icon mũi tên quay lại
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Quay lại',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          )),
    );
  }

  // Hiển thị dialog xác nhận khi thoát
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Xác nhận thoát",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: const Text(
              "Bạn chắc chắn muốn thoát ứng dụng? Tất cả tiến trình học hiện tại sẽ bị mất nếu bạn thoát.",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Hủy",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Thoát",
                    style: TextStyle(color: Colors.red, fontSize: 14)),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Widget avatar (bot dùng ảnh logo.png, user dùng icon)
  Widget _buildAvatar(bool isUser) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isUser ? Colors.green : Colors.transparent,
      child: isUser
          ? const Icon(Icons.person, color: Colors.white, size: 24)
          : ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
                width: 34,
                height: 34,
              ),
            ),
    );
  }
}
