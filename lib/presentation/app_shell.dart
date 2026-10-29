import 'package:flutter/material.dart';
import 'package:madang/presentation/screens/home/home_screen.dart';
import 'package:madang/presentation/screens/search/search_screen.dart';
import 'package:madang/presentation/screens/profile/profile_screen.dart';
import 'package:madang/presentation/screens/food/food_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  void _onNavigationTap(int index) {
    if (index == 0 || index == 1 || index == 3) {
      setState(() => selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 1:
        return SearchScreen(onNavigationTap: _onNavigationTap);
      case 3:
        return ProfileScreen(onNavigationTap: _onNavigationTap);
      case 4:
        return FoodScreen(onBack: () => setState(() => selectedIndex = 0));
      default:
        return HomeScreen(
          onNavigationTap: _onNavigationTap,
          onFoodTap: () => setState(() => selectedIndex = 4),
        );
    }
  }
}
