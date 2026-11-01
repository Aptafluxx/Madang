import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

///
/// ```dart
/// CustomCheckbox(value: agreed, label: 'Remember me', onChanged: (v) => setState(() => agreed = v))
/// CustomCheckbox(value: agreed, onChanged: ..., labelWidget: Text.rich(...)) // e.g. terms link
/// ```

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.labelStyle,
    this.enabled = true,
    this.activeColor = AppColors.primary,
    this.borderColor = AppColors.gray,
    this.spacing = 8,
  }) : assert(
         label == null || labelWidget == null,
         'Provide either label or labelWidget, not both',
       );

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final TextStyle? labelStyle;
  final bool enabled;
  final Color activeColor;
  final Color borderColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;
    final hasLabel = label != null || labelWidget != null;

    final box = SizedBox(
      width: 20,
      height: 20,
      child: Checkbox(
        value: value,
        onChanged: isEnabled ? (v) => onChanged!(v ?? false) : null,
        activeColor: activeColor,
        checkColor: AppColors.white,
        side: WidgetStateBorderSide.resolveWith(
          (s) => BorderSide(
            width: 1.5,
            color: s.contains(WidgetState.selected) ? activeColor : borderColor,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isEnabled ? () => onChanged!(!value) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            box,
            if (hasLabel) ...[
              SizedBox(width: spacing),
              Flexible(
                child:
                    labelWidget ??
                    Text(
                      label!,
                      style:
                          labelStyle ??
                          AppTextStyles.body2
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
