import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/errors/auth_exceptions.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';

class HomeController extends GetxController {
  Future<void> logout() async {
    try {
      await AuthRepository.instance.logout();
      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      AppSnackBar.error(Get.context!, e.message);
    }
  }
}
