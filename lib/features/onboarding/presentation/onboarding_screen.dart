import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/features/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const .symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .start,
          children: [
            Text(
              "Madang",
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 15),
            Text(
              "Booking a table and food from everywhere.",
              style: AppTextStyles.heading4.copyWith(fontWeight: .w500),
            ),
            const SizedBox(height: 80),
            CustomButton(label: "Sign Up", onPressed: () {}),
            const SizedBox(height: 25),
            CustomButton(
              label: "Login",
              variant: CustomButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
