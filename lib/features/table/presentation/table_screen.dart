import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/core/widgets/custom_chip.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/table/data/controllers/table_controller.dart';
import 'package:madang/features/table/data/models/table_model.dart';
import 'package:madang/features/table/presentation/widgets/table_booking_sheet.dart';
import 'package:madang/features/table/presentation/widgets/table_card.dart';

class TableScreen extends GetView<TableController> {
  const TableScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopNavigation(
                title: "Table",
                showCart: true,
                onCartTap: () {
                  Get.toNamed(AppRoutes.cart);
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const .symmetric(horizontal: 15),
                child: CustomTextField(
                  hintText: "Search Table",
                  controller: controller.searchTextController,
                  textInputAction: .search,
                  keyboardType: .text,
                  suffixIcon: Icons.clear,
                  onSuffixTap: () {
                    controller.clearFilters();
                  },
                  onChanged: controller.onSearchChanged,
                ),
              ),
              const SizedBox(height: 24),
              _buildChips(),
              const SizedBox(height: 30),
              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 30,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: TableController.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 15),
          itemBuilder: (context, index) {
            final category = TableController.categories[index];
            return CustomChip(
              label: category,
              isSelected: selected == category,
              onTap: () => controller.selectCategory(category),
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
          title: "Well, there is no table you are looking for :(",
          actionLabel: "Find Other Table",
          onAction: () => controller.clearFilters(),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: tables.length,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (_, index) => TableCard(
          table: tables[index],
          onTap: () => _openBooking(context, tables[index]),
        ),
      );
    });
  }

  Future<void> _openBooking(BuildContext context, TableModel table) async {
    final booking = await TableBookingSheet.show(context, table: table);
    if (booking == null || !context.mounted) return;

    AppSnackBar.show(
      context,
      message: 'Successfully booked table',
      actionLabel: 'Cart',
      onAction: () => Get.toNamed(AppRoutes.cart),
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
