import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madang/features/food/data/models/food_model.dart';

class FoodRepository {
  FoodRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<FoodModel>> getAllFoods() async {
    final snapshot = await _firestore.collection('foods').get();

    final foods = snapshot.docs
        .map((doc) => FoodModel.fromMap(doc.id, doc.data()))
        .toList();

    foods.sort((a, b) {
      final byRating = b.rating.compareTo(a.rating);
      return byRating != 0 ? byRating : a.title.compareTo(b.title);
    });
    return foods;
  }
}
