import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/features/cart/data/controllers/cart_controller.dart';
import 'package:madang/features/cart/data/models/cart_model.dart';
import 'package:madang/features/payment_method/data/models/payment_method.dart';
import 'package:madang/features/payment_method/data/repositories/payment_repository.dart';
import 'package:madang/features/recent/data/controllers/recent_controller.dart';

class PaymentController extends GetxController {
  PaymentController({PaymentRepository? repository})
    : _repository = repository ?? PaymentRepository();

  final PaymentRepository _repository;
  final CartController _cart = Get.find<CartController>();

  /// Same id for every attempt of this checkout (prevents double orders).
  late final String _orderId = _repository.newOrderId();

  final RxnString selectedMethodId = RxnString();
  final RxBool isPaying = false.obs;

  List<PaymentMethod> get methods => PaymentMethod.all;

  /// Read inside Obx so the button updates.
  bool get canPay =>
      selectedMethodId.value != null && !isPaying.value && !_cart.isEmpty;

  void selectMethod(String id) => selectedMethodId.value = id;

  Future<void> pay() async {
    final method = PaymentMethod.byId(selectedMethodId.value);
    if (method == null || isPaying.value || _cart.isEmpty) return;

    isPaying.value = true;
    try {
      await _repository.placeOrder(
        orderId: _orderId,
        cart: CartModel(
          foods: _cart.foods.toList(),
          table: _cart.table.value,
          additions: _cart.additions.toList(),
        ),
        paymentMethod: method,
        taxRate: CartController.taxRate,
      );

      await _cart.clear();
      if (Get.isRegistered<RecentController>()) {
        Get.find<RecentController>().refreshOrders();
      }

      // Replace cart + payment with the success page, keeping Home
      // underneath, so Back can never return to payment.
      Get.offNamedUntil(
        AppRoutes.orderSuccess,
        (route) => route.settings.name == AppRoutes.home,
        arguments: _orderId,
      );
    } on CartChangedException catch (e) {
      // Show the new prices in the cart and send the user back to review.
      _cart.replaceWith(e.updatedCart);
      _showError(e.message);
      Get.back();
    } on PaymentException catch (e) {
      _showError(e.message);
    } on FirebaseException catch (e) {
      _showError(_firebaseMessage(e));
    } catch (_) {
      _showError('Could not place your order. Please try again.');
    } finally {
      isPaying.value = false;
    }
  }

  String _firebaseMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Could not place your order. Please sign in again.';
      case 'unavailable':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Could not place your order. Please try again.';
    }
  }

  void _showError(String message) {
    final context = Get.context;
    if (context != null) AppSnackBar.error(context, message);
  }
}
