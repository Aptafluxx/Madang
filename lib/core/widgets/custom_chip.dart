import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

///
/// ```dart
/// CustomChip(label: 'Burger', isSelected: sel == 'Burger', onTap: () => setState(() => sel = 'Burger'))
/// CustomChip(label: 'Spicy', isSelected: true, onDeleted: () => remove('Spicy'))
/// ```

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onDeleted,
    this.leadingIcon,
    this.showCloseWhenSelected = true,
    this.height = 32,
    this.selectedColor = AppColors.primary,
    this.unselectedColor = AppColors.chipBackground,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final IconData? leadingIcon;
  final bool showCloseWhenSelected;
  final double height;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? AppColors.white : AppColors.textPrimary;

    return Material(
      color: isSelected ? selectedColor : unselectedColor,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 16, color: fg),
                  const SizedBox(width: 4),
                ],
                Text(label, style: AppTextStyles.body2.copyWith(color: fg)),
                if (isSelected && showCloseWhenSelected) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDeleted ?? onTap,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 10, color: selectedColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
