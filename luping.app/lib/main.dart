import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:luping/data/database_helper.dart';
import 'package:luping/services/chatbot_service.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/loading.dart';
import 'pages/auth/auth_page.dart';
import 'pages/character.dart';
import 'pages/word.dart';
import 'pages/note.dart';
import 'pages/gamescreen.dart';
import 'pages/main_screen.dart';

import 'models/chat_message.dart';
import 'models/chat_session.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dotenv, specifying the path.
  await dotenv.load(fileName: '.env');

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

  // Initialize Hive.
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ChatMessageAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ChatSessionAdapter());
  }

  // Khởi tạo Hive box cho chat session
  await ChatbotService().initHive();

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
        GetPage(
            name: '/',
            page: () => const Loading()), // Đổi trang khởi đầu thành Loading
        GetPage(
            name: '/main',
            page: () => const MainScreen()), // Đăng ký MainScreen
        GetPage(name: '/authpage', page: () => const AuthPage()),
        // GetPage(name: '/search', page: () => const Search()),
        GetPage(name: '/note', page: () => const Note()),
        GetPage(name: '/search/character', page: () => const Character()),
        GetPage(name: '/search/word', page: () => const WordInfo()),
        GetPage(name: '/game', page: () => GameScreen()),
      ],
    );
  }
}
