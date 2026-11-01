import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';
import 'custom_button.dart';

/// ```dart
/// EmptyState(
///   title: 'Your cart is empty',
///   message: 'Add something delicious.',
///   icon: Icons.shopping_bag_outlined,
///   actionLabel: 'Browse food',
///   onAction: () => context.go(Routes.home),
/// )
/// ```

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.restaurant_menu_rounded,
    this.iconSize = 120,
    this.iconColor = AppColors.primary,
    this.imageAsset,
    this.imageHeight = 160,
    this.illustration,
    this.actionLabel,
    this.onAction,
    this.actionVariant = CustomButtonVariant.primary,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.padding = const EdgeInsets.all(24),
    this.graphicSpacing = 32,
    this.messageSpacing = 8,
    this.actionSpacing = 32,
    this.titleStyle,
    this.messageStyle,
    this.textAlign = TextAlign.center,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final String? imageAsset;
  final double imageHeight;
  final Widget? illustration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final CustomButtonVariant actionVariant;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final EdgeInsetsGeometry padding;
  final double graphicSpacing;
  final double messageSpacing;
  final double actionSpacing;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final TextAlign textAlign;
  factory EmptyState.search({
    Key? key,
    String title = 'Well, there is no result you are looking for :(',
    String actionLabel = 'Find Other',
    VoidCallback? onAction,
  }) => EmptyState(
    key: key,
    title: title,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Cart → no items.
  factory EmptyState.cart({
    Key? key,
    String title = 'Your cart is empty',
    String? message = 'Looks like you haven\'t added anything yet.',
    String actionLabel = 'Browse Food',
    VoidCallback? onAction,
  }) => EmptyState(
    key: key,
    title: title,
    message: message,
    icon: Icons.shopping_bag_outlined,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Food list → nothing available.
  factory EmptyState.food({
    Key? key,
    String title = 'No food available right now',
    String? message,
    String actionLabel = 'Back to Home',
    VoidCallback? onAction,
  }) => EmptyState(
    key: key,
    title: title,
    message: message,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Table list → nothing available.
  factory EmptyState.table({
    Key? key,
    String title = 'No tables available right now',
    String? message,
    String actionLabel = 'Back to Home',
    VoidCallback? onAction,
  }) => EmptyState(
    key: key,
    title: title,
    message: message,
    icon: Icons.table_restaurant_outlined,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  Widget? _buildGraphic() {
    if (illustration != null) return illustration;
    if (imageAsset != null) {
      return Image.asset(imageAsset!, height: imageHeight, fit: BoxFit.contain);
    }
    if (icon != null) return Icon(icon, size: iconSize, color: iconColor);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final graphic = _buildGraphic();

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (graphic != null) ...[
              Center(child: ExcludeSemantics(child: graphic)),
              SizedBox(height: graphicSpacing),
            ],
            Text(
              title,
              textAlign: textAlign,
              style:
                  titleStyle ??
                  AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
            ),
            if (message != null) ...[
              SizedBox(height: messageSpacing),
              Text(
                message!,
                textAlign: textAlign,
                style:
                    messageStyle ??
                    AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
            if (actionLabel != null) ...[
              SizedBox(height: actionSpacing),
              CustomButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: actionVariant,
              ),
            ],
            if (secondaryActionLabel != null) ...[
              const SizedBox(height: 12),
              CustomButton(
                label: secondaryActionLabel!,
                onPressed: onSecondaryAction,
                variant: CustomButtonVariant.outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
