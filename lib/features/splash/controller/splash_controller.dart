import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/services/preferences_service.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final PreferencesService _prefs = Get.find<PreferencesService>();
  final AuthRepository _authRepository = AuthRepository.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!_prefs.hasSeenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (_authRepository.currentUser != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
