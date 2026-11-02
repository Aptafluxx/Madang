import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/features/splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              "Madang",
              style: AppTextStyles.heading1.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const .symmetric(horizontal: 15),
              child: LoadingAnimationWidget.inkDrop(
                color: AppColors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
