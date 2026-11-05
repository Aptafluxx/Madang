import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';

/// Reusable bottom sheet: drag handle, optional title, scrollable body,
/// optional pinned action button.
///
/// Open it with [CustomBottomSheet.show]:
/// ```dart
/// final saved = await CustomBottomSheet.show<bool>(
///   context,
///   title: 'Time',
///   child: MyContent(),
///   actionLabel: 'Booking table',
///   onAction: () => Navigator.of(context).pop(true),
/// );
/// ```

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.titleStyle,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.onClose,
    this.actionLabel,
    this.onAction,
    this.isActionLoading = false,
    this.footer,
    this.height,
    this.maxHeightFactor = 0.9,
    this.isScrollable = true,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.backgroundColor = AppColors.white,
    this.borderRadius = 30,
  });

  final Widget child;
  final String? title;
  final TextStyle? titleStyle;
  final bool showDragHandle;
  final bool showCloseButton;
  final VoidCallback? onClose;

  /// Pinned primary button at the bottom (e.g. "Booking table").
  /// Hidden when null. A null [onAction] shows it disabled.
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isActionLoading;
  final Widget? footer;
  final double? height;
  final double maxHeightFactor;
  final bool isScrollable;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double borderRadius;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    TextStyle? titleStyle,
    bool showDragHandle = true,
    bool showCloseButton = false,
    VoidCallback? onClose,
    String? actionLabel,
    VoidCallback? onAction,
    bool isActionLoading = false,
    Widget? footer,
    double? height,
    double maxHeightFactor = 0.9,
    bool isScrollable = true,
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    Color backgroundColor = AppColors.white,
    double borderRadius = 30,
    bool isDismissible = true,
    bool enableDrag = true,
    Color barrierColor = const Color(0x4D000000),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomBottomSheet(
        title: title,
        titleStyle: titleStyle,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        onClose: onClose,
        actionLabel: actionLabel,
        onAction: onAction,
        isActionLoading: isActionLoading,
        footer: footer,
        height: height,
        maxHeightFactor: maxHeightFactor,
        isScrollable: isScrollable,
        padding: padding,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final maxHeight = (media.size.height - keyboard) * maxHeightFactor;
    final fixedHeight = height == null ? null : math.min(height!, maxHeight);

    final hasTitleRow = title != null || showCloseButton;
    final sidePadding = EdgeInsets.only(
      left: padding.left,
      right: padding.right,
    );

    final body = isScrollable
        ? SingleChildScrollView(padding: padding, child: child)
        : Padding(padding: padding, child: child);

    final content = Column(
      mainAxisSize: fixedHeight == null ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Drag handle
        if (showDragHandle)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 20),

        // Title row
        if (hasTitleRow)
          Padding(
            padding: sidePadding.copyWith(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: titleStyle ?? AppTextStyles.title2,
                  ),
                ),
                if (showCloseButton)
                  IconButton(
                    onPressed:
                        onClose ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
              ],
            ),
          ),

        // Body
        if (fixedHeight == null)
          Flexible(child: body)
        else
          Expanded(child: body),

        // Footer: your widget, or the action button
        if (footer != null)
          footer!
        else if (actionLabel != null)
          Padding(
            padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 20),
            child: CustomButton(
              label: actionLabel!,
              onPressed: onAction,
              isLoading: isActionLoading,
            ),
          ),
      ],
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedPadding(
        // Lifts the sheet above the keyboard.
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.only(bottom: keyboard),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            width: double.infinity,
            height: fixedHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            child: SafeArea(top: false, child: content),
          ),
        ),
      ),
    );
  }
}
