import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madang/presentation/screens/home/widgets/navigation/bottom_navigation.dart';
import 'package:madang/presentation/screens/home/widgets/restaurant_card.dart';

class SearchScreen extends StatefulWidget {
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
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController(
    text: '',
  );
  String _activeSearchChip = 'Noodle';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final hasMeatballResult = query.contains('meat') || query.contains('ball');
    final hasNoodleResult =
        query.contains('noodle') ||
        (query.isEmpty && _activeSearchChip == 'Noodle');

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
                        _SearchField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        if (_activeSearchChip.isNotEmpty)
                          _SearchFilterChip(
                            label: _activeSearchChip,
                            onClear: () =>
                                setState(() => _activeSearchChip = ''),
                          ),
                        if (hasNoodleResult && query.isNotEmpty ||
                            query.isEmpty && hasNoodleResult)
                          const _NoodleResultCard()
                        else if (query.isNotEmpty && hasMeatballResult)
                          const _MeatballResultCard()
                        else if (query.isEmpty)
                          const _DefaultSearchContent()
                        else if (query.isNotEmpty)
                          _SearchEmptyResult(
                            onFindOther: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                BottomNavigation(
                  selectedIndex: 1,
                  onTap: widget.onNavigationTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFilterChip extends StatelessWidget {
  const _SearchFilterChip({required this.label, required this.onClear});

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClear,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF008C8C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.cancel, size: 12, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB3B3B3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
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

class _MeatballResultCard extends StatelessWidget {
  const _MeatballResultCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 1),
            blurRadius: 5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/figma/food_meatball.png',
            width: 174,
            height: 160,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meatball Sweatie',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB3B3B3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rp63.500',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoodleResultCard extends StatelessWidget {
  const _NoodleResultCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 1),
            blurRadius: 5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/figma/food_noodle.png',
            width: 174,
            height: 160,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Noodle Ex',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB3B3B3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rp42.000',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultSearchContent extends StatelessWidget {
  const _DefaultSearchContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

class _SearchEmptyResult extends StatelessWidget {
  const _SearchEmptyResult({required this.onFindOther});

  final VoidCallback onFindOther;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        SvgPicture.asset(
          'assets/figma/search_empty_restaurant.svg',
          width: 160,
          height: 160,
        ),
        const SizedBox(height: 16),
        const Text(
          'Well, there is no result you are looking for :(',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onFindOther,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008C8C),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Find Other',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
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
