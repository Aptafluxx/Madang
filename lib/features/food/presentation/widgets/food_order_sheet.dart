import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_bottom_sheet.dart';
import 'package:madang/core/widgets/quantity_selector.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/food/data/models/food_model.dart';

final NumberFormat _money = NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
);

class FoodOrder {
  const FoodOrder({
    required this.food,
    required this.quantity,
    required this.total,
  });

  final FoodModel food;
  final int quantity;
  final num total;
}

/// Opens the food sheet (photo, name, rating, quantity, price, button).
/// Returns the order, or null if the user closed the sheet.
///
/// ```dart
/// final order = await FoodOrderSheet.show(context, food: food);
/// ```

class FoodOrderSheet {
  const FoodOrderSheet._();

  static const int maxQuantity = 20;

  static Future<FoodOrder?> show(
    BuildContext context, {
    required FoodModel food,
  }) {
    final quantity = 1.obs;

    return CustomBottomSheet.show<FoodOrder>(
      context,
      header: _FoodImage(imageUrl: food.imageUrl),
      dragHandleColor: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: _FoodDetails(food: food, quantity: quantity),
      actionLabel: 'Add to cart',
      onAction: () => Navigator.of(context).pop(
        FoodOrder(
          food: food,
          quantity: quantity.value,
          total: food.price * quantity.value,
        ),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  const _FoodImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.chipBackground,
      child: const Icon(Icons.restaurant, color: AppColors.gray, size: 64),
    );

    return AspectRatio(
      aspectRatio: 1.2,
      child: imageUrl.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              memCacheWidth: 1000,
              placeholder: (_, _) => const ShimmerBox(),
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}

class _FoodDetails extends StatelessWidget {
  const _FoodDetails({required this.food, required this.quantity});

  final FoodModel food;
  final RxInt quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title2.copyWith(
                      fontSize: 18,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Stars(rating: food.rating, ratingText: food.ratingText),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => QuantitySelector(
                value: quantity.value,
                min: 1,
                max: FoodOrderSheet.maxQuantity,
                onChanged: (value) => quantity.value = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => Text(
            _money.format(food.price * quantity.value),
            style: AppTextStyles.heading4.copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, required this.ratingText});

  final num rating;
  final String ratingText;

  @override
  Widget build(BuildContext context) {
    final filled = rating.round().clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < filled ? Icons.star : Icons.star_border,
            size: 20,
            color: AppColors.accent,
          ),
        const SizedBox(width: 8),
        Text(
          ratingText,
          style: AppTextStyles.body2.copyWith(
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
