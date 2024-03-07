import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/models/food.dart';
import 'package:construction/models/orders.dart';
import 'package:construction/services/food_service.dart';
import 'package:construction/services/order_service.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class AllOrder extends StatefulWidget {
  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  Future<List<Orders>>? _orders;
  UserService userService = UserService();
  OrderService orderService = OrderService();

  bool _isLoading1 = false;
  bool _isLoading2 = false;
  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  Future<void> _getOrders() async {
    Map<String, dynamic> user = await userService.getCurrentUser();
    String? restaurantId = user['id'];
    _orders = orderService.getOrdersByRestaurantId(restaurantId!);
    setState(() {});
  }

  Future<void> _updateState(String orderId, String state) async {
    setState(() {
      if (state == "Accept") {
        _isLoading1 = true;
      } else {
        _isLoading2 = true;
      }
    });
    try {
      await orderService.updateStateOrder(orderId, state);
      _getOrders();
    } catch (e) {
      setState(() {
        if (state == "Accept") {
          _isLoading1 = false;
        } else {
          _isLoading2 = false;
        }
        showErrorSnackBar(context, e.toString());
      });
    } finally {
      setState(() {
        if (state == "Accept") {
          _isLoading1 = false;
        } else {
          _isLoading2 = false;
        }
      });
    }
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
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order (${order.state})',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text('Total Price: ${order.totalPrice} RS'),
                            ],
                          ),
                          children: order.orderItems!.map((orderItem) {
                            return FutureBuilder<List<Food>>(
                              future:
                                  FoodService().getFoodsById(orderItem.foodId!),
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
                                                image:
                                                    NetworkImage(food.picture!),
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
                        Column(
                          children: [
                            CustomIconButton(
                              label: 'Accept',
                              icon: Icons.check,
                              onPressed: (() =>
                                  _updateState(order.orderId!, "Accept")),
                              isLoading: _isLoading1,
                              bgColor: Colors.green,
                            ),
                            const SizedBox(height: 5),
                            CustomIconButton(
                              label: 'Refusal',
                              icon: Icons.clear,
                              onPressed: (() =>
                                  _updateState(order.orderId!, "Refusal")),
                              isLoading: _isLoading2,
                              bgColor: Colors.red,
                            ),
                          ],
                        )
                      ],
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
