import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_bottom_sheet.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_checkbox.dart';
import 'package:madang/core/widgets/custom_chip.dart';
import 'package:madang/core/widgets/custom_radio.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/quantity_selector.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/table/data/controllers/table_booking_controller.dart';
import 'package:madang/features/table/data/models/table_model.dart';

/// Opens the booking sheet. Returns the user's choices, or null if closed.
///
/// ```dart
/// final booking = await TableBookingSheet.show(context, table: table);
/// ```
class TableBookingSheet {
  const TableBookingSheet._();

  static Future<TableBookingSelection?> show(
    BuildContext context, {
    required TableModel table,
  }) {
    final controller = TableBookingController(table);

    return CustomBottomSheet.show<TableBookingSelection>(
      context,
      height: 720,
      child: _BookingForm(controller: controller),
      footer: _BookingFooter(controller: controller),
    );
  }
}

void _unfocus(BuildContext context) => FocusScope.of(context).unfocus();

// ── Body ────────────────────────────────────────────────────────

class _BookingForm extends StatelessWidget {
  const _BookingForm({required this.controller});

  final TableBookingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableSummary(table: controller.table),
        const SizedBox(height: 24),
        Text('Time', style: AppTextStyles.title2),
        const SizedBox(height: 16),
        _buildDurations(context),
        const SizedBox(height: 20),
        _buildCustomTime(context),
        _buildTimeError(),
        const SizedBox(height: 24),
        Text('Additional', style: AppTextStyles.title2),
        const SizedBox(height: 16),
        for (final addition in TableBookingController.availableAdditions)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _AdditionRow(controller: controller, addition: addition),
          ),
      ],
    );
  }

  Widget _buildDurations(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedDuration.value;
      final custom = controller.isCustomTime.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final duration in TableBookingController.durations)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CustomChip(
                  label: duration,
                  isSelected: !custom && selected == duration,
                  onTap: () {
                    _unfocus(context);
                    controller.selectDuration(duration);
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCustomTime(BuildContext context) {
    return Obx(() {
      if (controller.isCustomTime.value) {
        return _CustomTimeField(controller: controller);
      }
      return Center(
        child: TextButton(
          onPressed: () {
            _unfocus(context);
            controller.enableCustomTime();
          },
          child: const Text('custom time'),
        ),
      );
    });
  }

  Widget _buildTimeError() {
    return Obx(() {
      final error = controller.timeError.value;
      if (error == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          error,
          style: AppTextStyles.body2.copyWith(
            fontSize: 12,
            color: AppColors.error,
          ),
        ),
      );
    });
  }
}

// ── Table details (title, description, price, image) ────────────

class _TableSummary extends StatelessWidget {
  const _TableSummary({required this.table});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 72, height: 72, child: _buildImage()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle2.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  table.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatMoney(table.price),
                  style: AppTextStyles.subtitle2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final fallback = Container(
      color: AppColors.chipBackground,
      child: const Icon(Icons.restaurant, color: AppColors.gray),
    );
    if (table.imageUrl.isEmpty) return fallback;

    return CachedNetworkImage(
      imageUrl: table.imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 200,
      placeholder: (_, _) => const ShimmerBox(),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

// ── One extra (Chair / Table / Flower) ──────────────────────────

class _AdditionRow extends StatelessWidget {
  const _AdditionRow({required this.controller, required this.addition});

  final TableBookingController controller;
  final BookingAddition addition;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedAdditions.contains(addition.name);
      final quantity = controller.quantities[addition.name] ?? 1;

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomCheckbox(
                  value: selected,
                  label: addition.name,
                  onChanged: (checked) {
                    _unfocus(context);
                    controller.toggleAddition(addition.name, checked);
                  },
                ),
              ),
              // Price follows the quantity: 2 flowers shows $5.00
              Text(
                addition.priceTextFor(selected ? quantity : 1),
                style: AppTextStyles.subtitle2,
              ),
            ],
          ),
          if (addition.allowsQuantity && selected)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: QuantitySelector(
                  value: quantity,
                  min: 1,
                  max: 10,
                  onChanged: (q) {
                    _unfocus(context);
                    controller.setQuantity(addition.name, q);
                  },
                ),
              ),
            ),
        ],
      );
    });
  }
}

// ── Custom time input ───────────────────────────────────────────

/// Owns its own TextEditingController so it is disposed with the widget.
class _CustomTimeField extends StatefulWidget {
  const _CustomTimeField({required this.controller});

  final TableBookingController controller;

  @override
  State<_CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<_CustomTimeField> {
  final TextEditingController _text = TextEditingController(
    text: TableBookingController.defaultCustomTime,
  );

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CustomRadio<bool>(
            value: true,
            groupValue: true,
            onChanged: (_) {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            hintText: 'e.g. 10 minutes',
            controller: _text,
            autofocus: true,
            helperText: 'example: 10 minutes, 1 hour',
            onChanged: widget.controller.setCustomTime,
          ),
        ),
      ],
    );
  }
}

// ── Pinned footer: price breakdown + button ─────────────────────

class _BookingFooter extends StatelessWidget {
  const _BookingFooter({required this.controller});

  final TableBookingController controller;

  Widget _line(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.subtitle2
                : AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.heading5.copyWith(color: AppColors.primary)
                : AppTextStyles.body2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Obx(() {
          final additions = controller.additionsTotal;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _line('Table', formatMoney(controller.tablePrice)),
              if (additions > 0) _line('Additional', formatMoney(additions)),
              _line(
                'Subtotal',
                formatMoney(controller.subtotal),
                isTotal: true,
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: 'Add to cart',
                onPressed: () {
                  if (!controller.validate()) return;
                  Navigator.of(context).pop(controller.buildSelection());
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
