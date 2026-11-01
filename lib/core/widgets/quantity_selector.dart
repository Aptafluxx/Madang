import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.step = 1,
    this.buttonSize = 24,
    this.enabled = true,
  }) : assert(min <= max, 'min must be <= max');

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final double buttonSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canDecrease = enabled && value > min;
    final canIncrease = enabled && value < max;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundButton(
          icon: Icons.remove,
          size: buttonSize,
          enabled: canDecrease,
          semanticLabel: 'Decrease quantity',
          onTap: () => onChanged(math.max(min, value - step)),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 36),
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        _RoundButton(
          icon: Icons.add,
          size: buttonSize,
          enabled: canIncrease,
          semanticLabel: 'Increase quantity',
          onTap: () => onChanged(math.min(max, value + step)),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.size,
    required this.enabled,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: enabled ? AppColors.primary : AppColors.gray,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: size * 0.65, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
