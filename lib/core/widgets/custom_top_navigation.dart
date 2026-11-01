import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

/// Top app bar: back arrow + page title, optional cart icon (with badge).
/// Use as `Scaffold(appBar: CustomTopNavigation(...))`.
///
/// ```dart
/// CustomTopNavigation(title: 'Food', showCart: true, cartCount: 2, onCartTap: () => context.push(Routes.cart))
/// CustomTopNavigation(title: 'Orders', bottom: CustomTabBar(tabs: [...]))
/// ```

class CustomTopNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomTopNavigation({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.showCart = false,
    this.onCartTap,
    this.cartCount = 0,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor = AppColors.white,
    this.elevation = 0,
    this.titleStyle,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showCart;
  final VoidCallback? onCartTap;
  final int cartCount;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final TextStyle? titleStyle;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: elevation,
      shadowColor: const Color(0x33000000),
      centerTitle: centerTitle,
      titleSpacing: showBackButton ? 0 : 16,
      leading: showBackButton
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back, size: 24),
              color: AppColors.textPrimary,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            titleStyle ??
            AppTextStyles.subtitle2.copyWith(color: AppColors.textPrimary),
      ),
      actions: [
        ...?actions,
        if (showCart)
          IconButton(
            onPressed: onCartTap,
            color: AppColors.textPrimary,
            tooltip: 'Cart',
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              backgroundColor: AppColors.accent,
              textColor: AppColors.white,
              child: const Icon(Icons.shopping_cart, size: 22),
            ),
          ),
        const SizedBox(width: 8),
      ],
      bottom: bottom,
    );
  }
}
