import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_bottom_sheet.dart';
import 'package:madang/core/widgets/custom_checkbox.dart';
import 'package:madang/core/widgets/custom_chip.dart';
import 'package:madang/core/widgets/custom_radio.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/quantity_selector.dart';
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
      title: 'Time',
      height: 620,
      child: _BookingForm(controller: controller),
      actionLabel: 'Booking table',
      onAction: () {
        if (!controller.validate()) return;
        Navigator.of(context).pop(controller.buildSelection());
      },
    );
  }
}

class _BookingForm extends StatelessWidget {
  const _BookingForm({required this.controller});

  final TableBookingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDurations(),
        const SizedBox(height: 20),
        _buildCustomTime(),
        const SizedBox(height: 24),
        Text(
          'Additional',
          style: AppTextStyles.title2.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 16),
        for (final addition in TableBookingController.availableAdditions)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _AdditionRow(controller: controller, addition: addition),
          ),
      ],
    );
  }

  Widget _buildDurations() {
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
                  onTap: () => controller.selectDuration(duration),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCustomTime() {
    return Obx(() {
      if (controller.isCustomTime.value) {
        return _CustomTimeField(controller: controller);
      }
      return Center(
        child: TextButton(
          onPressed: controller.enableCustomTime,
          child: const Text('custom time'),
        ),
      );
    });
  }
}

class _AdditionRow extends StatelessWidget {
  const _AdditionRow({required this.controller, required this.addition});

  final TableBookingController controller;
  final BookingAddition addition;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedAdditions.contains(addition.name);

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomCheckbox(
                  value: selected,
                  label: addition.name,
                  onChanged: (checked) =>
                      controller.toggleAddition(addition.name, checked),
                ),
              ),
              Text(
                addition.priceText,
                style: AppTextStyles.subtitle2.copyWith(color: AppColors.black),
              ),
            ],
          ),
          if (addition.allowsQuantity && selected)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: QuantitySelector(
                  value: controller.quantities[addition.name] ?? 1,
                  min: 1,
                  max: 10,
                  onChanged: (q) => controller.setQuantity(addition.name, q),
                ),
              ),
            ),
        ],
      );
    });
  }
}

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
          child: Obx(
            () => CustomTextField(
              hintText: 'e.g. 10 minutes',
              controller: _text,
              autofocus: true,
              helperText: 'example: 10 minutes, 1 hour',
              errorText: widget.controller.customTimeError.value,
              onChanged: widget.controller.setCustomTime,
            ),
          ),
        ),
      ],
    );
  }
}
