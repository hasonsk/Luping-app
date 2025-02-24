import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luping/pages/profile.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/search_container.dart';
import '../../widgets/shimmer_image_grid.dart';
import '../note.dart';
import 'package:shimmer/shimmer.dart';
import 'package:luping/pages/search/search.dart';

class Home extends StatefulWidget {
  final ValueChanged<bool> onBottomNavVisibilityChanged;

  const Home({super.key, required this.onBottomNavVisibilityChanged});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> data = ['Từ vựng', 'Story', 'Mẫu câu', 'Hình ảnh'];
  static const Color primaryColor = Color(0xFF96D962);
  int _currentPageIndex = 0;
  int shareIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex == 0 ? _buildAppBar() : null,
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          _buildHomePage(),
          _buildSearchPage(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(color: primaryColor),
      actions: [
        const SizedBox(width: 15),
        FirebaseAuth.instance.currentUser == null
            ? Row(
                children: [
                  _buildAppBarButton(
                    onPressed: () => Get.toNamed('/authpage',
                        arguments: {'isLoginMode': true}),
                    text: 'Đăng nhập',
                    isElevated: true,
                  ),
                  _buildAppBarButton(
                    onPressed: () => Get.toNamed('/authpage',
                        arguments: {'isLoginMode': false}),
                    text: 'Đăng ký',
                    isElevated: false,
                  ),
                ],
              )
            : PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  } else if (value == 'logout') {
                    FirebaseAuth.instance.signOut().then((_) {
                      Get.offAllNamed('/');
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Text('Quản lý trang cá nhân'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Đăng xuất'),
                    ),
                  ];
                },
                icon: CircleAvatar(
                  backgroundImage:
                      FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!)
                          : AssetImage('/images/default_avatar.png'),
                ),
              ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildHomePage() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildFunctionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchPage() {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _currentPageIndex = 0;
          widget.onBottomNavVisibilityChanged(true);
        });
        return false;
      },
      child: Search(
        onBack: () {
          setState(() {
            _currentPageIndex = 0;
            widget.onBottomNavVisibilityChanged(true);
          });
        },
        sharedIndex: shareIndex,
        pageIndex: _currentPageIndex,
      ),
    );
  }

  Widget _buildAppBarButton({
    required VoidCallback onPressed,
    String? text,
    bool isElevated = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: isElevated
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(30, 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: Text(
                text!,
                style: const TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            )
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
              child: Text(
                text!,
                style: const TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Nihao Luping!',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  Text(
                    '超级词典',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/logo.png'),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 35),
            ],
          ),
          _buildSearchContainer(),
          _buildHistoryRow(),
        ],
      ),
    );
  }

  Widget _buildSearchContainer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentPageIndex = 1;
            widget.onBottomNavVisibilityChanged(false);
          });
        },
        child: const SearchContainer(),
      ),
    );
  }

  Widget _buildHistoryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 3, 20, 10),
      child: Row(
        children: [
          const Icon(Icons.filter_list_outlined, size: 19, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: data.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentPageIndex = 1;
                          widget.onBottomNavVisibilityChanged(false);
                          shareIndex = data.indexOf(item);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        minimumSize: const Size(0, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionSection() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
              child: BannerSlider(
                images: [
                  'assets/banner_test.png',
                  'assets/banner_test.png',
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Các chức năng khác', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            _buildSectionTitle(
                'HSK/ Từ vựng', Colors.green, 'assets/twobird_ic (1).png'),
            const SizedBox(height: 15),
            const ShimmerImageGrid(),
            const SizedBox(height: 15),
            _buildSectionTitle(
                'Bạn bè', Colors.purple, 'assets/goccay_icon_1 (1).png'),
            const SizedBox(height: 15),
            const SizedBox(height: 100),
            const Center(
              child: Text(
                'Fanpage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/fb_ic.png'),
                    height: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Luping Dict',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const Expanded(child: SizedBox()),
        Image(
          image: AssetImage(image),
          height: 25,
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
