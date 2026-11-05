import 'package:intl/intl.dart';

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
  final double price;
  final double rating;
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

  static double _toNum(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  static final NumberFormat _money = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  String get priceText => _money.format(price);

  String get ratingText => rating.toStringAsFixed(1);
}
