import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/features/home/data/controller/home_controller.dart';
import 'package:madang/features/home/presentation/widgets/restaurant_card.dart';
import 'package:shimmer/shimmer.dart';

class RecommendationList extends GetView<HomeController> {
  const RecommendationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const _RecommendationSkeleton();
      }

      final error = controller.errorMessage.value;
      if (error != null) {
        return SizedBox(
          height: 290,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.loadTables,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        );
      }

      final tables = controller.tables;
      if (tables.isEmpty) {
        return const SizedBox(
          height: 290,
          child: Center(child: Text('No tables available right now')),
        );
      }

      return SizedBox(
        height: 290,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: tables.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          clipBehavior: .none,
          itemBuilder: (_, index) {
            final table = tables[index];
            return RestaurantCard(
              imageUrl: table.imageUrl,
              rating: table.ratingText,
              title: table.title,
              description: table.description,
              price: table.priceText,
            );
          },
        ),
      );
    });
  }
}

class _RecommendationSkeleton extends StatelessWidget {
  const _RecommendationSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: Shimmer.fromColors(
        baseColor: AppColors.divider,
        highlightColor: AppColors.disabledFill,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, _) => const _SkeletonCard(),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  Widget _block(double width, double height, double radius) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(radius),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _block(160, 180, 16),
          const SizedBox(height: 12),
          _block(110, 14, 4),
          const SizedBox(height: 8),
          _block(80, 12, 4),
          const SizedBox(height: 8),
          _block(60, 12, 4),
        ],
      ),
    );
  }
}
