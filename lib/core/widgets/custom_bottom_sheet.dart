import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';

/// Reusable bottom sheet: drag handle, optional full-width header (e.g. an
/// image), optional title, scrollable body, optional pinned action button.
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
    this.header,
    this.showDragHandle = true,
    this.dragHandleColor = AppColors.gray,
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
  final Widget? header;
  final bool showDragHandle;
  final Color dragHandleColor;
  final bool showCloseButton;
  final VoidCallback? onClose;
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
    Widget? header,
    bool showDragHandle = true,
    Color dragHandleColor = AppColors.gray,
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
      isDismissible: true,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomBottomSheet(
        title: title,
        titleStyle: titleStyle,
        header: header,
        showDragHandle: showDragHandle,
        dragHandleColor: dragHandleColor,
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

    final handle = Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: dragHandleColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final content = Column(
      mainAxisSize: fixedHeight == null ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null)
          Stack(
            fit: StackFit.passthrough,
            children: [
              header!,
              if (showDragHandle)
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(child: handle),
                ),
            ],
          )
        else if (showDragHandle)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: Center(child: handle),
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
                    style:
                        titleStyle ??
                        AppTextStyles.title2.copyWith(
                          color: AppColors.textPrimary,
                        ),
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
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(top: false, child: content),
            ),
          ),
        ),
      ),
    );
  }
}
