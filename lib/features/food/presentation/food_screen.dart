import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/core/widgets/custom_chip.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/features/food/data/controllers/food_controller.dart';
import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/food/presentation/widgets/food_card.dart';
import 'package:madang/features/food/presentation/widgets/food_order_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomTopNavigation(
          title: 'Food',
          showCart: true,
          onCartTap: _openCart,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildChips(),
            const SizedBox(height: 20),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomTextField(
        hintText: 'Search food',
        controller: controller.searchTextController,
        prefixIcon: Icons.search,
        textInputAction: TextInputAction.search,
        keyboardType: .text,
        onChanged: controller.onSearchChanged,
        suffixIcon: Icons.cancel,
        onSuffixTap: () => controller.clearFilters(),
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 32,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: FoodController.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 15),
          itemBuilder: (context, index) {
            final category = FoodController.categories[index];
            return CustomChip(
              label: category,
              isSelected: selected == category,
              onTap: () => controller.selectCategory(category),
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
        return EmptyState.food(
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
        itemBuilder: (context, index) {
          final food = foods[index];
          return FoodCard(food: food, onTap: () => _openBooking(context, food));
        },
      );
    });
  }

  Future<void> _openBooking(BuildContext context, FoodModel food) async {
    final booking = await FoodOrderSheet.show(context, food: food);
    if (booking == null || !context.mounted) return;

    AppSnackBar.show(
      context,
      message: 'Food added to cart',
      actionLabel: 'Cart',
      onAction: () => Get.toNamed(AppRoutes.cart),
    );
  }
}

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
