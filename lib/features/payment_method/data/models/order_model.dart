import 'package:madang/features/cart/data/models/cart_model.dart';

/// One order, as saved in the Firestore `orders` collection.
/// Items are stored inside the order document, so placing an order is a
/// single write.
class OrderModel {
  const OrderModel({
    required this.userId,
    required this.foods,
    required this.table,
    required this.additions,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
  });

  final String userId;
  final List<CartFoodItem> foods;
  final CartTableItem? table;
  final List<CartAddition> additions;
  final num subtotal;
  final num tax;
  final num total;
  final String paymentMethod; // PaymentMethod.id

  /// The repository adds `createdAt` (server time) when it writes this.
  Map<String, dynamic> toMap() => {
    'userId': userId,
    'foods': foods.map((f) => f.toMap()).toList(),
    'table': table?.toMap(),
    'additions': additions.map((a) => a.toMap()).toList(),
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
    'paymentMethod': paymentMethod,
    // The app can only ever create orders as pending. Only a trusted
    // backend (payment webhook) may mark one as paid.
    'paymentStatus': 'pending',
    'status': 'placed',
  };
}
