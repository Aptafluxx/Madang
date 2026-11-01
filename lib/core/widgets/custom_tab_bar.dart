import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

/// Pair it with a [TabBarView]. Either pass a [controller] or wrap in a
/// [DefaultTabController].
/// ```dart
/// DefaultTabController(
///   length: 2,
///   child: Column(children: [
///     const CustomTabBar(tabs: ['Ongoing', 'History']),
///     Expanded(child: TabBarView(children: [...])),
///   ]),
/// )
/// ```

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = false,
    this.padding,
    this.height = 48,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.gray,
  });

  final List<String> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Size get preferredSize => Size.fromHeight(height + 2);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: isScrollable,
      tabAlignment: isScrollable ? TabAlignment.start : null,
      padding: padding,
      tabs: [for (final t in tabs) Tab(text: t, height: height)],
      labelColor: activeColor,
      unselectedLabelColor: inactiveColor,
      labelStyle: AppTextStyles.subtitle2,
      unselectedLabelStyle: AppTextStyles.subtitle2,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: activeColor),
      ),
      dividerColor: AppColors.divider,
      dividerHeight: 1,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
