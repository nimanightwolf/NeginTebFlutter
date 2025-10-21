import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/network.dart';

class StoryCarousel extends StatefulWidget {
  final List<String> images;
  final List<String> titles;

  const StoryCarousel({
    super.key,
    required this.images,
    required this.titles,
  });

  @override
  StoryCarouselState createState() => StoryCarouselState();
}

class StoryCarouselState extends State<StoryCarousel> {
  int _currentIndex = 0;
  late Timer _timer;
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();

    // بعد از اولین فریم و آماده‌شدن کنترلر، تایمر را شروع کن
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _carouselController.onReady;
      // if (!mounted || widget.images.isEmpty) return;
      _startAutoSlide();
    });
  }


  void _startAutoSlide() {
    // اگر هیچ عکسی نیست تایمر نساز
    // if (widget.images.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted || widget.images.isEmpty) return;
      if (!_carouselController.ready) return;

      // محاسبه اندیس بعدی
      final next = (_currentIndex + 1) % widget.images.length;
      await _safeAnimateTo(next);
      if (mounted) setState(() => _currentIndex = next);
    });
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _nextImage() async {
    if (widget.images.isEmpty) return;
    final next = (_currentIndex + 1) % widget.images.length;
    await _safeAnimateTo(next);
    if (mounted) setState(() => _currentIndex = next);
  }
  Future<void> _safeAnimateTo(int page) async {
    if (!mounted) return;
    if (widget.images.isEmpty) return;

    // صبر کن تا کنترلر آماده شود
    await _carouselController.onReady;

    // اگر باز هم آماده نبود یا ایندکس نامعتبر بود، برنگرد
    if (!_carouselController.ready) return;
    if (page < 0 || page >= widget.images.length) return;

    try {
      await _carouselController.animateToPage(page);
    } catch (_) {
      // اگر هنوز pageController مقدار نگرفته بود، یک فریم صبر کن و دوباره
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        await _carouselController.animateToPage(page);
      }
    }
  }

  void _prevImage() async {
    if (widget.images.isEmpty) return;
    final prev = (_currentIndex - 1 + widget.images.length) % widget.images.length;
    await _safeAnimateTo(prev);
    if (mounted) setState(() => _currentIndex = prev);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlay: false,
              onPageChanged: (index, reason) {
                if (mounted) setState(() => _currentIndex = index);
              },
            ),
            items: widget.images.map((imageUrl) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(networkUrl(imageUrl), fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(widget.images.length, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _currentIndex >= index ? Colors.white : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              widget.titles[_currentIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 100,
            child: GestureDetector(
              onTap: _nextImage,
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.6),
                child: const Icon(Icons.chevron_right, color: Colors.black),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 100,
            child: GestureDetector(
              onTap: _prevImage,
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.6),
                child: const Icon(Icons.chevron_left, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



