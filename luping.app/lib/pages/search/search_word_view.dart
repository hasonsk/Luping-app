import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/hint_character.dart';

class SearchWordView extends StatefulWidget {
  final List<HintCharacter> list;

  const SearchWordView({super.key, required this.list});

  @override
  _SearchWordViewState createState() => _SearchWordViewState();
}

class _SearchWordViewState extends State<SearchWordView> {
  late ScrollController _scrollController;
  late TextEditingController _controller;
  bool isCardReplaced = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
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
              if (isCardReplaced && index == 0) {
                return buildCardDetail();
              }

              final item = widget.list[index];
              return InkWell(
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  setState(() {
                    isCardReplaced = true;
                  });
                  _controller.text = item.hanzi;
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
                                maxWidth: MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Text(
                                item.hanzi,
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
                                    item.hanViet,
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
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Icon(Icons.volume_up_outlined, size: 20, color: Colors.grey),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        Text(
                          item.shortmeaning,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
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

  // Card buildCardDetail() {
  //   return Card(
  //     color: Colors.white,
  //     margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
  //     child: SizedBox(
  //       width: double.infinity,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const Text(
  //                   '我们',
  //                   style: TextStyle(
  //                       fontSize: 24,
  //                       color: Colors.red,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 5),
  //                   child: Text(
  //                     '[nǐmen]',
  //                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 5),
  //                   child: Text(
  //                     '[nhĩ môn]'.toUpperCase(),
  //                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
  //                   ),
  //                 ),
  //                 const Expanded(child: SizedBox()),
  //                 const Icon(
  //                   Icons.volume_up_outlined,
  //                   color: Colors.grey,
  //                   size: 20,
  //                 ),
  //                 const SizedBox(
  //                   width: 5,
  //                 )
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             const Divider(),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               children: [
  //                 Text(
  //                   'Cấp độ:',
  //                   style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey[600],
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: Colors.grey),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 2.0, horizontal: 4), // Khoảng cách bên trong
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(255, 177, 54, 68), // Màu nền
  //                     borderRadius:
  //                     BorderRadius.circular(4.0), // Đường viền bo tròn
  //                   ),
  //                   child: const Text(
  //                     'HSK 1',
  //                     style: TextStyle(fontSize: 10, color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               children: [
  //                 Text(
  //                   'Từ loại:',
  //                   style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey[600],
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: Colors.grey),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 2.0, horizontal: 4), // Khoảng cách bên trong
  //                   decoration: BoxDecoration(
  //                     color:
  //                     Colors.white, // Màu nền (có thể thay đổi theo ý muốn)
  //                     borderRadius:
  //                     BorderRadius.circular(4.0), // Đường viền bo tròn
  //                     border: Border.all(
  //                       // Thêm border
  //                       color: Colors.grey, // Màu của border
  //                       width: 0.5, // Độ dày của border
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Đại từ',
  //                     style: TextStyle(fontSize: 11),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                   vertical: 2.0, horizontal: 9.0), // Khoảng cách bên trong
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[400], // Màu nền
  //               ),
  //               child: const Text(
  //                 'Đại từ',
  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 2),
  //                   child: Text(
  //                     '1)',
  //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 5,
  //                 ),
  //                 const Expanded(
  //                   // Sử dụng Expanded để cho phép Text chiếm không gian
  //                   child: Text(
  //                     'mấy người; các cậu; các bạn; các ông; các bà; anh chị; các anh; các chị',
  //                     style: TextStyle(fontSize: 15),
  //                     maxLines: null, // Không giới hạn số dòng
  //                     overflow: TextOverflow.visible, // Cho phép xuống dòng
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Padding(
  //               padding:
  //               const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //               child: Text(
  //                 '代词，称不止一个人的对方或包括对方在内的若干人',
  //                 style: TextStyle(color: Colors.blue[700]),
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //               const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //               child: Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 2),
  //                     child: Icon(
  //                       Icons.volume_up_outlined,
  //                       size: 18,
  //                       color: Colors.grey[500],
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     '你们歇一会儿，让我们接着干。',
  //                     style: TextStyle(fontSize: 15, color: Colors.blue[700]),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 15),
  //               child: Text(
  //                 'nǐmen xiē yīhuǐr, ràng wǒmen jiēzhe gàn.',
  //                 style: TextStyle(fontSize: 13, color: Colors.grey[600]),
  //               ),
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 15),
  //               child: Text(
  //                 'Các anh nghỉ một lát, để chúng tôi làm tiếp.',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 5),
  //               child: Text(
  //                 'Từ cận nghĩa:',
  //                 style: TextStyle(
  //                     fontSize: 13,
  //                     color: Colors.grey[600],
  //                     decoration: TextDecoration.underline,
  //                     decorationColor: Colors.grey),
  //               ),
  //             ),
  //             buildCantrairow(1, '他们'),
  //             buildCantrairow(2, '我们'),
  //             const SizedBox(
  //               height: 25,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 5),
  //               child: Text(
  //                 'Hình ảnh:',
  //                 style: TextStyle(
  //                     fontSize: 13,
  //                     color: Colors.grey[600],
  //                     decoration: TextDecoration.underline,
  //                     decorationColor: Colors.grey),
  //               ),
  //             ),
  //             const Center(
  //                 child: Image(
  //                   image: NetworkImage(
  //                       'https://assets.hanzii.net/img_word/ab4a85fc2ec4cf830e0f84aaacefcb1c_h.jpg'),
  //                   height: 140,
  //                 )),
  //             const Divider(),
  //             Text(
  //               'Góp ý :',
  //               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Padding buildCantrairow(int idx, String word) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5),
  //     child: Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(top: 5),
  //           child: Text('$idx)',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600])),
  //         ),
  //         const SizedBox(
  //           width: 7,
  //         ),
  //         Text(
  //           word,
  //           style: TextStyle(fontSize: 16, color: Colors.blue[700]),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Card buildCardDetail() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction, // Icon biểu thị tính năng đang phát triển
                size: 50,
                color: Colors.orange[700],
              ),
              const SizedBox(height: 10),
              const Text(
                'Tính năng đang được phát triển!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Hãy quay lại sau để khám phá thêm nhé!',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
