import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/person.dart';

class PersonService {
     final String type; 
  late CollectionReference _personCollection;

  PersonService(this.type) {
    _personCollection = FirebaseFirestore.instance.collection(type);
  }

 

  Future<Person> getperson(String personId) async {
    DocumentSnapshot snapshot =
        await _personCollection.doc(personId).get();
    return Person.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<List<Person>> getAllpersons() async {
    QuerySnapshot snapshot = await _personCollection.get();
    return snapshot.docs
        .map((doc) => Person.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updatepersonState(Person person) async {
    await _personCollection.doc(person.id).update({
      "isActive": person.isActive,
    });
  }

  Future<void> deleteperson(String email) async {
    return await _personCollection.doc(email).delete();
  }
}
