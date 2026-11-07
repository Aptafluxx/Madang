import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:madang/features/cart/data/models/cart_model.dart';
import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/payment_method/data/models/order_model.dart';
import 'package:madang/features/payment_method/data/models/payment_method.dart';
import 'package:madang/features/table/data/models/table_model.dart';

/// A message that is safe to show to the user.
class PaymentException implements Exception {
  const PaymentException(this.message);

  final String message;
}

/// Prices or availability changed since the items were added to the cart.
/// [updatedCart] has the current values.
class CartChangedException implements Exception {
  const CartChangedException(this.updatedCart, this.message);

  final CartModel updatedCart;
  final String message;
}

/// All Firestore work for checkout.
///
/// COST: placing an order is ONE write plus a few reads (one query for the
/// foods in the cart and one read for the table). The reads are there so a
/// stale cart can never be bought at an old price.
class PaymentRepository {
  PaymentRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  /// Create this once per checkout and reuse it on retries, so tapping
  /// "Pay Now" twice can never create two orders.
  String newOrderId() => _orders.doc().id;

  Future<void> placeOrder({
    required String orderId,
    required CartModel cart,
    required PaymentMethod paymentMethod,
    required num taxRate,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const PaymentException('Please sign in to place an order.');
    }
    if (cart.foods.isEmpty && cart.table == null) {
      throw const PaymentException('Your cart is empty.');
    }

    // 1. Re-read current prices from the server (never trust the cart).
    final fresh = await _withCurrentPrices(cart);
    if (_signature(cart) != _signature(fresh)) {
      throw CartChangedException(
        fresh,
        'Some prices or items changed. Please review your cart.',
      );
    }

    // 2. Totals from the fresh values.
    final foodTotal = fresh.foods.fold<num>(0, (num sum, f) => sum + f.total);
    final additionsTotal = fresh.additions.fold<num>(
      0,
      (num sum, a) => sum + a.total,
    );
    final subtotal = _round2(
      foodTotal + (fresh.table?.price ?? 0) + additionsTotal,
    );
    final tax = _round2(subtotal * taxRate);

    final order = OrderModel(
      userId: user.uid,
      foods: fresh.foods,
      table: fresh.table,
      additions: fresh.additions,
      subtotal: subtotal,
      tax: tax,
      total: _round2(subtotal + tax),
      paymentMethod: paymentMethod.id,
    );

    // 3. The single write.
    await _orders.doc(orderId).set({
      ...order.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Helpers ───────────────────────────────────────────────────

  /// Returns the cart with today's titles and prices. Items that no longer
  /// exist are dropped. Always reads from the server, so it needs internet.
  Future<CartModel> _withCurrentPrices(CartModel cart) async {
    const serverOnly = GetOptions(source: Source.server);

    // Foods: a whereIn query takes at most 30 ids.
    final foodIds = cart.foods.map((f) => f.id).toSet().toList();
    final freshFoods = <String, FoodModel>{};
    for (var i = 0; i < foodIds.length; i += 30) {
      final chunk = foodIds.sublist(i, math.min(i + 30, foodIds.length));
      final snapshot = await _firestore
          .collection('foods')
          .where(FieldPath.documentId, whereIn: chunk)
          .get(serverOnly);
      for (final doc in snapshot.docs) {
        freshFoods[doc.id] = FoodModel.fromMap(doc.id, doc.data());
      }
    }

    final foods = <CartFoodItem>[
      for (final item in cart.foods)
        if (freshFoods[item.id] case final food?)
          CartFoodItem(
            id: item.id,
            title: food.title,
            price: food.price,
            imageUrl: food.imageUrl,
            quantity: item.quantity,
          ),
    ];

    // Table (its extras go with it if the table is gone).
    var table = cart.table;
    var additions = cart.additions;
    if (table != null) {
      final doc = await _firestore
          .collection('tables')
          .doc(table.id)
          .get(serverOnly);
      final data = doc.data();
      if (!doc.exists || data == null) {
        table = null;
        additions = const [];
      } else {
        final t = TableModel.fromMap(doc.id, data);
        table = CartTableItem(
          id: table.id,
          title: t.title,
          description: t.description,
          price: t.price,
          imageUrl: t.imageUrl,
          duration: table.duration,
        );
      }
    }

    return CartModel(foods: foods, table: table, additions: additions);
  }

  /// Compact text of what is being bought and at what price, used to see
  /// whether anything changed.
  String _signature(CartModel cart) {
    final foods = cart.foods.map((f) => '${f.id}:${f.price}:${f.quantity}');
    final table = cart.table == null
        ? ''
        : '${cart.table!.id}:${cart.table!.price}';
    return '${foods.join('|')}#$table';
  }

  num _round2(num value) => (value * 100).round() / 100;
}
