import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanjii/pages/lessons/conversation/pronunciation_assessment_screen.dart';
import '/models/pronunciation_assessment_result.dart';
import '/services/pronunciation_assessment_service.dart';
import '../../../models/lesson.dart';
import '/services/tts_service.dart';

class ConversationScreen extends StatefulWidget {
  final Lesson lesson;

  const ConversationScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int userScore = 0; // Biến lưu điểm số của người dùng
  int wrongAnswers = 0; // Biến lưu trữ số lỗi sai (ví dụ)

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
    final List<String> displayedMessages = messages.sublist(0, currentMessageIndex + 1);

    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 20),
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
            SizedBox(height: 10),
            // Danh sách tin nhắn
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: displayedMessages.length,
                itemBuilder: (context, index) {
                  bool isUser = index % 2 != 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUser) _buildAvatar(isUser),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.green : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: isUser ? Radius.circular(18) : Radius.zero,
                                bottomRight: isUser ? Radius.zero : Radius.circular(18),
                              ),
                              boxShadow: [
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
                                      color: isUser ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(
                                    Icons.volume_up,
                                    color: isUser ? Colors.white : Colors.black54,
                                  ),
                                  onPressed: () => _speakText(displayedMessages[index]), // Phát âm thanh cho cả user và bot
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
            // Nút để hiển thị tin nhắn tiếp theo (chỉ hiển thị nếu còn tin nhắn)
            if (currentMessageIndex < messages.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: showNextMessage,
                  child: Text('Tin nhắn tiếp theo'),
                ),
              ),
            // Phần Micro + Điểm
            Text('Hãy nghe và chọn micro để kiểm tra',style: TextStyle(fontSize: 16),),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Số lỗi sai bên trái
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 24),
                          SizedBox(width: 6),
                          Text(
                            '$wrongAnswers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Micro ở giữa
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          String textToAssess = messages[currentMessageIndex];

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.4,
                                child: Center(
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 600),
                                    padding: const EdgeInsets.all(16),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return PronunciationAssessmentWidget(textToPronounce: textToAssess);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).whenComplete(() {
                            debugPrint("Đóng BottomSheet - Xóa tài nguyên");
                          });
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
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.mic, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Điểm số bên phải
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 24),
                          SizedBox(width: 6),
                          Text(
                            "$userScore",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị dialog xác nhận khi thoát
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Xác nhận thoát",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          "Bạn chắc chắn muốn thoát ứng dụng? Tất cả tiến trình học hiện tại sẽ bị mất nếu bạn thoát.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Hủy", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Thoát", style: TextStyle(color: Colors.red, fontSize: 14)),
          ),
        ],
      ),
    ) ?? false;
  }

  // Widget avatar (bot dùng ảnh logo.png, user dùng icon)
  Widget _buildAvatar(bool isUser) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isUser ? Colors.green : Colors.transparent,
      child: isUser
          ? Icon(Icons.person, color: Colors.white, size: 24)
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
