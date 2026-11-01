import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

enum AppSnackBarType { info, success, error }

/// ```dart
/// AppSnackBar.show(context, message: 'Item added to cart', actionLabel: 'View', onAction: () => context.push(Routes.cart));
/// AppSnackBar.success(context, 'Order placed');
/// AppSnackBar.error(context, 'Payment failed');
/// ```

abstract final class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    AppSnackBarType type = AppSnackBarType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    final Color background;
    final IconData? defaultIcon;
    switch (type) {
      case AppSnackBarType.info:
        background = AppColors.secondary50;
        defaultIcon = null;
      case AppSnackBarType.success:
        background = AppColors.primary70;
        defaultIcon = Icons.check_circle_outline;
      case AppSnackBarType.error:
        background = AppColors.error;
        defaultIcon = Icons.error_outline;
    }
    final leading = icon ?? defaultIcon;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          elevation: 0,
          duration: duration,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
            children: [
              if (leading != null) ...[
                Icon(leading, size: 20, color: AppColors.white),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.body2.copyWith(color: AppColors.white),
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: 12),
                _ActionPill(
                  label: actionLabel,
                  onTap: () {
                    messenger.hideCurrentSnackBar();
                    onAction?.call();
                  },
                ),
              ],
            ],
          ),
        ),
      );
  }

  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: AppSnackBarType.success,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: AppSnackBarType.error,
    actionLabel: actionLabel,
    onAction: onAction,
  );
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
