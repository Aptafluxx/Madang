import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_radio.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/features/payment_method/data/controllers/payment_controller.dart';
import 'package:madang/features/payment_method/data/models/payment_method.dart';

class PaymentMethodScreen extends GetView<PaymentController> {
  const PaymentMethodScreen({super.key});

  Widget _logoFor(PaymentMethod method) {
    switch (method.id) {
      case 'atm_bersama':
        return _AtmBersamaLogo();
      case 'gopay':
        return const _GopayLogo();
      case 'linkaja':
        return const _LinkAjaLogo();
      default:
        return const Icon(Icons.payment, color: AppColors.gray);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedId = controller.selectedMethodId.value;

      return PopScope(
        // Do not leave the page while the order is being placed.
        canPop: !controller.isPaying.value,
        child: Scaffold(
          appBar: const CustomTopNavigation(title: 'Payment Method'),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Material(
              color: AppColors.white,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: CustomButton(
                  label: 'Pay Now',
                  isLoading: controller.isPaying.value,
                  // null = grey, disabled (no method chosen yet)
                  onPressed: controller.canPay ? controller.pay : null,
                ),
              ),
            ),
          ),
          body: RadioGroup<String>(
            groupValue: selectedId ?? '',
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                controller.selectMethod(value);
              }
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              children: [
                for (final method in controller.methods) ...[
                  _PaymentOption(
                    method: method,
                    logo: _logoFor(method),
                    selected: selectedId == method.id,
                    onTap: () => controller.selectMethod(method.id),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.method,
    required this.logo,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final Widget logo;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            CustomRadio(
              value: method.id,
              groupValue: selected ? method.id : '',
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 10),
            SizedBox(width: 38, height: 38, child: Center(child: logo)),
            const SizedBox(width: 12),
            Text(
              method.label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AtmBersamaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'ATM',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 0.9,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Color(0xFF166DB5),
          ),
        ),
        Text(
          'BERSAMA',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 5,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF166DB5),
          ),
        ),
      ],
    );
  }
}

class _GopayLogo extends StatelessWidget {
  const _GopayLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF009CDE), width: 1.5),
      ),
      child: Center(
        child: Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: Color(0xFF00AED6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 11,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _LinkAjaLogo extends StatelessWidget {
  const _LinkAjaLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFEF2029),
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 15,
          color: AppColors.white,
        ),
      ),
    );
  }
}
