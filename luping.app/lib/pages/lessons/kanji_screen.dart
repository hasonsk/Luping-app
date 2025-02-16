import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanjii/pages/lessons/kanjivocab_learn_screen.dart';
import '../../models/lesson.dart';
import 'kanjivocab_test_screen.dart';

class KanjiScreen extends StatelessWidget {
  final Lesson lesson;

  const KanjiScreen({Key? key, required this.lesson}) : super(key: key);

  void _navigateToLearnScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KanjivocabLearnScreen()),
    );
  }

  void _navigateToTestScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KanjivocabTestScreen()),
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
            'Bài ${lesson.index} / Chuẩn bị',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white, // Màu nền của AppBar
          foregroundColor: Colors.black,
          elevation: 4,
          centerTitle: true,
          shadowColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white, // Đặt màu nền Status Bar trùng với AppBar
            statusBarIconBrightness: Brightness.dark, // Giữ icon status bar màu tối
          ),
        ),
      body: Container(
        color: const Color.fromRGBO(254, 247, 255, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _buildSectionTitle('Bắt đầu :', Colors.green),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildActionButton(context, Icons.school, 'Học', () => _navigateToLearnScreen(context)),
                  SizedBox(width: 20,),
                  // _buildActionButton(context, Icons.edit, 'Luyện tập', () {}),
                  // _buildActionButton(context, Icons.check, 'Kiểm tra', () => _navigateToTestScreen(context)),
                ],
              ),
              const SizedBox(height: 25),
              _buildSectionTitle('Hướng dẫn :', Colors.green),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Text('Ở phần này chúng ta hãy cùng nhau chuẩn bị các Hán tự cần thiết cho bài mới nhé.', style: TextStyle(color: Colors.black87),),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: lesson.vocabulary.length,
                  itemBuilder: (context, index) {
                    return _buildVocabularyCard(lesson.vocabulary[index], index + 1);
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
              offset: Offset(0, -5), // Đổ bóng phía trên
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 20,),
            Text(
              'Kiểm tra!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(child: SizedBox()),
            ElevatedButton.icon(
              onPressed: () => _navigateToTestScreen(context),
              icon: Icon(Icons.play_arrow, color: Colors.grey[200],),
              label: Text('Bắt đầu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[200])),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Giảm padding
                textStyle: TextStyle(fontSize: 15), // Giảm font nếu cần
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
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



  Widget _buildVocabularyCard(String vocab, int index) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0), // Giảm border radius xuống 4
      ),
      child: Center(
        child: Text(
          vocab,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}
