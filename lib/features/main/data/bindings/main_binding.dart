import 'package:get/get.dart';

import '../../../home/data/controller/home_controller.dart';
import '../../../search/data/controllers/search_page_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchPageController>(() => SearchPageController());
  }
}
