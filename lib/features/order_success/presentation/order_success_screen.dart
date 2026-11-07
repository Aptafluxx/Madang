import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/features/main/data/controllers/main_controller.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final iconSize = constraints.maxWidth >= 360 ? 96.0 : 90.0;

              return Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.21),
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: iconSize * 0.7,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text("You've Made Order!", style: AppTextStyles.heading4),
                  const SizedBox(height: 33),
                  CustomButton(
                    label: "Check Order",
                    onPressed: () {
                      Get.until(
                        (route) => route.settings.name == AppRoutes.home,
                      );
                      Get.find<MainController>().changeTab(2);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    label: "Back Home",
                    variant: CustomButtonVariant.outlined,
                    onPressed: () => Get.offAllNamed(AppRoutes.home),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
