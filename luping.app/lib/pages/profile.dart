import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // static const Color primaryColor = Color(0xFF96D962);
  static final Color backColor = Colors.grey[200]!;

  @override
  void initState() {
    super.initState();
    // Thiết lập màu cho status bar và màu của icon trên status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backColor, // Màu của status bar
        statusBarIconBrightness: Brightness.dark, // Màu của icon trên status bar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            color: backColor,
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage('assets/logo.png'),
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Tuan Anh Le',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'tuananh12072002@gmail.com',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem('Từ đã học', '0'),
                                    _buildStatItem('Hán tự đã học', '0'),
                                    _buildStatItem('Sách đã đọc', '0'),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                          const Positioned(
                              top: 15,
                              right: 15,
                              child: Icon(Icons.edit, color: Colors.black54, size: 22,)
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          buildTitle('Hán tự gần đây', Colors.green),
                          const SizedBox(height: 20,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                buildTextButton('你'),
                                buildTextButton('戈'),
                                buildTextButton('饥'),
                                buildTextButton('了'),
                                buildTextButton('非'),
                                buildTextButton('查'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          buildTitle('Thẻ nhớ đã lưu', Colors.purple),
                          const SizedBox(height: 20,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                buildFolderButton('Từ vựng'),
                                buildFolderButton('Ở lớp'),
                                buildFolderButton('Đọc sách'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //       children: [
                          //         CustomImageWidget(imageUrl: 'assets/chuanhanngu_2.png', index: 1, Hanzinum: 432),
                          //         CustomImageWidget(imageUrl: 'assets/chuanhanngu_3.png', index: 1, Hanzinum: 432),
                          //         CustomImageWidget(imageUrl: 'assets/chuanhanngu_4.png', index: 1, Hanzinum: 432),
                          //         CustomImageWidget(imageUrl: 'assets/chuanhanngu_6.png', index: 1, Hanzinum: 432),
                          //
                          //       ],
                          //     ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 150,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          height: 18,
          width: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        const SizedBox(width: 10,),
        Text('$title :', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
      ],
    );
  }

  Widget buildTextButton(String hanzi) {
    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: (){},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.6,
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.transparent,
            ),
            child: Center(
              child: Text(
                hanzi,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 13),
      constraints: const BoxConstraints(
        minWidth: 100, // Set your desired minimum width here
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // backgroundColor: Colors.white
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              // backgroundColor: Colors.white,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFolderButton(String hanzi) {
    return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: (){},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.6,
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.transparent,
            ),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.folder, color: Colors.grey,size: 22,),
                  const SizedBox(width: 5,),
                  Text(
                    hanzi,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12, // Màu sắc của border
          width: 0.6, // Độ dày của border
        ),
        borderRadius: BorderRadius.circular(8.0), // Nếu bạn muốn bo tròn các góc
      ),
      margin: const EdgeInsets.only(
        right: 20
      ),
      child: InkWell(
        onTap: () {
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Để làm cho hình ảnh cũng bo tròn góc
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text('GT Chuẩn HSK $index', style: TextStyle(fontSize: 12)),
            //       const SizedBox(height: 2),
            //       Text('Từ vựng : $Hanzinum', style: TextStyle(fontSize: 10)),
            //       const SizedBox(height: 2),
            //       Text('Tiến độ : 0%', style: TextStyle(fontSize: 10)),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
