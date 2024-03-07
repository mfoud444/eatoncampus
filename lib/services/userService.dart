import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/admin.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/models/person.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {

  Future<dynamic> getDataUsers() async {
    final Map<String, dynamic> user = await getCurrentUser();
    final String type = user['type'];
    final String uid = user['id'];
    switch(type) {
      case 'admin':
        final DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('admin')
            .doc(uid)
            .get();
        return Admin.fromJson(adminSnapshot.data() as Map<String, dynamic>);
      case 'builder':
        final DocumentSnapshot builderSnapshot = await FirebaseFirestore.instance
            .collection('builder')
            .doc(uid)
            .get();
        return Person.fromJson(builderSnapshot.data() as Map<String, dynamic>);
      case 'contractor':
        final DocumentSnapshot contractorSnapshot = await FirebaseFirestore.instance
            .collection('contractor')
            .doc(uid)
            .get();
        return Person.fromJson(contractorSnapshot.data() as Map<String, dynamic>);
      case 'market':
        final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
            .collection('market')
            .doc(uid)
            .get();
        return Organize.fromJson(marketSnapshot.data() as Map<String, dynamic>);
      case 'factory':
        final DocumentSnapshot factorySnapshot = await FirebaseFirestore.instance
            .collection('factory')
            .doc(uid)
            .get();
        return Organize.fromJson(factorySnapshot.data() as Map<String, dynamic>);
      default:
        throw Exception('Invalid account type');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('User not found in accounts collection');
      }
    } else {
      throw Exception('No current user');
    }
  }

  Future<Map<String, dynamic>> getDataUser(String uid) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data != null) {
      final String type = data['type'];
      switch(type) {
        case 'admin':
          final DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
              .collection('admin')
              .doc(uid)
              .get();
          return adminSnapshot.data() as Map<String, dynamic>;
        case 'builder':
          final DocumentSnapshot builderSnapshot = await FirebaseFirestore.instance
              .collection('builder')
              .doc(uid)
              .get();
          return builderSnapshot.data() as Map<String, dynamic>;
        case 'contractor':
          final DocumentSnapshot contractorSnapshot = await FirebaseFirestore.instance
              .collection('contractor')
              .doc(uid)
              .get();
          return contractorSnapshot.data() as Map<String, dynamic>;
        case 'market':
          final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
              .collection('market')
              .doc(uid)
              .get();
          return marketSnapshot.data() as Map<String, dynamic>;
        case 'factory':
          final DocumentSnapshot factorySnapshot = await FirebaseFirestore.instance
              .collection('factory')
              .doc(uid)
              .get();
          return factorySnapshot.data() as Map<String, dynamic>;
        default:
          throw Exception('Invalid account type');
      }
    } else {
      throw Exception('Invalid user id');
    }
  }
}