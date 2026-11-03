import 'package:flutter/material.dart';
import 'package:madang/features/home/presentation/widgets/bottom_navigation.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key, required this.onNavigationTap});

  final ValueChanged<int> onNavigationTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text(
                'Recent',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const Expanded(child: Center(child: Text('No recent activity'))),
            BottomNavigation(selectedIndex: 2, onTap: onNavigationTap),
          ],
        ),
      ),
    );
  }
}
