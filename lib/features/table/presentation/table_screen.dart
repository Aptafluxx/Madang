import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/table/data/controllers/table_controller.dart';
import 'package:madang/features/table/presentation/widgets/table_card.dart';

class TableScreen extends GetView<TableController> {
  const TableScreen({super.key});

  void _openCart() => Get.toNamed(AppRoutes.home);

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
                _buildHeader(),
                const SizedBox(height: 8),
                _buildSearchField(),
                const SizedBox(height: 24),
                _buildChips(),
                const SizedBox(height: 30),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              onPressed: Get.back,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
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
            child: IconButton(
              onPressed: _openCart,
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                'assets/figma/table_cart.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller.searchTextController,
        onChanged: controller.onSearchChanged,
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
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 32,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: TableController.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final category = TableController.categories[index];
            return ChoiceChip(
              label: Text(category),
              selected: selected == category,
              onSelected: (_) => controller.selectCategory(category),
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
        );
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const _TableListSkeleton();

      final error = controller.errorMessage.value;
      if (error != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.loadTables,
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      }

      final tables = controller.tables;
      if (tables.isEmpty) {
        return EmptyState(
          title: "Empty",
          actionLabel: "Clear",
          onAction: () => controller.clearFilters(),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: tables.length,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (_, index) => TableCard(
          table: tables[index],
          onTap: () => _showBookingSheet(context),
        ),
      );
    });
  }

  Future<void> _showBookingSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: const Color(0x4D000000),
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const Text('Book a table'),
      ),
    );
  }
}

class _TableListSkeleton extends StatelessWidget {
  const _TableListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
      itemBuilder: (_, _) => const AspectRatio(
        aspectRatio: 371 / 240,
        child: ShimmerBox(borderRadius: 8),
      ),
    );
  }
}
