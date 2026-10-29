import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String selectedCategory = '';
  bool showFoodDetails = false;
  bool showOrderConfirmation = false;
  bool hasPlacedOrder = false;
  String searchQuery = 'Pizza';
  late final TextEditingController searchController;

  final categories = const [
    'Dinner Food',
    'Economic Food',
    'Hot Food',
    'Family Food',
    'Super Food',
  ];

  final foods = const [
    _FoodData(
      'Meatball Sweatie',
      '4.9',
      'Rp63.500',
      'assets/figma/food_meatball.png',
    ),
    _FoodData('Noodle Ex', '4.8', 'Rp42.000', 'assets/figma/food_noodle.png'),
    _FoodData(
      'Burger Ala Ala',
      '4.7',
      'Rp55.500',
      'assets/figma/food_burger.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: searchQuery);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleFoods = foods.where((food) {
      return food.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 411,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      key: const ValueKey('food-header'),
                      child: _FoodHeader(
                        onBack: widget.onBack,
                        showCartBadge: hasPlacedOrder,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: const ValueKey('food-search'),
                      child: _SearchField(
                        theme: theme,
                        controller: searchController,
                        onChanged: (value) =>
                            setState(() => searchQuery = value.trim()),
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: const ValueKey('food-categories'),
                      child: _CategoryList(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onSelected: (category) =>
                            setState(() => selectedCategory = category),
                      ),
                    ),
                    if (visibleFoods.isEmpty)
                      SliverToBoxAdapter(
                        key: const ValueKey('food-empty-result'),
                        child: _EmptyFoodResult(
                          onFindOtherFood: () {
                            searchController.clear();
                            setState(() => searchQuery = '');
                          },
                        ),
                      )
                    else
                      SliverPadding(
                        key: const ValueKey('food-results'),
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _FoodCard(
                              key: ValueKey(
                                'food-card-${visibleFoods[index].name}',
                              ),
                              food: visibleFoods[index],
                              showRatingBadge: searchQuery.isEmpty,
                              onTap: () =>
                                  setState(() => showFoodDetails = true),
                            ),
                            childCount: visibleFoods.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 18,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 252,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (showFoodDetails)
              _FoodDetailsSheet(
                onDismiss: () => setState(() => showFoodDetails = false),
                onPlaced: () => setState(() {
                  showFoodDetails = false;
                  showOrderConfirmation = true;
                  hasPlacedOrder = true;
                }),
              ),
            if (showOrderConfirmation)
              const Align(
                alignment: Alignment.bottomCenter,
                child: _OrderConfirmationPopup(),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFoodResult extends StatelessWidget {
  const _EmptyFoodResult({required this.onFindOtherFood});

  final VoidCallback onFindOtherFood;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/figma/food_empty_restaurant.svg',
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 24),
          const Text(
            'Well, there is no food you are\nlooking for :(',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 88),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onFindOtherFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008C8C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Find Other Food',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodHeader extends StatelessWidget {
  const _FoodHeader({required this.onBack, required this.showCartBadge});
  final VoidCallback onBack;
  final bool showCartBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(22),
            child: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.arrow_back, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Food',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.shopping_cart_outlined, size: 24),
              ),
              if (showCartBadge)
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF008C8C),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.theme,
    required this.controller,
    required this.onChanged,
  });
  final ThemeData theme;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFB3B3B3)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration.collapsed(
                  hintText: 'Search Food',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFA6A6A6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final category = categories[index];
          final selected = category == selectedCategory;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF008C8C)
                    : const Color(0xFFF3F1F1),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.cancel_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    required this.showRatingBadge,
  });
  final _FoodData food;
  final VoidCallback onTap;
  final bool showRatingBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.asset(
                    food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        ColoredBox(color: Colors.orange.shade100),
                  ),
                ),
                if (showRatingBadge)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xCC171414),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            food.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    if (!showRatingBadge) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            food.rating,
                            style: const TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ] else
                      const SizedBox(height: 8),
                    Text(
                      food.price,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodDetailsSheet extends StatefulWidget {
  const _FoodDetailsSheet({required this.onDismiss, required this.onPlaced});
  final VoidCallback onDismiss;
  final VoidCallback onPlaced;

  @override
  State<_FoodDetailsSheet> createState() => _FoodDetailsSheetState();
}

class _FoodDetailsSheetState extends State<_FoodDetailsSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 411,
            height: 560,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 411,
                  child: Image.asset(
                    'assets/figma/food_detail_noodle.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB3B3B3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                'Noodle Ex',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _QuantityControl(
                              quantity: quantity,
                              onChanged: (value) =>
                                  setState(() => quantity = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            for (var index = 0; index < 5; index++)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.star,
                                  color: Color(0xFFFFC107),
                                  size: 20,
                                ),
                              ),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'Rp42.000',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: widget.onPlaced,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF008C8C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderConfirmationPopup extends StatelessWidget {
  const _OrderConfirmationPopup();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 371,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF49516F),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Successfuly place order',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
            ),
          ),
          SizedBox(width: 32),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Cart',
                style: TextStyle(
                  color: Color(0xFF008C8C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.quantity, required this.onChanged});
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 91,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove_circle, color: Color(0xFFB3B3B3)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
          Text('$quantity', style: const TextStyle(fontSize: 16)),
          IconButton(
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add_circle, color: Color(0xFF008C8C)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }
}

class _FoodData {
  const _FoodData(this.name, this.rating, this.price, this.imageUrl);
  final String name;
  final String rating;
  final String price;
  final String imageUrl;
}
