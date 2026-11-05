import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/features/food/data/controllers/food_controller.dart';
import 'package:madang/features/food/presentation/widgets/food_card.dart';
import 'package:shimmer/shimmer.dart';

const _gridPadding = EdgeInsets.fromLTRB(20, 0, 20, 24);
const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  childAspectRatio: 0.74,
);

class FoodScreen extends GetView<FoodController> {
  const FoodScreen({super.key});

  void _openCart() => Get.toNamed(AppRoutes.cart);

  // void _openDetail(FoodModel food) =>
  //     Get.toNamed(AppRoutes.foodDetailPath(food.id), arguments: food);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomTopNavigation(
        title: 'Food',
        showCart: true,
        onCartTap: _openCart,
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSearchField(),
          const SizedBox(height: 16),
          _buildChips(),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomTextField(
        hintText: 'Search food',
        controller: controller.searchTextController,
        prefixIcon: Icons.search,
        textInputAction: TextInputAction.search,
        onChanged: controller.onSearchChanged,
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 32,
      child: Obx(() {
        // Read the Rx value here, outside itemBuilder, so Obx can track it.
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: FoodController.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final category = FoodController.categories[index];
            return ChoiceChip(
              label: Text(category),
              selected: selected == category,
              onSelected: (_) => controller.selectCategory(category),
              side: BorderSide.none,
              backgroundColor: const Color(0xFFF3F1F1),
              selectedColor: const Color(0xFFDCEBEC),
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              labelStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.6,
              ),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
            );
          },
        );
      }),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isLoading.value) return const _FoodGridSkeleton();

      final error = controller.errorMessage.value;
      if (error != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.loadFoods,
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      }

      final foods = controller.foods;
      if (foods.isEmpty) {
        return EmptyState.search(
          title: 'Well, there is no food you are looking for :(',
          actionLabel: 'Find Other Food',
          onAction: controller.clearFilters,
        );
      }

      return GridView.builder(
        padding: _gridPadding,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: _gridDelegate,
        itemCount: foods.length,
        itemBuilder: (_, index) {
          final food = foods[index];
          return FoodCard(food: food, onTap: () {});
          // return FoodCard(food: food, onTap: () => _openDetail(food));
        },
      );
    });
  }
}

/// Shimmering placeholder cards shown while food loads.
class _FoodGridSkeleton extends StatelessWidget {
  const _FoodGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.disabledFill,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: _gridPadding,
        gridDelegate: _gridDelegate,
        itemCount: 6,
        itemBuilder: (_, _) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  Widget _block({double? width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _block(width: 110, height: 14),
        const SizedBox(height: 8),
        _block(width: 70, height: 12),
        const SizedBox(height: 8),
        _block(width: 60, height: 14),
      ],
    );
  }
}
