import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:hanjii/services/database_helper.dart';
import 'pages/loading.dart';
// import 'pages/authpage.dart';
import 'pages/auth/auth_page.dart';
import 'pages/character.dart';
import 'pages/word.dart';
import 'pages/note.dart';
import 'pages/gamescreen.dart';
import 'pages/mainscreen.dart';
import 'package:flutter/services.dart';
// Import lớp quản lý cơ sở dữ liệu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAzH0xZuKdzWOmtB6VKr2h8lAu98dQvCQI',
      appId: '1:1041014738919:android:40653e3f765a2d2e3f7742',
      messagingSenderId: '1041014738919',
      projectId: 'hanziforest-3137d',
      storageBucket: 'hanziforest-3137d.appspot.com',
    ),
  );

  // Đảm bảo cơ sở dữ liệu tồn tại
  await DatabaseHelper.ensureDatabase();
  await DatabaseHelper.testDatabase();

  // Khởi chạy ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Loading()), // Đổi trang khởi đầu thành Loading
        GetPage(name: '/main', page: () => MainScreen()), // Đăng ký MainScreen
        GetPage(name: '/authpage', page: () => AuthPage()),
        // GetPage(name: '/search', page: () => const Search()),
        GetPage(name: '/note', page: () => const Note()),
        GetPage(name: '/search/character', page: () => const Character()),
        GetPage(name: '/search/word', page: () => const WordInfo()),
        GetPage(name: '/game', page: () => GameScreen()),
      ],
    );
  }
}
