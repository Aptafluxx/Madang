import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/core/widgets/custom_chip.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/features/food/presentation/widgets/food_card.dart';
import 'package:madang/features/food/presentation/widgets/food_order_sheet.dart';
import 'package:madang/features/home/presentation/widgets/restaurant_card.dart';
import 'package:madang/features/search/data/controllers/search_page_controller.dart';
import 'package:madang/features/search/data/models/search_item.dart';
import 'package:madang/features/table/presentation/widgets/table_booking_sheet.dart';
import 'package:shimmer/shimmer.dart';

const _gridPadding = EdgeInsets.fromLTRB(20, 0, 20, 24);
const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  childAspectRatio: 0.74,
);

class SearchScreen extends GetView<SearchPageController> {
  const SearchScreen({super.key});

  void _openCart() => Get.toNamed(AppRoutes.cart);

  Future<void> _openItem(BuildContext context, SearchItem item) async {
    controller.markOpened(item);

    if (item.type == SearchItemType.food) {
      final order = await FoodOrderSheet.show(context, food: item.food!);
      if (order == null || !context.mounted) return;
      AppSnackBar.show(
        context,
        message: 'Added to your order',
        actionLabel: 'Cart',
        onAction: _openCart,
      );
    } else {
      final booking = await TableBookingSheet.show(context, table: item.table!);
      if (booking == null || !context.mounted) return;
      AppSnackBar.show(
        context,
        message: 'Table added to cart',
        actionLabel: 'Cart',
        onAction: _openCart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopNavigation(title: "Search", showBackButton: false),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextField(
                  hintText: 'Search food, table, or something',
                  controller: controller.searchTextController,
                  prefixIcon: Icons.search,
                  textInputAction: TextInputAction.search,
                  suffixIcon: Icons.cancel,
                  onSuffixTap: () => controller.clearAll(),
                  onChanged: controller.onSearchChanged,
                ),
              ),
              _buildActiveChip(),
              const SizedBox(height: 16),
              Expanded(child: Obx(() => _buildBody(context))),
            ],
          ),
        ),
      ),
    );
  }

  /// The teal "Noodle x" chip shown under the field.
  Widget _buildActiveChip() {
    return Obx(() {
      final chip = controller.selectedChip.value;
      if (chip == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomChip(
            label: chip,
            isSelected: true,
            onTap: controller.clearChip,
            onDeleted: controller.clearChip,
          ),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    if (!controller.isSearching) return _buildSuggestions(context);

    if (controller.isLoading.value) return const _SearchSkeleton();

    final error = controller.errorMessage.value;
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadCatalog,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final results = controller.results;
    if (results.isEmpty) {
      return EmptyState.search(onAction: controller.clearAll);
    }

    return GridView.builder(
      padding: _gridPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: _gridDelegate,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return FoodCard(
          food: item.toCardModel(),
          onTap: () => _openItem(context, item),
        );
      },
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final recent = controller.recentItems;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Popular Search'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final term in SearchPageController.popularSearches)
                  CustomChip(
                    label: term,
                    onTap: () => controller.selectPopular(term),
                  ),
              ],
            ),
          ),
          if (recent.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _sectionTitle('Recently Search', padded: false),
                  ),
                  TextButton(
                    onPressed: controller.clearRecent,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 290,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recent.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = recent[index];
                  final card = item.toCardModel();
                  return GestureDetector(
                    onTap: () => _openItem(context, item),
                    child: RestaurantCard(
                      imageUrl: card.imageUrl,
                      rating: card.ratingText,
                      title: card.title,
                      description: card.description,
                      price: card.priceText,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {bool padded = true}) {
    final title = Text(text, style: AppTextStyles.heading5);
    return padded
        ? Padding(padding: const .symmetric(horizontal: 15), child: title)
        : title;
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

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
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.disabledFill,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: _gridPadding,
        gridDelegate: _gridDelegate,
        itemCount: 4,
        itemBuilder: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _block(height: double.infinity, radius: 12)),
            const SizedBox(height: 10),
            _block(width: 110, height: 14),
            const SizedBox(height: 8),
            _block(width: 70, height: 12),
            const SizedBox(height: 8),
            _block(width: 60, height: 14),
          ],
        ),
      ),
    );
  }
}
