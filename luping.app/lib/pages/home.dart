// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:flutter_svg/flutter_svg.dart';
import 'note.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hanjii/pages/search/search.dart';

class Home extends StatefulWidget {
  final ValueChanged<bool>
      onBottomNavVisibilityChanged; // Callback để báo hiệu cho MainScreen

  const Home({super.key, required this.onBottomNavVisibilityChanged});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> data = ['Từ vựng', 'Story', 'Mẫu câu', 'Hình ảnh'];
  static const Color primaryColor = Color(0xFF96D962);
  int _currentPageIndex = 0; // Thay đổi để quản lý chỉ mục trang hiện tại
  int shareIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex == 0 // Hiển thị AppBar nếu đang ở trang Home
          ? AppBar(
              elevation: 0, // Loại bỏ hiệu ứng đổ bóng
              flexibleSpace:
                  Container(color: primaryColor), // Đặt màu nền cố định
              actions: [
                const SizedBox(
                  width: 15,
                ),
                _buildAppBarButton(
                  onPressed: () {
                    Get.toNamed('/authpage', arguments: {'isLoginMode': true});
                  },
                  text: 'Đăng nhập',
                  icon: null,
                  isElevated: true,
                ),
                _buildAppBarButton(
                  onPressed: () {
                    Get.toNamed('/authpage', arguments: {'isLoginMode': false});
                  },
                  text: 'Đăng ký',
                  icon: null,
                  isElevated: false,
                ),
                const Expanded(child: SizedBox()),
                // _buildAppBarButton(
                //   onPressed: () {},
                //   text: null,
                //   icon: Icons.shopping_bag_outlined,
                //   isElevated: true,
                // ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(
                              20.0), // Thay đổi kích thước góc trên bên trái
                          bottomLeft: Radius.circular(
                              20.0), // Thay đổi kích thước góc dưới bên trái
                        )),
                    child: Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'HanziiStory',
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
                                      fontSize: 11),
                                )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('assets/logo.png'),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 35,
                            ),
                          ],
                        ),
                        _buildSearchContainer(),
                        _buildHistoryRow(),
                      ],
                    ),
                  ),
                  _buildFunctionSection(),
                ],
              ),
            ),
          ),
          WillPopScope(
            onWillPop: () async {
              setState(() {
                _currentPageIndex = 0; // Quay về Home khi nhấn nút back
                widget.onBottomNavVisibilityChanged(
                    true); // Hiển thị lại BottomNavigationBar
              });
              return false; // Không thoát ngay
            },
            child: Search(
                onBack: () {
                  setState(() {
                    _currentPageIndex = 0; // Quay về Home
                    widget.onBottomNavVisibilityChanged(
                        true); // Hiện lại BottomNavigationBar
                  });
                },
                sharedIndex: shareIndex,
                pageIndex: _currentPageIndex),
          )
        ],
      ),
    );
  }

  Widget _buildAppBarButton(
      {required VoidCallback onPressed,
      String? text,
      IconData? icon,
      required bool isElevated}) {
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
              child: text != null
                  ? Text(text,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.black))
                  : Icon(icon, size: 19, color: Colors.black),
            )
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              ),
              child: Text(text!,
                  style: const TextStyle(fontSize: 12.0, color: Colors.black)),
            ),
    );
  }

  Widget _buildSearchContainer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
      child: InkWell(
          onTap: () {
            setState(() {
              _currentPageIndex = 1; // Chuyển đến DetailPage khi nhấn nút
              widget.onBottomNavVisibilityChanged(
                  false); // Hiện lại BottomNavigationBar
            });
          },
          child: const SearchContainer()),
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
                          _currentPageIndex =
                              1; // Chuyển đến DetailPage khi nhấn nút
                          widget.onBottomNavVisibilityChanged(
                              false); // Hiện lại BottomNavigationBar
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
                  'assets/banner_test.png', // Thay thế bằng đường dẫn đến hình ảnh của bạn
                  'assets/banner_test.png', // Thay thế bằng đường dẫn đến hình ảnh của bạn
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Các chức năng khác', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            _buildSectionTitle(
                'HSK', Colors.green, 'assets/twobird_ic (1).png'),
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
            )),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/fb_ic.png'),
                    height: 20,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Hanzi Story',
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

  Widget noteButton(String title, String dayTime) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Note(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(begin: begin, end: end);
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white70, width: 0.5),
                    ),
                    minimumSize: const Size(130, 75),
                    maximumSize: const Size(130, 75),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                dayTime,
                style: const TextStyle(fontSize: 11),
              )
            ],
          ),
        ),
        Positioned(
            left: 6,
            bottom: 42,
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: 14,
            )),
        Positioned(
            right: 22,
            top: 16,
            child: Icon(
              Icons.more_vert,
              size: 16,
              color: Colors.grey[600],
            )),
      ],
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

class BannerSlider extends StatefulWidget {
  final List<String> images;

  const BannerSlider({super.key, required this.images});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final CarouselSliderController  _carouselController = CarouselSliderController ();
  bool _isLoading = true; // Thay đổi trạng thái khi dữ liệu được tải

  @override
  void initState() {
    super.initState();
    // Giả lập thời gian tải
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 63.0,
                  color: Colors.white,
                ),
              )
            : CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 63.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items: widget.images.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: () {
              _carouselController.previousPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(20, 20),
              elevation: 0,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 12,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: () {
              _carouselController.nextPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(20, 20),
              elevation: 0,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 14,
            ),
          ),
        ),
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

class ShimmerImageGrid extends StatefulWidget {
  const ShimmerImageGrid({super.key});

  @override
  _ShimmerImageGridState createState() => _ShimmerImageGridState();
}

class _ShimmerImageGridState extends State<ShimmerImageGrid>
    with SingleTickerProviderStateMixin {
  // Một mảng bool để lưu trạng thái tải của từng ảnh
  final List<bool> _imageLoaded = List.generate(7, (_) => false);
  final List<bool> _animated = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Bắt đầu hiệu ứng sau khi widget được xây dựng xong
      for (int i = 0; i < _animated.length; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          setState(() {
            _animated[i] = true; // Kích hoạt hiệu ứng cho từng phần tử
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Số cột
        crossAxisSpacing: 2.0, // Khoảng cách ngang giữa các phần tử
        mainAxisSpacing: 20.0, // Khoảng cách dọc giữa các phần tử
      ),
      itemCount: 7, // Số lượng phần tử trong lưới
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _animated[index] ? 1.0 : 0.0, // Hiệu ứng mờ dần
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _animated[index]
                    ? const Offset(0, 0)
                    : const Offset(0, 0.5), // Hiệu ứng trượt từ dưới lên
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 20, // Tăng độ mờ
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/HSK${index + 1}_icon.png',
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (frame != null && !_imageLoaded[index]) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    _imageLoaded[index] = true;
                                  });
                                });
                              }
                              return child;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'HSK${index + 1}',
              style: const TextStyle(fontSize: 9),
            ),
          ],
        );
      },
    );
  }
}

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  bool showCursor = true; // Biến để kiểm tra trạng thái hiển thị con trỏ
  Timer? cursorTimer; // Timer để điều khiển nhấp nháy của con trỏ

  @override
  void initState() {
    super.initState();
    _startCursorTimer(); // Bắt đầu timer cho con trỏ
  }

  void _startCursorTimer() {
    cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        showCursor = !showCursor; // Chuyển đổi trạng thái hiển thị của con trỏ
      });
    });
  }

  @override
  void dispose() {
    cursorTimer?.cancel(); // Hủy timer khi không còn sử dụng
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20),
                const SizedBox(width: 5),
                // Container này là con trỏ nhấp nháy
                Container(
                  width: 2,
                  height: 20,
                  color: showCursor
                      ? Colors.green
                      : Colors
                          .transparent, // Thay đổi màu sắc dựa vào trạng thái
                  margin: const EdgeInsets.only(
                      left: 2.0), // Khoảng cách giữa con trỏ và chữ
                ),
                const SizedBox(
                    width: 3), // Khoảng cách giữa con trỏ và chữ "Tìm kiếm"
                const Text(
                  'Tìm kiếm ...',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(color: Colors.green),
            child: const Center(
              child: Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
