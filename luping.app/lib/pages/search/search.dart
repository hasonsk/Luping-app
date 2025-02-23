import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:luping/models/hint_character.dart';
import 'package:luping/data/database_helper.dart';
import 'package:luping/models/hint_story.dart';
import 'package:luping/models/sentence.dart';
import 'package:luping/pages/search/develop_announce_screen.dart';
import 'package:luping/pages/search/drawingboard.dart';
import 'package:luping/pages/search/search_image_view.dart';
import 'package:luping/pages/search/search_loading_widget.dart';
import 'package:luping/pages/search/search_lobby_view.dart';
import 'package:luping/pages/search/search_sentence_view.dart';
import 'dart:async';
import 'package:luping/pages/search/stories/search_story_view.dart';
import 'package:luping/pages/search/search_triangle_icon.dart';
import 'package:luping/pages/search/search_word_view.dart';
import 'package:luping/services/search_service.dart';
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
  // Import Search Service
  final SearchService _searchService = SearchService();

  // Color variable
  static const primaryColor = Color(0xFF96D962); // Màu chủ đề
  static const bodyColor = Color(0xFFF2F2F7); // Màu nền của body

  // Điều khiển text-field && Tab
  final TextEditingController _controller =
      TextEditingController(); // Điều khiển nội dung của TextField
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;
  late PageController _pageController; // Thêm PageController

  bool isLoading = false; // Biến trạng thái cho loading

  String searchword = ''; // Biến lưu query hiện tại
  String _previousText = '';

  bool _isTabTapped = false; // Biến để theo dõi khi tab được nhấn
  Timer? _debounceTimer; // Biến lưu Timer để thực hiện debounce

  bool isFocused = false;
  bool isCardReplaced = false; // Biến để theo dõi trạng thái thay thế thẻ
  Map<int, bool> selectedCards = {};

  // Parameter Quay lại
  bool _isBackPressed = false;

  // Parameter
  late ValueNotifier<int> _selectedTabIndex;

  // Data field
  List<HintCharacter> wordData = [];
  List<HintStory> hanziData = [];
  List<Sentence> sentenceData = [];
  List<String> imageData = [];

// Setter cho _selectedTabIndex để đồng bộ TabBar và PageView
  set selectedTabIndex(int index) {
    setState(() {
      _selectedTabIndex.value = index; // Cập nhật chỉ số tab
      _tabController.animateTo(index); // Cập nhật TabBar
      _pageController.jumpToPage(index); // Cập nhật PageView
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = ValueNotifier<int>(widget.sharedIndex);
    _selectedTabIndex.value =
        widget.sharedIndex; // Gán giá trị ban đầu từ sharedIndex
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController(); // in initState()

    // Khi khởi tạo, đồng bộ TabBar và PageView theo _selectedTabIndex
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController
          .animateTo(_selectedTabIndex.value); // Chọn tab tương ứng index
      _pageController.jumpToPage(
          _selectedTabIndex.value); // Hiển thị trang tương ứng index
      // Kiểm tra nếu pageIndex = 1 thì focus vào TextField
      if (widget.pageIndex == 1) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    // Lắng nghe thay đổi trên TabController
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _isTabTapped = true; // Tab được nhấn
        setState(() {
          _selectedTabIndex.value =
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
            _selectedTabIndex.value = page; // Cập nhật tab đang được chọn
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
        _selectedTabIndex =
            ValueNotifier<int>(widget.sharedIndex); // Cập nhật từ sharedIndex
        _tabController.animateTo(_selectedTabIndex.value); // Cập nhật TabBar
        _pageController
            .jumpToPage(_selectedTabIndex.value); // Cập nhật PageView
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
    _tabController.dispose();
    _focusNode.dispose();
    _pageController.dispose(); // Dispose page controller
    _selectedTabIndex.dispose();
    super.dispose();
  }

  // Xử lý dữ liệu mình tab cho lần đầu
  Future<void> _getData(String? text, int index) async {
    if (text == null || text.trim().isEmpty) {
      // Nếu text null hoặc rỗng, đặt tất cả dữ liệu về danh sách rỗng
      setState(() {
        wordData = [];
        hanziData = [];
        sentenceData = [];
        imageData = [];
      });
      return; // Thoát khỏi hàm, không gọi API
    }

    switch (index) {
      case 0:
        setState(() {
          wordData = [];
          hanziData = [];
          sentenceData = [];
          imageData = [];
        });
        var result = await _searchService.hintSearch(text);
        setState(() {
          wordData = result;
        });
        break;
      case 1:
        setState(() {
          wordData = [];
          hanziData = [];
          sentenceData = [];
          imageData = [];
        });
        var result = await _searchService.getStoryHint(text);
        setState(() {
          hanziData = result;
        });
        break;
      case 2:
        setState(() {
          wordData = [];
          hanziData = [];
          sentenceData = [];
          imageData = [];
        });
        var result = await _searchService.getSentence(text);
        setState(() {
          sentenceData = result;
        });
        break;
      case 3:
        setState(() {
          wordData = [];
          hanziData = [];
          sentenceData = [];
          imageData = [];
        });
        var result = await _searchService.getImage(text, 0);
        setState(() {
          imageData = result ?? []; // Nếu result là null, đặt imageData = []
        });
        break;
      default:
        print("Index không hợp lệ: $index");
    }
  }

  // Cập nhât dữ liệu khi người dùng đổi tab
  Future<void> _updateData(String? text, int index) async {
    if (text == null || text.trim().isEmpty)
      return; // Nếu text rỗng, không làm gì

    setState(() {
      isLoading = true; // Bắt đầu tải dữ liệu
    });

    try {
      switch (index) {
        case 0:
          if (wordData.isEmpty) {
            var result = await _searchService.hintSearch(text);
            setState(() {
              wordData = result;
            });
          }
          break;
        case 1:
          if (hanziData.isEmpty) {
            var result = await _searchService.getStoryHint(text);
            setState(() {
              hanziData = result;
            });
          }
          break;
        case 2:
          if (sentenceData.isEmpty) {
            var result = await _searchService.getSentence(text);
            setState(() {
              sentenceData = result;
            });
          }
          break;
        case 3:
          if (imageData.isEmpty) {
            var result = await _searchService.getImage(text, 0);
            setState(() {
              imageData = result ?? [];
            });
          }
          break;
        default:
          print("Index không hợp lệ: $index");
      }
    } finally {
      setState(() {
        isLoading = false; // Kết thúc tải dữ liệu
      });
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
    setState(() {
      wordData = [];
      hanziData = [];
      sentenceData = [];
      imageData = [];
    });
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
                              onChanged: _onSearchTextChanged,
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
    // if (_controller.text.isEmpty) {
    //   return const SearchLobbyView(); // Gọi hàm xây dựng giao diện sảnh chờ
    // }
    // if(wordData.isEmpty){
    //   _updateData(_controller.text, 0);
    // }
    // return SearchWordView(list: wordData);
    return DevelopAnnounceScreen();
  }

  Widget buildStoriesView() {
    if (hanziData.isEmpty) {

      _updateData(_controller.text, 1).then((_) {
        setState(() {
          isLoading = false; // Tắt loading khi dữ liệu đã tải xong
        });
      });
    }

    return isLoading
        ? const Center(child: SearchLoadingWidget()) // Hiển thị loading
        : SearchStoryView(list: hanziData); // Hiển thị dữ liệu khi đã có
  }

  Widget buildSentencesView() {
    if(sentenceData.isEmpty){
      // _updateData(_controller.text, 2);
    }
    // return SearchSentencesView(list: sentenceData);
    return DevelopAnnounceScreen();
  }

  Widget buildImagesView() {
    // if(sentenceData.isEmpty){
    //   _updateData(_controller.text, 3);
    // }
    // return SearchImageView(list : imageData);
    return DevelopAnnounceScreen();
  }

  // Hàm này được gọi khi người dùng thay đổi nội dung TextField
  void _onSearchTextChanged(String newQuery) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (newQuery != searchword) {
        setState(() {
          searchword = newQuery;
          isLoading = true; // Bắt đầu hiển thị loading
        });

        // Gửi request tìm kiếm
        _getData(searchword, _selectedTabIndex.value).then((_) {
          setState(() {
            isLoading = false; // Tắt loading sau khi dữ liệu đã tải xong
          });
        });
      }
    });
  }
}
