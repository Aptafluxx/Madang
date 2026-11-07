import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:madang/features/cart/data/models/cart_model.dart';
import 'package:madang/features/cart/data/repositories/cart_repository.dart';
import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/table/data/controllers/table_booking_controller.dart';

/// The one cart for the whole app. Registered permanently by AppBinding,
/// so Food, Table, Search and Cart screens all talk to the same instance.
class CartController extends GetxController {
  CartController(this._repository);

  final CartRepository _repository;

  /// Tax on top of the subtotal. 0.1 = 10%. The Tax row is hidden while 0.
  static const num taxRate = 0.1;

  static const int maxFoodQuantity = 20;

  final RxList<CartFoodItem> foods = <CartFoodItem>[].obs;
  final Rxn<CartTableItem> table = Rxn<CartTableItem>();
  final RxList<CartAddition> additions = <CartAddition>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<User?>? _authSub;
  VoidCallback? _undo;
  bool _hasLocalChanges = false;
  int _saveRevision = 0;

  @override
  void onInit() {
    super.onInit();
    // Fires on start and on every sign-in / sign-out, so each user sees
    // their own cart.
    _authSub = FirebaseAuth.instance.authStateChanges().listen((_) => _load());
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  // ── Totals (read inside Obx so the screen updates) ────────────

  bool get isEmpty => foods.isEmpty && table.value == null;

  /// Number shown on a cart badge.
  int get itemCount =>
      foods.fold<int>(0, (sum, f) => sum + f.quantity) +
      (table.value == null ? 0 : 1);

  num get foodTotal => foods.fold<num>(0, (sum, f) => sum + f.total);
  num get tableTotal => table.value?.price ?? 0;
  num get additionsTotal => additions.fold<num>(0, (sum, a) => sum + a.total);
  num get subtotal => foodTotal + tableTotal + additionsTotal;
  num get tax => subtotal * taxRate;
  num get total => subtotal + tax;

  String get foodTotalText => formatCartMoney(foodTotal);
  String get tableTotalText => formatCartMoney(tableTotal);
  String get taxText => formatCartMoney(tax);
  String get totalText => formatCartMoney(total);

  // ── Adding (called by the food / table / search screens) ──────

  /// Adds [quantity] of [food]. Adding the same food again increases the
  /// quantity instead of creating a second row.
  void addFood(FoodModel food, int quantity) {
    final index = foods.indexWhere((f) => f.id == food.id);
    if (index >= 0) {
      final current = foods[index];
      foods[index] = current.copyWith(
        quantity: math.min(maxFoodQuantity, current.quantity + quantity),
      );
    } else {
      foods.add(
        CartFoodItem(
          id: food.id,
          title: food.title,
          price: food.price,
          imageUrl: food.imageUrl,
          quantity: math.max(1, math.min(maxFoodQuantity, quantity)),
        ),
      );
    }
    _save();
  }

  /// A cart holds one table: booking another replaces it (and its extras).
  void addTable(TableBookingSelection selection) {
    final t = selection.table;
    table.value = CartTableItem(
      id: t.id,
      title: t.title,
      description: t.description,
      price: t.price,
      imageUrl: t.imageUrl,
      duration: selection.duration,
    );
    additions.assignAll([
      for (final entry in selection.additions.entries)
        CartAddition(
          name: entry.key,
          unitPrice: _additionPrice(entry.key),
          quantity: entry.value,
        ),
    ]);
    _save();
  }

  num _additionPrice(String name) {
    return TableBookingController.availableAdditions
        .firstWhere(
          (a) => a.name == name,
          orElse: () => BookingAddition(name, 0),
        )
        .price;
  }

  // ── Changing and removing (called by the cart screen) ─────────

  void updateFoodQuantity(String id, int quantity) {
    final index = foods.indexWhere((f) => f.id == id);
    if (index < 0) return;
    foods[index] = foods[index].copyWith(
      quantity: math.max(1, math.min(maxFoodQuantity, quantity)),
    );
    _save();
  }

  /// Returns true if something was removed. Call [undoRemove] to bring it back.
  bool removeFood(String id) {
    final index = foods.indexWhere((f) => f.id == id);
    if (index < 0) return false;

    final removed = foods.removeAt(index);
    _undo = () {
      foods.insert(math.min(index, foods.length), removed);
      _save();
    };
    _save();
    return true;
  }

  /// Removes the table together with its extras.
  bool removeTable() {
    final removedTable = table.value;
    if (removedTable == null) return false;

    final removedAdditions = additions.toList();
    table.value = null;
    additions.clear();
    _undo = () {
      table.value = removedTable;
      additions.assignAll(removedAdditions);
      _save();
    };
    _save();
    return true;
  }

  /// Brings back the last removed food or table.
  void undoRemove() {
    _undo?.call();
    _undo = null;
  }

  /// Empties the cart (use after the order is placed).
  Future<void> clear() async {
    foods.clear();
    table.value = null;
    additions.clear();
    _undo = null;
    await _repository.clear();
  }

  // ── Storage ───────────────────────────────────────────────────

  Future<void> _load() async {
    isLoading.value = true;
    try {
      if (_hasLocalChanges) return;
      final cart = await _repository.load();
      if (_hasLocalChanges) return;
      foods.assignAll(cart.foods);
      table.value = cart.table;
      additions.assignAll(cart.additions);
      _undo = null;
    } catch (_) {
      // Keep whatever is in memory; the cart will save on the next change.
    } finally {
      isLoading.value = false;
    }
  }

  void _save() {
    _hasLocalChanges = true;
    final revision = ++_saveRevision;
    unawaited(
      _repository
          .save(
            CartModel(
              foods: foods.toList(),
              table: table.value,
              additions: additions.toList(),
            ),
          )
          .whenComplete(() {
            if (_saveRevision == revision) {
              _hasLocalChanges = false;
            }
          }),
    );
  }
}
