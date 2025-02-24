import 'package:flutter/material.dart';

class ShimmerImageGrid extends StatefulWidget {
  const ShimmerImageGrid({super.key});

  @override
  _ShimmerImageGridState createState() => _ShimmerImageGridState();
}

class _ShimmerImageGridState extends State<ShimmerImageGrid> with SingleTickerProviderStateMixin {
  final List<bool> _imageLoaded = List.generate(7, (_) => false);
  final List<bool> _animated = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _animated.length; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          setState(() {
            _animated[i] = true;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 20.0,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _animated[index] ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _animated[index] ? const Offset(0, 0) : const Offset(0, 0.5),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/HSK${index + 1}_icon.png',
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (frame != null && !_imageLoaded[index]) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _imageLoaded[index] = true;
                                  });
                                });
                              }
                              return child;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'HSK${index + 1}',
              style: const TextStyle(fontSize: 9),
            ),
          ],
        );
      },
    );
  }
}
