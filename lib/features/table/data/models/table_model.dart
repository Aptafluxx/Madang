import 'package:intl/intl.dart';

class TableModel {
  const TableModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.isRecommended,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  final bool isRecommended;

  factory TableModel.fromMap(String id, Map<String, dynamic> map) {
    return TableModel(
      id: id,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      price: _toNum(map['price']),
      rating: _toNum(map['rating']),
      imageUrl: (map['imageUrl'] as String?) ?? '',
      category: (map['category'] as String?) ?? '',
      isRecommended: map['isRecommended'] == true,
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
