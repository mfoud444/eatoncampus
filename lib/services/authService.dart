import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/admin.dart';
import 'package:construction/models/person.dart';
import 'package:construction/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:construction/models/organize.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UserService userService = UserService();
  Future<void> signUpPerson(
      BuildContext context, Person person, String type) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(type)
        .where('email', isEqualTo: person.email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      final User? authUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: person.email!, password: person.password!))
          .user;
      person.id = authUser!.uid;
      await FirebaseFirestore.instance
          .collection(type)
          .doc(authUser.uid)
          .set(person.toJson());
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(authUser.uid)
          .set({'id': authUser.uid, 'type': type});
    } else {
      throw Exception('Id is already taken');
    }
  }

  Future<void> signUpOrganize(
      BuildContext context, Organize organize, String type) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(type)
        .where('email', isEqualTo: organize.email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      final User? authUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: organize.email!, password: organize.password!))
          .user;
      organize.id = authUser!.uid;
      await FirebaseFirestore.instance
          .collection(type)
          .doc(authUser.uid)
          .set(organize.toJson());
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(authUser.uid)
          .set({'id': authUser.uid, 'type': type});
    } else {
      throw Exception('Email is already taken');
    }
  }

  Future<void> signUpAdmin(BuildContext context, Admin admin) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: admin.email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      final User? authUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: admin.email!, password: admin.password!))
          .user;
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(authUser!.uid)
          .set(admin.toJson());
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(authUser.uid)
          .set({'id': authUser.uid, 'type': 'admin'});
    } else {
      throw Exception('Email is already taken');
    }
  }

  Future<void> signInPerson(
      BuildContext context, String email, String password, String type) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(type)
        .where('email', isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      final String _email = documents[0]['email'];
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: password);
    } else {
      throw Exception('Email Not Registered yet');
    }
  }

  Future<void> signInOrganize(
      BuildContext context, String email, String password, String type) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(type)
        .where('email', isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isNotEmpty) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } else {
      throw Exception('Email Not Registered yet');
    }
  }

  Future<void> signInAdmin(
      BuildContext context, String email, String password) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isNotEmpty) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } else {
      throw Exception('Email Not Registered yet');
    }
  }

// sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> uploadImage(File image) async {
    Reference ref =
        _storage.ref().child('images').child('${DateTime.now()}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
























  // Future<void> signUpStudent(Student student) async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('students')
  //       .where('universityId', isEqualTo: student.universityId)
  //       .get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   if (documents.isEmpty) {
  //     final User? authUser = (await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(
  //                 email: student.email!, password: student.password!))
  //         .user;
  //     // AppUser student = AppUser(uid: authUser!.uid, isStudent: true);
  //     await FirebaseFirestore.instance
  //         .collection('students')
  //         .doc(authUser!.uid)
  //         .set(student.toJson());
  //   } else {
  //     throw Exception('University Id is already taken');
  //   }
  // }

  // Future<void> signUpRestaurant(Restaurant restaurant) async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('restaurants')
  //       .where('email', isEqualTo: restaurant.email)
  //       .get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   if (documents.isEmpty) {
  //     final User? authUser = (await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(
  //                 email: restaurant.email!, password: restaurant.password!))
  //         .user;
  //        // Save the id in the Firestore collection
  //     await FirebaseFirestore.instance
  //         .collection('restaurants')
  //         .doc(authUser!.uid)
  //         .set({'id': authUser.uid});

  //     await FirebaseFirestore.instance
  //         .collection('restaurants')
  //         .doc(authUser.uid)
  //         .set(restaurant.toJson());
  //   } else {
  //     throw Exception('Email is already taken');
  //   }
  // }

  // Future<void> signUpAdmin(Admin admin) async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('admins')
  //       .where('email', isEqualTo: admin.email)
  //       .get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   if (documents.isEmpty) {
  //     final User? authUser = (await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(
  //                 email: admin.email!, password: admin.password!))
  //         .user;
  //     // AppUser user = AppUser(uid: authUser!.uid, isAdmin: true);
  //     await FirebaseFirestore.instance
  //         .collection('admins')
  //         .doc(authUser!.uid)
  //         .set(admin.toJson());
  //   } else {
  //     throw Exception('Email is already taken');
  //   }
  // }

//   Future<void> signInStudent(String universityId, String password) async {
//     // Query the universityIds collection to get the email associated with the universityId
//     // Replace "universityIds" with the name of your database collection for storing universityIds
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('students')
//         .where('universityId', isEqualTo: universityId)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;

//     if (documents.isNotEmpty) {
//       // If the universityId is found, get the email
//       final String email = documents[0]['email'];
//       // Use the email and password to log in
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } else {
//       // If the universityId is not found, display an error message
//       throw Exception('University Id Not Registered yet');
//     }
//   }

//   Future<void> signInRestaurant(String email, String password) async {
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('restaurants')
//         .where('email', isEqualTo: email)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;
//     if (documents.isNotEmpty) {
// // Use the email and password to log in
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } else {
// // If the email is not found, throw an error
//       throw Exception('Email Not Registered yet');
//     }
//   }

//   Future<void> signInAdmin(String email, String password) async {
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('admins')
//         .where('email', isEqualTo: email)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;
//     if (documents.isNotEmpty) {
// // Use the email and password to log in
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } else {
// // If the email is not found, throw an error
//       throw Exception('Email Not Registered yet');
//     }
//   }










































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // create new user
//   Future<void> signUp(String fullName, String universityId, String email,
//       String password) async {
//     // Check if the universityId is unique
//     // Replace "universityIds" with the name of your database collection for storing universityIds
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('users')
//         .where('universityId', isEqualTo: universityId)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;
//     if (documents.isEmpty) {
//       // If the universityId is unique, create the user in Firebase authentication
//       final User? user = (await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(email: email, password: password))
//           .user;
//       // Then store the full name and universityId in the Firebase Firestore database
//       // Replace "users" with the name of your database collection for storing user data
//       await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
//         'full_name': fullName,
//         'universityId': universityId,
//         'email': email,
//       });
//     } else {
//       // If the username is not unique, display an error message
//       throw Exception('University Id is already taken');
//     }
//   }

//   Future<void> signIn(String universityId, String password) async {
//     // Query the universityIds collection to get the email associated with the universityId
//     // Replace "universityIds" with the name of your database collection for storing universityIds
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('users')
//         .where('universityId', isEqualTo: universityId)
//         .get();
//     final List<DocumentSnapshot> documents = result.docs;

//     if (documents.isNotEmpty) {
   
//   // If the universityId is found, get the email
//       final String email = documents[0]['email'];
//       // Use the email and password to log in
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } else {
//       // If the universityId is not found, display an error message
//       throw Exception('University Id Not Registered yet');
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
