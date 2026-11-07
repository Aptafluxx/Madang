import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/core/widgets/quantity_selector.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/cart/data/controllers/cart_controller.dart';
import 'package:madang/features/cart/data/models/cart_model.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  void _showUndo(BuildContext context, String message) {
    AppSnackBar.show(
      context,
      message: message,
      actionLabel: 'Undo',
      onAction: controller.undoRemove,
    );
  }

  void _removeFood(BuildContext context, String id) {
    if (controller.removeFood(id)) _showUndo(context, 'Food deleted');
  }

  void _removeTable(BuildContext context) {
    if (controller.removeTable()) _showUndo(context, 'Table removed');
  }

  void _onContinue() {
    // TODO: open the payment method page when it exists.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomTopNavigation(title: 'Detail Cart'),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return const SizedBox.shrink();

          if (controller.isEmpty) {
            return EmptyState.cart(
              title: 'Well, there is no item in your cart :(',
              message: null,
              actionLabel: 'Find Item',
              onAction: () => Get.toNamed(AppRoutes.food),
            );
          }
          return _buildContent(context);
        }),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.isEmpty) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          top: false,
          child: Material(
            color: AppColors.white,
            child: _CheckoutBar(
              totalText: controller.totalText,
              onContinue: _onContinue,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final foods = controller.foods;
    final table = controller.table.value;
    final additions = controller.additions;

    // Rows of the "Total" section
    final totalRows = <_PriceRow>[
      if (foods.isNotEmpty)
        _PriceRow(label: 'Food', price: controller.foodTotalText),
      if (table != null)
        _PriceRow(label: 'Table', price: controller.tableTotalText),
      for (final a in additions)
        if (a.unitPrice > 0) _PriceRow(label: a.name, price: a.totalText),
      if (CartController.taxRate > 0)
        _PriceRow(label: 'Tax', price: controller.taxText),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const _SectionTitle('Food'),
          const SizedBox(height: 15),
          for (final food in foods)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey('food_${food.id}'),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removeFood(context, food.id),
                background: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.only(right: 24),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                child: _FoodRow(
                  item: food,
                  onQuantityChanged: (q) =>
                      controller.updateFoodQuantity(food.id, q),
                ),
              ),
            ),
          Center(
            child: TextButton(
              onPressed: () => Get.toNamed(AppRoutes.food),
              child: Text(
                foods.isEmpty ? 'Add food' : 'Add more food',
                style: AppTextStyles.subtitle2.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _SectionTitle('Table'),
          const SizedBox(height: 15),
          if (table != null)
            _TableRow(table: table, onDelete: () => _removeTable(context))
          else
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.table),
                child: Text(
                  'Add table',
                  style: AppTextStyles.subtitle2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          if (additions.isNotEmpty) ...[
            const SizedBox(height: 30),
            const _SectionTitle('Additional'),
            const SizedBox(height: 15),
            for (final a in additions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PriceRow(label: a.label, price: a.totalText),
              ),
          ],
          const SizedBox(height: 17),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 15),
          const _SectionTitle('Total'),
          const SizedBox(height: 16),
          for (final row in totalRows)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: row),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(title, style: AppTextStyles.subtitle1),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: AppColors.black.withValues(alpha: 0.1),
      spreadRadius: 2,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

class _Thumb extends StatelessWidget {
  const _Thumb(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.chipBackground,
      child: const Icon(Icons.restaurant, color: AppColors.gray),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        height: 64,
        child: imageUrl.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 200,
                placeholder: (_, _) => const ShimmerBox(),
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({required this.item, required this.onQuantityChanged});

  final CartFoodItem item;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _Thumb(item.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle2,
                  ),
                  Text(item.priceText, style: AppTextStyles.subtitle2),
                ],
              ),
            ),
            QuantitySelector(
              value: item.quantity,
              min: 1,
              max: CartController.maxFoodQuantity,
              onChanged: onQuantityChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.table, required this.onDelete});

  final CartTableItem table;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _Thumb(table.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    table.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle2,
                  ),
                  Text(
                    table.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body2,
                  ),
                  if (table.duration.isNotEmpty)
                    Text(
                      table.duration,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              tooltip: 'Remove table',
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.gray,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.price});

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.subtitle2),
          Text(price, style: AppTextStyles.subtitle2),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.totalText, required this.onContinue});

  final String totalText;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Total: ',
              style: AppTextStyles.subtitle1,
              children: [
                TextSpan(text: totalText, style: AppTextStyles.title2),
              ],
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(label: 'Continue', onPressed: onContinue),
        ],
      ),
    );
  }
}
