import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/core/widgets/custom_bottom_navigation.dart';
import 'package:madang/features/home/presentation/home_screen.dart';
import 'package:madang/features/recent/presentation/recent_screen.dart';
import 'package:madang/features/search/presentation/search_screen.dart';
import 'package:madang/presentation/screens/profile/profile_screen.dart';

import '../data/controllers/main_controller.dart';

class MainShellScreen extends GetView<MainController> {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.currentIndex.value;

      return PopScope(
        canPop: index == MainTab.home.index,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.changeTab(MainTab.home.index);
        },
        child: Scaffold(
          body: IndexedStack(
            index: index,
            children: const [
              HomeScreen(),
              SearchScreen(),
              RecentScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: index,
            onTap: controller.changeTab,
          ),
        ),
      );
    });
  }
}
