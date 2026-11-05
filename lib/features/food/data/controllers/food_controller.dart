import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/food/data/repositories/food_repository.dart';

class FoodController extends GetxController {
  FoodController({FoodRepository? repository})
    : _repository = repository ?? FoodRepository();

  final FoodRepository _repository;

  /// Chip labels. They must match the `category` values in Firestore.
  static const List<String> categories = [
    'Dinner Food',
    'Economic Food',
    'Hot Food',
    'Family Food',
    'Super Food',
  ];

  List<FoodModel> _all = [];

  /// What the screen shows (after search + chip filtering).
  final RxList<FoodModel> foods = <FoodModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  /// null means no chip is selected (show all).
  final RxnString selectedCategory = RxnString();
  final RxString searchQuery = ''.obs;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Opened with a category, e.g. /food?category=Hot%20Food
    final initial = Get.parameters['category'];
    if (initial != null && categories.contains(initial)) {
      selectedCategory.value = initial;
    }

    // Re-filter when the chip changes, or 300 ms after the user stops typing.
    ever(selectedCategory, (_) => _applyFilters());
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );

    loadFoods();
  }

  Future<void> loadFoods() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      _all = await _repository.getAllFoods();
      _applyFilters();
    } on FirebaseException catch (e) {
      errorMessage.value = e.code == 'permission-denied'
          ? 'You do not have permission to view food.'
          : 'Could not load food. Please try again.';
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Called by the screen ──────────────────────────────────────

  /// Tapping the selected chip again unselects it.
  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category
        ? null
        : category;
  }

  void onSearchChanged(String value) => searchQuery.value = value.trim();

  void clearFilters() {
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';
    _applyFilters(); // refresh right away, no 300 ms wait
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  // ── Internals ─────────────────────────────────────────────────

  void _applyFilters() {
    final category = selectedCategory.value;
    final query = searchQuery.value.toLowerCase();

    foods.assignAll(
      _all.where((f) {
        final matchesCategory = category == null || f.category == category;
        final matchesSearch =
            query.isEmpty ||
            f.title.toLowerCase().contains(query) ||
            f.description.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }),
    );
  }
}
