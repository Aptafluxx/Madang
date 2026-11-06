import 'package:madang/features/food/data/models/food_model.dart';
import 'package:madang/features/table/data/models/table_model.dart';

enum SearchItemType { food, table }

class SearchItem {
  const SearchItem._({
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.searchText,
    this.food,
    this.table,
  });

  factory SearchItem.fromFood(FoodModel f) => SearchItem._(
    type: SearchItemType.food,
    id: f.id,
    title: f.title,
    description: f.description,
    category: f.category,
    price: f.price,
    rating: f.rating,
    imageUrl: f.imageUrl,
    searchText: '${f.title} ${f.description} ${f.category}'.toLowerCase(),
    food: f,
  );

  factory SearchItem.fromTable(TableModel t) => SearchItem._(
    type: SearchItemType.table,
    id: t.id,
    title: t.title,
    description: t.description,
    category: t.category,
    price: t.price,
    rating: t.rating,
    imageUrl: t.imageUrl,
    searchText: '${t.title} ${t.description} ${t.category}'.toLowerCase(),
    table: t,
  );

  final SearchItemType type;
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String searchText;
  final FoodModel? food;
  final TableModel? table;
  String get key => '${type.name}:$id';

  FoodModel toCardModel() =>
      food ??
      FoodModel(
        id: id,
        title: title,
        description: description,
        price: price,
        rating: rating,
        imageUrl: imageUrl,
        category: category,
      );
}
