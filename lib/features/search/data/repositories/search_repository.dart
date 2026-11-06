import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/table/data/models/table_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Catalog {
  const Catalog({required this.foods, required this.tables});

  final List<FoodModel> foods;
  final List<TableModel> tables;

  bool get isEmpty => foods.isEmpty && tables.isEmpty;
}

class SearchRepository {
  SearchRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const Duration catalogTtl = Duration(hours: 6);
  static const int maxRecent = 10;

  static const String _kLastSync = 'search_catalog_last_sync_ms';
  static const String _kRecentPrefix = 'search_recent_';

  Future<Catalog> loadCatalog({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final age = now - (prefs.getInt(_kLastSync) ?? 0);
    final isFresh = age >= 0 && age < catalogTtl.inMilliseconds;

    if (isFresh && !forceRefresh) {
      final cached = await _read(Source.cache);
      if (!cached.isEmpty) return cached;
    }

    try {
      final fresh = await _read(Source.serverAndCache);
      await prefs.setInt(_kLastSync, DateTime.now().millisecondsSinceEpoch);
      return fresh;
    } on FirebaseException {
      // Offline or failing: fall back to whatever is cached.
      final cached = await _read(Source.cache);
      if (!cached.isEmpty) return cached;
      rethrow;
    }
  }

  Future<Catalog> _read(Source source) async {
    final options = GetOptions(source: source);
    try {
      final snapshots = await Future.wait([
        _firestore.collection('foods').get(options),
        _firestore.collection('tables').get(options),
      ]);
      return Catalog(
        foods: snapshots[0].docs
            .map((d) => FoodModel.fromMap(d.id, d.data()))
            .toList(),
        tables: snapshots[1].docs
            .map((d) => TableModel.fromMap(d.id, d.data()))
            .toList(),
      );
    } on FirebaseException {
      if (source == Source.cache) return const Catalog(foods: [], tables: []);
      rethrow;
    }
  }

  String get _recentKey =>
      '$_kRecentPrefix${FirebaseAuth.instance.currentUser?.uid ?? 'guest'}';

  Future<List<String>> getRecentKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentKey) ?? [];
  }

  Future<void> saveRecentKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList(_recentKey) ?? [];
    keys.remove(key);
    keys.insert(0, key);
    await prefs.setStringList(_recentKey, keys.take(maxRecent).toList());
  }

  Future<void> clearRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }
}
