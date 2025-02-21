import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hanjii/models/hint_story.dart';
import '../../models/hint_character.dart';

class SearchStoryView extends StatefulWidget {
  final List<HintStory> list;

  const SearchStoryView({super.key, required this.list});

  @override
  _SearchStoryViewState createState() => _SearchStoryViewState();
}

class _SearchStoryViewState extends State<SearchStoryView> {
  late ScrollController _scrollController;
  late Map<int, bool> _selectedCards;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedCards = {};
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              if (_selectedCards[index] == true) {
                return buildCardDetailHan();
              }

              final item = widget.list[index];

              return InkWell(
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  setState(() {
                    _selectedCards[index] = true;
                  });
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  child: Text(
                                    item.character,
                                    style: const TextStyle(fontSize: 30, color: Colors.red),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.hanviet,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 14, color: Colors.purple),
                                      ),
                                      Text(
                                        item.pinyin,
                                        style: const TextStyle(fontSize: 14, color: Colors.orange),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.meaning[0],
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 100, // Chiều rộng của ảnh
                            height: double.infinity, // Đảm bảo ảnh có chiều cao bằng với card
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400, // Màu sắc của border
                                width: 0.5, // Độ dày của border
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4), // Bo góc cho ảnh nếu muốn
                              child: Image.network(
                                item.image,
                                fit: BoxFit.contain, // Đảm bảo ảnh không bị biến dạng
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

  }

  Card buildCardDetailHan() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset('assets/charactertest.png'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Bộ : nhân 人',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Lục thư : hình thanh & hội ý',
                          style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Bính âm : nǐ ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Số nét : 7 ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.volume_up_outlined,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
              const Divider(),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bộ thành phần:',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      buildTProw(1, 'thủ 扌'),
                      buildTProw(2, 'qua 戈'),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Text(
                              'Ý nghĩa:',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          buildTProw(1, 'Tôi'),
                          buildTProw(2, 'Ta'),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Màu viền
                            width: 0.5, // Độ dày viền
                          ),
                          borderRadius:
                          BorderRadius.circular(4.0), // Bo góc viền
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(8.0), // Bo góc cho ảnh
                          child: const Image(
                            image: NetworkImage(
                              'https://luping.com.vn/word_media/Luping_minhhoa_webp/%E6%88%91.webp',
                            ),
                            width: 60,
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              Text(
                'Câu chuyện:',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text('('),
                  const SizedBox(width: 5),
                  Text(
                    '我',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                  const SizedBox(width: 3),
                  const Text('='),
                  const SizedBox(width: 3),
                  Text('丿', style: TextStyle(color: Colors.blue[600])),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text('+'),
                  const SizedBox(
                    width: 3,
                  ),
                  Text('扌', style: TextStyle(color: Colors.blue[600])),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text('+'),
                  const SizedBox(
                    width: 3,
                  ),
                  Text('戈', style: TextStyle(color: Colors.blue[600])),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(')'),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  color: Colors.grey[100],
                  child: const Text(
                    '"TÔI" là người đầu đội mũ (丿) tay (扌) cầm giáo (戈).',
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  )),
              SizedBox(
                  height: 130,
                  child: Image.network(
                      'https://luping.com.vn/word_media/Luping_joychinese_gif/joychinese%E6%88%91.gif')),
              buildNguonGoc(
                  'Trung',
                  '我 nguyên nghĩa là một loại vũ khí, có tay cầm dài và lưỡi sắc ba cạnh. Nhưng từ thời kỳ cổ, nó đã được mượn để biểu thị đại từ nhân xưng ngôi thứ nhất thường là tự xưng của dân Yin Shang, như "ta thụ niên", "ta phá Quan" và những cái khác. Nguyên nghĩa đã không còn tồn tại từ lâu',
                  ['assets/我_nguongoc.png']),
              buildNguonGoc(
                  'Hàn',
                  'Từ "我" có nghĩa là "ta". Hình ảnh của từ "我" được vẽ giống như một cây giáo có lưỡi dao hình răng cưa. Điều này cũng giống như cây thương ba mũi mà Đường Tăng đã mang theo trong "Tây du ký". Mặc dù từ "我" được vẽ như một cây thương ba mũi, nhưng nó đã được sử dụng từ sớm như một đại từ nhân xưng ngôi thứ nhất có nghĩa là "ta". Ngay cả trong thời kỳ Ân Thương, khi chữ giáp cốt được tạo ra, từ "我" đã được sử dụng với nghĩa "ta", cho thấy ý nghĩa ban đầu của nó đã không được sử dụng từ rất sớm. Tuy nhiên, không có giải thích rõ ràng về lý do tại sao "我" lại có nghĩa là "ta". Chỉ có suy đoán rằng nó có nghĩa là "ta" hoặc "chúng ta" vì đã cùng nhau cầm vũ khí và chiến đấu. Trong chữ Hán, có những chữ như 余 (ta dư), 吾 (ta ngô), 朕 (ta trẫm) vốn không liên quan đến "ta" nhưng theo thời gian đã được sử dụng để chỉ bản thân, vì vậy "我" cũng có thể là một trong những ví dụ như vậy.',
                  ['assets/我_naver.png']),
              buildNguonGoc(
                  'Anh',
                  '我 ban đầu có ý nghĩa là "rìu chiến có gai", và thường giữ ý nghĩa này '
                      'khi được sử dụng như một thành phần ký tự. Khi được sử dụng như một ký tự đầy đủ, nó có nghĩa là "Tôi" '
                      'hoặc "mình".<br><br>'
                      '<b>Rìu chiến có gai </b>: Bốn nét đầu tiên là lưỡi rìu có gai, nét thứ năm là cán, nét thứ sáu là tay cầm, '
                      'nét thứ bảy là tua. <br>'
                      'Thường thì vũ khí Trung Quốc có một tua màu đỏ từ lông ngựa. Tua có ba chức năng: nó thể hiện '
                      'tình trạng của quân lính tinh nhuệ, nó giúp làm mờ tầm nhìn của đối thủ và nó ngăn chặn sự chảy máu xuống '
                      'cán.<br><br>'
                      '<b>Tôi </b>: Khi một người cầm vũ khí trong tay, anh ta thể hiện quyền lực của mình. Điều này truyền đạt cảm giác "Tôi": '
                      'sự quan trọng của một người.',
                  [
                    'assets/我_column.png',
                    'assets/我_nguongoca_1.png',
                    'assets/我_nguongoca_2.png',
                    'assets/我_nguongoca_4.png',
                    'assets/我_nguongoca_3.png'
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTProw(int idx, String inputString) {
    // Tách chuỗi dựa vào khoảng trắng
    List<String> parts = inputString.split(' ');

    String hanviet = '';
    String word = '';

    if (parts.length == 2) {
      // Kiểm tra phần đầu có phải là tiếng Việt không (chứa ký tự ASCII)
      if (RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(parts[0])) {
        hanviet = parts[0];
        word = parts[1];
      } else {
        hanviet = parts[1];
        word = parts[0];
      }
    } else if (parts.length == 1) {
      // Kiểm tra nếu inputString là tiếng Việt hay tiếng Trung
      if (RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(inputString)) {
        hanviet = inputString; // Nếu là tiếng Việt, gán vào hanviet
      } else {
        word = inputString; // Nếu là tiếng Trung, gán vào word
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text('$idx)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700])),
          ),
          const SizedBox(width: 7),
          Text(hanviet, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 7),
          Text(word, style: TextStyle(fontSize: 16, color: Colors.blue[700])),
        ],
      ),
    );
  }

  Column buildNguonGoc(String country, String content, List imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nguồn gốc ($country):',
          style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imageUrls.map((url) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 2.0), // Add padding between images
                child: Image(
                  image: AssetImage(url),
                  height: 130,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        MyExpandableContainer(content: content),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}


class MyExpandableContainer extends StatefulWidget {
  final String content;

  const MyExpandableContainer({super.key, required this.content});

  @override
  _MyExpandableContainerState createState() => _MyExpandableContainerState();
}

class _MyExpandableContainerState extends State<MyExpandableContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Hiển thị nội dung, nếu chưa mở rộng sẽ có chiều cao cố định
          SizedBox(
            height: _isExpanded ? null : 100, // Chiều cao cố định
            child: Html(
              data: '<span style="font-size: 12.5px;">${widget.content}</span>',
            ),
          ),
          // Nút "Mở rộng" nếu chưa mở rộng
          if (!_isExpanded)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = true; // Đặt trạng thái mở rộng
                });
              },
              child: const Text('Mở rộng'),
            ),
          // Sử dụng Visibility để hiện nội dung mở rộng
          Visibility(
            visible: _isExpanded,
            child: const Column(
              children: [
                // Nội dung bổ sung có thể được thêm vào đây
                // Có thể thêm nhiều nội dung khác
              ],
            ),
          ),
        ],
      ),
    );
  }
}

