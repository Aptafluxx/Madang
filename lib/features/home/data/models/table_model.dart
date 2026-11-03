import 'package:intl/intl.dart';

class TableModel {
  const TableModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;

  factory TableModel.fromMap(String id, Map<String, dynamic> map) {
    return TableModel(
      id: id,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      price: _toNum(map['price']),
      rating: _toNum(map['rating']),
      imageUrl: (map['imageUrl'] as String?) ?? '',
    );
  }

  static double _toNum(Object? value) =>
      value is num ? value.toDouble() : num.tryParse('$value')?.toDouble() ?? 0;

  static final NumberFormat _money = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  String get priceText => _money.format(price);

  String get ratingText => rating.toStringAsFixed(1);
}
