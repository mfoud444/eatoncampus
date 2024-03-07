import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/models/OrderItem.dart';
import 'package:construction/models/food.dart';
import 'package:construction/models/orders.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/models/table.dart';
import 'package:construction/services/SharedPreferencesHelper.dart';
import 'package:construction/services/food_service.dart';
import 'package:construction/services/order_service.dart';
import 'package:construction/services/userService.dart';
import 'package:construction/person/screens/WaitingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PaymentScreen extends StatefulWidget {
  final Tables? table;
  final Organize restaurant;
  final Timestamp? tableReservationTime;
  const PaymentScreen(
      {this.table, required this.restaurant, this.tableReservationTime});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState(
      restaurant: restaurant,
      table: table,
      tableReservationTime: tableReservationTime);
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _total = 0;
  bool _isLoading = false;
  final Tables? table;
  final Organize restaurant;
  final Timestamp? tableReservationTime;
  Timestamp? _orderReceivingTime = Timestamp.now();
  String? _promoCode;
  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  final OrderService _orderService = OrderService();
  final FoodService _foodService = FoodService();
  _PaymentScreenState(
      {this.table, required this.restaurant, this.tableReservationTime});
  UserService userService = UserService();
  List<OrderItem> _orderItems = [];
  List<String> _foodIdsToClear = [];

  Future<double> _calculateTotalPrice() async {
    final Map<String, int> quantities =
        await _sharedPreferencesHelper.getQuantities();
    double totalPrice = 0;
    List<OrderItem> orderItems = [];
    List<String> foodIdsToClear = [];

    for (String foodId in quantities.keys) {
      final bool containsFoodId =
          await _sharedPreferencesHelper.containsFoodId(foodId);
      if (containsFoodId) {
        final List<Food> foodList = await _foodService.getFoodsById(foodId);
        for (Food food in foodList) {
          if (food.restaurantId == restaurant.id) {
            orderItems.add(OrderItem(
              foodId: food.foodId,
              quantity: quantities[foodId],
              price: food.price,
            ));
            totalPrice += (food.price! * quantities[foodId]!);
            foodIdsToClear.add(food.foodId!);
          }
        }
      }
    }
    _orderItems = orderItems;
    _foodIdsToClear = foodIdsToClear;
    return totalPrice;
  }

  void _createOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final double totalPrice = await _calculateTotalPrice();

      Map<String, dynamic> user = await userService.getCurrentUser();

      String? studentId = user['id'];
      final Orders orders = Orders(
        orderItems: _orderItems,
        totalPrice: totalPrice,
        studentId: studentId,
        restaurantId: restaurant.id,
        tableId: table?.tableId,
        state: "pending",
        tableReservationTime: tableReservationTime,
        orderReceivingTime: _orderReceivingTime,
        promoCode: _promoCode,
      );

      final String orderId = await _orderService.createOrder(orders);
      orders.orderId = orderId;

      // clear food items from cart
      await _clearCart(_foodIdsToClear);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WaitingScreen(restaurant: restaurant, orders: orders),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        showErrorSnackBar(context, e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCart(List<String> foodIds) async {
    for (String foodId in foodIds) {
      await _sharedPreferencesHelper.remove(foodId);
    }
  }

//   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select The receipt time',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            FormBuilderDateTimePicker(
                              name: 'orderReceivingTime',
                              initialValue: Timestamp.now().toDate(),
                              inputType: InputType.time,
                              decoration: const InputDecoration(
                                labelText: 'Time',
                              ),
                              onChanged: (time) {
                                _orderReceivingTime = time != null
                                    ? Timestamp.fromDate(time)
                                    : Timestamp.now();
                              },
                            ),

                            // ignore: prefer_const_constructors
                          ],
                        )),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment Method',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(Icons.credit_card),
                              const Text(
                                'Card',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(Icons.monetization_on),
                              const Text(
                                'Cash',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Have a Promo Code?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Expanded(
                              child: TextField(
                            decoration:
                                InputDecoration(hintText: 'Enter promo code'),
                          )),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            child: const Text('Apply'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FutureBuilder<double>(
                  future: _calculateTotalPrice(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _total = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('$_total RS',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomIconButton(
                              label: 'Pay',
                              icon: Icons.payment,
                              onPressed: _createOrder,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
