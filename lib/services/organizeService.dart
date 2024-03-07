import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/organize.dart';

class OrganizeService {
  final String type;
  late CollectionReference _organizeCollection;

  OrganizeService(this.type) {
    _organizeCollection = FirebaseFirestore.instance.collection(type);
  }

  Future<Map<String, int>> getOrganizeCounts() async {
    Map<String, String> collectionPaths = {
      'builder': 'builder',
      'contractor': 'contractor',
      'admin': 'admin',
      'market': 'market',
      'factory': 'factory',
    };

    Map<String, int> counts = {};

    for (String type in collectionPaths.keys) {
      String collectionPath = collectionPaths[type]!;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionPath).get();
      int count = snapshot.docs.length;
      counts[type] = count;
    }

    return counts;
  }

  Future<Organize> getOrganize(String organizeId) async {
    DocumentSnapshot snapshot = await _organizeCollection.doc(organizeId).get();
    return Organize.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<List<Organize>> getAllOrganizes() async {
    QuerySnapshot snapshot = await _organizeCollection.get();
    return snapshot.docs
        .map((doc) => Organize.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateOrganizeState(Organize organize) async {
    await _organizeCollection.doc(organize.id).update({
      "isActive": organize.isActive,
    });
  }

  Future<void> deleteOrganize(String email) async {
    return await _organizeCollection.doc(email).delete();
  }
}
