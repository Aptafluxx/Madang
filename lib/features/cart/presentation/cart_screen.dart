import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/quantity_selector.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopNavigation(title: "Detail Cart"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const _SectionTitle('Food'),
              const SizedBox(height: 15),
              _FoodRow(
                quantity: 1,
                onQuantityChanged: (value) {},
                // onQuantityChanged: (value) =>
                //     setState(() => _quantity = value),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Add more food',
                    style: AppTextStyles.subtitle2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const _SectionTitle('Table'),
              const SizedBox(height: 15),
              const _TableRow(),
              const SizedBox(height: 30),
              const _SectionTitle('Additional'),
              const SizedBox(height: 15),
              const _PriceRow(label: '1 x Flower', price: 'Rp25.000'),
              const SizedBox(height: 25),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 15),
              const _SectionTitle('Total'),
              const SizedBox(height: 16),
              const _PriceRow(label: 'Food', price: 'Rp136.000'),
              const SizedBox(height: 8),
              const _PriceRow(label: 'Table', price: 'Rp0'),
              const SizedBox(height: 8),
              const _PriceRow(label: 'Flower', price: 'Rp25.000'),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: Material(color: AppColors.white, child: _CheckoutBar()),
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
      padding: const .symmetric(horizontal: 15),
      child: Text(title, style: AppTextStyles.subtitle1),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({required this.quantity, required this.onQuantityChanged});

  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(6),
            //   child: Image.asset(
            //     'assets/figma/food_noodle.png',
            //     width: 80,
            //     height: 80,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(width: 24),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Noodle Ex', style: AppTextStyles.subtitle2),
                  Text('Rp42.000', style: AppTextStyles.subtitle2),
                ],
              ),
            ),
            QuantitySelector(value: quantity, onChanged: onQuantityChanged),
          ],
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(6),
            //   child: Image.asset(
            //     'assets/figma/table_work.png',
            //     width: 80,
            //     height: 80,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(width: 24),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Work Table', style: AppTextStyles.subtitle2),
                Text('1 table 1 chair', style: AppTextStyles.body2),
              ],
            ),
            const Spacer(),
            Icon(Icons.delete_outline, color: AppColors.gray, size: 20),
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
  const _CheckoutBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: .circular(24),
          topRight: .circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Total: ',
              style: AppTextStyles.subtitle1,
              children: [
                TextSpan(text: 'Rp171.000', style: AppTextStyles.title2),
              ],
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(label: "Continue", onPressed: () {}),
        ],
      ),
    );
  }
}
