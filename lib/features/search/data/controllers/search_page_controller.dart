import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:madang/features/search/data/models/search_item.dart';
import 'package:madang/features/search/data/repositories/search_repository.dart';

class SearchPageController extends GetxController {
  SearchPageController({SearchRepository? repository})
    : _repository = repository ?? SearchRepository();

  final SearchRepository _repository;

  static const List<String> popularSearches = [
    'Duo Table',
    'Noodle',
    'Chicken',
    'Fried Rice',
    'Meat',
    'Family',
  ];

  static const int maxResults = 50;

  static const Map<String, String> _synonyms = {'duo': 'double'};

  List<SearchItem> _all = [];

  final RxList<SearchItem> results = <SearchItem>[].obs;
  final RxList<SearchItem> recentItems = <SearchItem>[].obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final RxString query = ''.obs;

  final RxnString selectedChip = RxnString();

  final RxString activeTerm = ''.obs;

  final TextEditingController searchTextController = TextEditingController();

  bool get isSearching => activeTerm.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    ever(selectedChip, (_) => _applySearch());
    debounce(
      query,
      (_) => _applySearch(),
      time: const Duration(milliseconds: 200),
    );
    loadCatalog();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> loadCatalog({bool forceRefresh = false}) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final catalog = await _repository.loadCatalog(forceRefresh: forceRefresh);
      _all = [
        ...catalog.foods.map(SearchItem.fromFood),
        ...catalog.tables.map(SearchItem.fromTable),
      ];
      await _loadRecent();
      _applySearch();
    } on FirebaseException catch (e) {
      errorMessage.value = e.code == 'permission-denied'
          ? 'You do not have permission to search.'
          : 'Could not load search. Please try again.';
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadRecent() async {
    final keys = await _repository.getRecentKeys();
    final byKey = {for (final item in _all) item.key: item};
    recentItems.assignAll(keys.map((k) => byKey[k]).whereType<SearchItem>());
  }

  void onSearchChanged(String value) {
    selectedChip.value = null;
    query.value = value.trim();
  }

  void selectPopular(String term) {
    searchTextController.clear();
    query.value = '';
    selectedChip.value = selectedChip.value == term ? null : term;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void clearChip() => selectedChip.value = null;

  void clearAll() {
    searchTextController.clear();
    query.value = '';
    selectedChip.value = null;
    _applySearch();
  }

  Future<void> markOpened(SearchItem item) async {
    recentItems.removeWhere((i) => i.key == item.key);
    recentItems.insert(0, item);
    if (recentItems.length > SearchRepository.maxRecent) {
      recentItems.removeRange(SearchRepository.maxRecent, recentItems.length);
    }
    await _repository.saveRecentKey(item.key);
  }

  Future<void> clearRecent() async {
    recentItems.clear();
    await _repository.clearRecent();
  }

  void _applySearch() {
    final term = (selectedChip.value ?? query.value).trim();
    activeTerm.value = term;

    if (term.isEmpty) {
      results.clear();
      return;
    }

    final lower = term.toLowerCase();
    final tokens = lower
        .split(RegExp(r'\s+'))
        .map((word) => _synonyms[word] ?? word)
        .toList();

    final matches = _all
        .where((item) => tokens.every((t) => item.searchText.contains(t)))
        .toList();

    int rank(SearchItem i) => i.title.toLowerCase().contains(lower) ? 0 : 1;
    matches.sort((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      return byRank != 0 ? byRank : b.rating.compareTo(a.rating);
    });

    results.assignAll(matches.take(maxResults));
  }
}
