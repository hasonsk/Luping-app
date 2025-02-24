import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  static const primaryColor = Color(0xFF96D962);
  static const noteColor = Color(0xFFE8FED4);
  bool _isTranslated = false;
  bool _iskoreanTranslated = false;
  final String _originalText =
      '我 originally meant "spiked battle-axe", and generally retains this meaning '
      'when used as a character component. When used as a full character, it means "I" '
      'or "me".\n\n'
      'spiked battle-axe: The first four strokes are the spiked blade, the fifth stroke '
      'is the shaft, sixth stroke is the handle, seventh stroke is the tassel.\n\n'
      'It was common for Chinese weapons to include a red horse-hair tassel. The tassel served '
      'three functions: it showed elite troop status, it aided in blurring the vision of the '
      'opponent, and it stopped the flow of blood down the shaft.\n\n'
      'I: When a man has a weapon in his hand he exerts his dominance. This conveys the sense of "I": '
      'a person’s self-importance.';

  final String _translatedText =
      '我 ban đầu có ý nghĩa là "rìu chiến có gai", và thường giữ ý nghĩa này '
      'khi được sử dụng như một thành phần ký tự. Khi được sử dụng như một ký tự đầy đủ, nó có nghĩa là "Tôi" '
      'hoặc "mình".\n\n'
      'Rìu chiến có gai: Bốn nét đầu tiên là lưỡi rìu có gai, nét thứ năm là cán, nét thứ sáu là tay cầm, '
      'nét thứ bảy là tua. \n\n'
      'Thường thì vũ khí Trung Quốc có một tua màu đỏ từ lông ngựa. Tua có ba chức năng: nó thể hiện '
      'tình trạng của quân lính tinh nhuệ, nó giúp làm mờ tầm nhìn của đối thủ và nó ngăn chặn sự chảy máu xuống '
      'cán.\n\n'
      'Tôi: Khi một người cầm vũ khí trong tay, anh ta thể hiện quyền lực của mình. Điều này truyền đạt cảm giác "Tôi": '
      'sự quan trọng của một người.';
  final String _koreanoriginalText =
      '結자는 ‘맺다’나 ‘모으다’, ‘묶다’라는 뜻을 가진 글자이다. 結자는 糸(가는 실 사)자와 吉(길할 길)자가 결합한 모습이다. 吉자는 신전에 꽂아두던 위목(位目)을 그린 것이다. 結자는 이렇게 상하가 결합하는 형태인 吉자에 糸자를 결합한 것으로 ‘(실을) 잇는다’라는 뜻을 표현했다. 누에고치에서 뽑은 실은 길이가 한정돼 있다. 그래서 비단을 만들기 위해서는 실을 이어주는 과정이 필요했다. 結자는 그러한 의미를 표현한 글자로 吉(결합하다)에 糸(실)자를 합해 ‘실이 이어지다’를 뜻하다가 후에 ‘맺다’나 ‘모으다’, ‘묶다’라는 뜻을 갖게 되었다.';
  final String _koreantranslatedText =
      'Chữ "Kết" có nghĩa là "kết nối", "tập hợp" hoặc "buộc lại". Chữ "Kết" được hình thành từ sự kết hợp của chữ "Mịch" (sợi chỉ) và chữ "Cát" (may mắn). Chữ "Cát" được vẽ theo hình thức của một vật phẩm được cắm trong đền thờ. Chữ "Kết" thể hiện ý nghĩa "kết nối (sợi chỉ)" bằng cách kết hợp chữ "Mịch" với hình thức kết hợp của chữ "Cát". Sợi chỉ được lấy từ kén tằm có chiều dài hạn chế. Do đó, để tạo ra tơ lụa, cần có quá trình nối dài sợi chỉ. Chữ "Kết" thể hiện ý nghĩa đó bằng cách kết hợp chữ "Cát" (kết hợp) với chữ "Mịch" (sợi chỉ), mang nghĩa "sợi chỉ được nối lại", sau này có thêm nghĩa là "kết nối", "tập hợp" hoặc "buộc lại".';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/cardnai_bg.webp'), context);
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/card_bg.webp'),
                          fit: BoxFit.fitWidth,
                          repeat: ImageRepeat.repeatY, // Lặp lại theo chiều dọc
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/cardnai_bg.webp'),
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
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text('我',
                                                    style: TextStyle(
                                                        fontSize: 36)),
                                                const Text('wǒ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                const SizedBox(height: 35),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Ngã',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'tôi',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showImagePreview(context,
                                              'https://luping.com.vn/word_media/Luping_minhhoa_webp/%E6%88%91.webp');
                                        },
                                        child: SizedBox(
                                          height: 50,
                                          child: Image.network(
                                              'https://luping.com.vn/word_media/Luping_minhhoa_webp/%E6%88%91.webp'),
                                        ),
                                      ),
                                      // SizedBox(height: 12,),
                                      // Icon(Icons.star_border, color: Colors.green, size: 22,),
                                      // SizedBox(height: 30,),
                                      // Icon(Icons.edit, color: Colors.green, size: 22,),
                                    ]),
                                  ),
                                ),
                                Positioned(
                                    left: 10,
                                    top: 0,
                                    child: Container(
                                        width: 40,
                                        height: 55,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/bookmark.webp'),
                                              fit: BoxFit.contain),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'HSK',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700]),
                                            ),
                                            Text(
                                              '1',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700]),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )))
                              ],
                            ),
                            CustomExpansionTile()
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 75,
                                height: 20,
                                color: primaryColor,
                                child: const Center(
                                    child: Text(
                                  'Minh hoạ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              const Expanded(child: SizedBox()),
                              const Row(
                                children: [
                                  Text('Video',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Icon(Icons.play_arrow,
                                      color: Colors.grey, size: 13),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 0.5, // Độ dày của đường viền
                            color: Colors.grey[300], // Màu của đường viền
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height:
                                120, // Đặt chiều cao cố định cho phần chứa hình ảnh
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ImageCard(
                                    imageUrl:
                                        'https://luping.com.vn/word_media/Luping_joychinese_gif/joychinese%E6%88%91.gif',
                                  ),
                                  ImageCard(
                                    imageUrl:
                                        'https://luping.com.vn/word_media/ziyuan/e68891.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30)
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const SectionHeader(text: 'Mẹo nhớ'),
                    const SizedBox(
                      height: 25,
                    ),
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWithBorder(text: '我'),
                            Text(
                              '=',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            TextWithBorder(text: '丿'),
                            Text(
                              '+',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            TextWithBorder(text: '扌'),
                            Text(
                              '+',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            TextWithBorder(text: '戈'),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 20),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          minHeight: 100, // Thêm chiều cao tối thiểu
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: const BoxDecoration(
                          color: noteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Thêm borderRadius
                        ),
                        child: const Text(
                          'Tôi là người đầu đội mũ (丿) tay (扌) cầm giáo (戈).',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SectionHeader(text: 'Nguồn gốc'),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      '(Trung)',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/我_nguongoc.png'),
                            height: 100,
                          ),
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 32,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '我',
                              style: TextStyle(fontSize: 36),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/notebg.png'),
                          fit: BoxFit
                              .fill, // Đảm bảo ảnh phủ toàn bộ diện tích của Container
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Container(
                        color: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: const Text(
                          '我 nguyên nghĩa là một loại vũ khí, có tay cầm dài và lưỡi sắc ba cạnh. Nhưng từ thời kỳ cổ, nó đã được mượn để biểu thị đại từ nhân xưng ngôi thứ nhất thường là tự xưng của dân Yin Shang, như "ta thụ niên", "ta phá Quan" và những cái khác. Nguyên nghĩa đã không còn tồn tại từ lâu',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SectionHeader(text: 'Nguồn gốc'),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      '(Hàn)',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://dic-phinf.pstatic.net/20190220_43/1550651377400rbeHs_PNG/_.png'),
                            height: 100,
                          ),
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 32,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '我',
                              style: TextStyle(fontSize: 36),
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _iskoreanTranslated = !_iskoreanTranslated;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70,
                            26), // Đảm bảo kích thước đủ lớn để chứa cả icon và văn bản
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Colors.grey[200], // Màu nền của button
                        foregroundColor:
                            Colors.grey[900], // Màu của văn bản và icon
                        elevation: 0, // Loại bỏ độ nổi
                        shadowColor:
                            Colors.transparent, // Loại bỏ bóng của button
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz,
                              size: 18, color: Colors.green[700]),
                          const SizedBox(
                              width: 5), // Khoảng cách giữa icon và chữ
                          Text('Dịch',
                              style: TextStyle(
                                  color: Colors.green[700], fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/notebg.png'),
                          fit: BoxFit
                              .fill, // Đảm bảo ảnh phủ toàn bộ diện tích của Container
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Container(
                          color: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Text(
                            _iskoreanTranslated
                                ? _koreantranslatedText
                                : _koreanoriginalText,
                            style: const TextStyle(
                              fontSize:
                                  12.0, // Chỉnh kích thước chữ nếu cần thiết
                            ),
                          )),
                    ),
                    const SectionHeader(text: 'Nguồn gốc'),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      '(Anh)',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage('assets/我_nguongoca_1.png'),
                              height: 100,
                            ),
                            Image(
                              image: AssetImage('assets/我_nguongoca_2.png'),
                              height: 100,
                            ),
                            Image(
                              image: AssetImage('assets/我_nguongoca_4.png'),
                              height: 100,
                            ),
                            Image(
                              image: AssetImage('assets/我_nguongoca_3.png'),
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isTranslated = !_isTranslated;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70,
                            26), // Đảm bảo kích thước đủ lớn để chứa cả icon và văn bản
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Colors.grey[200], // Màu nền của button
                        foregroundColor:
                            Colors.grey[900], // Màu của văn bản và icon
                        elevation: 0, // Loại bỏ độ nổi
                        shadowColor:
                            Colors.transparent, // Loại bỏ bóng của button
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz,
                              size: 18, color: Colors.green[700]),
                          const SizedBox(
                              width: 5), // Khoảng cách giữa icon và chữ
                          Text('Dịch',
                              style: TextStyle(
                                  color: Colors.green[700], fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/notebg.png'),
                          fit: BoxFit
                              .fill, // Đảm bảo ảnh phủ toàn bộ diện tích của Container
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Container(
                          color: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Text(
                            _isTranslated ? _translatedText : _originalText,
                            style: const TextStyle(
                              fontSize:
                                  12.0, // Chỉnh kích thước chữ nếu cần thiết
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatefulWidget {
  final String imageUrl;

  const ImageCard({
    super.key,
    required this.imageUrl,
  });

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final Image image = Image.network(widget.imageUrl);
    final ImageStream stream = image.image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        onError: (exception, stackTrace) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }

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
              child: _isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.grey[200],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageUrl,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _showImagePreview(context, widget.imageUrl);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      'assets/fullscreen.svg',
                      height: 14,
                      width: 14,
                      color: Colors.white,
                    ),
                  ),
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

// Widget mới được thêm vào
class TextWithBorder extends StatelessWidget {
  final String text;

  const TextWithBorder({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      constraints: const BoxConstraints(
        maxWidth: 30, // Giới hạn chiều rộng tối đa
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.grey, // Màu viền
          width: 0.5, // Độ dày viền
        ),
        borderRadius: BorderRadius.circular(4), // Độ bo tròn góc
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black45), // Kích thước font nhỏ hơn
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({super.key});

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final CarouselSliderController  _carouselController = CarouselSliderController ();
  int _currentIndex = 0; // Chỉ số trang hiện tại

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy chiều cao của màn hình
    final screenHeight = MediaQuery.of(context).size.height;
    // Tính toán chiều cao của Container
    final containerHeight = screenHeight - 340.0;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0, // Expand vertically
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: containerHeight, // Sử dụng chiều cao tính toán được
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
                  color: Colors.white,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: containerHeight, // Chiều cao của slider
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex =
                              index; // Cập nhật chỉ số trang hiện tại
                        });
                      },
                      // scrollPhysics: NeverScrollableScrollPhysics(),
                    ),
                    items: const [chitietView(), tughepView(), lienquanView()],
                  ),
                ),
                Positioned(
                  left: -10,
                  top: 0,
                  child: Visibility(
                    visible:
                        _currentIndex > 0, // Hiện nút nếu không phải trang đầu
                    child: ElevatedButton(
                      onPressed: () {
                        _carouselController.previousPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], // Màu nền xám nhạt
                        shape: const CircleBorder(),
                        side: const BorderSide(
                            color: Colors.grey, width: 0.5), // Viền màu xám
                        padding:
                            const EdgeInsets.all(2), // Tăng kích thước của nút
                        minimumSize:
                            const Size(16, 16), // Kích thước tối thiểu của nút
                        elevation: 0, // Bỏ bóng đổ để phù hợp với thiết kế xám
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: 0,
                  child: Visibility(
                    visible:
                        _currentIndex < 2, // Hiện nút nếu không phải trang cuối
                    child: ElevatedButton(
                      onPressed: () {
                        _carouselController.nextPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], // Màu nền xám nhạt
                        shape: const CircleBorder(),
                        side: const BorderSide(
                            color: Colors.grey, width: 0.5), // Viền màu xám
                        padding:
                            const EdgeInsets.all(2), // Tăng kích thước của nút
                        minimumSize:
                            const Size(16, 16), // Kích thước tối thiểu của nút
                        elevation: 0, // Bỏ bóng đổ để phù hợp với thiết kế xám
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -3),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 26,
                  color: Colors.grey[600],
                ),
                // Icon(Icons.abc)
                const Text(
                  '词典',
                  style: TextStyle(color: Colors.black87),
                )
              ],
            ),
            onTap: () {
              setState(() {
                if (_expanded) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
                _expanded = !_expanded;
              });
            },
          ),
        ],
      ),
    );
  }
}

class chitietView extends StatefulWidget {
  const chitietView({
    super.key,
  });

  @override
  State<chitietView> createState() => _chitietViewState();
}

class _chitietViewState extends State<chitietView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SectionHeader(text: 'Chi tiết'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                    children: [
                      TextSpan(
                        text: '(1) (Đại) Ta tôi, tao (đại từ ngôi thứ nhất)\n',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.grey[200],
                ), // Divider giữa các phần
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                    children: [
                      TextSpan(
                        text: '(2) (Danh) Bản thân\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '無我\n',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: 'vô ngã\nđừng chấp bản thân\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '子絕四:母意,母必,母固,母我(子罕 - 論語)\n',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text:
                            'Tử tuyệt tứ: vô ý, vô tất, vô cố, vô ngã (Tử Hãn - Luận Ngữ)\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            'Khổng Tử bỏ hẳn bốn tật này: "vô ý" là xét việc thì không đem ý riêng (hoặc tư dục) của mình vào mà cứ theo lẽ phải; '
                            '"vô tất" tức không quyết rằng điều đó tất đúng, việc đó tất làm được; "vô cố" tức không cố chấp, "vô ngã" tức quên mình đi, '
                            'không để cho cái ta làm mờ (hoặc không ích kỉ mà phải chí công vô tư)\n',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 5,
                  color: Colors.grey[200],
                ), // Divider giữa các phần
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                    children: [
                      TextSpan(
                        text: '(3) (Tính) Của ta, của tôi (tỏ ý thân mật)\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: '我兄\nngã huynh\nanh tôi\n',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: '我弟\nngã đệ\nem ta\n',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class lienquanView extends StatefulWidget {
  const lienquanView({
    super.key,
  });

  @override
  State<lienquanView> createState() => _lienquanViewState();
}

class _lienquanViewState extends State<lienquanView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SectionHeader(text: 'Liên quan'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Các hán tự liên quan')],
            ),
          ),
        ],
      ),
    );
  }
}

class tughepView extends StatefulWidget {
  const tughepView({
    super.key,
  });

  @override
  State<tughepView> createState() => _tughepViewState();
}

class _tughepViewState extends State<tughepView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SectionHeader(text: 'Từ ghép'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '(1) 我们 |wǒmen| : chúng tôi; chúng ta\n'
                  '(2) 我国 |wǒguó| : nước ta\n'
                  '(3) 自我 |zìwǒ| : mình, tự mình\n'
                  '(4) 我方 |wǒ fāng| : bên ta, phía ta\n'
                  '(5) 自我批评 |zìwǒ pīpíng| : tự phê bình\n',
                  style: TextStyle(height: 1.5),
                )
              ],
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
