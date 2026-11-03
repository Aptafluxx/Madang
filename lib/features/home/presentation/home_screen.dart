import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/features/home/controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomButton(
              label: 'Logout',
              variant: CustomButtonVariant.outlined,
              onPressed: controller.logout,
            ),
          ),
        ),
      ),
    );
  }
}
