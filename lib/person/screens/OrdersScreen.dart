import 'package:construction/models/OrderItem.dart';
import 'package:construction/models/food.dart';
import 'package:construction/models/orders.dart';
import 'package:construction/services/food_service.dart';
import 'package:construction/services/order_service.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<Orders>>? _orders;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  Future<void> _getOrders() async {
    Map<String, dynamic> user = await userService.getCurrentUser();
    String? studentId = user['id'];

    OrderService orderService = OrderService();
    _orders = orderService.getOrdersByStudentId(studentId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Orders>>(
      future: _orders,
      builder: (BuildContext context, AsyncSnapshot<List<Orders>> snapshot) {
        if (snapshot.hasData) {
          List<Orders> orders = snapshot.data!;
          if (orders.isNotEmpty) {
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                Orders order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                             
                              ),
                  child: Container(
                      margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order (${order.state})'),
                           Text('Total Price: ${order.totalPrice}'),
                          
                        ],
                      ),
                      children: order.orderItems!.map((orderItem) {
                        return FutureBuilder<List<Food>>(
                          future: FoodService().getFoodsById(orderItem.foodId!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Food>> snapshot) {
                            if (snapshot.hasData) {
                              List<Food> foods = snapshot.data!;

                              if (foods.isNotEmpty) {
                                Food food = foods[0];

                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(food.picture!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            food.name!.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${food.price} RS',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  child: const Text('Food not found'),
                                );
                              }
                            } else if (snapshot.hasError) {
                              return Container(
                                child: Text('${snapshot.error}'),
                              );
                            } else {
                              return Container(
                                child: const CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No orders found'),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            child: Text('${snapshot.error}'),
          );
        } else {
          return Container(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


