import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class TableRepository {
  TableRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<TableModel>> getAllTables() async {
    final snapshot = await _firestore.collection('tables').get();

    final tables = snapshot.docs
        .map((doc) => TableModel.fromMap(doc.id, doc.data()))
        .toList();

    tables.sort((a, b) {
      final byRating = b.rating.compareTo(a.rating);
      return byRating != 0 ? byRating : a.title.compareTo(b.title);
    });
    return tables;
  }
}
