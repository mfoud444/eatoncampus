import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/food.dart';

class FoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> addFood(Food food) async {
    try {
      DocumentReference docRef =
          await _db.collection('foods').add(food.toJson());
      String foodId = docRef.id;
      await docRef.update({'foodId': foodId});
    } catch (e) {
      throw e;
    }
  }

  Future<List<Food>> getAllFoods(String restaurantId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('foods')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      final List<Food> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Food.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Food>> getFoodsByCategory(
      String restaurantId, String category) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('foods')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('category', isEqualTo: category)
          .get();
      final List<Food> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Food.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Food>> getFoodsById(
      String foodId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('foods')
          .where('foodId', isEqualTo: foodId)
          .get();
      final List<Food> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Food.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      throw e;
    }
  }
  Future<void> updateFood(Food food) async {
    try {
      await _db.collection('foods').doc(food.foodId).update(food.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      await _db.collection('foods').doc(id).delete();
    } catch (e) {
      throw e;
    }
  }
}
