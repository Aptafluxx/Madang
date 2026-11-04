import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:madang/features/home/data/repositories/home_repository.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class HomeController extends GetxController {
  HomeController({HomeRepository? repository})
    : _repository = repository ?? HomeRepository();

  final HomeRepository _repository;

  final RxList<TableModel> tables = <TableModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadTables();
  }

  Future<void> loadTables() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      tables.assignAll(await _repository.getRecommendedTables());
    } on FirebaseException catch (e) {
      errorMessage.value = e.code == 'permission-denied'
          ? 'You do not have permission to view tables.'
          : 'Could not load tables. Please try again.';
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}

// Future<void> logout() async {
//   try {
//     await AuthRepository.instance.logout();
//     Get.offAllNamed(AppRoutes.login);
//   } on AuthException catch (e) {
//     AppSnackBar.error(Get.context!, e.message);
//   }
// }
