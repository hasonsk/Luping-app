import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:luping/models/hint_story.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:luping/pages/search/stories/expandable_container.dart';
import '../../../models/hint_character.dart';
import '../../../models/story.dart';
import '../../../services/search_service.dart'; // Import service để gọi getStoryDetails()

class SearchStoryView extends StatefulWidget {
  final List<HintStory> list;

  const SearchStoryView({super.key, required this.list});

  @override
  _SearchStoryViewState createState() => _SearchStoryViewState();
}

class _SearchStoryViewState extends State<SearchStoryView> {
  late ScrollController _scrollController;
  late Map<int, bool> _selectedCards;
  Story? _selectedStory; // Lưu trữ câu chuyện được chọn
  bool _isLoading = false; // Trạng thái loading khi lấy dữ liệu

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

  void _onCardTap(int index, String character) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // Ẩn bàn phím
    print(character);
    setState(() {
      _selectedCards = {index: true}; // Chỉ hiển thị một thẻ chi tiết
      _isLoading = true;
      _selectedStory = null;
    });

    // Gọi API để lấy chi tiết
    Story? story = await SearchService().getStoryDetails(character);

    setState(() {
      _isLoading = false;
      _selectedStory = story;
    });
  }

  @override
  void didUpdateWidget(covariant SearchStoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != oldWidget.list) {
      setState(() {
        _selectedCards = {}; // Reset selected cards when list changes
        _selectedStory = null; // Reset selected story
      });
    }
  }

  void _playSound(String audioUrl) async {
    final player = AudioPlayer();
    try {
      await player.play(UrlSource(audioUrl));
    } catch (e) {
      debugPrint('Lỗi khi phát âm thanh: $e');
    }
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
              final item = widget.list[index];

              if (_selectedCards[index] == true) {
                return _isLoading
                    ? const Padding(
                      padding: EdgeInsets.all(.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : _selectedStory != null
                    ? buildCardDetailHan(_selectedStory!)
                    : const Center(child: Text("Không tìm thấy dữ liệu"));
              }

              return InkWell(
                onTap: () => _onCardTap(index, item.character),
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
                              item.meaning.join(', '),
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
                            width: 100,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.contain,
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


  Card buildCardDetailHan(Story story) {
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
                  // SizedBox(
                  //   height: 100,
                  //   child: Image.asset('assets/charactertest.png'),
                  // ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/tian_black.png'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        '${story.character}',
                        style: TextStyle(fontSize: 60, color: Colors.green.shade400),
                      ),
                    ),
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
                          'Bộ : ${story.bothu}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Lục thư : ${story.lucthu}',
                          style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Bính âm : ${story.pinyin} ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Số nét : ${story.sonet} ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _playSound(story.mp3),
                    icon: Icon(
                      Icons.volume_up_outlined,
                      color: Colors.grey[500],
                      size: 20,
                    ),
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
                      if ((story.bothanhphan ?? []).isNotEmpty) ...[
                        Text(
                          'Bộ thành phần:',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      Column(
                        children: (story.bothanhphan ?? [])
                            .asMap()
                            .map((index, value) => MapEntry(index, buildTProw(index + 1, value)))
                            .values
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(right: 100),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  decorationColor: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.5),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: (story.meaning ?? [])
                                    .asMap()
                                    .map((index, value) => MapEntry(index, buildTProwMean(index + 1, value)))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          borderRadius:
                          BorderRadius.circular(4.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            story.image ?? '',
                            width: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox();
                            },
                          ),
                        )
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
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(8.0),
                child: Html(
                  data: '<span style="font-size: 12.5px;">${story.mnemonic_v_content}</span>',
                  style: {
                    "span": Style(
                      fontSize: FontSize(12.5),
                      color: Colors.black,
                    ),
                  },
                ),
              ),
              SizedBox(
                height: 130,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Cho phép cuộn ngang nếu bị tràn
                  child: Row(
                    children: (story.mnemonic_v_media ?? [])
                        .map((url) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5), // Thêm khoảng cách giữa ảnh
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 130, // Giới hạn chiều rộng tối đa
                        ),
                        child: Image.network(
                          url,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              buildNguonGoc(
                  'Trung',
                  '${story.mnemonic_c_content}',
                  ['https://luping.com.vn/word_media/nguongoc_result/${story.mnemonic_c_media}.webp', 'https://luping.com.vn/word_media/ziyuan/${story.mnemonic_c_media}.png']),
              buildNguonGoc(
                  'Hàn',
                  story.mnemonic_k_content ?? '',
                story.mnemonic_k_media != null ? [story.mnemonic_k_media!] : []),
              buildNguonGoc(
                  'Anh',
                  '',
                  []),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTProw(int idx, String inputString) {
    List<String> parts = inputString.split(' ');

    String hanviet = '';
    String word = '';

    if (parts.length == 2) {
      if (RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(parts[0])) {
        hanviet = parts[0];
        word = parts[1];
      } else {
        hanviet = parts[1];
        word = parts[0];
      }
    } else if (parts.length == 1) {
      if (RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(inputString)) {
        hanviet = inputString;
      } else {
        word = inputString;
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

  Padding buildTProwMean(int idx, String nghia) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(nghia, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget buildNguonGoc(String country, String content, List<String> imageUrls) {
    if (content.trim().isEmpty && imageUrls.isEmpty) {
      return const SizedBox();
    }

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
            decorationColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),

        if (imageUrls.isNotEmpty)
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageUrls.map((url) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Image.network(
                        url,
                        height: 130,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 130,
                            width: 130,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => const SizedBox(
                          height: 130,
                          width: 130,
                          child: Center(
                            child: Icon(Icons.broken_image, color: Colors.red, size: 40),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

        if (content.trim().isNotEmpty) ...[
          ExpandableContainer(content: content),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
