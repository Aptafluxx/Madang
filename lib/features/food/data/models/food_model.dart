import 'package:intl/intl.dart';

/// One document of the Firestore `foods` collection.
class FoodModel {
  const FoodModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final num price;
  final num rating;
  final String imageUrl;
  final String category;

  factory FoodModel.fromMap(String id, Map<String, dynamic> map) {
    return FoodModel(
      id: id,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      price: _toNum(map['price']),
      rating: _toNum(map['rating']),
      imageUrl: (map['imageUrl'] as String?) ?? '',
      category: (map['category'] as String?) ?? '',
    );
  }

  static num _toNum(Object? value) =>
      value is num ? value : num.tryParse('$value') ?? 0;

  static final NumberFormat _money =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  /// 6.35 becomes "$6.35"
  String get priceText => _money.format(price);

  /// 4.9 becomes "4.9"
  String get ratingText => rating.toStringAsFixed(1);
}
