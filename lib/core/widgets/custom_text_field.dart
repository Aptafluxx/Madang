import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_theme.dart';

/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hintText: 'you@example.com',
///   controller: _email,
///   prefixIcon: Icons.mail_outline,
///   keyboardType: TextInputType.emailAddress,
///   validator: Validators.email,
/// )
/// CustomTextField(hintText: 'Password', isPassword: true, prefixIcon: Icons.lock_outline)
/// ```
/// Works inside a [Form] (it wraps a [TextFormField]).

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.label,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
    this.contentPadding,
    this.fillColor,
    this.borderRadius = 8,
  });

  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final double borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static Color _iconColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.error)) return AppColors.error;
    if (states.contains(WidgetState.focused)) return AppColors.primary;
    return AppColors.gray;
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        color: AppColors.gray,
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
        ),
      );
    }
    if (widget.suffixIcon == null) return null;
    if (widget.onSuffixTap != null) {
      return IconButton(
        onPressed: widget.onSuffixTap,
        color: AppColors.gray,
        icon: Icon(widget.suffixIcon, size: 20),
      );
    }
    return Icon(widget.suffixIcon, size: 20);
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.onTap,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.isPassword ? null : widget.minLines,
      maxLength: widget.maxLength,
      autofillHints: widget.autofillHints,
      cursorColor: AppColors.primary,
      style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.hint),
        helperText: widget.helperText,
        helperStyle: AppTextStyles.body2.copyWith(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        errorText: widget.errorText,
        errorStyle: AppTextStyles.body2.copyWith(
          fontSize: 12,
          color: AppColors.error,
        ),
        filled: true,
        fillColor: widget.enabled
            ? (widget.fillColor ?? AppColors.white)
            : AppColors.disabledFill,
        isDense: true,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 20),
        suffixIcon: _buildSuffix(),
        prefixIconColor: WidgetStateColor.resolveWith(_iconColor),
        suffixIconColor: WidgetStateColor.resolveWith(_iconColor),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, 1.5),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, 1.5),
        disabledBorder: _border(AppColors.divider),
      ),
    );

    if (widget.label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label!, style: AppTextStyles.body1),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
