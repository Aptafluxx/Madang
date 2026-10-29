import 'package:flutter/material.dart';
import 'package:madang/presentation/screens/home/widgets/menu_tile.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key, required this.onFoodTap});

  final VoidCallback onFoodTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItemData(icon: Icons.fastfood_outlined, label: 'Food', active: true),
      _MenuItemData(icon: Icons.table_restaurant_outlined, label: 'Table'),
      _MenuItemData(icon: Icons.credit_card_rounded, label: 'Payment'),
      _MenuItemData(icon: Icons.more_horiz_rounded, label: 'More'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Expanded(
            child: MenuTile(
              icon: item.icon,
              label: item.label,
              active: item.active,
              onTap: item.label == 'Food' ? onFoodTap : null,
            ),
          );
        }),
      ),
    );
  }
}

class _MenuItemData {
  const _MenuItemData({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;
}
