import 'package:get/get.dart';
import 'package:madang/features/search/data/controllers/search_page_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPageController>(() => SearchPageController());
  }
}
