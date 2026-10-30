import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key, required this.onBack, this.initialQuery = ''});

  final VoidCallback onBack;
  final String initialQuery;

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  static const _categories = [
    'Single Table',
    'Double Table',
    'Family Table',
    'Special Date',
    'Custom Table',
  ];

  static const _tables = [
    _TableData(
      title: 'Work Table',
      description: '1 table 1 chair',
      category: 'Single Table',
      image: 'assets/figma/table_work.png',
    ),
    _TableData(
      title: 'Family Table',
      description: '1 table 6 chair',
      category: 'Family Table',
      image: 'assets/figma/table_family.png',
    ),
    _TableData(
      title: 'Family Table',
      description: '1 table 6 chair',
      category: 'Family Table',
      image: 'assets/figma/table_special.png',
    ),
  ];

  late final TextEditingController _searchController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_TableData> get _filteredTables {
    final query = _searchController.text.trim().toLowerCase();
    return _tables.where((table) {
      final matchesQuery =
          query.isEmpty ||
          table.title.toLowerCase().contains(query) ||
          table.description.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || table.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _findOtherTable() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 411,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 5,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Back',
                        child: IconButton(
                          onPressed: widget.onBack,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 24,
                            height: 24,
                          ),
                          icon: SvgPicture.asset(
                            'assets/figma/table_arrow_back.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Table',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.04,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Semantics(
                        button: true,
                        label: 'Cart',
                        child: SvgPicture.asset(
                          'assets/figma/table_cart.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Search table',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 16,
                        height: 1.6,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: SvgPicture.asset(
                          'assets/figma/table_search.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFB3B3B3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFB3B3B3)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = selected ? null : category;
                          });
                        },
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFF3F1F1),
                        selectedColor: const Color(0xFFDCEBEC),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.6,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: const StadiumBorder(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: _filteredTables.isEmpty
                      ? _TableEmptyResult(onFindOther: _findOtherTable)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: _filteredTables.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            return _TableCard(
                              table: _filteredTables[index],
                              onTap: () => _showBookingSheet(context),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showBookingSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: const Color(0x4D000000),
      backgroundColor: Colors.transparent,
      builder: (_) => const _TableBookingSheet(),
    );
  }
}

class _TableEmptyResult extends StatelessWidget {
  const _TableEmptyResult({required this.onFindOther});

  final VoidCallback onFindOther;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(
            'assets/figma/search_empty_restaurant.svg',
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 16),
          const Text(
            'Well, there is no table you are looking for :(',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.3,
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
                'Find Other Table',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  const _TableCard({required this.table, required this.onTap});

  final _TableData table;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 371 / 240,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(table.image, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        letterSpacing: 0.048,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      table.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: 0.032,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableBookingSheet extends StatefulWidget {
  const _TableBookingSheet();

  @override
  State<_TableBookingSheet> createState() => _TableBookingSheetState();
}

class _TableBookingSheetState extends State<_TableBookingSheet> {
  static const _durations = ['30 minutes', '45 minutes', '1 hour', '2 hour'];

  String _selectedDuration = '30 minutes';
  final TextEditingController _customTimeController = TextEditingController(
    text: '10 minutes',
  );
  bool _customTimeVisible = false;
  final Set<String> _selectedAdditions = {'Flower'};
  int _flowerQuantity = 1;

  @override
  void dispose() {
    _customTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetHeight = screenHeight < 738 ? screenHeight : 738.0;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 411,
        height: sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _durations.map(_buildDuration).toList()),
              ),
            ),
            const SizedBox(height: 8),
            if (_customTimeVisible)
              _buildCustomTime()
            else
              Center(
                child: TextButton(
                  onPressed: () => setState(() {
                    _customTimeVisible = true;
                    _selectedDuration = _customTimeController.text.trim();
                  }),
                  child: const Text(
                    'custom time',
                    style: TextStyle(
                      color: Color(0xFF008C8C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Additional',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildAddition('Chair', 'Free'),
            _buildAddition('Table', 'Free'),
            _buildAddition('Flower', 'Rp.25.000'),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 41),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        backgroundColor: const Color(0xFF49516F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        duration: const Duration(seconds: 4),
                        content: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Successfuly booking table',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Cart',
                                style: TextStyle(
                                  color: Color(0xFF008C8C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008C8C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Booking table',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuration(String duration) {
    final selected = _selectedDuration == duration;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () => setState(() {
          _selectedDuration = duration;
          _customTimeVisible = false;
        }),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF008C8C) : const Color(0xFFF3F1F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                duration,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/figma/table_booking_close.svg',
                  width: 12,
                  height: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11),
            child: SvgPicture.asset(
              'assets/figma/table_booking_radio.svg',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _customTimeController,
                  onChanged: (value) => setState(() {
                    _selectedDuration = value.trim();
                  }),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFB3B3B3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFF008C8C)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'example: 10 minutes, 1 hour',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddition(String name, String price) {
    final selected = _selectedAdditions.contains(name);
    final isFlower = name == 'Flower';
    return InkWell(
      onTap: () {
        setState(() {
          if (selected) {
            _selectedAdditions.remove(name);
          } else {
            _selectedAdditions.add(name);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/figma/table_booking_checkbox.svg',
                  width: 24,
                  height: 24,
                  colorFilter: selected
                      ? const ColorFilter.mode(
                          Color(0xFF008C8C),
                          BlendMode.srcIn,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (isFlower && selected) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 91,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          if (_flowerQuantity > 1) _flowerQuantity--;
                        }),
                        child: SvgPicture.asset(
                          'assets/figma/table_booking_remove_circle.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Text(
                        '$_flowerQuantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _flowerQuantity++),
                        child: SvgPicture.asset(
                          'assets/figma/table_booking_add_circle.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TableData {
  const _TableData({
    required this.title,
    required this.description,
    required this.category,
    required this.image,
  });

  final String title;
  final String description;
  final String category;
  final String image;
}
