import 'package:get/get.dart';
import 'package:madang/core/services/preferences_service.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';

class AppBinding {
  static Future<void> initialize() async {
    await Get.putAsync<PreferencesService>(
      () => PreferencesService().init(),
    );
    Get.put<AuthRepository>(AuthRepository());
  }
}
