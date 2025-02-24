import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
            Word(id:1,word:'你',pinyin:'nǐ',meaning:['Bạn, cậu, anh,..'], hanviet: 'Chào bạn', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/df1fd9101108b40d26977a8d0bb9fd1e_h.jpg', shortmeaning: "Bạn", hskLevel: '1'),
            Word(id:2,word:'你好',pinyin:'nǐ hǎo',meaning:['Chào bạn, cậu, anh,..'], hanviet: 'Tôi', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/7eca689f0d3389d9dea66ae112e5cfd7_h.jpg', shortmeaning: "Chào bạn", hskLevel: '1'),
            Word(id:3,word:'好',pinyin:'hǎo',meaning:['Tốt, khỏe'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/ac2c8f13c6e60810197b19d683f5f184_h.jpg', shortmeaning: "Tốt", hskLevel: '1'),
            Word(id:4,word:'不好',pinyin:'bù hǎo.',meaning:['Không tốt'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/3ed53de49b127ac414e6afff35b04005_h.jpg', shortmeaning: "Không tốt", hskLevel: '1'),
            Word(id:5,word:'您',pinyin:'nín',meaning:['Ngài (Người lớn tuổi hơn)'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/6e2d1fbf2362dcb5e4bcad4315f96ad0_h.jpg', shortmeaning: "Ngài", hskLevel: '1'),
          ],
          kanji: [
            Word(id: 1, word: '你', pinyin: 'nǐ', meaning: ['Bạn'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: 'https://luping.com.vn/word_media/Luping_minhhoa_webp/%E4%BD%A0.webp', shortmeaning: "Bạn", hskLevel: '1'),
            Word(id: 2, word: '好', pinyin: 'hǎo', meaning: ['Tốt'], hanviet: 'Tốt', cannghia: [], trainghia: [], image: 'https://luping.com.vn/word_media/Luping_minhhoa_webp/%E5%A5%BD.webp', shortmeaning: "Tốt", hskLevel: '1'),
          ],
          lessonConversation: ["你好", "我叫", "我来自", "我今年"],
          lessonListening: [
            AudioFile(title: 'Hội thoại', filePath: 'https://drive.google.com/file/d/1UzLcSm-Z8X75Xvh8CHQhUfRHciZLRxEE/view?usp=sharing'),
            AudioFile(title: 'Từ vựng 1', filePath: 'https://drive.google.com/file/d/1x4FGSCyNiJji9XoeZm-AEOdc0tcdbSq3/view?usp=drive_link'),
            AudioFile(title: 'Từ vựng 2', filePath: 'https://drive.google.com/file/d/12Zpj_d2r7bsAd8RxhUd1sO9M64IcUqbv/view?usp=sharing'),
            AudioFile(title: 'Bài tập 1', filePath: 'https://drive.google.com/file/d/12JmQY4736jZqQxV_PJy54mjnYzJfYoRg/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 2', filePath: 'https://drive.google.com/file/d/1iEGgaarnYj2_lZTof5d78oRLAw8AFN7i/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 3', filePath: 'https://drive.google.com/file/d/1_DiBXE-eH6tsrZPOUEly9RKailBttQLx/view?usp=drive_link'),
          ],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 2,
          lessonPosition: 2,
          lessonName: '谢谢你 - Cảm ơn bạn',
          vocabulary: [
            Word(id: 4, word: '谢谢', pinyin: 'xièxiè', meaning: ['Cảm ơn'], hanviet: 'Cảm ơn', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/a34490b593cdc390c77104721ba7eb39_h.jpg', shortmeaning: "Cảm ơn", hskLevel: '1'),
            Word(id: 5, word: '不客气', pinyin: 'bú kèqì', meaning: ['Không có gì'], hanviet: 'Không có gì', cannghia: [], trainghia: [], image: 'https://assets.hanzii.net/img_word/be672ad54806f817f7c3d08d128f9da6_h.jpg', shortmeaning: "Không có gí", hskLevel: '1'),
          ],
          kanji: [],
          lessonConversation: ["你好吗？", "最近怎么样？", "祝你身体健康！"],
          lessonListening: [
            AudioFile(title: 'Hội thoại', filePath: 'https://drive.google.com/file/d/1UzLcSm-Z8X75Xvh8CHQhUfRHciZLRxEE/view?usp=sharing'),
            AudioFile(title: 'Từ vựng 1', filePath: 'https://drive.google.com/file/d/1x4FGSCyNiJji9XoeZm-AEOdc0tcdbSq3/view?usp=drive_link'),
            AudioFile(title: 'Từ vựng 2', filePath: 'https://drive.google.com/file/d/12Zpj_d2r7bsAd8RxhUd1sO9M64IcUqbv/view?usp=sharing'),
            AudioFile(title: 'Bài tập 1', filePath: 'https://drive.google.com/file/d/12JmQY4736jZqQxV_PJy54mjnYzJfYoRg/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 2', filePath: 'https://drive.google.com/file/d/1iEGgaarnYj2_lZTof5d78oRLAw8AFN7i/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 3', filePath: 'https://drive.google.com/file/d/1_DiBXE-eH6tsrZPOUEly9RKailBttQLx/view?usp=drive_link'),
          ],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 3,
          lessonPosition: 3,
          lessonName: '你叫什么名字？Cô tên là gì?',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 4,
          lessonPosition: 4,
          lessonName: '她是我的汉语老师 - Cô ấy là giáo viên tiếng Trung của tôi',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [
            AudioFile(title: 'Hội thoại', filePath: 'https://drive.google.com/file/d/1UzLcSm-Z8X75Xvh8CHQhUfRHciZLRxEE/view?usp=sharing'),
            AudioFile(title: 'Từ vựng 1', filePath: 'https://drive.google.com/file/d/1x4FGSCyNiJji9XoeZm-AEOdc0tcdbSq3/view?usp=drive_link'),
            AudioFile(title: 'Từ vựng 2', filePath: 'https://drive.google.com/file/d/12Zpj_d2r7bsAd8RxhUd1sO9M64IcUqbv/view?usp=sharing'),
            AudioFile(title: 'Bài tập 1', filePath: 'https://drive.google.com/file/d/12JmQY4736jZqQxV_PJy54mjnYzJfYoRg/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 2', filePath: 'https://drive.google.com/file/d/1iEGgaarnYj2_lZTof5d78oRLAw8AFN7i/view?usp=drive_link'),
            AudioFile(title: 'Bài tập 3', filePath: 'https://drive.google.com/file/d/1_DiBXE-eH6tsrZPOUEly9RKailBttQLx/view?usp=drive_link'),
          ],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 5,
          lessonPosition: 5,
          lessonName: '她女儿今年二十岁 - Con gái cô ấy năm nay 20 tuổi',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 6,
          lessonPosition: 6,
          lessonName: '我会说汉语 - Tôi biết nói Tiếng Trung',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 7,
          lessonPosition: 7,
          lessonName: '今天几号？ - Hôm nay là ngày mấy?',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 8,
          lessonPosition: 8,
          lessonName: '我想喝茶。 - Tôi muốn uống trà',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 9,
          lessonPosition: 9,
          lessonName: '你儿子在哪工作？- Con trai anh làm việc ở đâu?',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
          lessonReference: [],
        ),
        Lesson(
          lessonId: 10,
          lessonPosition: 10,
          lessonName: '我能坐这儿吗？- Tôi có thể ngồi ở đây được không?',
          vocabulary: [],
          kanji: [],
          lessonConversation: [],
          lessonListening: [],
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
              if (animation.status == AnimationStatus.reverse) {
                // Khi quay về, dùng hiệu ứng hiện dần (FadeTransition)
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              } else {
                // Khi đi tới, dùng hiệu ứng trượt (SlideTransition)
                var tween = Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.ease));

                var slideAnimation = animation.drive(tween);

                return SlideTransition(
                  position: slideAnimation,
                  child: child,
                );
              }
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
