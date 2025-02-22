import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/flashcard.dart';
import 'create_flashcard_page.dart';
import 'flashcard_content_page.dart'; // Import màn hình cần chuyển đến

class FlashcardListPage extends StatelessWidget {
  final List<Flashcard> flashcards;

  const FlashcardListPage({super.key, required this.flashcards});

  // Hàm điều hướng đến FlashcardContentPage
  void _navigateToFlashcardPage(BuildContext context, Flashcard flashcard) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlashcardContentPage(flashcard: flashcard)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 5.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.stacked_bar_chart, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Trình tạo Flashcard / Lưu trữ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: 23,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Bộ thẻ :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4, // Giữ nguyên tỷ lệ
                ),
                itemCount: flashcards.length + 1, // Thêm 1 ô "Mới"
                itemBuilder: (context, index) {
                  Widget folderButton;
                  if (index < flashcards.length) {
                    final flashcard = flashcards[index];
                    folderButton = GestureDetector(
                      onTap: () => _navigateToFlashcardPage(context, flashcard), // Gọi hàm điều hướng
                      child: Stack(
                        children: [
                          // Tab trên của folder
                          Positioned(
                            top: 0,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                              ),
                            ),
                          ),
                          // Nội dung chính của folder
                          Container(
                            width: double.infinity, // Để Flutter tự động chia đều
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: const Offset(-3, 0), // Bóng đổ về bên trái
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Icon(Icons.folder, color: Colors.blueGrey, size: 24),
                                const Spacer(),
                                Text(
                                  flashcard.title,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${flashcard.createdAt.day}/${flashcard.createdAt.month}/${flashcard.createdAt.year}",
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    folderButton = GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateFlashcardPage(onCreate: (newFlashcard) {
                            flashcards.add(newFlashcard);
                          })),
                        );
                      },
                      child: Stack(
                        children: [
                          // Tab trên của folder
                          Positioned(
                            top: 0,
                            left: 10,
                            right: 10,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                              ),
                            ),
                          ),
                          // Nội dung chính của folder
                          Container(
                            width: double.infinity, // Tự động chia đều
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: const Offset(-3, 0), // Bóng đổ về bên trái
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, color: Colors.blueGrey, size: 28),
                                  SizedBox(height: 6),
                                  Text("Mới", style: TextStyle(fontSize: 13, color: Colors.black87)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return folderButton;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
