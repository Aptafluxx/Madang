import 'package:get/get.dart';
import 'package:madang/features/food/data/controllers/food_controller.dart';

class FoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodController>(() => FoodController());
  }
}
