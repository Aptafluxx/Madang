import 'package:flutter/material.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTopNavigation(title: "Recent", showBackButton: false),
            const Expanded(child: Center(child: Text('No recent activity'))),
          ],
        ),
      ),
    );
  }
}
