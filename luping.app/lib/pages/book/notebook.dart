import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart'; // Import GetX
import '../../models/audio_file.dart';
import '../../models/book.dart';
import '../../models/lesson.dart';
import '../../models/word.dart';
import 'book_page.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  late final TabController _tabController2;
  static const primaryColor = Color(0xFF96D962);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });
    _tabController2 = TabController(length: 3, vsync: this);
    _tabController2.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _tabController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Material(
              elevation: 7.0,
              shadowColor: Colors.black.withOpacity(0.6), // Màu bóng nhạt hơn
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: primaryColor,
                        width: 4.0,
                      ),
                    ),
                  ),
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.book_outlined, size: 18.0, color: Colors.green),
                          SizedBox(width: 4.0),
                          Text(
                            'Sách',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          SizedBox(width: 4.0),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.list, size: 20.0, color: Colors.green),
                          SizedBox(width: 4.0),
                          Text(
                            'Từ vựng',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          SizedBox(width: 4.0),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stacked_bar_chart, size: 18, color: Colors.green,),
                          SizedBox(width: 4.0),
                          Text(
                            'Hán tự',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          SizedBox(width: 4.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 45),
                          child: Row(
                            children: [
                              Icon(Icons.flag_outlined),
                              SizedBox(width: 10),
                              Text('Các đầu sách mới phát hành', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_1.png', index: 1, hanzinum: 432),
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_2.png', index: 2, hanzinum: 500),
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_3.png', index: 3, hanzinum: 521),
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_4.png', index: 4, hanzinum: 641),
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_5.png', index: 5, hanzinum: 900),
                              CustomImageWidget(imageUrl: 'assets/chuanhanngu_6.png', index: 6, hanzinum: 1200),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/search_icon.svg', height: 20,),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 2,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBar(
                                      controller: _tabController2,
                                      indicator: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.transparent, // Ẩn border bottom
                                          ),
                                        ),
                                      ),
                                      unselectedLabelColor: Colors.grey,
                                      dividerColor: Colors.transparent,
                                      labelColor: Colors.black,
                                      splashFactory: NoSplash.splashFactory,
                                      tabs: List.generate(3, (index) {
                                        return Tab(
                                          child: TweenAnimationBuilder(
                                            tween: Tween<double>(
                                              begin: 15.0,
                                              end: _tabController2.index == index ? 14.0 : 15.0,
                                            ),
                                            duration: const Duration(milliseconds: 0),
                                            builder: (context, double fontSize, child) {
                                              return Text(
                                                index == 0 ? 'Sơ cấp' : index == 1 ? 'Trung cấp' : 'Cao cấp',
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: _tabController2.index == index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              // Thay thế Expanded bằng SizedBox hoặc ConstrainedBox để giới hạn chiều cao
                              AnimatedBuilder(
                                animation: _tabController2,
                                builder: (context, _) {
                                  switch (_tabController2.index) {
                                    case 0:
                                      return _bookListTab();
                                    case 1:
                                      return const Center(child: Text('Nội dung trung cấp'));
                                    case 2:
                                      return const Center(child: Text('Nội dung cao cấp'));
                                    default:
                                      return const Center(child: Text('Loading...'));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BuildWordList(),
                  const BuildHanziList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bookListTab() {
  return const Padding(
    padding: EdgeInsets.fromLTRB(0, 25, 0, 10),
    child: Column(
      children: [
        BookWidget(imageURL: 'assets/chuanhanngu_1.png', name: 'GT chuẩn HSK1', detail: '...'),
        BookWidget(imageURL: 'assets/chuanhanngu_2.png', name: 'GT chuẩn HSK2', detail: '...'),
        BookWidget(imageURL: 'assets/chuanhanngu_3.png', name: 'GT chuẩn HSK3', detail: '...')
      ],
    ),
  );
}

class BookWidget extends StatelessWidget {
  final String imageURL;
  final String name;
  final String detail;

  const BookWidget({
    required this.imageURL,
    required this.name,
    required this.detail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: SizedBox(
        height: 175,
        child: Row(
          children: [
            SizedBox(
              height: 175,
              child: Image.asset(
                imageURL,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(name, style: const TextStyle(fontSize: 14)),
                ),
                Text('Tác giả : $detail', style: const TextStyle(fontSize: 13)),
                const Expanded(child: SizedBox())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final int index;
  final int hanzinum;

  const CustomImageWidget({
    required this.imageUrl,
    required this.index,
    required this.hanzinum,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Book selectedBook = Book(
      bookId: 1,
      bookName: 'Giáo trình Hán ngữ chuẩn HSK 1',
      bookAuthor: 'Liu Xun',
      bookImageUrl: 'assets/chuanhanngu_1.png',
      bookDifficult: 1,
      vocabCount: 3,
      lessons: [
        Lesson(
          lessonId: 1,
          lessonPosition: 1,
          lessonName: '你好 - Xin chào',
          vocabulary: [
            Word(id: 1, word: '你好', pinyin: 'nǐ hǎo', meaning: ['Xin chào'], hanviet: 'Chào bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
            Word(id: 2, word: '我', pinyin: 'wǒ', meaning: ['Tôi'], hanviet: 'Tôi', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
            Word(id: 3, word: '你', pinyin: 'nǐ', meaning: ['Bạn'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
          ],
          kanji: [
            Word(id: 1, word: '你', pinyin: 'nǐ', meaning: ['Bạn'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
            Word(id: 2, word: '好', pinyin: 'hǎo', meaning: ['Tốt'], hanviet: 'Tốt', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
          ],
          lessonConversation: ["你好", "我叫", "我来自", "我今年"],
          lessonListening: [
            AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
            AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
            AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
          ],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 2,
          lessonPosition: 2,
          lessonName: '谢谢你 - Cảm ơn bạn',
          vocabulary: [
            Word(id: 4, word: '谢谢', pinyin: 'xièxiè', meaning: ['Cảm ơn'], hanviet: 'Cảm ơn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
            Word(id: 5, word: '不客气', pinyin: 'bú kèqì', meaning: ['Không có gì'], hanviet: 'Không có gì', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
          ],
          kanji: [],
          lessonConversation: ["你好吗？", "最近怎么样？", "祝你身体健康！"],
          lessonListening: [
            AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
            AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
            AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
          ],
          lessonReference: [],
        ),
      ],
    );
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1200),
            pageBuilder: (context, animation, secondaryAnimation) => BookPage(book: selectedBook),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Define the slide transition for forward navigation
              var tween = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.ease));
              var slideAnimation = animation.drive(tween);

              // Define the slide transition for backward navigation
              var reverseTween = Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-1.0, 0.0),
              ).chain(CurveTween(curve: Curves.ease));
              var reverseSlideAnimation = secondaryAnimation.drive(reverseTween);

              // Choose the appropriate animation based on the status
              var currentAnimation = secondaryAnimation.status == AnimationStatus.reverse
                  ? reverseSlideAnimation
                  : slideAnimation;

              return SlideTransition(
                position: currentAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 24, 0),
            height: 135.0,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GT Chuẩn HSK $index', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 2),
                Text('Từ vựng : $hanzinum', style: const TextStyle(fontSize: 10)),
                const SizedBox(height: 2),
                const Text('Tiến độ : 0%', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BuildWordList extends StatefulWidget {
  const BuildWordList({super.key});

  @override
  _BuildWordListState createState() => _BuildWordListState();
}

class _BuildWordListState extends State<BuildWordList> {
  @override
  Widget build(BuildContext context) {
    return buildWordList();
  }

  Widget buildWordList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 38, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/maps.svg',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8,),
                const Text('Lộ trình HSK :', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 3,),
                    Container(
                      height: 16,
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 2),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    buildHSKButton('HSK 1', '100', 80),
                    const SizedBox(height: 5,),
                    const Image(
                      image: AssetImage('assets/jieduan1.png'),
                      height: 20,
                    ),
                  ],
                ),
                const Expanded(
                    child: MySeparator()
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 10,),
                Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/jieduan2.png'),
                      height: 30,
                    ),
                    const SizedBox(height: 5,),
                    buildHSKButton('HSK 2', '100', 80),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.green,
                    )
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            children: [
                              buildHSKButton('HSK 4', '100', 80),
                              const SizedBox(width: 2,),
                              const Image(
                                image: AssetImage('assets/jieduan4.png'),
                                height: 40,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 6
                                ),
                                child: Icon(Icons.arrow_back_ios, size: 10, color: Colors.green,),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,)
                      ],
                    ),
                    const Expanded(child: Padding(
                      padding: EdgeInsets.only(
                        top: 67.5
                      ),
                      child: MySeparator()
                      ,
                    )),
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 44,),
                            Column(
                              children: [
                                Container(
                                  width: 1,
                                  color: Colors.green,
                                  height: 24,
                                ),
                                const Icon(Icons.expand_more_outlined, color: Colors.green, size: 16,)
                              ],
                            ),
                            const SizedBox(width: 10,),
                            const Image(
                              image: AssetImage('assets/jieduan3.png'),
                              height: 40,
                            ),
                          ],
                        ),
                        buildHSKButton('HSK 3', '100', 80),
                        const SizedBox(height: 45,)
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: -5,
                    left: 47,
                    child: Container(
                      height: 45,
                      width: 1,
                      color: Colors.green,
                    )
                )
              ],
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Image(
                                image: AssetImage('assets/jieduan5.png'),
                                height: 45,
                              ),
                            ],
                          ),
                          buildHSKButton('HSK 5', '10', 80),
                        ],
                      ),
                    ),
                    const Expanded(child: Padding(
                      padding: EdgeInsets.only(top: 85),
                      child: Row(
                        children: [
                          Expanded(
                              child: MySeparator()
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.green, size: 10,)
                        ],
                      ),
                    )),
                    Column(
                      children: [
                        const SizedBox(height: 3,),
                        const Image(
                          image: AssetImage('assets/jieduan6.png'),
                          height: 60,
                        ),
                        const SizedBox(height: 2,),
                        buildHSKButton('HSK 6', '0', 80),
                        const SizedBox(height: 5,),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.green,
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  left: 39.5,
                  child: Column(
                    children: [
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.green,
                      ),
                      const Icon(Icons.expand_more_sharp, color: Colors.green, size: 16,)
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(child: SizedBox()),
                    const Image(
                      image: AssetImage('assets/jieduan7 (1).png'),
                      height: 70,
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 60
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 8,
                                width: 1,
                                color: Colors.green,
                              ),
                              const Icon(Icons.expand_more, color: Colors.green, size: 22,),
                            ],
                          ),
                        ),
                        buildHSKButton('HSK 7-9', '0', 140),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 120,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0), // Đặt radius ở đây
                    ),
                    child: const Text(
                      'End',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BuildHanziList extends StatefulWidget {
  const BuildHanziList({super.key});

  @override
  _BuildHanziListState createState() => _BuildHanziListState();
}

class _BuildHanziListState extends State<BuildHanziList> {
  @override
  Widget build(BuildContext context) {
    return buildHanziList();
  }

  Widget buildHanziList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 38, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/butterfly.svg',
                  height: 23,
                  width: 23,
                ),
                const SizedBox(width: 8,),
                const Text('Bắt Hán tự :', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}




Stack buildHSKButton(String title, String tiendo, double widthVal) {
  return Stack(
    children: [
      OutlinedButton(
        onPressed: () {
          int fallDuration = 30; // Ví dụ: tham số bạn muốn truyền
          Get.toNamed('/game', arguments: fallDuration);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green, width: 0.5),
          backgroundColor: Colors.grey[50], // Đặt màu nền thành grey
          elevation: 0, // Loại bỏ hiệu ứng nổi
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Loại bỏ border radius
          ),
        ),
        child: SizedBox(
          height: 50,
          width: widthVal, //
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ),
      ),
      Positioned(
        top: 2,
        left: 10,
        child: Text(
          '$tiendo%',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    ],
  );
}


class MySeparator extends StatelessWidget {
  const MySeparator({super.key, this.height = 1, this.color = Colors.green});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
