import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:luping/data/database_helper.dart';
import 'package:luping/models/word.dart';
import 'package:luping/services/search_service.dart'; // Import lớp hintCharacter

class WordInfo extends StatefulWidget {
  const WordInfo({super.key});

  @override
  State<WordInfo> createState() => _WordInfoState();
}

class _WordInfoState extends State<WordInfo> {
  // static const primaryColor = Color(0xFF96D962);
  static const noteColor = Color(0xFFE8FED4);
  final hanzi = Get.arguments as String; // Cast tham số thành String

  final SearchService _searchService = SearchService();

  final List<String> imageUrls = [
    'https://www.tanghuaku.com/wp-content/uploads/2021/04/TK-1174.jpg',
    'https://img95.699pic.com/xsj/0w/s2/ml.jpg!/fh/300',
    'https://pic.616pic.com/ys_img/01/16/35/BWucumSLaC.jpg',
    'https://img95.699pic.com/element/40096/1112.png_300.png',
    'https://www.tanghuaku.com/wp-content/uploads/2021/08/1630239170-b312cc8653ffd4c.jpg',
    'https://pic.pngsucai.com/00/79/92/8fbc0a7390f333f2.webp',
    // Thêm các URL hình ảnh khác vào đây
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/cardnai_bg_word.webp'), context);
    precacheImage(const AssetImage('assets/bookmark.webp'), context);
    precacheImage(const AssetImage('assets/card_bg.webp'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Container(color: Colors.white), // Đặt màu nền cố định
        title: Text('Chi tiết',
            style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        centerTitle: true,
        toolbarHeight: 50,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: FutureBuilder<Word?>(
        future:
            _searchService.getWord(hanzi), // Sử dụng hàm getWord để lấy dữ liệu
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            final word = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/card_bg.webp'),
                                fit: BoxFit.fitWidth,
                                repeat: ImageRepeat
                                    .repeatY, // Lặp lại theo chiều dọc
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 30.0, 25.0, 30.0),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/cardnai_bg_word.webp'),
                                              fit: BoxFit.cover),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 15),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 36,
                                                        child: Text(
                                                            '${word.word}'),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      const SizedBox(
                                                        width: double.infinity,
                                                        height:
                                                            20, // Placeholder cho pinyin
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      const SizedBox(
                                                        width: 30,
                                                        height:
                                                            30, // Placeholder cho nút phát
                                                      ),
                                                      const SizedBox(height: 10)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        right: 2,
                                        top: 15,
                                        child: SizedBox(
                                          width: 50,
                                          height:
                                              50, // Placeholder cho hình ảnh
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        top: 0,
                                        child: Container(
                                          width: 40,
                                          height:
                                              55, // Placeholder cho bookmark
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/bookmark.webp'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'HSK',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(height: 5),
                                              SizedBox(height: 10)
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SectionHeader(text: 'Định nghĩa'),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 20),
                            child: Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                minHeight: 10, // Thêm chiều cao tối thiểu
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              decoration: const BoxDecoration(
                                color: noteColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)), // Thêm borderRadius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    word.meaning.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String meaning = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '${index + 1}. $meaning',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SectionHeader(text: 'Ví dụ'),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(25, 0, 20, 0),
                            child: Column(
                              children: [
                                vidu(1, '我们的老师', 'wǒmen de lǎoshī',
                                    'Thầy giáo của chúng tôi'),
                                vidu(
                                    2,
                                    '我们的学校真大，是吧？',
                                    'wǒmen de xuéxiào zhēn dà, shì ba?',
                                    'Trường của chúng mình thật to, phải không?'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SectionHeader(text: 'Hình ảnh'),
                          const Center(
                              child: Text(
                            '( 我们 )',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          )),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 130,
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            child: CarouselSlider.builder(
                              itemCount: imageUrls.length,
                              itemBuilder: (context, index, realIndex) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrls[index],
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      placeholder: (context, url) => Container(
                                        width: double.infinity,
                                        color: Colors.grey[
                                            300], // Placeholder shimmer color
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 100,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                viewportFraction:
                                    0.58, // Tăng kích cỡ của slide
                                enableInfiniteScroll: false,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayCurve: Curves.easeInOut,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const SectionHeader(text: 'Liên quan'),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        color: Colors.green[300],
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: const Text('Từ trái nghĩa :',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: word.trainghia!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        String trainghia = entry.value;
                                        return Row(
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(top: 2),
                                            //   child: Text(
                                            //     '${index + 1}.',
                                            //     style: TextStyle(fontSize: 12),
                                            //   ),
                                            // ),
                                            // SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                trainghia,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        color: Colors.green[300],
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: const Text('Từ đồng nghĩa :',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: word.cannghia!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        String cannghia = entry.value;
                                        return Row(
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(top: 2),
                                            //   child: Text(
                                            //     '${index + 1}.',
                                            //     style: TextStyle(fontSize: 12),
                                            //   ),
                                            // ),
                                            // SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                cannghia,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ])),
                          const SizedBox(
                            height: 90,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;

  const ImageCard({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: SizedBox(
        width: 120,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      12), // Đảm bảo ảnh cũng có góc bo tròn
                  child: Image.network(
                    imageUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.contain, // Đảm bảo ảnh vừa với khung
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _showImagePreview(context, imageUrl);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      // color: Colors.black.withOpacity(0.5),
                      ),
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SvgPicture.asset(
                        'assets/fullscreen.svg',
                        height: 14,
                        width: 14,
                        color: Colors.black45,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String text;

  const SectionHeader({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Divider(
              height: 2,
              color: Colors.green,
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              height: 2,
              color: Colors.green,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

void _showImagePreview(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white, // Đặt màu nền của hộp thoại
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Đặt bo tròn cho hộp thoại
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 32, 0, 32),
              height: 400, // Chiều cao của Container
              width: MediaQuery.of(context).size.width *
                  0.8, // Chiều rộng của Container (80% màn hình)
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.green),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Đóng hộp thoại khi nhấn vào icon
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget vidu(
  int index,
  String sentence,
  String pinyin,
  String meaning,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 5),
        height: 20,
        width: 20,
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 20, // Chiều cao giả lập của text
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 150, // Chiều rộng giả lập cho Pinyin
              height: 18,
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 20, // Chiều cao giả lập cho nghĩa
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 4),
        child: SizedBox(
          width: 18,
          height: 18, // Giả lập kích thước của icon
        ),
      ),
      const SizedBox(width: 10),
    ],
  );
}
