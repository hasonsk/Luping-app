import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Thêm dòng này
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hanjii/pages/chatbot/chatbot_lobby.dart';
import 'home.dart';
import 'profile.dart';
import 'notebook.dart';
import 'flashcard/flashcard_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _bottomShow = true;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      Home(
        onBottomNavVisibilityChanged: (bool isVisible) {
          setState(() {
            _bottomShow = isVisible; // Cập nhật trạng thái ẩn/hiện BottomNavigationBar
          });
        },
      ),
      const Notebook(),
      const FlashcardPage(),
      const Profile(),
      const ChatBotLobby(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _bottomShow? Container(
        height: 54,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black45,
              width: 0.5,
            ),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(child: _buildCustomBottomNavigationBarItem('assets/home.svg', 'Home', 0)),
            Expanded(child: _buildCustomBottomNavigationBarItem('assets/notebook.svg', 'Tài liệu', 1)),
            Expanded(child: _buildCustomBottomNavigationBarItem('assets/flashcard.svg', 'Thẻ nhớ', 2)),
            Expanded(child: _buildCustomBottomNavigationBarItem('assets/chatbot.svg', 'AI Chat', 4)),
            Expanded(child: _buildCustomBottomNavigationBarItem('assets/user.svg', 'Hồ sơ', 3)),
          ],
        ),
      ) : null
    );
  }

  Widget _buildCustomBottomNavigationBarItem(String assetPath, String label, int index) {
    final bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // Cập nhật màu thanh trạng thái dựa trên mục đã chọn
        _updateStatusBarColor(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              assetPath,
              color: isSelected ? Colors.green : Colors.grey,
              height: 22,
              width: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatusBarColor(int index) {
    switch (index) {
      case 1: // Sổ tay
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      case 2: // Thẻ nhớ
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      case 3: // Hồ sơ
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.grey[200],
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      case 4: // ChatBot
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      default: // Home
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
        break;
    }
  }
}
