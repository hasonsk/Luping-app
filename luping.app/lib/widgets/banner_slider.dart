import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerSlider extends StatefulWidget {
  final List<String> images;

  const BannerSlider({super.key, required this.images});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 63.0,
            color: Colors.white,
          ),
        )
            : CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 63.0,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 5),
          ),
          items: widget.images.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: () => _carouselController.previousPage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(20, 20),
              elevation: 0,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 12,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: () => _carouselController.nextPage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(4),
              minimumSize: const Size(20, 20),
              elevation: 0,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}
