import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/bindings/app_binding.dart';
import 'package:madang/app/routes/app_pages.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_theme.dart';
import 'package:madang/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppBinding.initialize();
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
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(body: Center(child: Text('Page not found'))),
      ),
    );
  }
}
