import 'package:flutter/material.dart';
import 'package:madang/features/home/presentation/widgets/menu_tile.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({
    super.key,
    required this.onFoodTap,
    required this.onTableTap,
    required this.onPaymentTap,
    required this.onMoreTap,
  });

  final VoidCallback onFoodTap;
  final VoidCallback onTableTap;
  final VoidCallback onPaymentTap;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final items = const [
      _MenuItemData(icon: Icons.fastfood_outlined, label: 'Food'),
      _MenuItemData(icon: Icons.table_restaurant_outlined, label: 'Table'),
      _MenuItemData(icon: Icons.credit_card_rounded, label: 'Payment'),
      _MenuItemData(icon: Icons.more_horiz_rounded, label: 'More'),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Expanded(
          child: MenuTile(
            icon: item.icon,
            label: item.label,
            onTap: switch (item.label) {
              'Food' => onFoodTap,
              'Table' => onTableTap,
              'Payment' => onPaymentTap,
              'More' => onMoreTap,
              _ => () {},
            },
          ),
        );
      }),
    );
  }
}

class _MenuItemData {
  const _MenuItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
