import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_pages.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_theme.dart';
import 'package:madang/core/services/preferences_service.dart';

void main() async {
  await Get.putAsync(() => PreferencesService().init());
  runApp(const MadangApp());
}

class MadangApp extends StatelessWidget {
  const MadangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Madang Restaurant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
