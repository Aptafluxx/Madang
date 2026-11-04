import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:madang/features/table/data/models/table_model.dart';
import 'package:madang/features/table/data/repositories/table_repository.dart';

class TableController extends GetxController {
  TableController({TableRepository? repository})
    : _repository = repository ?? TableRepository();

  final TableRepository _repository;

  static const List<String> categories = [
    'Single Table',
    'Double Table',
    'Family Table',
    'Special Date',
  ];

  final TextEditingController searchTextController = TextEditingController();

  List<TableModel> _all = [];

  final RxList<TableModel> tables = <TableModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final RxnString selectedCategory = RxnString();
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(selectedCategory, (_) => _applyFilters());
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
    loadTables();
  }

  Future<void> loadTables() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      _all = await _repository.getAllTables();
      _applyFilters();
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
    _applyFilters();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void _applyFilters() {
    final category = selectedCategory.value;
    final query = searchQuery.value.toLowerCase();

    tables.assignAll(
      _all.where((t) {
        final matchesCategory = category == null || t.category == category;
        final matchesSearch =
            query.isEmpty ||
            t.title.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }),
    );
  }
}
