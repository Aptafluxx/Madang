import 'package:intl/intl.dart';

final NumberFormat _money = NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
);

/// 4.2 becomes "$4.20"
String formatCartMoney(num value) => _money.format(value);

/// A food line in the cart. Title and price are copied when the item is
/// added, so the cart still shows correctly offline.
class CartFoodItem {
  const CartFoodItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  final String id;
  final String title;
  final num price; // per item
  final String imageUrl;
  final int quantity;

  num get total => price * quantity;
  String get priceText => formatCartMoney(price);

  CartFoodItem copyWith({int? quantity}) => CartFoodItem(
    id: id,
    title: title,
    price: price,
    imageUrl: imageUrl,
    quantity: quantity ?? this.quantity,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
  };

  factory CartFoodItem.fromMap(Map<String, dynamic> map) => CartFoodItem(
    id: (map['id'] as String?) ?? '',
    title: (map['title'] as String?) ?? '',
    price: (map['price'] as num?) ?? 0,
    imageUrl: (map['imageUrl'] as String?) ?? '',
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
  );
}

/// The booked table (a cart holds one table).
class CartTableItem {
  const CartTableItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.duration,
  });

  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  final String duration; // "30 minutes"

  String get priceText => formatCartMoney(price);

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'duration': duration,
  };

  factory CartTableItem.fromMap(Map<String, dynamic> map) => CartTableItem(
    id: (map['id'] as String?) ?? '',
    title: (map['title'] as String?) ?? '',
    description: (map['description'] as String?) ?? '',
    price: (map['price'] as num?) ?? 0,
    imageUrl: (map['imageUrl'] as String?) ?? '',
    duration: (map['duration'] as String?) ?? '',
  );
}

/// An extra chosen with the table (Chair, Table, Flower).
class CartAddition {
  const CartAddition({
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  final String name;
  final num unitPrice; // 0 = free
  final int quantity;

  num get total => unitPrice * quantity;

  /// "1 x Flower"
  String get label => '$quantity x $name';

  /// "Free" or the line total.
  String get totalText => unitPrice == 0 ? 'Free' : formatCartMoney(total);

  Map<String, dynamic> toMap() => {
    'name': name,
    'unitPrice': unitPrice,
    'quantity': quantity,
  };

  factory CartAddition.fromMap(Map<String, dynamic> map) => CartAddition(
    name: (map['name'] as String?) ?? '',
    unitPrice: (map['unitPrice'] as num?) ?? 0,
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
  );
}

/// Everything in the cart, as saved on the device.
class CartModel {
  const CartModel({
    required this.foods,
    required this.table,
    required this.additions,
  });

  static const CartModel empty = CartModel(
    foods: [],
    table: null,
    additions: [],
  );

  final List<CartFoodItem> foods;
  final CartTableItem? table;
  final List<CartAddition> additions;

  Map<String, dynamic> toMap() => {
    'foods': foods.map((f) => f.toMap()).toList(),
    'table': table?.toMap(),
    'additions': additions.map((a) => a.toMap()).toList(),
  };

  factory CartModel.fromMap(Map<String, dynamic> map) {
    final rawTable = map['table'];
    return CartModel(
      foods: ((map['foods'] as List?) ?? const [])
          .map((e) => CartFoodItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      table: rawTable is Map
          ? CartTableItem.fromMap(Map<String, dynamic>.from(rawTable))
          : null,
      additions: ((map['additions'] as List?) ?? const [])
          .map((e) => CartAddition.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
