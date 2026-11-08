import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:madang/features/cart/data/models/cart_model.dart';

/// How the Recent screen labels an order: Process / Done / Cancel.
enum OrderStatus { process, done, cancelled }

/// One order, as saved in the Firestore `orders` collection.
/// Items are stored inside the order document, so placing an order is a
/// single write, and showing an order in Recent needs no extra reads.
class OrderModel {
  const OrderModel({
    this.id = '',
    required this.userId,
    required this.foods,
    required this.table,
    required this.additions,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    this.status = 'placed',
    this.paymentStatus = 'pending',
    this.createdAt,
  });

  final String id; // Firestore document id (empty before it is saved)
  final String userId;
  final List<CartFoodItem> foods;
  final CartTableItem? table;
  final List<CartAddition> additions;
  final num subtotal;
  final num tax;
  final num total;
  final String paymentMethod; // PaymentMethod.id
  final String status; // placed | done | cancelled (set by staff / backend)
  final String paymentStatus; // pending | paid (set by backend only)
  final DateTime? createdAt;

  // ── Display helpers (used by the Recent screen) ───────────────

  OrderStatus get orderStatus {
    switch (status) {
      case 'done':
      case 'completed':
        return OrderStatus.done;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default: // 'placed', 'processing', anything new
        return OrderStatus.process;
    }
  }

  /// "Noodle Ex", "Noodle Ex +1 more", or the table name for a table-only order.
  String get displayTitle {
    if (foods.isNotEmpty) {
      final extra = foods.length - 1;
      return extra > 0
          ? '${foods.first.title} +$extra more'
          : foods.first.title;
    }
    return table?.title ?? 'Order';
  }

  String get imageUrl =>
      foods.isNotEmpty ? foods.first.imageUrl : (table?.imageUrl ?? '');

  /// "Work Table · 1 Flower"
  String get summary {
    final parts = <String>[
      if (table != null && foods.isNotEmpty) table!.title,
      for (final a in additions) '${a.quantity} ${a.name}',
    ];
    return parts.join(' · ');
  }

  // ── Firestore ─────────────────────────────────────────────────

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    final rawTable = map['table'];
    final created = map['createdAt'];

    return OrderModel(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      foods: ((map['foods'] as List?) ?? const [])
          .map((e) => CartFoodItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      table: rawTable is Map
          ? CartTableItem.fromMap(Map<String, dynamic>.from(rawTable))
          : null,
      additions: ((map['additions'] as List?) ?? const [])
          .map((e) => CartAddition.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      subtotal: (map['subtotal'] as num?) ?? 0,
      tax: (map['tax'] as num?) ?? 0,
      total: (map['total'] as num?) ?? 0,
      paymentMethod: (map['paymentMethod'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'placed',
      paymentStatus: (map['paymentStatus'] as String?) ?? 'pending',
      createdAt: created is Timestamp ? created.toDate() : null,
    );
  }

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
    // The app can only ever create orders as pending / placed. Only a
    // trusted backend may mark an order paid, done or cancelled.
    'paymentStatus': 'pending',
    'status': 'placed',
  };
}
