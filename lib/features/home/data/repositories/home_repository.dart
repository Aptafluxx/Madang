import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class HomeRepository {
  HomeRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<TableModel>> getRecommendedTables() async {
    final snapshot = await _firestore
        .collection('tables')
        .where('isRecommended', isEqualTo: true)
        .limit(10)
        .get();

    final tables = snapshot.docs
        .map((doc) => TableModel.fromMap(doc.id, doc.data()))
        .toList();

    tables.sort((a, b) => b.rating.compareTo(a.rating));
    return tables;
  }
}
