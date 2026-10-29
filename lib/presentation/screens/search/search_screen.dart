import 'package:flutter/material.dart';
import 'package:madang/presentation/screens/home/widgets/navigation/bottom_navigation.dart';
import 'package:madang/presentation/screens/home/widgets/restaurant_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.onNavigationTap});

  final ValueChanged<int> onNavigationTap;

  static const popularSearches = <String>[
    'Duo Table',
    'Noodle',
    'Chicken',
    'Fried Rice',
    'Meat',
    'Family',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 411,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Search',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        const _SearchField(),
                        const SizedBox(height: 24),
                        Text(
                          'Popular Search',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        const _PopularSearchChips(),
                        const SizedBox(height: 24),
                        Text(
                          'Recently Search',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        const Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            RestaurantCard(
                              imageUrl: 'https://www.figma.com/api/mcp/asset/7a0be8b2-25fc-4ba0-9a53-e72658417db4/57354.png',
                              rating: '4.7',
                              title: 'Family Package',
                              description: '1 large table 6 chair',
                              price: 'Rp320.000',
                            ),
                            RestaurantCard(
                              imageUrl: 'https://www.figma.com/api/mcp/asset/7a0be8b2-25fc-4ba0-9a53-e72658417db4/be31a.png',
                              rating: '4.9',
                              title: 'Date Package',
                              description: '1 table 2 chair',
                              price: 'Rp135.000',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                BottomNavigation(selectedIndex: 1, onTap: onNavigationTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB3B3B3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFFB3B3B3)),
          hintText: 'Search food, table, or something',
          hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B3B3)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _PopularSearchChips extends StatelessWidget {
  const _PopularSearchChips();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: SearchScreen.popularSearches
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F1F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          )
          .toList(),
    );
  }
}
