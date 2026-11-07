import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:madang/features/cart/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String _kPrefix = 'cart_';

  String get _key =>
      '$_kPrefix${FirebaseAuth.instance.currentUser?.uid ?? 'guest'}';

  Future<CartModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return CartModel.empty;

    try {
      return CartModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return CartModel.empty;
    }
  }

  Future<void> save(CartModel cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(cart.toMap()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
