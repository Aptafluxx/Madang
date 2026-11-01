import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

abstract final class AppTheme {
  static const double _radius = 8;

  static OutlineInputBorder _inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: color, width: width),
      );

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary50,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary10,
      onPrimaryContainer: AppColors.primary90,
      secondary: AppColors.secondary50,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondary10,
      onSecondaryContainer: AppColors.secondary90,
      tertiary: AppColors.accent50,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.accent10,
      onTertiaryContainer: AppColors.accent90,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.gray,
      outlineVariant: AppColors.divider,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radius),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextTheme.textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
        selectionColor: Color(0x4D008C8C),
      ),

      // ── Top navigation ──
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.subtitle2.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Buttons ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.gray,
          disabledForegroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: shape,
          textStyle: AppTextStyles.subtitle2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.gray,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size.fromHeight(48),
          shape: shape,
          textStyle: AppTextStyles.subtitle2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.subtitle2,
        ),
      ),

      // ── Text input (for plain TextField/TextFormField) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.hint),
        errorStyle: AppTextStyles.body2.copyWith(
          fontSize: 12,
          color: AppColors.error,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.primary, 1.5),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error, 1.5),
        disabledBorder: _inputBorder(AppColors.divider),
        prefixIconColor: WidgetStateColor.resolveWith(_inputIconColor),
        suffixIconColor: WidgetStateColor.resolveWith(_inputIconColor),
      ),

      // ── Selection controls ──
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.white),
        side: WidgetStateBorderSide.resolveWith(
          (s) => BorderSide(
            width: 1.5,
            color: s.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.gray,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.gray,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackground,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.chipBackground,
        checkmarkColor: AppColors.white,
        labelStyle: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
        secondaryLabelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── Snackbar ──
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.secondary50,
        contentTextStyle: AppTextStyles.body2.copyWith(color: AppColors.white),
        shape: shape,
      ),
    );
  }

  static Color _inputIconColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.error)) return AppColors.error;
    if (states.contains(WidgetState.focused)) return AppColors.primary;
    return AppColors.gray;
  }
}
