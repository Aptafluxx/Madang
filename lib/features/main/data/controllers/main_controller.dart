import 'package:get/get.dart';
import 'package:madang/features/recent/data/controllers/recent_controller.dart';

enum MainTab { home, search, recent, profile }

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is MainTab) {
      currentIndex.value = args.index;
    }
  }

  void changeTab(int index) {
    if (index >= 0 &&
        index < MainTab.values.length &&
        index != currentIndex.value) {
      currentIndex.value = index;
    }
    if (index == 2 && Get.isRegistered<RecentController>()) {
      Get.find<RecentController>().loadIfStale();
    }
  }
}
