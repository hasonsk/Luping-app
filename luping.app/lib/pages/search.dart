import 'package:flutter/services.dart'; // Required for SystemChannels
import 'package:flutter/material.dart';
import 'package:hanjii/domain/models/hint_character.dart';
import 'package:hanjii/data/database_helper.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:hanjii/services/search_service.dart';
import 'handwriting.dart'; // Import lớp Handwriting

class Search extends StatefulWidget {
  final Function onBack; // Hàm callback để thay đổi trang
  final int sharedIndex;
  final int pageIndex;

  const Search(
      {super.key,
      required this.onBack,
      required this.sharedIndex,
      required this.pageIndex});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  static const primaryColor = Color(0xFF96D962);
  static const bodyColor = Color(0xFFF2F2F7); // Màu nền của body
  final TextEditingController _controller =
      TextEditingController(); // Điều khiển nội dung của TextField
  final FocusNode _focusNode = FocusNode();
  final SearchService _searchService = SearchService();
  List<HintCharacter> wordData = [];
  bool isLoading = false; // Biến trạng thái cho loading
  int _selectedTabIndex = 3;
  late TabController _tabController;
  late PageController _pageController; // Thêm PageController
  String _previousText = '';
  final Map<String, List<HintCharacter>> _searchCache = {};
  bool _isTabTapped = false; // Biến để theo dõi khi tab được nhấn
  Timer? _debounce;
  final ScrollController _scrollController =
      ScrollController(); // Controller cho ScrollView
  bool isFocused = false;
  bool isCardReplaced = false; // Biến để theo dõi trạng thái thay thế thẻ
  Map<int, bool> selectedCards = {};
  bool _isBackPressed = false;
  List<HintCharacter> hanziData = [
    HintCharacter(
      hanzi: '我',
      pinyin: 'wǒ',
      hanViet: 'Ngã',
      shortMeaning: 'Tôi',
    ),
    HintCharacter(
      hanzi: '们',
      pinyin: 'men',
      hanViet: 'Môn',
      shortMeaning: 'chúng',
    ),
  ];
// Setter cho _selectedTabIndex để đồng bộ TabBar và PageView
  set selectedTabIndex(int index) {
    setState(() {
      _selectedTabIndex = index; // Cập nhật chỉ số tab
      _tabController.animateTo(index); // Cập nhật TabBar
      _pageController.jumpToPage(index); // Cập nhật PageView
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedTabIndex =
        widget.sharedIndex; // Gán giá trị ban đầu từ sharedIndex
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController(); // in initState()

    // Khi khởi tạo, đồng bộ TabBar và PageView theo _selectedTabIndex
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(_selectedTabIndex); // Chọn tab tương ứng index
      _pageController
          .jumpToPage(_selectedTabIndex); // Hiển thị trang tương ứng index
      // Kiểm tra nếu pageIndex = 1 thì focus vào TextField
      if (widget.pageIndex == 1) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    _controller.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 100), () {
        String text = _controller.text;
        if (text != _previousText) {
          _previousText = text;
          _getData(text);
        }
      });
    });

    _scrollController.addListener(() {
      // Ẩn bàn phím khi cuộn
      if (_scrollController.hasClients) {
        FocusScope.of(context).unfocus();
      }
    });

    // Lắng nghe thay đổi trên TabController
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _isTabTapped = true; // Tab được nhấn
        setState(() {
          _selectedTabIndex =
              _tabController.index; // Cập nhật tab đang được chọn
        });
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 200), // Thời gian chuyển trang
          curve: Curves.easeInOut,
        );
      }
    });

    // Lắng nghe thay đổi trên PageController để đồng bộ tab khi lướt nhanh
    _pageController.addListener(() {
      if (!_isTabTapped) {
        final page = _pageController.page?.round();
        if (page != null && page != _tabController.index) {
          setState(() {
            _selectedTabIndex = page; // Cập nhật tab đang được chọn
          });
          _tabController.animateTo(page);
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant Search oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật _selectedTabIndex nếu widget.sharedIndex thay đổi
    if (oldWidget.sharedIndex != widget.sharedIndex) {
      setState(() {
        _selectedTabIndex = widget.sharedIndex; // Cập nhật từ sharedIndex
        _tabController.animateTo(_selectedTabIndex); // Cập nhật TabBar
        _pageController.jumpToPage(_selectedTabIndex); // Cập nhật PageView
      });
    }

    // Kiểm tra pageIndex và request focus cho TextField nếu pageIndex là 1
    if (widget.pageIndex == 1) {
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else {
      // Bỏ focus nếu không phải trang 1
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _pageController.dispose(); // Dispose page controller
    super.dispose();
  }

  Future<void> _getData(String text) async {
    if (text.isEmpty) {
      setState(() {
        wordData = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (_searchCache.containsKey(text)) {
      setState(() {
        wordData = _searchCache[text]!;
        isLoading = false;
      });
    } else {
      try {
        List<HintCharacter> results = await _searchService.hintSearch(text);
        setState(() {
          wordData = results;
          _searchCache[text] = results;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          wordData = [];
          isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    // Nếu TextField đang focus, bỏ focus và không thoát ứng dụng
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      return false;
    }

    // Nếu TextField có nội dung và chưa nhấn back lần đầu
    if (_controller.text.isNotEmpty && !_isBackPressed) {
      _clearText(); // Xoá nội dung
      _isBackPressed = true; // Đánh dấu đã nhấn lần đầu
      // Đặt lại trạng thái sau 1 giây để cho phép nhấn back lần tiếp theo
      await Future.delayed(const Duration(seconds: 1));
      _isBackPressed = false; // Đặt lại trạng thái sau thời gian chờ
      return false; // Không thoát ứng dụng
    }

    // Nếu đã nhấn back lần đầu và người dùng nhấn back lần nữa
    if (_isBackPressed) {
      return true; // Thoát ứng dụng
    }

    // Nếu không còn nội dung và không đang focus, cho phép thoát ứng dụng
    return true;
  }

  void _clearText() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Xử lý sự kiện back
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // Ngăn chặn tự động điều chỉnh kích thước khi bàn phím xuất hiện
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(58), // Chiều cao tùy chỉnh cho AppBar
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            backgroundColor: primaryColor,
            title: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 21.0),
                    onPressed: () {
                      // Unfocus TextField trước khi gọi hàm callback
                      if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                      }
                      _clearText(); // Xoá nội dung
                      widget.onBack();
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40, // Chiều cao của Container
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              focusNode: _focusNode,
                              controller: _controller,
                              style: const TextStyle(
                                  fontSize: 15.0), // Kiểu chữ cho text nhập vào
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                hintText: '哈喽，你好，。。',
                                hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight
                                        .normal), // Đặt kiểu chữ cho placeholder
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        18.0), // Bo tròn góc trên bên trái
                                    bottomLeft: Radius.circular(
                                        18.0), // Bo tròn góc dưới bên trái
                                    topRight: Radius.circular(18.0),
                                    bottomRight: Radius.circular(18.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.search,
                                    size: 20.0,
                                    color: Colors.grey), // Thêm icon tìm kiếm
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel,
                                            size: 18.0,
                                            color: Colors.grey[400]),
                                        onPressed: _clearText,
                                      )
                                    : null,
                              ),
                              onTap: () {
                                setState(() {
                                  isCardReplaced =
                                      false; // Đặt biến isCardReplaced thành false khi tap vào TextField
                                  isFocused = true;
                                });
                                FocusScope.of(context).requestFocus(_focusNode);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              InkWell(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: const Icon(Icons.draw_outlined,
                                        color: Colors.white, size: 22)),
                                onTap: () {
                                  _focusNode.unfocus();
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const DrawingBoard();
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: bodyColor,
        body: GestureDetector(
          onPanEnd: (_) {
            // Khi người dùng nhả ngón tay, ẩn bàn phím mà không mất focus
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            setState(() {
              isFocused = false;
            });
          },
          child: Column(
            children: [
              Container(
                color: primaryColor, // Set background color to primaryColor
                height: 40, // Adjust height as needed
                child: TabBar(
                  controller: _tabController,
                  tabs: ['Từ vựng', 'Story', 'Mẫu câu', 'Hình ảnh']
                      .map((label) => Tab(text: label))
                      .toList(),
                  onTap: (index) {
                    if (_pageController.page != index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(
                            milliseconds: 120), // Faster transition
                        curve: Curves.fastOutSlowIn, // More dynamic curve
                      );
                    }
                  },
                  labelPadding: const EdgeInsets.symmetric(
                      vertical: 4), // Adjust vertical padding
                  labelColor: Colors.white, // Color for selected tab text
                  unselectedLabelColor:
                      Colors.green[100], // Color for unselected tab text
                  indicator: const TriangleIndicator(
                    color: bodyColor, // Set the color of the triangle
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 8,
                    color: primaryColor,
                  ),
                  Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      color: bodyColor, // Màu sắc của container
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0), // Bo góc trái trên
                        topRight: Radius.circular(20.0), // Bo góc phải trên
                      ),
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 8),
              Expanded(
                child: PageView(
                  controller:
                      _pageController, // Sử dụng PageController trong PageView
                  onPageChanged: (index) {
                    if (!_tabController.indexIsChanging) {
                      _tabController.animateTo(index);
                    }
                  },
                  children: [
                    buildWordsView(),
                    buildStoriesView(),
                    buildSentencesView(),
                    buildSentencesView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWordsView() {
    if (_controller.text.isEmpty) {
      return buildLobbyView(); // Gọi hàm xây dựng giao diện sảnh chờ
    }

    if (isLoading) {
      if (isFocused) {
        return const Center(
            child: Image(
          image: AssetImage('assets/loading_green.gif'),
          height: 90,
        ));
      } else {
        return const Padding(
          padding: EdgeInsets.only(bottom: 150),
          child: Center(
              child: Image(
            image: AssetImage('assets/loading_green.gif'),
            height: 100,
          )),
        );
      }
    }

    if (wordData.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return buildListView(wordData);
  }

  Widget buildListView(List<HintCharacter> list) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: list.length, // Số lượng thẻ trong danh sách
            itemBuilder: (context, index) {
              // Nếu đã nhấn vào thẻ đầu tiên, thay thế bằng buildCardDetail()
              if (isCardReplaced && index == 0) {
                return buildCardDetail(); // Hiển thị nội dung chi tiết
              }

              // Lấy mục từ danh sách
              final item = list[index];

              return InkWell(
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if (index == 0) {
                    // Xử lý nhấn vào thẻ đầu tiên
                    setState(() {
                      isCardReplaced =
                          true; // Đánh dấu rằng thẻ đã được thay thế
                    });
                  } else {
                    // Xử lý nhấn vào các thẻ khác
                    setState(() {
                      isCardReplaced = true; // Trả thẻ về trạng thái ban đầu
                    });
                    _controller.text = item
                        .hanzi; // Dán Hanzi vào TextField mà không yêu cầu focus
                  }
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Text(
                                item.hanzi,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.red),
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
                                    item.hanViet,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.purple),
                                  ),
                                  Text(
                                    item.pinyin,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.orange),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Icon(Icons.volume_up_outlined,
                                  size: 20, color: Colors.grey),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        Text(
                          item.shortMeaning,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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

  Card buildCardDetail() {
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
                children: [
                  const Text(
                    '我们',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '[nǐmen]',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '[nhĩ môn]'.toUpperCase(),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(
                    Icons.volume_up_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Cấp độ:',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 4), // Khoảng cách bên trong
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 177, 54, 68), // Màu nền
                      borderRadius:
                          BorderRadius.circular(4.0), // Đường viền bo tròn
                    ),
                    child: const Text(
                      'HSK 1',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Từ loại:',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 4), // Khoảng cách bên trong
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // Màu nền (có thể thay đổi theo ý muốn)
                      borderRadius:
                          BorderRadius.circular(4.0), // Đường viền bo tròn
                      border: Border.all(
                        // Thêm border
                        color: Colors.grey, // Màu của border
                        width: 0.5, // Độ dày của border
                      ),
                    ),
                    child: const Text(
                      'Đại từ',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 2.0, horizontal: 9.0), // Khoảng cách bên trong
                decoration: BoxDecoration(
                  color: Colors.grey[400], // Màu nền
                ),
                child: const Text(
                  'Đại từ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '1)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Expanded(
                    // Sử dụng Expanded để cho phép Text chiếm không gian
                    child: Text(
                      'mấy người; các cậu; các bạn; các ông; các bà; anh chị; các anh; các chị',
                      style: TextStyle(fontSize: 15),
                      maxLines: null, // Không giới hạn số dòng
                      overflow: TextOverflow.visible, // Cho phép xuống dòng
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  '代词，称不止一个人的对方或包括对方在内的若干人',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.volume_up_outlined,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '你们歇一会儿，让我们接着干。',
                      style: TextStyle(fontSize: 15, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'nǐmen xiē yīhuǐr, ràng wǒmen jiēzhe gàn.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Các anh nghỉ một lát, để chúng tôi làm tiếp.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'Từ cận nghĩa:',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey),
                ),
              ),
              buildCantrairow(1, '他们'),
              buildCantrairow(2, '我们'),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'Hình ảnh:',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey),
                ),
              ),
              const Center(
                  child: Image(
                image: NetworkImage(
                    'https://assets.hanzii.net/img_word/ab4a85fc2ec4cf830e0f84aaacefcb1c_h.jpg'),
                height: 140,
              )),
              const Divider(),
              Text(
                'Góp ý :',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildCantrairow(int idx, String word) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text('$idx)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            word,
            style: TextStyle(fontSize: 16, color: Colors.blue[700]),
          )
        ],
      ),
    );
  }

  Widget buildListViewHan(List<HintCharacter> list) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: list.length, // Chỉ cần số lượng item trong list
            itemBuilder: (context, index) {
              // Kiểm tra trạng thái để hiển thị thẻ chi tiết nếu thẻ đã được chọn
              if (selectedCards[index] == true) {
                return buildCarddetailHan(); // Hiển thị thẻ chi tiết
              }

              final item = list[index];

              return InkWell(
                onTap: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  setState(() {
                    // Đánh dấu card đã được nhấn trong Map
                    selectedCards[index] = true;
                  });
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Text(
                                item.hanzi,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.red),
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
                                    item.hanViet,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.purple),
                                  ),
                                  Text(
                                    item.pinyin,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.orange),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Icon(Icons.volume_up_outlined,
                                  size: 20, color: Colors.grey),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        Text(
                          item.shortMeaning,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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

  Card buildCarddetailHan() {
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

  Widget buildStoriesView() {
    return buildListViewHan(hanziData);
  }

  Widget buildSentencesView() {
    return const Center(child: Text('Sentences Content'));
  }
}

// Sảnh chờ
Widget buildLobbyView() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Lịch sử tra cứu :',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey[350],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('我们'),
          Divider(
            color: Colors.grey[300],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('你们'),
          Divider(
            color: Colors.grey[300],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('豪门'),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey[300],
          ),
        ],
      ),
    ),
  );
}

class TriangleIndicator extends Decoration {
  final Color color;

  const TriangleIndicator({required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrianglePainter(color: color);
  }
}

class _TrianglePainter extends BoxPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()..color = color;

    final Rect rect = offset & configuration.size!;

    // Chiều cao và chiều rộng cố định cho tam giác
    const double triangleHeight = 8.0;
    const double triangleWidth = 20.0;

    // Tính toán vị trí tam giác sao cho nó nằm ở giữa theo chiều ngang
    final double triangleStartX = rect.left + (rect.width - triangleWidth) / 2;
    final Path path = Path()
      ..moveTo(triangleStartX, rect.bottom) // Bắt đầu từ bên trái của tam giác
      ..lineTo(triangleStartX + triangleWidth / 2,
          rect.bottom - triangleHeight) // Đỉnh tam giác ở giữa
      ..lineTo(triangleStartX + triangleWidth,
          rect.bottom) // Kết thúc bên phải của tam giác
      ..close(); // Đóng tam giác

    canvas.drawPath(path, paint);
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

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final List<Offset?> _points = [];
  String _recognizedResult = "";
  late Handwriting _handwriting; // Khai báo đối tượng Handwriting

  @override
  void initState() {
    super.initState();
    _handwriting = Handwriting(width: 300, height: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Vẽ ký tự tiếng Trung ở đây",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _points.add(null); // Đánh dấu kết thúc vẽ
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(_points),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _recognizeHandwriting();
          },
          child: const Text("Nhận diện"),
        ),
        const SizedBox(height: 20),
        Text(
          "Kết quả nhận diện: $_recognizedResult",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _recognizeHandwriting() {
    List<List<List<int>>> rawTrace =
        _convertPointsToTrace(_points); // Đổi kiểu biến ở đây
    print("Trace: $rawTrace"); // In tọa độ ra console

    // Chuyển đổi rawTrace sang định dạng đúng cho phương thức recognize
    List<List<int>> trace = [];

    for (var stroke in rawTrace) {
      // Chỉ thêm x và y vào trace
      if (stroke.length == 2) {
        trace.add(stroke[0]); // X coordinates
        trace.add(stroke[1]); // Y coordinates
      }
    }

    var options = {
      'language': 'zh_TW',
      'numOfReturn': 5,
      'numOfWords': 2,
    };

    _handwriting.recognize(
      trace,
      options,
      (results, error) {
        if (error != null) {
          setState(() {
            _recognizedResult = "Error: ${error.toString()}";
          });
        } else {
          setState(() {
            _recognizedResult = results?.toString() ?? "No result";
          });
        }
      },
    );
  }

  List<List<List<int>>> _convertPointsToTrace(List<Offset?> points) {
    List<List<List<int>>> trace = [];
    List<int> xCoords = [];
    List<int> yCoords = [];

    for (var point in points) {
      if (point != null) {
        // Thêm tọa độ vào danh sách
        xCoords.add(point.dx.toInt());
        yCoords.add(point.dy.toInt());
      } else {
        // Khi gặp null, có thể đã kết thúc một stroke
        if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
          // Thêm stroke vào trace
          trace.add([xCoords, yCoords]);
          // Reset danh sách tọa độ cho stroke tiếp theo
          xCoords = [];
          yCoords = [];
        }
      }
    }

    // Nếu còn tọa độ trong xCoords và yCoords, thêm stroke cuối cùng
    if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
      trace.add([xCoords, yCoords]);
    }

    return trace; // Trả về danh sách các strokes
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
