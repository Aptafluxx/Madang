import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

///
/// ```dart
/// CustomRadio<PaymentType>(value: PaymentType.cash, groupValue: _type, label: 'Cash',
///     onChanged: (v) => setState(() => _type = v))
/// ```

class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.labelStyle,
    this.enabled = true,
    this.size = 20,
    this.spacing = 8,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.gray,
  }) : assert(
         label == null || labelWidget == null,
         'Provide either label or labelWidget, not both',
       );

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final TextStyle? labelStyle;
  final bool enabled;
  final double size;
  final double spacing;
  final Color activeColor;
  final Color inactiveColor;
  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;
    final hasLabel = label != null || labelWidget != null;
    final ringColor = _selected ? activeColor : inactiveColor;

    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 2),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: _selected ? size * 0.5 : 0,
        height: _selected ? size * 0.5 : 0,
        decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
      ),
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      enabled: isEnabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isEnabled ? () => onChanged!(value) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              circle,
              if (hasLabel) ...[
                SizedBox(width: spacing),
                Flexible(
                  child:
                      labelWidget ??
                      Text(label!, style: labelStyle ?? AppTextStyles.body2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
