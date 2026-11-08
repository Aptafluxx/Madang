import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/features/home/data/controller/home_controller.dart';
import 'package:madang/features/home/presentation/widgets/menu_grid.dart';
import 'package:madang/features/home/presentation/widgets/promo_banner.dart';
import 'package:madang/features/home/presentation/widgets/recommendation_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const .only(top: 15, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final name = controller.displayName;
                            return Text(
                              name.isEmpty ? 'Your name' : name,
                              style: AppTextStyles.title1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            );
                          }),

                          const SizedBox(height: 4),
                          const Text(
                            'Get your favorite food here!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.cart);
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        size: 28,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const PromoBanner(),
              const SizedBox(height: 30),
              MenuGrid(
                onFoodTap: () {
                  Get.toNamed(AppRoutes.food);
                },
                onTableTap: () {
                  Get.toNamed(AppRoutes.table);
                },
                onPaymentTap: () {},
                onMoreTap: () {},
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: .only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Recommendation', style: AppTextStyles.title2),
                ),
              ),
              const SizedBox(height: 15),
              const RecommendationList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
