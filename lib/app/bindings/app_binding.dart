import 'package:get/get.dart';
import 'package:madang/core/services/preferences_service.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';
import 'package:madang/features/cart/data/controllers/cart_controller.dart';
import 'package:madang/features/cart/data/repositories/cart_repository.dart';

class AppBinding {
  static Future<void> initialize() async {
    await Get.putAsync<PreferencesService>(() => PreferencesService().init());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<CartRepository>(CartRepository(), permanent: true);
    Get.put<CartController>(
      CartController(Get.find<CartRepository>()),
      permanent: true,
    );
  }
}
