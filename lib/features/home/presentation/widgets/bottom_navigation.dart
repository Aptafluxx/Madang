import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/features/home/presentation/widgets/bottom_nav_icon.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, this.selectedIndex = 0, this.onTap});

  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(icon: Icons.home_rounded, label: 'Home'),
      _NavItemData(icon: Icons.search_rounded, label: 'Search'),
      _NavItemData(icon: Icons.refresh_rounded, label: 'Recent'),
      _NavItemData(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      width: double.infinity,
      padding: const .symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            offset: Offset(0, -8),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap?.call(index),
            behavior: HitTestBehavior.opaque,
            child: BottomNavIcon(
              icon: item.icon,
              label: item.label,
              active: selectedIndex == index,
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
