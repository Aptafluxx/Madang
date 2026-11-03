import 'dart:async';

import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  static const _banners = [
    'assets/images/promo_banners/promo_banner1.png',
    'assets/images/promo_banners/promo_banner2.png',
    'assets/images/promo_banners/promo_banner3.png',
  ];

  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const .symmetric(horizontal: 15),
          child: SizedBox(
            width: double.infinity,
            height: 190,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: _onPageChanged,
              clipBehavior: .none,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const .symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _banners[index],
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (_, _, _) =>
                          Container(color: Colors.brown.shade300),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        IgnorePointer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? AppColors.primary
                      : AppColors.gray,
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
