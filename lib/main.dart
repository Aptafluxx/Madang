import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_theme.dart';
import 'package:madang/presentation/app_shell.dart';

void main() {
  runApp(const MadangApp());
}

class MadangApp extends StatelessWidget {
  const MadangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madang Restaurant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
