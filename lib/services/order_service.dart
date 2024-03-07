import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/orders.dart';

class OrderService {
  final CollectionReference _orderRef =
      FirebaseFirestore.instance.collection('orders');

Future<String> createOrder(Orders order) async {
  final DocumentReference docRef = _orderRef.doc();
  await docRef.set(order.toJson());

  // order.orderId = docRef.id;
   final updateOrderId = {
      'orderId': docRef.id,
    };
  await docRef.update(updateOrderId);

  return docRef.id;
}


  Future<List<Orders>> getOrdersByStudentId(String studentId) async {
    final QuerySnapshot snap = await _orderRef
        .where('studentId', isEqualTo: studentId)
        .get();
    return snap.docs
        .map((doc) => Orders.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Orders>> getOrdersByRestaurantId(String restaurantId) async {
    final QuerySnapshot snap = await _orderRef
        .where('restaurantId', isEqualTo: restaurantId)
        .get();
    return snap.docs
        .map((doc) => Orders.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateStateOrder(String orderId, String state) async {
  final updateData = {
    'state': state,
  };
  try {
    await _orderRef.doc(orderId).update(updateData);
  } catch (e) {
      throw e;
    }
}

}

