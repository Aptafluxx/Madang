import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:madang/features/auth/data/models/user_model.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';
import 'package:madang/features/home/data/repositories/home_repository.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class HomeController extends GetxController {
  HomeController({HomeRepository? repository, AuthRepository? authRepository})
    : _repository = repository ?? HomeRepository(),
      _authRepository = authRepository ?? AuthRepository();

  final HomeRepository _repository;
  final AuthRepository _authRepository;

  final RxList<TableModel> tables = <TableModel>[].obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadTables();
    _loadProfile();
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

  Future<void> _loadProfile() async {
    try {
      user.value = await _authRepository.fetchUserName();
    } catch (_) {
      // The screen falls back to the Firebase Auth values.
    }
  }

  String get displayName {
    final name = user.value?.name ?? '';
    if (name.isNotEmpty) return name;
    return FirebaseAuth.instance.currentUser?.displayName ?? '';
  }
}
