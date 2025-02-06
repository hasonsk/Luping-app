import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Thêm import này


class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light, // For iOS: (dark icons)
          statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20), // Điều chỉnh kích thước tại đây
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 25),
            child: Text(
              'Giáo trình Hán ngữ chuẩn HSK 1',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 65),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Icon(Icons.list, color: Colors.green),
                      SizedBox(width: 5), // Thêm khoảng cách giữa biểu tượng và văn bản
                      Text('Mục lục : (15 bài học)', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Row(
                    children: [
                      SizedBox(width: 2,),
                      Icon(Icons.pie_chart_rounded, color: Colors.green, size: 12,),
                      SizedBox(width: 10,),
                      Text('Tiến độ :', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),
                      Text('0/15', style: TextStyle(color: Colors.green),)
                    ],
                  ),
                  const SizedBox(height: 20,),
                  buildLesson(1 ,'你好 - Xin chào'),
                  buildLesson(2 ,'谢谢你 - Cảm ơn bạn'),
                  buildLesson(3 ,'你叫什么名字 - Bạn tên là gì ?'),
                  buildLesson(4 ,'她是我的汉语老师 - Cô ấy là giáo viên tiếng Trung của tôi'),
                  buildLesson(5 ,'她女儿今年二十岁 - Con gái của cô ấy năm nay 20 tuổi'),
                  buildLesson(6 ,'我会说汉语 - Tôi biết nói tiếng Trung'),
                  buildLesson(7 ,'今天几号 - Hôm nay ngày mấy'),
                  buildLesson(8 ,'我想喝茶 - Tôi muốn uống trà'),
                  buildLesson(9 ,'你儿子在哪儿工作 - Con trai bạn làm ở đâu'),
                  buildLesson(10 ,'我能坐这儿吗 - Tôi có thể ngồi ở đây không ?'),
                  buildLesson(11 ,'现在几点- Bây giờ mấy giờ'),
                  buildLesson(12 ,'明天天气怎么样 - Ngày mai thời tiết như thế nào'),
                  buildLesson(13 ,'她在学做中国菜呢 - Cô ấy đang học làm món Trung Quốc'),
                  buildLesson(14 ,'她买了不少衣服 - Cô ấy mua không ít quần áo'),
                  buildLesson(15 ,'我是坐飞机来的 - Tôi ngồi máy bay tới'),

                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              color: Colors.white,
            )
          ),
        ],
      )
    );
  }

  Widget buildLesson(int index, String title) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo text căn lề trên
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1,
                    ),
                    child: Text('Bài $index :',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa 'Bài 1 :' và title
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true, // Cho phép tự động xuống dòng
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.green[100],
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của nút
                    foregroundColor: Colors.black, // Màu chữ
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Điều chỉnh kích cỡ
                    textStyle: const TextStyle(fontSize: 14), // Giảm kích cỡ chữ
                    side: const BorderSide(color: Colors.grey, width: 0.5), // Viền màu xám
                    elevation: 4, // Độ cao của bóng (hiệu ứng nổi)
                    shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng xung quanh
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Góc bo viền
                    ),
                  ),
                  child: const Text('Hán tự'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của nút
                    foregroundColor: Colors.black, // Màu chữ
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Điều chỉnh kích cỡ
                    textStyle: const TextStyle(fontSize: 14), // Giảm kích cỡ chữ
                    side: const BorderSide(color: Colors.grey, width: 0.5), // Viền màu xám
                    elevation: 4, // Độ cao của bóng (hiệu ứng nổi)
                    shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng xung quanh
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Góc bo viền
                    ),
                  ),
                  child: const Text('Từ vựng'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của nút
                    foregroundColor: Colors.black, // Màu chữ
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Điều chỉnh kích cỡ
                    textStyle: const TextStyle(fontSize: 14), // Giảm kích cỡ chữ
                    side: const BorderSide(color: Colors.grey, width: 0.5), // Viền màu xám
                    elevation: 4, // Độ cao của bóng (hiệu ứng nổi)
                    shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng xung quanh
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Góc bo viền
                    ),
                  ),
                  child: const Text('考试'),
                ),
              ],
            ),
            const SizedBox(height: 15,)
          ],
        ),
        Positioned(
            top: 3,
            right: 0,
            child: Checkbox(
              value: false,
              onChanged: (bool? value){},
              activeColor: Colors.green,
            )
        )
      ]
    );
  }
}
