import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hanjii/models/hint_character.dart';
import 'package:hanjii/data/database_helper.dart';
import 'package:hanjii/models/hint_story.dart';
import 'package:hanjii/pages/search/drawingboard.dart';
import 'package:hanjii/pages/search/search_image_view.dart';
import 'package:hanjii/pages/search/search_lobby_view.dart';
import 'dart:async';
import 'package:hanjii/pages/search/search_story_view.dart';
import 'package:hanjii/pages/search/search_word_view.dart';
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
  List<HintCharacter> wordData = [];
  List<HintStory> hanziData = [];
  List<String> imageData = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIBK512v9cBy7_94eTofhozRCKwwszEWdeYw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWWM5vq0LOukFhr-hw3b5GS1MkUJm0p5A2gw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8yXKP24h_8R175Yf46FniZ4OBxlbfKbs7tQ&s",
    "https://i.kfs.io/album/global/255707687,0v1/fit/500x500.jpg",
    "https://www.tanghuaku.com/wp-content/uploads/2021/04/TK-1174.jpg",
    "https://i.ytimg.com/vi/lNB8Y82DVio/maxresdefault.jpg",
    "https://upload.wikimedia.org/wikipedia/zh/4/41/You_and_Me_cover.jpg",
    "https://p1.img.cctvpic.com/photoAlbum/page/performance/img/2016/6/28/1467095898279_379.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJKaM5XMXpZmdB3jA13DGi_nGK_PyzBZArmw&s",
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
                    buildImagesView(),
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
      return SearchLobbyView(); // Gọi hàm xây dựng giao diện sảnh chờ
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

    return SearchWordView(list: wordData);
  }

  Widget buildStoriesView() {
    return SearchStoryView(list : hanziData);
  }

  Widget buildSentencesView() {
    return const Center(child: Text('Sentences Content'));
  }

  Widget buildImagesView() {
    return SearchImageView(list : imageData);
  }
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

