import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

class BottomNavItem {
  const BottomNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData? activeIcon;
}

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultItems,
    this.backgroundColor = AppColors.white,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.gray,
    this.height = 64,
  });

  static const List<BottomNavItem> defaultItems = [
    BottomNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    BottomNavItem(label: 'Search', icon: Icons.search_rounded),
    BottomNavItem(
      label: 'Recent',
      icon: Icons.access_time_rounded,
      activeIcon: Icons.access_time_filled_rounded,
    ),
    BottomNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    assert(items.length >= 2, 'Provide at least two items');
    assert(
      currentIndex >= 0 && currentIndex < items.length,
      'currentIndex out of range',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: _NavTile(
                    item: items[i],
                    selected: i == currentIndex,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? (item.activeIcon ?? item.icon) : item.icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.body2.copyWith(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
