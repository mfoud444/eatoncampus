import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/OrderItem.dart';

class Orders {
  String? orderId;
  final List<OrderItem>? orderItems;
  final double? totalPrice;
  final String? studentId;
  final String? restaurantId;
  final String? tableId;
  final String? state;
  final Timestamp? tableReservationTime;
  final Timestamp? orderReceivingTime;
  final String? promoCode;
  late Timestamp orderDateTime;

  Orders({
    this.orderId,
    this.orderItems,
    this.totalPrice,
    this.studentId,
    this.restaurantId,
    this.tableId,
    this.state,
    this.tableReservationTime,
    this.orderReceivingTime,
    this.promoCode,
   orderDateTime ,

    
  }) :orderDateTime = ( orderDateTime ?? Timestamp.now() );

  factory Orders.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    for (Map<String, dynamic> item in json['orderItems']) {
      orderItems.add(OrderItem.fromJson(item));
    }
    return Orders(
      orderId: json['orderId'],
      orderItems: orderItems,
      totalPrice: json['totalPrice'],
      studentId: json['studentId'],
      restaurantId: json['restaurantId'],
      tableId: json['tableId'],
      state: json['state'],
      tableReservationTime: json['tableReservationTime'],
      orderReceivingTime: json['orderReceivingTime'],
      promoCode: json['promoCode'],
      orderDateTime: json['orderDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> orderItemsJson = [];
    for (OrderItem orderItem in orderItems!) {
      orderItemsJson.add(orderItem.toJson());
    }
    return {
      'orderId': orderId,
      'orderItems': orderItemsJson,
      'totalPrice': totalPrice,
      'studentId': studentId,
      'restaurantId': restaurantId,
      'tableId': tableId,
      'state': state,
      'tableReservationTime': tableReservationTime,
      'orderReceivingTime': orderReceivingTime,
      'promoCode': promoCode,
      'orderDateTime': orderDateTime,
    };
  }
}
