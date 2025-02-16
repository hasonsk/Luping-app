import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'dart:math'; // Import dart:math để sử dụng Random
import 'package:flutter/services.dart'; // Import để sử dụng SystemChrome

class GameScreen extends StatefulWidget {
  final int fallDuration = Get.arguments as int;

  GameScreen({super.key}); // Nhận tham số thời gian rơi

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isPaused = false; // Trạng thái dừng hoặc tiếp tục
  double randomHorizontalPosition = 0.0; // Khởi tạo với giá trị mặc định
  final Color bgColor = Colors.white; // Mã màu #51a387

  @override
  void initState() {
    super.initState();

    // Đổi màu StatusBar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: bgColor, // Đổi màu StatusBar
        statusBarIconBrightness: Brightness.dark, // Đổi màu biểu tượng StatusBar thành trắng
      ),
    );

    // Trì hoãn việc tính toán vị trí ngang ngẫu nhiên sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        randomHorizontalPosition = Random().nextDouble() * (MediaQuery.of(context).size.width - 100);
      });
    });

    // Tạo AnimationController với thời gian tùy chỉnh từ tham số fallDuration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.fallDuration), // Sử dụng tham số fallDuration
    );

    // Tạo Tween để chuyển từ giá trị 0 (đỉnh màn hình) tới chiều cao của màn hình
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Sử dụng đường cong tuyến tính để di chuyển đều
    ));

    // Bắt đầu chuyển động
    _controller.forward();

    // Dừng khi widget chạm đáy
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop(); // Dừng khi chạm đáy
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Hủy controller khi không sử dụng nữa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXy-ltJx3bjNcFIvvqQDJ6UnwviNNiFWxFkGoTiVIivVpTT842crIvLirWkbnGbdj5CY8&usqp=CAU'),
              fit: BoxFit.fitWidth,
              repeat: ImageRepeat.repeatY
            ),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Tính toán vị trí dựa trên chiều cao của màn hình và tiến trình animation
                  double topPosition = _animation.value * (MediaQuery.of(context).size.height - 100);
                  return Positioned(
                    top: topPosition,
                    left: randomHorizontalPosition, // Sử dụng vị trí ngẫu nhiên theo chiều ngang
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.stop(); // Dừng animation khi nhấn vào widget
                          isPaused = true; // Cập nhật trạng thái thành dừng
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            'Tap Me!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.heart_broken_sharp),
                              Text('Lượt', style: TextStyle(fontSize: 16),)
                            ],
                          )
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Text('0', style: TextStyle(fontSize: 18),),
                            SizedBox(height: 2,),
                            Text('Điểm', style: TextStyle(fontSize: 16),)
                          ],
                        ),
                      ),
                      if (isPaused) // Hiện nút Resume khi animation dừng
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                child: const Icon(Icons.play_circle_outline_outlined),
                                onTap: (){
                                  setState(() {
                                    _controller.forward(); // Tiếp tục animation
                                    isPaused = false; // Cập nhật trạng thái thành tiếp tục
                                  });
                                },
                              ),
                              const SizedBox(height: 2,),
                              const Text('Tiếp tục', style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        )
                      else // Hiện nút Stop khi animation đang chạy
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              child: const Icon(Icons.stop_circle_outlined),
                              onTap: (){
                                setState(() {
                                  _controller.stop(); // Dừng animation
                                  isPaused = true; // Cập nhật trạng thái thành dừng
                                });
                              },
                            ),
                            const SizedBox(height: 6,),
                            const Text('Tạm dừng')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Container thay thế AppBar, chỉ hiển thị khi isPaused là true
              Align(
                alignment: Alignment.topCenter,
                child: Visibility(
                  visible: isPaused,
                  child: Container(
                    width: double.infinity, // Chiếm toàn bộ chiều ngang của màn hình
                    height: 60, // Giới hạn chiều cao của Container
                    color: Colors.white, // Màu nền cho Container
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 20,),
                          onPressed: () {
                            // Đưa ra hành động khi nhấn nút quay lại, ví dụ: quay lại trang trước đó
                            Get.back(); // Sử dụng GetX để quay lại trang trước đó
                          },
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Pause',
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
