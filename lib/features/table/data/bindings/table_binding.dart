import 'package:get/get.dart';
import 'package:madang/features/table/data/controllers/table_controller.dart';

class TableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TableController>(() => TableController());
  }
}
