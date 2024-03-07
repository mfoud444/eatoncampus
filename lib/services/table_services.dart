import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/table.dart';

class TableService {
  final CollectionReference _tablesCollection =
      FirebaseFirestore.instance.collection('tables');



Future<void> addTable(Tables table) async {
    try {
        DocumentReference docRef = await _tablesCollection.add(table.toJson());
        String tableId = docRef.id;
        await docRef.update({'tableId': tableId});
    } catch (e) {
      throw e;
    }
}

  Future<List<Tables>> getTablesByRestaurant(String restaurantId) async {
    try {
      final querySnapshot = await _tablesCollection
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      return querySnapshot.docs
          .map((doc) => Tables.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateTable(Tables table) async {
    try {
      await _tablesCollection.doc(table.tableId).update(table.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteTable(String tableId) async {
    try {
      await _tablesCollection.doc(tableId).delete();
    } catch (e) {
      throw e;
    }
  }
}
