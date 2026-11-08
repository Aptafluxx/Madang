import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_tab_bar.dart';
import 'package:madang/core/widgets/empty_state.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/payment_method/data/models/order_model.dart';
import 'package:madang/features/recent/data/controllers/recent_controller.dart';
import 'package:shimmer/shimmer.dart';

final DateFormat _dateFormat = DateFormat('d MMMM y, HH:mm');

class RecentScreen extends GetView<RecentController> {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'Recent',
                  style: AppTextStyles.title2.copyWith(color: AppColors.black),
                ),
              ),
              const SizedBox(height: 16),
              const CustomTabBar(
                tabs: ['Newest', 'Oldest'],
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildList(newestFirst: true),
                    _buildList(newestFirst: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Both tabs show the same orders; "Oldest" just reverses them.
  Widget _buildList({required bool newestFirst}) {
    return Obx(() {
      final orders = controller.orders;
      final loading = controller.isLoading.value;
      final error = controller.errorMessage.value;

      if (loading && orders.isEmpty) return const _RecentSkeleton();

      if (error != null && orders.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.refreshOrders,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        );
      }

      if (orders.isEmpty) {
        return EmptyState(
          title: 'No orders yet',
          message: 'Your orders will show up here.',
          icon: Icons.receipt_long_outlined,
          actionLabel: 'Find Item',
          onAction: () => Get.toNamed(AppRoutes.food),
        );
      }

      final list = newestFirst ? orders.toList() : orders.reversed.toList();

      return RefreshIndicator(
        onRefresh: controller.refreshOrders,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, index) => _OrderRow(order: list[index]),
        ),
      );
    });
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (order.orderStatus) {
      OrderStatus.process => ('Process', AppColors.primary),
      OrderStatus.done => ('Done', AppColors.primary),
      OrderStatus.cancelled => ('Cancel', AppColors.error),
    };

    final created = order.createdAt;
    final date = created == null ? '' : _dateFormat.format(created);
    final summary = order.summary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Thumb(order.imageUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle2.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                  Text(
                    label,
                    style: AppTextStyles.body2.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
              if (summary.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.chipBackground,
      child: const Icon(Icons.restaurant, color: AppColors.gray),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 56,
        height: 56,
        child: imageUrl.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 200,
                placeholder: (_, _) => const ShimmerBox(),
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

/// Shimmering placeholder rows while the orders load.
class _RecentSkeleton extends StatelessWidget {
  const _RecentSkeleton();

  Widget _block({double? width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.disabledFill,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _block(width: 56, height: 56, radius: 6),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(width: 120, height: 16),
                  const SizedBox(height: 8),
                  _block(width: 160, height: 12),
                  const SizedBox(height: 8),
                  _block(width: 110, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
