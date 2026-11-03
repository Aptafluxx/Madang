import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/services/preferences_service.dart';

class OnboardingController extends GetxController {
  final PreferencesService _prefs = Get.find<PreferencesService>();

  Future<void> continueTo(String route) async {
    await _prefs.setHasSeenOnboarding(true);
    Get.offAllNamed(route);
  }

  Future<void> goToSignup() => continueTo(AppRoutes.signup);

  Future<void> goToLogin() => continueTo(AppRoutes.login);
}
