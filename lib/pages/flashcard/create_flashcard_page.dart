import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/flashcard.dart';

class CreateFlashcardPage extends StatefulWidget {
  final Function(Flashcard) onCreate;

  const CreateFlashcardPage({super.key, required this.onCreate});

  @override
  _CreateFlashcardPageState createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _createFlashcard() {
    if (_nameController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      final newFlashcard = Flashcard(
        id: "flashcard_${DateTime.now().millisecondsSinceEpoch}",
        title: _nameController.text,
        createdAt: DateTime.now(),
        ownerId: "user_123",
        isPublic: false,
        items: [],
      );

      widget.onCreate(newFlashcard);
      Navigator.pop(context); // Quay lại danh sách flashcard
    }
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
                Text(
                  'Tạo Flashcard',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Tên Flashcard :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Nhập tên thẻ...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                fillColor: Colors.white,
                filled: true
              ),
            ),
            const SizedBox(height: 12),
            const Text("Nội dung :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "哈喽，喜欢，认识",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                filled: true,
                fillColor: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: _createFlashcard,
                  child: const Text("Tạo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
