import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary10 = Color(0xFFCCEBEB);
  static const Color primary30 = Color(0xFF66BABA);
  static const Color primary50 = Color(0xFF008C8C);
  static const Color primary70 = Color(0xFF007070);
  static const Color primary90 = Color(0xFF004646);
  static const Color primary = primary50;

  static const Color secondary10 = Color(0xFFDBDCE2);
  static const Color secondary30 = Color(0xFF9297A9);
  static const Color secondary50 = Color(0xFF49516F);
  static const Color secondary70 = Color(0xFF3A4159);
  static const Color secondary90 = Color(0xFF252938);
  static const Color secondary = secondary50;

  static const Color accent10 = Color(0xFFF3E5DD);
  static const Color accent30 = Color(0xFFD6A389);
  static const Color accent50 = Color(0xFFC57857);
  static const Color accent70 = Color(0xFF8A563D);
  static const Color accent90 = Color(0xFF633E2C);
  static const Color accent = accent50;

  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFFB3B3B3);
  static const Color white = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFE05252);
  static const Color success = primary70;

  static const Color background = white;
  static const Color surface = white;
  static const Color textPrimary = black;
  static const Color textSecondary = secondary50;
  static const Color hint = gray;
  static const Color border = gray;
  static const Color divider = Color(0xFFE6E6E6);
  static const Color disabled = gray;
  static const Color disabledFill = Color(0xFFF5F5F5);
  static const Color chipBackground = Color(0xFFEFEFEF);
}
