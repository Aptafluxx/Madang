import 'package:flutter/material.dart';
import 'package:madang/presentation/screens/home/widgets/restaurant_card.dart';

class RecommendationList extends StatelessWidget {
  const RecommendationList({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      RestaurantCard(
        imageUrl: 'https://www.figma.com/api/mcp/asset/681482b4-7d25-4e0a-98c9-5aa879f1debf/57354.png',
        rating: '4.7',
        title: 'Family Package',
        description: '1 large table 6 chair',
        price: 'Rp320.000',
      ),
      RestaurantCard(
        imageUrl: 'https://www.figma.com/api/mcp/asset/681482b4-7d25-4e0a-98c9-5aa879f1debf/761ee.png',
        rating: '4.9',
        title: 'Single Breakfast',
        description: '1 table 1 chair',
        price: 'Rp70.000',
      ),
      RestaurantCard(
        imageUrl: 'https://www.figma.com/api/mcp/asset/681482b4-7d25-4e0a-98c9-5aa879f1debf/be31a.png',
        rating: '4.9',
        title: 'Date Package',
        description: '1 table 2 chair',
        price: 'Rp135.000',
      ),
    ];

    return SizedBox(
      height: 295,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, index) => cards[index],
      ),
    );
  }
}
