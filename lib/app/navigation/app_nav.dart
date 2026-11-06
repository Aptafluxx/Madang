import 'package:get/get.dart';

import '../../features/main/data/controllers/main_controller.dart';
import '../routes/app_routes.dart';

class AppNav {
  static void goToTab(MainTab tab) {
    final route = switch (tab) {
      MainTab.home => AppRoutes.home,
      MainTab.search => AppRoutes.search,
      MainTab.recent => AppRoutes.recent,
      MainTab.profile => AppRoutes.profile,
    };

    Get.offAllNamed(route, arguments: tab);
  }
}
