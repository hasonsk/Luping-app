import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/pages/lessons/vocabulary/kanjivocab_learn_screen.dart';
import 'package:luping/pages/lessons/vocabulary/kanjivocab_test_screen.dart';
import '../../../models/lesson.dart';
import '../../../models/word.dart';

class VocabularyScreen extends StatelessWidget {
  final int lessonPosition;
  final List<Word> vocabularies;
  final String title;

  const VocabularyScreen(
      {Key? key,
      required this.lessonPosition,
      required this.vocabularies,
      required this.title})
      : super(key: key);

  void _navigateToLearnScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              KanjivocabLearnScreen(vocabularies: vocabularies)),
    );
  }

  void _navigateToTestScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              KanjivocabTestScreen(vocabularies: vocabularies)),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (title == 'Bắt đầu :') ...[
          const Spacer(), // Đẩy icon sang bên phải
          Image.asset(
            'assets/logo.png', // Đường dẫn hình ảnh
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bài ${lessonPosition} / $title',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          backgroundColor: Colors.white, // Màu nền của AppBar
          foregroundColor: Colors.black,
          elevation: 4,
          centerTitle: true,
          shadowColor: Colors.black,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor:
                Colors.white, // Đặt màu nền Status Bar trùng với AppBar
            statusBarIconBrightness:
                Brightness.dark, // Giữ icon status bar màu tối
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(254, 247, 255, 1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSectionTitle('Bắt đầu :', Colors.green),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildActionButton(context, Icons.school, 'Học',
                        () => _navigateToLearnScreen(context)),
                    const SizedBox(
                      width: 20,
                    ),
                    // _buildActionButton(context, Icons.edit, 'Luyện tập', () {}),
                    _buildActionButton(context, Icons.check, 'Kiểm tra',
                        () => _navigateToTestScreen(context)),
                  ],
                ),
                const SizedBox(height: 25),
                _buildSectionTitle('Hướng dẫn :', Colors.green),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(
                    title.contains("Hán tự")
                        ? 'Ở phần này chúng ta hãy cùng nhau chuẩn bị các Hán tự cần thiết cho bài mới nhé.'
                        : 'Ở phần này chúng ta sẽ tìm hiểu các từ vựng quan trọng của bài học.',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                Container(
                  width: double.infinity, // Chiều ngang tối đa
                  height: 1, // Chiều cao 1
                  color: Colors.grey.shade300, // Màu xám nhẹ
                ),
                const SizedBox(height: 25),
                _buildSectionTitle('Từ vựng : ', Colors.yellow),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: vocabularies.length,
                    itemBuilder: (context, index) {
                      return _buildVocabularyCard(
                          context, vocabularies[index], index + 1);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, -5), // Đổ bóng phía trên
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Kiểm tra!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton.icon(
                onPressed: () => _navigateToTestScreen(context),
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.grey[200],
                ),
                label: Text('Bắt đầu',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[200])),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 12), // Giảm padding
                  textStyle: const TextStyle(fontSize: 15), // Giảm font nếu cần
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Gọi hàm được truyền vào
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        textStyle: const TextStyle(fontSize: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // Giảm độ bo tròn xuống 4
        ),
      ),
    );
  }

  Widget _buildVocabularyCard(BuildContext context, Word word, int index) {
    return GestureDetector(
      onTap: () {
        showDetailWord(context, index - 1); // Truyền context vào đây
      },
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    Text(
                      word.word,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.pinyin ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDetailWord(BuildContext context, int startIndex) {
    PageController pageController = PageController(initialPage: startIndex);
    ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(startIndex);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height:
              MediaQuery.of(context).size.height * 0.6, // Chiếm 60% màn hình
          child: Column(
            children: [
              // Tiêu đề hiển thị số trang, dùng ValueListenableBuilder để cập nhật
              ValueListenableBuilder<int>(
                valueListenable: currentIndexNotifier,
                builder: (context, currentIndex, child) {
                  return Text(
                    "Từ ${currentIndex + 1}/${vocabularies.length}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 10),

              // PageView chứa từ vựng
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: vocabularies.length,
                  onPageChanged: (index) {
                    currentIndexNotifier.value =
                        index; // Cập nhật index trong ValueNotifier
                  },
                  itemBuilder: (context, index) {
                    Word word = vocabularies[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          word.word,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pinyin: ${word.pinyin}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Nghĩa: ${(word.meaning is List<String>) ? word.meaning.join(", ") : word.meaning}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (word.image != null) ...[
                          const SizedBox(height: 15),
                          Image.network(
                            word.image!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),

              // Nút điều hướng
              ValueListenableBuilder<int>(
                valueListenable: currentIndexNotifier,
                builder: (context, currentIndex, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: currentIndex > 0
                            ? () {
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: Icon(Icons.arrow_back,
                            color:
                                currentIndex > 0 ? Colors.black : Colors.grey),
                      ),
                      IconButton(
                        onPressed: currentIndex < vocabularies.length - 1
                            ? () {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: Icon(Icons.arrow_forward,
                            color: currentIndex < vocabularies.length - 1
                                ? Colors.black
                                : Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
